import json
from pathlib import Path
import os

from udos_core.runtime import RuntimeKernel


def test_system_foundation_reports_v2_0_1_manifest():
    kernel = RuntimeKernel()

    result = kernel.execute("#system foundation")

    assert result["ok"] is True
    manifest = result["data"]["manifest"]
    assert manifest["version"] == "v2.0.1"
    assert manifest["command_runtime_model"]["owner"] == "uDOS-core"
    assert "schemas/plugin-manifest.schema.json" in manifest["schemas"]


def test_capability_resolve_returns_known_capability():
    kernel = RuntimeKernel()

    result = kernel.execute("#capability resolve shell.adapter.operator")

    assert result["ok"] is True
    capability = result["data"]["capability"]
    assert capability["found"] is True
    assert capability["owner"] == "uDOS-shell"


def test_release_lanes_return_default_lane():
    kernel = RuntimeKernel()

    result = kernel.execute("#release lanes")

    assert result["ok"] is True
    lanes = result["data"]["lanes"]
    assert lanes["version"] == "v2.0.1"
    assert lanes["default"] == "develop"


def test_runtime_services_reports_v2_0_2_starter_manifest():
    kernel = RuntimeKernel()

    result = kernel.execute("#runtime services")

    assert result["ok"] is True
    services = result["data"]["services"]
    assert services["version"] == "v2.0.2"
    assert services["extends"] == "v2.0.1"
    assert services["count"] >= 3


def test_runtime_services_contract_artifact_matches_command_surface():
    kernel = RuntimeKernel()

    result = kernel.execute("#runtime services")

    assert result["ok"] is True
    services = result["data"]["services"]
    artifact_path = Path(__file__).resolve().parents[1] / "contracts" / "runtime-services.json"
    artifact = json.loads(artifact_path.read_text(encoding="utf-8"))
    assert artifact == services


def test_vault_health_uses_configured_state_root(tmp_path: Path):
    os.environ["UDOS_VAULT_ROOT"] = str(tmp_path / "vault-root")
    try:
        kernel = RuntimeKernel()
        result = kernel.execute("#vault health")
    finally:
        os.environ.pop("UDOS_VAULT_ROOT", None)

    assert result["ok"] is True
    assert result["data"]["vault"]["vault_root"] == str((tmp_path / "vault-root").resolve())
