#!/usr/bin/env python3
"""Long-running HTTP daemons for the lane-1 Ubuntu runtime spine.

Modes:
  web       — static command-centre + JSON probes + Wizard ``/host/*`` surface (see below).
  commandd  — HTTP API that shells the existing ``udos-commandd.sh`` CLI (policy, surfaces, repo-op).
  hostd     — JSON only; assumes caller already ran runtime layout materialization.
  vaultd    — JSON health + ``/v1/status`` (vault path probes).
  syncd     — JSON health + ``/v1/status`` (sync queue/archive counts).
  budgetd / networkd / scheduled / tuid / thinui / wizard_adapter — minimal ``/health.json`` + ``/v1/status``.

Web ``/host/*`` (``contracts/udos-commandd/wizard-host-surface.v1.json``):

- ``GET/POST /host/local-state`` — JSON under ``~/.udos/state/web/local-state.json`` (shallow merge on POST).
- ``GET /host/contract`` — canonical wizard host surface JSON from disk.
- ``GET /host/runtime-summary`` — layout + policy/registry excerpts (+ optional CLI policy-summary).
- ``GET /host/orchestration-status`` — lane-1 host wiring metadata.
- ``GET /host/budget-status`` / ``GET /host/providers`` — ``config/host/*.lane1.json`` + optional ``~/.udos/state/host/*.json`` overlay; policy rule counts.
- ``GET /host/secrets`` — empty list; ``POST /host/secrets`` — **403** (not supported lane 1).

**commandd** HTTP (default port env ``UDOS_COMMANDD_PORT``, bind ``UDOS_COMMANDD_BIND``):

- ``GET /health.json``
- ``GET /v1/policy-summary``, ``GET /v1/list-operations?domain=``, ``GET /v1/surface-summary?surface=wizard|git``
- ``GET /v1/wizard-host-surface.json``
- ``POST /v1/repo-op`` body ``{"operation_id":"repo.list","arguments":[]}``

Override repo root with env ``UDOS_UBUNTU_ROOT`` when the tree is not next to this file.

Binds: use --bind/--port. Loopback dual-stack for 127.0.0.1 matches serve_static_http.py.
"""

from __future__ import annotations

import argparse
import datetime as _dt
from datetime import timezone
import json
import os
import socket
import subprocess
import sys
import threading
from http.server import BaseHTTPRequestHandler, SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple
from urllib.parse import parse_qs, urlparse

_DEFAULT_BIND = "127.0.0.1"
_LOCAL_STATE_MAX_BYTES = 256 * 1024
_REPO_OP_MAX_BYTES = 64 * 1024
_local_state_lock = threading.Lock()


def _udos_home() -> Path:
    return Path(os.environ.get("UDOS_HOME", Path.home() / ".udos")).expanduser()


def _read_json_file(path: Path) -> Optional[Any]:
    if not path.is_file():
        return None
    return json.loads(path.read_text(encoding="utf-8"))


def _ubuntu_repo_root() -> Path:
    env = os.environ.get("UDOS_UBUNTU_ROOT", "").strip()
    if env:
        return Path(env).expanduser().resolve()
    # This file: uDOS-host/scripts/lib/runtime_daemon_httpd.py
    return Path(__file__).resolve().parent.parent.parent


def _wizard_surface_path() -> Path:
    return _ubuntu_repo_root() / "contracts/udos-commandd/wizard-host-surface.v1.json"


def _github_policy_path() -> Path:
    raw = os.environ.get("UDOS_GITHUB_POLICY_PATH", "").strip()
    if raw:
        return Path(raw).expanduser().resolve()
    return _ubuntu_repo_root() / "config/policy/github-action-policy.json.example"


def _operation_registry_path() -> Path:
    return _ubuntu_repo_root() / "contracts/udos-commandd/operation-registry.v1.json"


def _commandd_script_path() -> Path:
    return _ubuntu_repo_root() / "scripts/udos-commandd.sh"


def _local_state_path() -> Path:
    return _udos_home() / "state/web/local-state.json"


