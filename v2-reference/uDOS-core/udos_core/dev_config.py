from __future__ import annotations

import os
import re
from pathlib import Path
from typing import Any

_ENV_REF_RE = re.compile(r"\$\{([^}]+)\}")


def family_root() -> Path:
    return Path(__file__).resolve().parents[2]


def core_repo_root() -> Path:
    return Path(__file__).resolve().parents[1]


def _parse_env_file(path: Path) -> dict[str, str]:
    if not path.exists():
        return {}

    values: dict[str, str] = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        raw = line.strip()
        if not raw or raw.startswith("#") or "=" not in raw:
            continue
        key, value = raw.split("=", 1)
        key = key.strip()
        value = value.strip().strip('"').strip("'")
        if key and value:
            values[key] = value
    return values


def _default_lookup(environ: dict[str, str] | None = None) -> dict[str, str]:
    env_home = ""
    if environ is not None:
        env_home = str(environ.get("HOME", "")).strip()
    home = Path(env_home).expanduser() if env_home else Path.home()
    defaults = {
        "HOME": str(home),
        "UDOS_HOME": str(home / ".udos"),
    }
    defaults["UDOS_STATE_ROOT"] = f'{defaults["UDOS_HOME"]}/state'
    defaults["UDOS_CACHE_ROOT"] = f'{defaults["UDOS_HOME"]}/cache'
    defaults["UDOS_LOG_ROOT"] = f'{defaults["UDOS_HOME"]}/logs'
    defaults["UDOS_VAULT_ROOT"] = f'{defaults["UDOS_STATE_ROOT"]}/vault'
    defaults["WIZARD_STATE_ROOT"] = f'{defaults["UDOS_STATE_ROOT"]}/wizard'
    defaults["UDOS_RENDER_ROOT"] = f'{defaults["UDOS_STATE_ROOT"]}/rendered'
    defaults["WIZARD_RESULT_STORE_PATH"] = f'{defaults["WIZARD_STATE_ROOT"]}/orchestration-results.json'
    return defaults


def _expand_value(raw: str, lookup: dict[str, str]) -> str:
    expanded = str(raw)
    for _ in range(5):
        updated = _ENV_REF_RE.sub(lambda match: lookup.get(match.group(1), match.group(0)), expanded)
        if updated == expanded:
            break
        expanded = updated
    return os.path.expanduser(expanded)


def _expanded_mapping(*sources: dict[str, str]) -> dict[str, str]:
    merged: dict[str, str] = {}
    for source in sources:
        merged.update(source)
    expanded: dict[str, str] = {}
    for key, value in merged.items():
        expanded[key] = _expand_value(value, {**merged, **expanded})
    return expanded


def _with_derived_roots(values: dict[str, str], explicit_keys: set[str] | None = None) -> dict[str, str]:
    derived = dict(values)
    explicit = explicit_keys or set()
    udos_home = str(derived.get("UDOS_HOME") or "").strip()
    if not udos_home:
        return derived
    if "UDOS_STATE_ROOT" not in explicit:
        derived["UDOS_STATE_ROOT"] = f"{udos_home}/state"
    if "UDOS_CACHE_ROOT" not in explicit:
        derived["UDOS_CACHE_ROOT"] = f"{udos_home}/cache"
    if "UDOS_LOG_ROOT" not in explicit:
        derived["UDOS_LOG_ROOT"] = f"{udos_home}/logs"
    if "UDOS_VAULT_ROOT" not in explicit:
        derived["UDOS_VAULT_ROOT"] = f'{derived["UDOS_STATE_ROOT"]}/vault'
    if "WIZARD_STATE_ROOT" not in explicit:
        derived["WIZARD_STATE_ROOT"] = f'{derived["UDOS_STATE_ROOT"]}/wizard'
    if "UDOS_RENDER_ROOT" not in explicit:
        derived["UDOS_RENDER_ROOT"] = f'{derived["UDOS_STATE_ROOT"]}/rendered'
    if "WIZARD_RESULT_STORE_PATH" not in explicit:
        derived["WIZARD_RESULT_STORE_PATH"] = f'{derived["WIZARD_STATE_ROOT"]}/orchestration-results.json'
    return _expanded_mapping(derived)


