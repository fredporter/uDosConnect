from __future__ import annotations

import json
import secrets
from pathlib import Path
from typing import Any

from .dev_config import udos_state_root

_STATE_KEY_MAP = {
    "UDOS_INSTALL_ID": ("install_id",),
    "USER_NAME": ("user", "name"),
    "USER_ROLE": ("user", "role"),
    "UDOS_VIEWPORT": ("preferences", "viewport"),
}


def local_state_path(*, repo_root: Path | None = None, environ: dict[str, str] | None = None) -> Path:
    if environ:
        state_root = str(environ.get("UDOS_STATE_ROOT") or "").strip()
        if state_root:
            return Path(state_root).expanduser().resolve() / "local-state.json"
        udos_home = str(environ.get("UDOS_HOME") or "").strip()
        if udos_home:
            return Path(udos_home).expanduser().resolve() / "state" / "local-state.json"
        home = str(environ.get("HOME") or "").strip()
        if home:
            return Path(home).expanduser().resolve() / ".udos" / "state" / "local-state.json"
    return udos_state_root(repo_root=repo_root) / "local-state.json"


def _default_state() -> dict[str, Any]:
    return {
        "install_id": "",
        "user": {"name": "", "role": ""},
        "preferences": {"viewport": ""},
    }


def load_local_state(*, repo_root: Path | None = None, environ: dict[str, str] | None = None) -> dict[str, Any]:
    path = local_state_path(repo_root=repo_root, environ=environ)
    if not path.exists():
        return _default_state()
    try:
        payload = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return _default_state()
    if not isinstance(payload, dict):
        return _default_state()

    state = _default_state()
    state["install_id"] = str(payload.get("install_id") or "")
    user = payload.get("user") or {}
    preferences = payload.get("preferences") or {}
    if isinstance(user, dict):
        state["user"]["name"] = str(user.get("name") or "")
        state["user"]["role"] = str(user.get("role") or "")
    if isinstance(preferences, dict):
        state["preferences"]["viewport"] = str(preferences.get("viewport") or "")
    return state


def save_local_state(
    state: dict[str, Any],
    *,
    repo_root: Path | None = None,
    environ: dict[str, str] | None = None,
) -> dict[str, Any]:
    payload = _default_state()
    payload["install_id"] = str(state.get("install_id") or "")
    user = state.get("user") or {}
    preferences = state.get("preferences") or {}
    if isinstance(user, dict):
        payload["user"]["name"] = str(user.get("name") or "")
        payload["user"]["role"] = str(user.get("role") or "")
    if isinstance(preferences, dict):
        payload["preferences"]["viewport"] = str(preferences.get("viewport") or "")
    path = local_state_path(repo_root=repo_root, environ=environ)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    return payload


def update_local_state(
    updates: dict[str, Any],
    *,
    repo_root: Path | None = None,
    environ: dict[str, str] | None = None,
) -> dict[str, Any]:
    state = load_local_state(repo_root=repo_root, environ=environ)

    if "install_id" in updates:
        state["install_id"] = str(updates.get("install_id") or "")

    user = updates.get("user")
    if isinstance(user, dict):
        if "name" in user:
            state["user"]["name"] = str(user.get("name") or "")
        if "role" in user:
            state["user"]["role"] = str(user.get("role") or "")

    preferences = updates.get("preferences")
    if isinstance(preferences, dict):
        if "viewport" in preferences:
            state["preferences"]["viewport"] = str(preferences.get("viewport") or "")

    return save_local_state(state, repo_root=repo_root, environ=environ)


def ensure_install_id(*, repo_root: Path | None = None, environ: dict[str, str] | None = None) -> str:
    state = load_local_state(repo_root=repo_root, environ=environ)
    install_id = str(state.get("install_id") or "").strip()
    if install_id:
        return install_id
    install_id = f"udos-{secrets.token_hex(8)}"
    state["install_id"] = install_id
    save_local_state(state, repo_root=repo_root, environ=environ)
    return install_id


def state_value(key: str, *, repo_root: Path | None = None, environ: dict[str, str] | None = None) -> str:
    path = _STATE_KEY_MAP.get(key)
    if path is None:
        return ""
    current: Any = load_local_state(repo_root=repo_root, environ=environ)
    for part in path:
        if not isinstance(current, dict):
            return ""
        current = current.get(part)
    return str(current or "")
