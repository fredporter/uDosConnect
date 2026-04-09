from __future__ import annotations

from dataclasses import asdict, dataclass

FOUNDATION_VERSION = "v2.0.1"
RUNTIME_SERVICES_VERSION = "v2.0.2"


@dataclass(frozen=True)
class CapabilitySpec:
    key: str
    owner: str
    kind: str
    route: str
    notes: str


CAPABILITY_SPECS = (
    CapabilitySpec(
        key="core.runtime.command",
        owner="uDOS-core",
        kind="runtime",
        route="local-kernel",
        notes="Canonical command and action execution semantics.",
    ),
    CapabilitySpec(
        key="shell.adapter.operator",
        owner="uDOS-shell",
        kind="shell-adapter",
        route="interactive-shell",
        notes="Operator-facing shell surface for palette and panel workflows.",
    ),
    CapabilitySpec(
        key="wizard.orchestration.provider",
        owner="uDOS-wizard",
        kind="orchestration",
        route="provider-router",
        notes="Provider and remote execution routing behind stable contracts.",
    ),
    CapabilitySpec(
        key="vault.memory.record",
        owner="uDOS-core",
        kind="memory",
        route="vault-store",
        notes="Starter vault and memory persistence conventions.",
    ),
)

RELEASE_LANES = (
    {
        "name": "develop",
        "purpose": "integration lane for active version-round work",
        "promotion_target": "main",
    },
    {
        "name": "main",
        "purpose": "reviewed promotion lane for releasable outputs",
        "promotion_target": "tagged-release",
    },
    {
        "name": "tagged-release",
        "purpose": "versioned release markers and downstream consumption",
        "promotion_target": "consumers",
    },
)

SCHEMA_CATALOG = (
    "schemas/plugin-manifest.schema.json",
    "schemas/binder-workflow.schema.json",
    "schemas/binder-spine-payload.v1.schema.json",
    "schemas/runtime-services.schema.json",
)

RUNTIME_SERVICES = (
    {
        "key": "runtime.command-registry",
        "owner": "uDOS-core",
        "route": "local-kernel",
        "stability": "starter",
        "consumers": ["uDOS-shell", "uHOME-client"],
        "notes": "Enumerates command namespaces and their canonical execution owner.",
    },
    {
        "key": "runtime.capability-registry",
        "owner": "uDOS-core",
        "route": "local-kernel",
        "stability": "starter",
        "consumers": ["uDOS-shell", "uDOS-wizard", "uDOS-empire", "uHOME-client"],
        "notes": "Resolves stable platform capability keys to ownership and route metadata.",
    },
    {
        "key": "runtime.release-lanes",
        "owner": "uDOS-core",
        "route": "promotion-manifest",
        "stability": "starter",
        "consumers": ["uDOS-dev", "uDOS-empire"],
        "notes": "Describes the version-round promotion path and release lane semantics.",
    },
)


class CapabilityRegistry:
    def __init__(self) -> None:
        self._capabilities = {spec.key: spec for spec in CAPABILITY_SPECS}

    def resolve(self, key: str) -> dict:
        spec = self._capabilities.get(key)
        if spec is None:
            return {"key": key, "found": False}
        payload = asdict(spec)
        payload["found"] = True
        return payload

    def summary(self) -> dict:
        return {
            "count": len(self._capabilities),
            "capabilities": [asdict(spec) for spec in CAPABILITY_SPECS],
        }


def release_lane_manifest() -> dict:
    return {
        "version": FOUNDATION_VERSION,
        "default": "develop",
        "lanes": list(RELEASE_LANES),
    }


def foundation_manifest() -> dict:
    return {
        "version": FOUNDATION_VERSION,
        "command_runtime_model": {
            "entrypoint": "uCODE command frame",
            "owner": "uDOS-core",
            "status": "starter",
        },
        "binder_workflow_engine": {
            "owner": "uDOS-core",
            "status": "starter",
            "notes": "In-memory binder tracking with repo-safe upgrade path.",
        },
        "capability_resolution": {
            "owner": "uDOS-core",
            "status": "starter",
            "count": len(CAPABILITY_SPECS),
        },
        "plugin_package_contracts": {
            "owner": "uDOS-core",
            "index_repo": "uDOS-plugin-index",
            "status": "starter",
        },
        "mcp_abstraction": {
            "owner": "uDOS-core",
            "integration_owner": "uDOS-wizard",
            "status": "starter",
        },
        "provider_abstraction": {
            "owner": "uDOS-core",
            "execution_owner": "uDOS-wizard",
            "status": "starter",
        },
        "vault_memory_conventions": {
            "owner": "uDOS-core",
            "status": "starter",
            "root": "memory/vault",
        },
        "release_lane_semantics": release_lane_manifest(),
        "conformance_tests": {
            "owner": "uDOS-core",
            "status": "starter",
            "entrypoints": [
                "scripts/run-core-checks.sh",
                "scripts/run-contract-enforcement.sh",
            ],
        },
        "schemas": list(SCHEMA_CATALOG),
    }


def runtime_services_manifest() -> dict:
    return {
        "version": RUNTIME_SERVICES_VERSION,
        "extends": FOUNDATION_VERSION,
        "count": len(RUNTIME_SERVICES),
        "services": list(RUNTIME_SERVICES),
    }
