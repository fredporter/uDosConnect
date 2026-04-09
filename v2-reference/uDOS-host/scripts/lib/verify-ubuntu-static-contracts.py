#!/usr/bin/env python3
"""Static contract checks for uDOS-host (extracted from run-ubuntu-checks.sh, OB-R4).

Required-file existence is enforced via ``ubuntu-check-required-files.v1.list``
(shared with ``run-ubuntu-checks.sh``). Run from repository root (same cwd as
``run-ubuntu-checks.sh``).
"""

from __future__ import annotations

import json
from pathlib import Path

MANIFEST_REL = Path("scripts/lib/ubuntu-check-required-files.v1.list")


def require_manifest_files(repo_root: Path) -> None:
    manifest = repo_root / MANIFEST_REL
    if not manifest.is_file():
        raise SystemExit(f"missing required manifest: {MANIFEST_REL}")
    for raw in manifest.read_text(encoding="utf-8").splitlines():
        stripped = raw.strip()
        if not stripped or stripped.startswith("#"):
            continue
        rel = Path(stripped)
        path = repo_root / rel
        if not path.is_file():
            raise SystemExit(f"missing required file (manifest): {rel}")


def main() -> None:
    repo_root = Path(".").resolve()
    require_manifest_files(repo_root)
    packages = (repo_root / "config" / "packages.list").read_text(encoding="utf-8").splitlines()
    if not any(line.strip() and not line.startswith("#") for line in packages):
        raise SystemExit("config/packages.list must include at least one package entry")
    google_mvp_host = json.loads(
        (repo_root / "examples" / "google-mvp-host-profile.json").read_text(encoding="utf-8")
    )
    api_envelope = json.loads(
        (repo_root / "contracts" / "udos-commandd" / "api-envelope.schema.json").read_text(
            encoding="utf-8"
        )
    )
    operation_registry = json.loads(
        (repo_root / "contracts" / "udos-commandd" / "operation-registry.v1.json").read_text(
            encoding="utf-8"
        )
    )
    minimum_operations = json.loads(
        (repo_root / "contracts" / "udos-commandd" / "minimum-operations.v1.json").read_text(
            encoding="utf-8"
        )
    )
    wizard_host_surface = json.loads(
        (repo_root / "contracts" / "udos-commandd" / "wizard-host-surface.v1.json").read_text(
            encoding="utf-8"
        )
    )
    git_host_surface = json.loads(
        (repo_root / "contracts" / "udos-commandd" / "git-host-surface.v1.json").read_text(
            encoding="utf-8"
        )
    )
    runtime_yaml = (repo_root / "config" / "runtime" / "runtime.yaml.example").read_text(
        encoding="utf-8"
    )
    git_repos_yaml = (repo_root / "config" / "runtime" / "git-repos.yaml.example").read_text(
        encoding="utf-8"
    )
    github_policy = json.loads(
        (repo_root / "config" / "policy" / "github-action-policy.json.example").read_text(
            encoding="utf-8"
        )
    )
    if google_mvp_host.get("profile") != "always-on-local-mirror-cache-host":
        raise SystemExit("examples/google-mvp-host-profile.json profile must be always-on-local-mirror-cache-host")
    if google_mvp_host.get("fallback_rules", {}).get("canonical_truth") != "local vault and family-owned extracted artifacts":
        raise SystemExit(
            "examples/google-mvp-host-profile.json fallback_rules.canonical_truth must remain local-family-owned"
        )
    if api_envelope.get("title") != "uDOS commandd API envelope":
        raise SystemExit("contracts/udos-commandd/api-envelope.schema.json title mismatch")
    registry_ops = {item["operation_id"] for item in operation_registry.get("operations", [])}
    minimum_ops = [item["operation_id"] for item in minimum_operations.get("minimum_operations", [])]
    if not minimum_ops:
        raise SystemExit("contracts/udos-commandd/minimum-operations.v1.json must define at least one minimum operation")
    if wizard_host_surface.get("owner") != "uDOS-host":
        raise SystemExit("contracts/udos-commandd/wizard-host-surface.v1.json owner mismatch")
    if wizard_host_surface.get("base_path") != "/host":
        raise SystemExit("contracts/udos-commandd/wizard-host-surface.v1.json base_path mismatch")
    if git_host_surface.get("owner") != "uDOS-host":
        raise SystemExit("contracts/udos-commandd/git-host-surface.v1.json owner mismatch")
    if git_host_surface.get("base_path") != "/repos":
        raise SystemExit("contracts/udos-commandd/git-host-surface.v1.json base_path mismatch")
    if git_host_surface.get("adapter_rule", {}).get("policy_source") != "config/policy/github-action-policy.json.example":
        raise SystemExit("contracts/udos-commandd/git-host-surface.v1.json policy_source mismatch")
    git_ops = {item["operation_id"] for item in git_host_surface.get("operations", [])}
    required_git_ops = {"repo.list", "repo.status", "repo.fetch", "repo.pull", "repo.clone_or_attach"}
    missing_git_surface_ops = sorted(required_git_ops - git_ops)
    if missing_git_surface_ops:
        raise SystemExit(f"git host surface missing required operations: {missing_git_surface_ops}")
    if 'repos: "~/.udos/repos"' not in runtime_yaml:
        raise SystemExit("config/runtime/runtime.yaml.example must declare ~/.udos/repos")
    if 'repo_registry: "~/.udos/state/gitd/repo-registry.tsv"' not in runtime_yaml:
        raise SystemExit("config/runtime/runtime.yaml.example must declare gitd repo registry path")
    if "repo_store:" not in git_repos_yaml or "repo_id: uDOS-host" not in git_repos_yaml:
        raise SystemExit("config/runtime/git-repos.yaml.example must define repo_store and at least uDOS-host")
    if github_policy.get("policy_id") != "ubuntu-github-action-policy":
        raise SystemExit("config/policy/github-action-policy.json.example policy_id mismatch")
    if github_policy.get("repo_rules", {}).get("repo.push", {}).get("mode") != "require-approval":
        raise SystemExit("config/policy/github-action-policy.json.example must gate repo.push with approval")
    if github_policy.get("github_rules", {}).get("github.pr.create", {}).get("mode") != "require-approval":
        raise SystemExit("config/policy/github-action-policy.json.example must gate github.pr.create with approval")
    missing_ops = [op for op in minimum_ops if op not in registry_ops]
    if missing_ops:
        raise SystemExit(f"minimum operations missing from operation registry: {missing_ops}")
    static_demo = json.loads(
        (repo_root / "contracts" / "udos-web" / "command-centre-static-demo.v1.json").read_text(
            encoding="utf-8"
        )
    )
    if static_demo.get("contract_id") != "udos-web.command-centre-static-demo.v1":
        raise SystemExit("contracts/udos-web/command-centre-static-demo.v1.json contract_id mismatch")
    if static_demo.get("protocol_family") != "v2":
        raise SystemExit("contracts/udos-web/command-centre-static-demo.v1.json protocol_family must be v2")
    web_env_text = (repo_root / "config" / "env" / "udos-web.env.example").read_text(encoding="utf-8")
    web_env: dict[str, str] = {}
    for line in web_env_text.splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        k, v = line.split("=", 1)
        web_env[k.strip()] = v.strip()
    web_bind = web_env.get("UDOS_WEB_BIND")
    web_port_s = web_env.get("UDOS_WEB_PORT")
    if web_bind is None or web_port_s is None:
        raise SystemExit("config/env/udos-web.env.example must set UDOS_WEB_BIND and UDOS_WEB_PORT")
    web_port = int(web_port_s)
    if static_demo["defaults"]["bind"] != web_bind or static_demo["defaults"]["port"] != web_port:
        raise SystemExit("command-centre-static-demo defaults must match udos-web.env.example")
    listen_sh = (repo_root / "scripts" / "lib" / "udos-web-listen.sh").read_text(encoding="utf-8")
    if f"UDOS_WEB_DEFAULT_BIND={web_bind}" not in listen_sh or f"UDOS_WEB_DEFAULT_PORT={web_port}" not in listen_sh:
        raise SystemExit("scripts/lib/udos-web-listen.sh defaults must match udos-web.env.example")


if __name__ == "__main__":
    main()
