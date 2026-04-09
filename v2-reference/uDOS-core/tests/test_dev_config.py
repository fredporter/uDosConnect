from __future__ import annotations

from pathlib import Path

from udos_core.dev_config import load_dev_config
from udos_core.local_state import ensure_install_id, load_local_state


def test_dev_config_precedence_prefers_process_env_then_repo_then_home_then_state(tmp_path: Path) -> None:
    repo_root = tmp_path / "repo"
    repo_root.mkdir()
    home_env_path = tmp_path / "home.env"
    home_env_path.write_text(
        "UDOS_HOME=${HOME}/.udos-home\nSHARED_KEY=from-home\n",
        encoding="utf-8",
    )
    (repo_root / ".env").write_text(
        "SHARED_KEY=from-repo\nUDOS_VAULT_ROOT=${UDOS_HOME}/vault-custom\n",
        encoding="utf-8",
    )
    environ = {"HOME": str(tmp_path / "home"), "SHARED_KEY": "from-process"}
    state_root = Path(environ["HOME"]) / ".udos-home" / "state"
    state_root.mkdir(parents=True, exist_ok=True)
    (state_root / "local-state.json").write_text(
        '{\n  "install_id": "udos-state",\n  "user": {"name": "state-user", "role": "admin"},\n  "preferences": {"viewport": "100x40"}\n}\n',
        encoding="utf-8",
    )

    config = load_dev_config(repo_root=repo_root, home_env_path=home_env_path, environ=environ)

    assert config.get_str("SHARED_KEY") == "from-process"
    assert config.get_str("USER_NAME") == "state-user"
    assert config.get_str("USER_ROLE") == "admin"
    assert config.get_str("UDOS_VIEWPORT") == "100x40"
    assert config.get_path("UDOS_VAULT_ROOT") == (Path(environ["HOME"]) / ".udos-home" / "vault-custom").resolve()


def test_ensure_install_id_bootstraps_and_reuses_value(tmp_path: Path) -> None:
    environ = {"UDOS_STATE_ROOT": str(tmp_path / "state")}

    first = ensure_install_id(environ=environ)
    second = ensure_install_id(environ=environ)
    state = load_local_state(environ=environ)

    assert first == second
    assert first.startswith("udos-")
    assert state["install_id"] == first


def test_local_state_loader_handles_malformed_json(tmp_path: Path) -> None:
    state_root = tmp_path / "state"
    state_root.mkdir(parents=True, exist_ok=True)
    (state_root / "local-state.json").write_text("{not-json", encoding="utf-8")

    state = load_local_state(environ={"UDOS_STATE_ROOT": str(state_root)})

    assert state["install_id"] == ""
    assert state["user"]["name"] == ""