def _utc_from_mtime(path: Path) -> Optional[str]:
    if not path.is_file():
        return None
    try:
        ts = path.stat().st_mtime
        return _dt.datetime.fromtimestamp(ts, tz=timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    except OSError:
        return None


def _load_local_state_dict() -> Dict[str, Any]:
    p = _local_state_path()
    raw = _read_json_file(p)
    if raw is None:
        return {}
    if not isinstance(raw, dict):
        return {}
    return raw


def _shallow_merge_state(base: Dict[str, Any], patch: Dict[str, Any]) -> Dict[str, Any]:
    out = dict(base)
    for key, val in patch.items():
        if key in out and isinstance(out[key], dict) and isinstance(val, dict):
            out[key] = {**out[key], **val}
        else:
            out[key] = val
    return out


def _atomic_write_json(path: Path, obj: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_suffix(path.suffix + ".tmp")
    data = json.dumps(obj, indent=2, sort_keys=True) + "\n"
    tmp.write_text(data, encoding="utf-8")
    tmp.replace(path)


def _read_body_limited(handler: BaseHTTPRequestHandler, max_bytes: int) -> bytes:
    cl = handler.headers.get("Content-Length")
    if cl is None:
        raise ValueError("missing Content-Length")
    n = int(cl)
    if n < 0 or n > max_bytes:
        raise ValueError("invalid Content-Length")
    return handler.rfile.read(n)


def _commandd_run(argv: List[str], timeout: float = 120.0) -> Tuple[int, str, str]:
    script = _commandd_script_path()
    if not script.is_file():
        return 127, "", "udos-commandd.sh not found"
    env = {**os.environ, "UDOS_HOME": str(_udos_home())}
    try:
        proc = subprocess.run(
            ["/usr/bin/env", "bash", str(script), *argv],
            capture_output=True,
            text=True,
            timeout=timeout,
            env=env,
            check=False,
        )
        return proc.returncode, proc.stdout, proc.stderr
    except subprocess.TimeoutExpired:
        return 124, "", "commandd subprocess timeout"
    except OSError as e:
        return 1, "", str(e)


def _parse_list_operations_stdout(stdout: str) -> Dict[str, Any]:
    lines = [ln.strip() for ln in stdout.splitlines() if ln.strip()]
    count = 0
    ops: List[Dict[str, str]] = []
    for line in lines:
        if line.startswith("operation_count="):
            try:
                count = int(line.split("=", 1)[1])
            except ValueError:
                count = 0
            continue
        parts: Dict[str, str] = {}
        for token in line.split():
            if "=" in token:
                k, _, v = token.partition("=")
                parts[k] = v
        if parts.get("operation_id"):
            ops.append(parts)
    return {"operation_count": count, "operations": ops}


def _build_runtime_summary() -> Dict[str, Any]:
    home = _udos_home()
    rr = _ubuntu_repo_root()
    layout = _read_json_file(home / "state/hostd/runtime-layout.json")
    policy = _read_json_file(_github_policy_path())
    registry = _read_json_file(_operation_registry_path())
    repo_ops: list[dict[str, Any]] = []
    if registry:
        repo_ops = [o for o in registry.get("operations", []) if o.get("domain") == "repo"]
    cmd_path = _commandd_script_path()
    commandd_lines: Optional[str] = None
    if cmd_path.is_file():
        try:
            proc = subprocess.run(
                ["/usr/bin/env", "bash", str(cmd_path), "policy-summary"],
                capture_output=True,
                text=True,
                timeout=30,
                env={**os.environ, "UDOS_HOME": str(home)},
                check=False,
            )
            if proc.returncode == 0:
                commandd_lines = proc.stdout.strip()
        except (OSError, subprocess.TimeoutExpired):
            commandd_lines = None
    return {
        "udos_home": str(home),
        "ubuntu_repo_root": str(rr),
        "runtime_layout_present": layout is not None,
        "runtime_layout": layout,
        "github_policy_path": str(_github_policy_path()),
        "github_policy_id": (policy or {}).get("policy_id"),
        "github_policy_default_mode": (policy or {}).get("default_mode"),
        "github_policy_repo_rules_count": len((policy or {}).get("repo_rules", {})),
        "github_policy_github_rules_count": len((policy or {}).get("github_rules", {})),
        "operation_registry_repo_domain_count": len(repo_ops),
        "operation_registry_repo_sample_ids": [o["operation_id"] for o in repo_ops[:16]],
        "commandd_policy_summary": commandd_lines,
    }


def _orchestration_status() -> Dict[str, Any]:
    rr = _ubuntu_repo_root()
    cmd = _commandd_script_path()
    cd_port = os.environ.get("UDOS_COMMANDD_PORT", "7101")
    return {
        "implementation": "lane1-udos-web",
        "ubuntu_repo_root": str(rr),
        "udos_commandd_script": str(cmd),
        "udos_commandd_script_present": cmd.is_file(),
        "udos_commandd_http": {
            "default_bind_env": "UDOS_COMMANDD_BIND",
            "default_port_env": "UDOS_COMMANDD_PORT",
            "default_port": int(cd_port) if str(cd_port).isdigit() else cd_port,
            "serve_entry": "bash scripts/udos-commandd.sh  (default subcommand: serve → HTTP listener)",
        },
        "udos_home": str(_udos_home()),
        "health_probes": {
            "udos_web": "/health.json",
            "udos_commandd": "http://127.0.0.1:<UDOS_COMMANDD_PORT>/health.json",
            "per_service": "Lane-1 daemons expose /health.json (hostd, vaultd, syncd, budgetd, networkd, …)",
        },
        "note": "No centralized process supervisor in lane 1; poll per-daemon health as needed.",
    }


def _host_state_dir() -> Path:
    return _udos_home() / "state/host"


def _repo_host_config(name: str) -> Path:
    return _ubuntu_repo_root() / "config/host" / name


def _budget_status_payload() -> Dict[str, Any]:
    base = _read_json_file(_repo_host_config("budget-status.lane1.json"))
    if not isinstance(base, dict):
        base = {}
    else:
        base = dict(base)
    ov = _read_json_file(_host_state_dir() / "budget-status.json")
    merged = _shallow_merge_state(base, ov if isinstance(ov, dict) else {})
    policy = _read_json_file(_github_policy_path()) or {}
    merged["github_policy_id"] = policy.get("policy_id")
    merged["github_policy_repo_rules_count"] = len(policy.get("repo_rules", {}))
    merged["github_policy_github_rules_count"] = len(policy.get("github_rules", {}))
    merged["udos_home"] = str(_udos_home())
    merged["overlay_path"] = str(_host_state_dir() / "budget-status.json")
    return merged


def _providers_payload() -> Dict[str, Any]:
    base = _read_json_file(_repo_host_config("providers.lane1.json"))
    if not isinstance(base, dict):
        base = {"providers": []}
    else:
        base = dict(base)
    ov = _read_json_file(_host_state_dir() / "providers.json")
    if isinstance(ov, dict):
        merged = _shallow_merge_state(base, ov)
        if "providers" in ov:
            merged["providers"] = ov["providers"]
    else:
        merged = base
    merged["udos_home"] = str(_udos_home())
    merged["overlay_path"] = str(_host_state_dir() / "providers.json")
    return merged


def _dir_entry_count(path: Path) -> int:
    if not path.is_dir():
        return 0
    try:
        return sum(1 for p in path.iterdir() if not p.name.startswith("."))
    except OSError:
        return -1


def _vault_status_payload() -> Dict[str, Any]:
    home = _udos_home()
    return {
        "service": "udos-vaultd",
        "status": "minimal",
        "role": "vault",
        "udos_home": str(home),
        "vault_paths": {
            "inbox_exists": (home / "vault/inbox").is_dir(),
            "projects_exists": (home / "vault/projects").is_dir(),
            "library_exists": (home / "vault/library").is_dir(),
        },
        "note": "Lane-1 listener; encryption and vault API in later lanes.",
    }


def _sync_status_payload() -> Dict[str, Any]:
    home = _udos_home()
    q = home / "sync/queue"
    a = home / "sync/archive"
    return {
        "service": "udos-syncd",
        "status": "minimal",
        "role": "sync",
        "udos_home": str(home),
        "sync_paths": {
            "queue_dir_exists": q.is_dir(),
            "queue_entry_count": _dir_entry_count(q),
            "archive_dir_exists": a.is_dir(),
            "archive_entry_count": _dir_entry_count(a),
        },
        "note": "Lane-1 listener; queue worker execution in later lanes.",
    }


def _make_minimal_aux_handler(svc_id: str, role: str, port_env: str) -> type:
    class AuxHandler(_JsonDaemonHandler):
        service_id = svc_id

        def do_GET(self) -> None:
            pth = urlparse(self.path).path
            if pth == "/v1/status":
                _send_json(
                    self,
                    200,
                    {
                        "service": svc_id,
                        "status": "minimal",
                        "role": role,
                        "udos_home": str(_udos_home()),
                        "port_env": port_env,
                    },
                )
                return
            super().do_GET()

    return AuxHandler


class _DualStackLoopbackServer(ThreadingHTTPServer):
    address_family = socket.AF_INET6

    def server_bind(self) -> None:
        self.socket.setsockopt(socket.IPPROTO_IPV6, socket.IPV6_V6ONLY, 0)
        super().server_bind()


def _send_json(handler: BaseHTTPRequestHandler, code: int, obj: object) -> None:
    body = json.dumps(obj, separators=(",", ":"), sort_keys=True).encode("utf-8")
    handler.send_response(code)
    handler.send_header("Content-Type", "application/json; charset=utf-8")
    handler.send_header("Content-Length", str(len(body)))
    handler.end_headers()
    handler.wfile.write(body)


def _quiet_log(_fmt: str, *_args: object) -> None:
    return


class _JsonDaemonHandler(BaseHTTPRequestHandler):
    service_id = "udos-unknown"
    protocol_version = "HTTP/1.1"

    def log_message(self, fmt: str, *args: object) -> None:
        _quiet_log(fmt, *args)

    def do_GET(self) -> None:
        path = urlparse(self.path).path
        if path == "/health.json":
            _send_json(
                self,
                200,
                {
                    "service": self.service_id,
                    "status": "ok",
                    "implementation": "lane1-runtime-daemon",
                    "udos_home": str(_udos_home()),
                },
            )
            return
        self.send_error(404, "Not found")


def _thinui_status_surface_block() -> dict:
    """Optional uDOS-surface profile hints for operators (env-driven)."""
    extra: dict = {}
    e = os.environ
    pid = e.get("UDOS_SURFACE_PROFILE_ID", "").strip()
    if pid:
        extra["surface_profile_id"] = pid
    repo = e.get("UDOS_SURFACE_REPO", "").strip()
    if repo:
        extra["surface_repo"] = repo
    f = e.get("UDOS_SURFACE_PROFILE_FILE", "").strip()
    summary: dict | None = None
    if f:
        p = Path(f).expanduser()
        raw = _read_json_file(p)
        if isinstance(raw, dict):
            extra["surface_profile_file"] = str(p)
            thin = raw.get("thinui")
            theme = thin.get("theme") if isinstance(thin, dict) else None
            summary = {
                "id": raw.get("id"),
                "layout": raw.get("layout"),
                "navigation": raw.get("navigation"),
                "theme": theme,
            }
    elif repo:
        prof = pid or "ubuntu-gnome"
        p = Path(repo).expanduser() / "profiles" / prof / "surface.json"
        raw = _read_json_file(p)
        if isinstance(raw, dict):
            extra["surface_profile_file"] = str(p)
            thin = raw.get("thinui")
            theme = thin.get("theme") if isinstance(thin, dict) else None
            summary = {
                "id": raw.get("id"),
                "layout": raw.get("layout"),
                "navigation": raw.get("navigation"),
                "theme": theme,
            }
    if summary:
        extra["surface_profile_summary"] = summary
    return extra


class ThinuiHandler(_JsonDaemonHandler):
    service_id = "udos-thinui"

    def do_GET(self) -> None:
        pth = urlparse(self.path).path
        if pth == "/v1/status":
            body = {
                "service": "udos-thinui",
                "status": "minimal",
                "role": "thinui",
                "udos_home": str(_udos_home()),
                "port_env": "UDOS_THINUI_PORT",
            }
            body.update(_thinui_status_surface_block())
            _send_json(self, 200, body)
            return
        super().do_GET()


_AUX_HTTP_HANDLERS: Dict[str, type] = {
    "budgetd": _make_minimal_aux_handler("udos-budgetd", "budget", "UDOS_BUDGETD_PORT"),
    "networkd": _make_minimal_aux_handler("udos-networkd", "network", "UDOS_NETWORKD_PORT"),
    "scheduled": _make_minimal_aux_handler("udos-scheduled", "scheduled", "UDOS_SCHEDULED_PORT"),
    "tuid": _make_minimal_aux_handler("udos-tuid", "tui", "UDOS_TUID_PORT"),
    "thinui": ThinuiHandler,
    "wizard_adapter": _make_minimal_aux_handler(
        "udos-wizard-adapter", "wizard_adapter", "UDOS_WIZARD_ADAPTER_PORT"
    ),
}


class HostdHandler(_JsonDaemonHandler):
    service_id = "udos-hostd"

    def do_GET(self) -> None:
        path = urlparse(self.path).path
        if path == "/v1/runtime-layout.json":
            home = _udos_home()
            data = _read_json_file(home / "state/hostd/runtime-layout.json")
            if data is None:
                _send_json(
                    self,
                    200,
                    {
                        "service": self.service_id,
                        "udos_home": str(home),
                        "runtime_layout": None,
                        "note": "layout manifest missing; run udos-hostd bootstrap or hostd shell wrapper",
                    },
                )
            else:
                _send_json(
                    self,
                    200,
                    {"service": self.service_id, "udos_home": str(home), "runtime_layout": data},
                )
            return
        super().do_GET()


class VaultdHandler(_JsonDaemonHandler):
    service_id = "udos-vaultd"

    def do_GET(self) -> None:
        path = urlparse(self.path).path
        if path == "/v1/status":
            _send_json(self, 200, _vault_status_payload())
            return
        super().do_GET()


class SyncdHandler(_JsonDaemonHandler):
    service_id = "udos-syncd"

    def do_GET(self) -> None:
        path = urlparse(self.path).path
        if path == "/v1/status":
            _send_json(self, 200, _sync_status_payload())
            return
        super().do_GET()


class CommanddHandler(BaseHTTPRequestHandler):
    """HTTP façade over ``udos-commandd.sh`` CLI (lane 1; no duplicate policy logic)."""

    protocol_version = "HTTP/1.1"
    service_id = "udos-commandd"

    def log_message(self, fmt: str, *args: object) -> None:
        _quiet_log(fmt, *args)

    def do_GET(self) -> None:
        parsed = urlparse(self.path)
        path = parsed.path
        if path == "/health.json":
            _send_json(
                self,
                200,
                {
                    "service": self.service_id,
                    "status": "ok",
                    "implementation": "lane1-commandd-http",
                    "udos_home": str(_udos_home()),
                    "ubuntu_repo_root": str(_ubuntu_repo_root()),
                },
            )
            return
        if path == "/v1/policy-summary":
            code, out, err = _commandd_run(["policy-summary"])
            _send_json(
                self,
                200 if code == 0 else 500,
                {"exit_code": code, "stdout": out, "stderr": err},
            )
            return
        if path == "/v1/list-operations":
            qs = parse_qs(parsed.query or "")
            dom = (qs.get("domain") or [""])[0]
            args = ["list-operations"]
            if dom:
                args.append(dom)
            code, out, err = _commandd_run(args)
            body: Dict[str, Any] = {
                "exit_code": code,
                "stderr": err,
                "parsed": _parse_list_operations_stdout(out) if code == 0 else None,
                "stdout": out,
            }
            _send_json(self, 200 if code == 0 else 500, body)
            return
        if path == "/v1/surface-summary":
            qs = parse_qs(parsed.query or "")
            surface = (qs.get("surface") or ["git"])[0]
            if surface not in ("git", "wizard"):
                _send_json(self, 400, {"error": "surface must be git or wizard"})
                return
            code, out, err = _commandd_run(["surface-summary", surface])
            _send_json(
                self,
                200 if code == 0 else 500,
                {"exit_code": code, "stdout": out, "stderr": err, "surface": surface},
            )
            return
        if path == "/v1/wizard-host-surface.json":
            doc = _read_json_file(_wizard_surface_path())
            if doc is None:
                _send_json(self, 404, {"error": "wizard_host_surface_missing"})
            else:
                _send_json(self, 200, doc)
            return
        self.send_error(404, "Not found")

    def do_POST(self) -> None:
        path = urlparse(self.path).path
        if path != "/v1/repo-op":
            self.send_error(404, "Not found")
            return
        try:
            raw = _read_body_limited(self, _REPO_OP_MAX_BYTES)
        except ValueError as e:
            _send_json(self, 400, {"error": str(e)})
            return
        try:
            body = json.loads(raw.decode("utf-8"))
        except json.JSONDecodeError:
            _send_json(self, 400, {"error": "invalid_json"})
            return
        if not isinstance(body, dict):
            _send_json(self, 400, {"error": "body_must_be_json_object"})
            return
        op_id = body.get("operation_id")
        if not op_id or not isinstance(op_id, str):
            _send_json(self, 400, {"error": "missing_or_invalid_operation_id"})
            return
        args = body.get("arguments", [])
        if args is None:
            args = []
        if not isinstance(args, list):
            _send_json(self, 400, {"error": "arguments_must_be_list"})
            return
        str_args = [str(a) for a in args]
        code, out, err = _commandd_run(["repo-op", op_id, *str_args])
        _send_json(
            self,
            200 if code == 0 else 500,
            {
                "exit_code": code,
                "operation_id": op_id,
                "arguments": str_args,
                "stdout": out,
                "stderr": err,
            },
        )


def _make_web_handler(static_dir: Path):
    root = static_dir.resolve()

    class WebHandler(SimpleHTTPRequestHandler):
        protocol_version = "HTTP/1.1"

        def __init__(self, *args, **kwargs):
            super().__init__(*args, directory=str(root), **kwargs)

        def log_message(self, fmt: str, *args: object) -> None:
            _quiet_log(fmt, *args)

        def do_GET(self) -> None:
            path = urlparse(self.path).path
            if path == "/health.json":
                _send_json(
                    self,
                    200,
                    {
                        "service": "udos-web",
                        "status": "ok",
                        "implementation": "lane1-runtime-daemon",
                        "host_surface": "wizard-host-surface.v1",
                        "udos_home": str(_udos_home()),
                        "ubuntu_repo_root": str(_ubuntu_repo_root()),
                    },
                )
                return
            if path == "/host/contract":
                sp = _wizard_surface_path()
                doc = _read_json_file(sp)
                if doc is None:
                    _send_json(
                        self,
                        500,
                        {
                            "error": "wizard_host_surface_missing",
                            "path": str(sp),
                        },
                    )
                else:
                    _send_json(self, 200, doc)
                return
            if path == "/host/runtime-summary":
                _send_json(self, 200, _build_runtime_summary())
                return
            if path == "/host/orchestration-status":
                _send_json(self, 200, _orchestration_status())
                return
            if path == "/host/budget-status":
                _send_json(self, 200, _budget_status_payload())
                return
            if path == "/host/providers":
                _send_json(self, 200, _providers_payload())
                return
            if path == "/host/local-state":
                with _local_state_lock:
                    st = _load_local_state_dict()
                    lp = _local_state_path()
                _send_json(
                    self,
                    200,
                    {
                        "operation_id": "runtime.host.local-state.get",
                        "local_state": st,
                        "storage_path": str(lp),
                        "updated_utc": _utc_from_mtime(lp),
                    },
                )
                return
            if path == "/host/secrets":
                _send_json(
                    self,
                    200,
                    {
                        "operation_id": "runtime.host.secrets.list",
                        "secrets": [],
                        "note": "Lane 1 does not expose secret values over HTTP; use OS vault and later udos-vaultd APIs.",
                    },
                )
                return
            super().do_GET()

        def do_POST(self) -> None:
            path = urlparse(self.path).path
            if path == "/host/local-state":
                try:
                    raw = _read_body_limited(self, _LOCAL_STATE_MAX_BYTES)
                except ValueError as e:
                    _send_json(self, 400, {"error": str(e)})
                    return
                try:
                    patch = json.loads(raw.decode("utf-8"))
                except json.JSONDecodeError:
                    _send_json(self, 400, {"error": "invalid_json"})
                    return
                if not isinstance(patch, dict):
                    _send_json(self, 400, {"error": "body_must_be_json_object"})
                    return
                with _local_state_lock:
                    cur = _load_local_state_dict()
                    merged = _shallow_merge_state(cur, patch)
                    _atomic_write_json(_local_state_path(), merged)
                    lp = _local_state_path()
                _send_json(
                    self,
                    200,
                    {
                        "operation_id": "runtime.host.local-state.set",
                        "local_state": merged,
                        "storage_path": str(lp),
                        "updated_utc": _utc_from_mtime(lp),
                    },
                )
                return
            if path == "/host/secrets":
                _send_json(
                    self,
                    403,
                    {
                        "error": "not_supported",
                        "operation_id": "runtime.host.secrets.set",
                        "note": "Setting secrets via this HTTP surface is disabled in lane 1; use dedicated vault flows later.",
                    },
                )
                return
            self.send_error(404, "Not found")

    return WebHandler


def _serve(bind: str, port: int, handler_cls: type) -> None:
    if bind == "127.0.0.1":
        try:
            httpd = _DualStackLoopbackServer(("::", port), handler_cls)
        except OSError:
            httpd = ThreadingHTTPServer((bind, port), handler_cls)
    else:
        httpd = ThreadingHTTPServer((bind, port), handler_cls)
    httpd.serve_forever()


def main() -> int:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument(
        "mode",
        choices=(
            "web",
            "commandd",
            "hostd",
            "vaultd",
            "syncd",
            "budgetd",
            "networkd",
            "scheduled",
            "tuid",
            "thinui",
            "wizard_adapter",
        ),
    )
    p.add_argument("--bind", "-b", default=_DEFAULT_BIND)
    p.add_argument("--port", "-p", type=int, required=True)
    p.add_argument("--static", "-d", type=Path, help="Static root for web mode (required for web)")
    args = p.parse_args()

    if args.mode == "web":
        if args.static is None:
            print("runtime_daemon_httpd: web mode requires --static DIR", file=sys.stderr)
            return 2
        if not args.static.is_dir():
            print(f"runtime_daemon_httpd: not a directory: {args.static}", file=sys.stderr)
            return 2
        handler = _make_web_handler(args.static)
    elif args.mode == "commandd":
        handler = CommanddHandler
    elif args.mode == "hostd":
        handler = HostdHandler
    elif args.mode == "vaultd":
        handler = VaultdHandler
    elif args.mode == "syncd":
        handler = SyncdHandler
    elif args.mode in _AUX_HTTP_HANDLERS:
        handler = _AUX_HTTP_HANDLERS[args.mode]
    else:
        return 2

    try:
        _serve(args.bind, args.port, handler)
    except OSError as e:
        print(f"runtime_daemon_httpd: bind {args.bind!r} port {args.port}: {e}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