class DevConfig:
    def __init__(
        self,
        *,
        repo_root: Path | None = None,
        home_env_path: Path | None = None,
        environ: dict[str, str] | None = None,
    ) -> None:
        self.repo_root = Path(repo_root or core_repo_root()).resolve()
        self.environ = environ if environ is not None else os.environ
        self.defaults = _expanded_mapping(_default_lookup(self.environ))
        hinted_home = self.environ.get("UDOS_HOME") or self.defaults["UDOS_HOME"]
        self.home_env_path = home_env_path or (Path(hinted_home).expanduser() / ".env")
        home_file_values = _parse_env_file(self.home_env_path)
        self.home_env = _with_derived_roots(
            _expanded_mapping(self.defaults, home_file_values),
            explicit_keys=set(home_file_values.keys()),
        )
        repo_file_values = _parse_env_file(self.repo_root / ".env")
        self.repo_env = _with_derived_roots(
            _expanded_mapping(self.defaults, self.home_env, repo_file_values),
            explicit_keys=set(home_file_values.keys()) | set(repo_file_values.keys()),
        )

    def _state_value(self, key: str) -> str:
        from .local_state import state_value

        state_environ = dict(self.environ)
        if "UDOS_STATE_ROOT" not in state_environ:
            state_environ["UDOS_STATE_ROOT"] = str(
                self.repo_env.get("UDOS_STATE_ROOT")
                or self.home_env.get("UDOS_STATE_ROOT")
                or _expand_value(self.defaults["UDOS_STATE_ROOT"], self.snapshot())
            )
        return state_value(key, repo_root=self.repo_root, environ=state_environ)

    def get(self, key: str, default: Any = None) -> Any:
        process_value = str(self.environ.get(key, "")).strip()
        if process_value:
            return process_value

        repo_value = str(self.repo_env.get(key, "")).strip()
        if repo_value:
            return repo_value

        home_value = str(self.home_env.get(key, "")).strip()
        if home_value:
            return home_value

        persisted_value = self._state_value(key)
        if persisted_value:
            return persisted_value

        default_value = self.defaults.get(key)
        if default_value not in (None, ""):
            return default_value
        return default

    def get_str(self, key: str, default: str = "") -> str:
        value = self.get(key, default)
        return str(value) if value is not None else default

    def get_bool(self, key: str, default: bool = False) -> bool:
        value = self.get_str(key, "")
        if value.lower() in {"1", "true", "yes", "on"}:
            return True
        if value.lower() in {"0", "false", "no", "off"}:
            return False
        return default

    def get_int(self, key: str, default: int = 0) -> int:
        value = self.get(key, None)
        if value is None:
            return default
        try:
            return int(str(value))
        except (TypeError, ValueError):
            return default

    def get_path(self, key: str, default: Path | None = None) -> Path | None:
        value = self.get(key, None)
        if value in (None, ""):
            return default
        return Path(_expand_value(str(value), self.snapshot())).expanduser().resolve()

    def snapshot(self) -> dict[str, str]:
        return {
            **self.defaults,
            **self.home_env,
            **self.repo_env,
            **{key: value for key, value in self.environ.items() if value},
        }

    def apply(self) -> dict[str, str]:
        applied: dict[str, str] = {}
        for key in (
            "UDOS_HOME",
            "UDOS_STATE_ROOT",
            "UDOS_CACHE_ROOT",
            "UDOS_LOG_ROOT",
            "UDOS_VAULT_ROOT",
            "WIZARD_STATE_ROOT",
            "UDOS_RENDER_ROOT",
            "WIZARD_RESULT_STORE_PATH",
        ):
            value = self.get_str(key, "")
            if value and key not in self.environ:
                self.environ[key] = value
                applied[key] = value
        return applied


def load_dev_config(
    *,
    repo_root: Path | None = None,
    home_env_path: Path | None = None,
    environ: dict[str, str] | None = None,
) -> DevConfig:
    config = DevConfig(repo_root=repo_root, home_env_path=home_env_path, environ=environ)
    config.apply()
    return config


def get_str(key: str, default: str = "", *, repo_root: Path | None = None) -> str:
    return load_dev_config(repo_root=repo_root).get_str(key, default)


def get_bool(key: str, default: bool = False, *, repo_root: Path | None = None) -> bool:
    return load_dev_config(repo_root=repo_root).get_bool(key, default)


def get_int(key: str, default: int = 0, *, repo_root: Path | None = None) -> int:
    return load_dev_config(repo_root=repo_root).get_int(key, default)


def get_path(key: str, default: Path | None = None, *, repo_root: Path | None = None) -> Path | None:
    return load_dev_config(repo_root=repo_root).get_path(key, default)


def udos_home(*, repo_root: Path | None = None) -> Path:
    return get_path("UDOS_HOME", repo_root=repo_root) or (Path.home() / ".udos")


def udos_state_root(*, repo_root: Path | None = None) -> Path:
    return get_path("UDOS_STATE_ROOT", repo_root=repo_root) or (udos_home(repo_root=repo_root) / "state")


def wizard_state_root(*, repo_root: Path | None = None) -> Path:
    return get_path("WIZARD_STATE_ROOT", repo_root=repo_root) or (udos_state_root(repo_root=repo_root) / "wizard")


def render_root(*, repo_root: Path | None = None) -> Path:
    return get_path("UDOS_RENDER_ROOT", repo_root=repo_root) or (udos_state_root(repo_root=repo_root) / "rendered")
