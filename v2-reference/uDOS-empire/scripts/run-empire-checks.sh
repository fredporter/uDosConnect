#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SHARED_PYTHON_BIN="${UDOS_SHARED_PYTHON_BIN:-}"
USE_SHARED_RESOURCES="${UDOS_USE_SHARED_RESOURCES:-1}"
VENV_DIR="${UDOS_VENV_DIR:-$HOME/.udos/venv/empire}"
PYTHON_BIN="$VENV_DIR/bin/python"

require_file() {
  if [ ! -f "$1" ]; then
    echo "missing required file: $1" >&2
    exit 1
  fi
}

cd "$REPO_ROOT"
mkdir -p "$VENV_DIR"

if [ "$USE_SHARED_RESOURCES" = "1" ] && [ -z "$SHARED_PYTHON_BIN" ]; then
    FAMILY_HELPER="$REPO_ROOT/../scripts/lib/family-python.sh"
    if [ -f "$FAMILY_HELPER" ]; then
        # shellcheck source=/dev/null
        . "$FAMILY_HELPER"
        ensure_shared_python
        SHARED_PYTHON_BIN="${UDOS_SHARED_PYTHON_BIN:-}"
    fi
fi

if [ -n "$SHARED_PYTHON_BIN" ] && [ -x "$SHARED_PYTHON_BIN" ]; then
    PYTHON_BIN="$SHARED_PYTHON_BIN"
elif [ ! -x "$PYTHON_BIN" ]; then
    PYTHON_BIN="python3"
fi

require_file "$REPO_ROOT/README.md"
require_file "$REPO_ROOT/docs/architecture.md"
require_file "$REPO_ROOT/docs/boundary.md"
require_file "$REPO_ROOT/docs/getting-started.md"
require_file "$REPO_ROOT/docs/examples.md"
require_file "$REPO_ROOT/docs/activation.md"
require_file "$REPO_ROOT/docs/wordpress-md-publishing-contract.md"
require_file "$REPO_ROOT/docs/data-safety-and-rollback.md"
require_file "$REPO_ROOT/docs/v2.0.1-sync-alignment.md"
require_file "$REPO_ROOT/packs/README.md"
require_file "$REPO_ROOT/packs/legacy/README.md"
require_file "$REPO_ROOT/packs/campaign-starter/README.md"
require_file "$REPO_ROOT/packs/campaign-starter/pack.json"
require_file "$REPO_ROOT/packs/campaign-starter/templates/message-template.md"
require_file "$REPO_ROOT/packs/campaign-starter/sample-data/audience-segment.json"
require_file "$REPO_ROOT/packs/campaign-starter/sample-data/preview-input.json"
require_file "$REPO_ROOT/packs/event-launch/README.md"
require_file "$REPO_ROOT/packs/event-launch/pack.json"
require_file "$REPO_ROOT/packs/event-launch/templates/landing-page.md"
require_file "$REPO_ROOT/packs/event-launch/sample-data/event-brief.json"
require_file "$REPO_ROOT/packs/event-launch/sample-data/preview-input.json"
require_file "$REPO_ROOT/packs/weekly-bulletin/README.md"
require_file "$REPO_ROOT/packs/weekly-bulletin/pack.json"
require_file "$REPO_ROOT/packs/weekly-bulletin/templates/bulletin.md"
require_file "$REPO_ROOT/packs/weekly-bulletin/sample-data/preview-input.json"
require_file "$REPO_ROOT/packs/contact-import-cleanup/README.md"
require_file "$REPO_ROOT/packs/contact-import-cleanup/pack.json"
require_file "$REPO_ROOT/packs/contact-import-cleanup/templates/cleanup-report.md"
require_file "$REPO_ROOT/packs/contact-import-cleanup/sample-data/preview-input.json"
require_file "$REPO_ROOT/packs/wordpress-contact-import/README.md"
require_file "$REPO_ROOT/packs/wordpress-contact-import/pack.json"
require_file "$REPO_ROOT/packs/wordpress-contact-import/templates/import-preview.md"
require_file "$REPO_ROOT/packs/wordpress-contact-import/sample-data/preview-input.json"
require_file "$REPO_ROOT/schemas/pack-manifest.schema.json"
require_file "$REPO_ROOT/src/README.md"
require_file "$REPO_ROOT/src/legacy/README.md"
require_file "$REPO_ROOT/src/legacy/asset-inventory.json"
require_file "$REPO_ROOT/src/wordpress-plugin/README.md"
require_file "$REPO_ROOT/src/wordpress-plugin/plugin-manifest.json"
require_file "$REPO_ROOT/src/wordpress-plugin/contact-record-profile.json"
require_file "$REPO_ROOT/src/uhome_empire/__init__.py"
require_file "$REPO_ROOT/src/uhome_empire/packs.py"
require_file "$REPO_ROOT/src/udos_empire/__init__.py"
require_file "$REPO_ROOT/src/udos_empire/packs.py"
require_file "$REPO_ROOT/src/udos_empire_compat/__init__.py"
require_file "$REPO_ROOT/src/udos_empire_compat/README.md"
require_file "$REPO_ROOT/src/udos_empire_compat/legacy_sync_runtime.py"
require_file "$REPO_ROOT/src/workflow-pattern.json"
require_file "$REPO_ROOT/src/sync-contract.json"
require_file "$REPO_ROOT/src/sync-record-profile.json"
require_file "$REPO_ROOT/src/containers/README.md"
require_file "$REPO_ROOT/src/containers/container-job-catalog.json"
require_file "$REPO_ROOT/src/containers/google-workspace-sync-container.json"
require_file "$REPO_ROOT/src/containers/hubspot-sync-container.json"
require_file "$REPO_ROOT/src/containers/binder-release-webhook-container.json"
require_file "$REPO_ROOT/src/webhooks/README.md"
require_file "$REPO_ROOT/src/webhooks/connection-template.json"
require_file "$REPO_ROOT/src/webhooks/google-sync-template.json"
require_file "$REPO_ROOT/src/webhooks/google-mvp-binder-trigger-template.json"
require_file "$REPO_ROOT/src/webhooks/hubspot-sync-template.json"
require_file "$REPO_ROOT/src/webhooks/webhook-server-template.json"
require_file "$REPO_ROOT/src/webhooks/mappings/default-contact-master.json"
require_file "$REPO_ROOT/src/webhooks/mappings/google-lead-enrichment.json"
require_file "$REPO_ROOT/src/webhooks/mappings/calendar-followup-task.json"
require_file "$REPO_ROOT/scripts/README.md"
require_file "$REPO_ROOT/scripts/smoke/sync_plan.py"
require_file "$REPO_ROOT/scripts/smoke/pack_catalog.py"
require_file "$REPO_ROOT/scripts/smoke/pack_preview.py"
require_file "$REPO_ROOT/scripts/smoke/pack_run.py"
require_file "$REPO_ROOT/scripts/smoke/hubspot_lane_gate.py"
require_file "$REPO_ROOT/scripts/smoke/live_wizard_smoke.py"
require_file "$REPO_ROOT/scripts/smoke/live_wizard_gate.py"
require_file "$REPO_ROOT/scripts/smoke/wordpress_md_publish_smoke.py"
require_file "$REPO_ROOT/scripts/smoke/data_safety_smoke.py"
require_file "$REPO_ROOT/tests/README.md"
require_file "$REPO_ROOT/config/README.md"
require_file "$REPO_ROOT/examples/README.md"
require_file "$REPO_ROOT/examples/basic-empire-flow.json"
require_file "$REPO_ROOT/examples/basic-sync-record-envelope.json"
require_file "$REPO_ROOT/examples/configurable-webhook-server.json"
require_file "$REPO_ROOT/examples/google-mvp-binder-trigger.json"
require_file "$REPO_ROOT/examples/google-mvp-generated-service-extract.json"

"$PYTHON_BIN" - <<'PY'
import json
from pathlib import Path

repo_root = Path(".").resolve()
source = json.loads((repo_root / "src" / "workflow-pattern.json").read_text(encoding="utf-8"))
sync_contract = json.loads((repo_root / "src" / "sync-contract.json").read_text(encoding="utf-8"))
sync_record_profile = json.loads((repo_root / "src" / "sync-record-profile.json").read_text(encoding="utf-8"))
legacy_inventory = json.loads((repo_root / "src" / "legacy" / "asset-inventory.json").read_text(encoding="utf-8"))
plugin_manifest = json.loads((repo_root / "src" / "wordpress-plugin" / "plugin-manifest.json").read_text(encoding="utf-8"))
contact_record_profile = json.loads((repo_root / "src" / "wordpress-plugin" / "contact-record-profile.json").read_text(encoding="utf-8"))
pack_manifest_schema = json.loads((repo_root / "schemas" / "pack-manifest.schema.json").read_text(encoding="utf-8"))
container_catalog = json.loads((repo_root / "src" / "containers" / "container-job-catalog.json").read_text(encoding="utf-8"))
google_container = json.loads((repo_root / "src" / "containers" / "google-workspace-sync-container.json").read_text(encoding="utf-8"))
hubspot_container = json.loads((repo_root / "src" / "containers" / "hubspot-sync-container.json").read_text(encoding="utf-8"))
binder_container = json.loads((repo_root / "src" / "containers" / "binder-release-webhook-container.json").read_text(encoding="utf-8"))
campaign_pack = json.loads((repo_root / "packs" / "campaign-starter" / "pack.json").read_text(encoding="utf-8"))
event_pack = json.loads((repo_root / "packs" / "event-launch" / "pack.json").read_text(encoding="utf-8"))
weekly_bulletin_pack = json.loads((repo_root / "packs" / "weekly-bulletin" / "pack.json").read_text(encoding="utf-8"))
contact_cleanup_pack = json.loads((repo_root / "packs" / "contact-import-cleanup" / "pack.json").read_text(encoding="utf-8"))
wordpress_contact_import_pack = json.loads((repo_root / "packs" / "wordpress-contact-import" / "pack.json").read_text(encoding="utf-8"))
example = json.loads((repo_root / "examples" / "basic-empire-flow.json").read_text(encoding="utf-8"))
webhook_server = json.loads((repo_root / "src" / "webhooks" / "webhook-server-template.json").read_text(encoding="utf-8"))
connection_template = json.loads((repo_root / "src" / "webhooks" / "connection-template.json").read_text(encoding="utf-8"))
google_sync = json.loads((repo_root / "src" / "webhooks" / "google-sync-template.json").read_text(encoding="utf-8"))
google_mvp_trigger = json.loads((repo_root / "src" / "webhooks" / "google-mvp-binder-trigger-template.json").read_text(encoding="utf-8"))
hubspot_sync = json.loads((repo_root / "src" / "webhooks" / "hubspot-sync-template.json").read_text(encoding="utf-8"))
default_contact_master = json.loads((repo_root / "src" / "webhooks" / "mappings" / "default-contact-master.json").read_text(encoding="utf-8"))
google_lead_enrichment = json.loads((repo_root / "src" / "webhooks" / "mappings" / "google-lead-enrichment.json").read_text(encoding="utf-8"))
calendar_followup_task = json.loads((repo_root / "src" / "webhooks" / "mappings" / "calendar-followup-task.json").read_text(encoding="utf-8"))
webhook_example = json.loads((repo_root / "examples" / "configurable-webhook-server.json").read_text(encoding="utf-8"))
google_mvp_example = json.loads((repo_root / "examples" / "google-mvp-binder-trigger.json").read_text(encoding="utf-8"))
google_mvp_extract = json.loads((repo_root / "examples" / "google-mvp-generated-service-extract.json").read_text(encoding="utf-8"))
sync_record_example = json.loads((repo_root / "examples" / "basic-sync-record-envelope.json").read_text(encoding="utf-8"))

required = {"pattern", "owner", "mode", "capabilities"}
for name, payload in {"src/workflow-pattern.json": source, "examples/basic-empire-flow.json": example}.items():
    missing = sorted(required - payload.keys())
    if missing:
        raise SystemExit(f"{name} missing required fields: {missing}")
    if not isinstance(payload["capabilities"], list) or not all(isinstance(item, str) for item in payload["capabilities"]):
        raise SystemExit(f"{name} capabilities must be a list of strings")

if sync_contract.get("version") != "v2.0.1":
    raise SystemExit("src/sync-contract.json version must be v2.0.1")
if sync_contract.get("status") != "legacy-transition":
    raise SystemExit("src/sync-contract.json status must be legacy-transition")
if sync_contract.get("source_of_truth") != "vault":
    raise SystemExit("src/sync-contract.json source_of_truth must be 'vault'")
channels = sync_contract.get("channels")
if not isinstance(channels, list) or not channels:
    raise SystemExit("src/sync-contract.json channels must be a non-empty array")
for channel in channels:
    if not {"channel", "transport", "upstream_owner", "capabilities"} <= channel.keys():
        raise SystemExit(f"sync channel missing required fields: {channel}")
    if not isinstance(channel["capabilities"], list) or not all(isinstance(item, str) for item in channel["capabilities"]):
        raise SystemExit("sync channel capabilities must be a list of strings")

if sync_record_profile.get("version") != "v2.0.4":
    raise SystemExit("src/sync-record-profile.json version must be v2.0.4")
if sync_record_profile.get("owner") != "uDOS-empire":
    raise SystemExit("src/sync-record-profile.json owner must be uDOS-empire")
if sync_record_profile.get("status") != "legacy-transition":
    raise SystemExit("src/sync-record-profile.json status must be legacy-transition")
required_record_types = {"canonical_contact", "activity", "binder_project", "sync_metadata"}
if set(sync_record_profile.get("supported_record_types", [])) != required_record_types:
    raise SystemExit("src/sync-record-profile.json supported_record_types must match the shared contract")
if "vault_contacts_db" not in sync_record_profile.get("contacts", {}).get("required_external_systems", []):
    raise SystemExit("src/sync-record-profile.json must require vault_contacts_db contact alignment")
if "hubspot-activity" not in sync_record_profile.get("binder_projects", {}).get("routing_targets", []):
    raise SystemExit("src/sync-record-profile.json must declare hubspot-activity routing")
if sync_record_example.get("contract_version") != "v2.0.4":
    raise SystemExit("examples/basic-sync-record-envelope.json contract_version must be v2.0.4")
if set(sync_record_example.keys()) != {"contract_version", "contacts", "activities", "binders", "sync_metadata"}:
    raise SystemExit("examples/basic-sync-record-envelope.json must contain the shared envelope collections")
if legacy_inventory.get("status") != "legacy-transition":
    raise SystemExit("src/legacy/asset-inventory.json status must be legacy-transition")
if plugin_manifest.get("plugin_type") != "wordpress-plugin":
    raise SystemExit("src/wordpress-plugin/plugin-manifest.json plugin_type must be wordpress-plugin")
if plugin_manifest.get("manifest_version") != "v2.3.0":
    raise SystemExit("src/wordpress-plugin/plugin-manifest.json manifest_version must be v2.3.0")
if plugin_manifest.get("status") != "stable-local-lab":
    raise SystemExit("src/wordpress-plugin/plugin-manifest.json status must be stable-local-lab")
if contact_record_profile.get("record_host") != "wordpress-user":
    raise SystemExit("src/wordpress-plugin/contact-record-profile.json record_host must be wordpress-user")

schema_required = {"$schema", "$id", "title", "type", "required", "properties"}
if not schema_required <= pack_manifest_schema.keys():
    raise SystemExit("schemas/pack-manifest.schema.json missing required schema fields")
if pack_manifest_schema.get("type") != "object":
    raise SystemExit("schemas/pack-manifest.schema.json type must be object")

pack_required = set(pack_manifest_schema.get("required", []))
for name, payload in {
    "packs/campaign-starter/pack.json": campaign_pack,
    "packs/event-launch/pack.json": event_pack,
    "packs/weekly-bulletin/pack.json": weekly_bulletin_pack,
    "packs/contact-import-cleanup/pack.json": contact_cleanup_pack,
    "packs/wordpress-contact-import/pack.json": wordpress_contact_import_pack,
}.items():
    missing = sorted(pack_required - payload.keys())
    if missing:
        raise SystemExit(f"{name} missing manifest fields: {missing}")
    if payload.get("manifest_version") != "v2.0.4":
        raise SystemExit(f"{name} manifest_version must be v2.0.4")
    if "status" not in payload:
        raise SystemExit(f"{name} must declare status")
    if not isinstance(payload.get("channels"), list) or not payload["channels"]:
        raise SystemExit(f"{name} channels must be a non-empty array")
    if not isinstance(payload.get("inputs"), list) or not payload["inputs"]:
        raise SystemExit(f"{name} inputs must be a non-empty array")
    if not isinstance(payload.get("outputs"), list) or not payload["outputs"]:
        raise SystemExit(f"{name} outputs must be a non-empty array")
    runtime = payload.get("runtime", {})
    if name == "packs/wordpress-contact-import/pack.json":
        if payload.get("status") != "current":
            raise SystemExit(f"{name} status must be current")
        if runtime.get("runtime_owner") != "uDOS-host":
            raise SystemExit(f"{name} runtime.runtime_owner must be uDOS-host")
    else:
        if payload.get("status") != "legacy-transition":
            raise SystemExit(f"{name} status must be legacy-transition")
        if runtime.get("runtime_owner") != "uDOS-host":
            raise SystemExit(f"{name} runtime.runtime_owner must be uDOS-host")
        if runtime.get("canonical_runtime_owner") != "uDOS-host":
            raise SystemExit(f"{name} runtime.canonical_runtime_owner must be uDOS-host")
    assets = payload.get("assets", {})
    for field in ("templates", "sample_data", "docs"):
        if not isinstance(assets.get(field), list) or not assets[field]:
            raise SystemExit(f"{name} assets.{field} must be a non-empty array")
    base_path = repo_root / name.rsplit("/", 1)[0]
    for rel_path in assets.get("templates", []) + assets.get("sample_data", []) + assets.get("docs", []):
        if not (base_path / rel_path).is_file():
            raise SystemExit(f"{name} references missing asset: {rel_path}")

if container_catalog.get("owner") != "uDOS-empire":
    raise SystemExit("src/containers/container-job-catalog.json owner must be uDOS-empire")
if container_catalog.get("status") != "legacy-transition":
    raise SystemExit("src/containers/container-job-catalog.json status must be legacy-transition")
if container_catalog.get("canonical_runtime_owner") != "uDOS-host":
    raise SystemExit("src/containers/container-job-catalog.json canonical_runtime_owner must be uDOS-host")
jobs = container_catalog.get("jobs")
if not isinstance(jobs, list) or not jobs:
    raise SystemExit("src/containers/container-job-catalog.json jobs must be a non-empty array")

container_required = {"job_id", "service", "execution_mode", "runtime_owner", "trigger", "transport"}
for name, payload in {
    "src/containers/google-workspace-sync-container.json": google_container,
    "src/containers/hubspot-sync-container.json": hubspot_container,
    "src/containers/binder-release-webhook-container.json": binder_container,
}.items():
    missing = sorted(container_required - payload.keys())
    if missing:
        raise SystemExit(f"{name} missing required fields: {missing}")
    if payload.get("status") != "legacy-transition":
        raise SystemExit(f"{name} status must be legacy-transition")
    if payload["runtime_owner"] != "uDOS-host":
        raise SystemExit(f"{name} runtime_owner must be uDOS-host")
    if payload.get("canonical_runtime_owner") != "uDOS-host":
        raise SystemExit(f"{name} canonical_runtime_owner must be uDOS-host")
    if not payload.get("host_action_id", "").startswith("repo.host.job."):
        raise SystemExit(f"{name} host_action_id must use the Ubuntu host job namespace")

webhook_required = {"service", "trigger", "source_of_truth", "inbound", "outbound", "auth", "operations"}
for name, payload in {
    "src/webhooks/webhook-server-template.json": webhook_server,
    "examples/configurable-webhook-server.json": webhook_example,
}.items():
    missing = sorted(webhook_required - payload.keys())
    if missing:
        raise SystemExit(f"{name} missing required fields: {missing}")
    if payload["source_of_truth"] != "vault":
        raise SystemExit(f"{name} source_of_truth must be 'vault'")
    for field in ("operations",):
        if not isinstance(payload[field], list) or not all(isinstance(item, str) for item in payload[field]):
            raise SystemExit(f"{name} {field} must be a list of strings")

connection_required = {"service", "transport", "auth", "base_url", "operations"}
for name, payload in {
    "src/webhooks/connection-template.json": connection_template,
    "src/webhooks/google-sync-template.json": google_sync,
    "src/webhooks/google-mvp-binder-trigger-template.json": google_mvp_trigger,
    "src/webhooks/hubspot-sync-template.json": hubspot_sync,
}.items():
    missing = sorted(connection_required - payload.keys())
    if missing:
        raise SystemExit(f"{name} missing required fields: {missing}")
    if name != "src/webhooks/connection-template.json" and payload.get("status") != "legacy-transition":
        raise SystemExit(f"{name} status must be legacy-transition")
    if payload["transport"] not in {"http", "webhook"}:
        raise SystemExit(f"{name} transport must be http or webhook")
    if not isinstance(payload["operations"], list) or not all(isinstance(item, str) for item in payload["operations"]):
        raise SystemExit(f"{name} operations must be a list of strings")

if google_mvp_trigger.get("lane_id") != "google-mvp-a":
    raise SystemExit("src/webhooks/google-mvp-binder-trigger-template.json lane_id must be google-mvp-a")
mirror_rules = google_mvp_trigger.get("mirror_rules")
if not isinstance(mirror_rules, dict):
    raise SystemExit("src/webhooks/google-mvp-binder-trigger-template.json mirror_rules must be an object")
if mirror_rules.get("canonical_truth") != "vault":
    raise SystemExit("src/webhooks/google-mvp-binder-trigger-template.json canonical_truth must be vault")
if mirror_rules.get("remote_role") != "firestore-mirror":
    raise SystemExit("src/webhooks/google-mvp-binder-trigger-template.json remote_role must be firestore-mirror")
if not isinstance(google_mvp_trigger.get("extraction_required"), list) or not google_mvp_trigger["extraction_required"]:
    raise SystemExit("src/webhooks/google-mvp-binder-trigger-template.json extraction_required must be a non-empty list")

for field in ("service", "lane_id", "source_of_truth", "inbound", "artifact", "target", "required_extraction", "status_emit"):
    if field not in google_mvp_example:
        raise SystemExit(f"examples/google-mvp-binder-trigger.json missing required field: {field}")
if google_mvp_example["lane_id"] != "google-mvp-a":
    raise SystemExit("examples/google-mvp-binder-trigger.json lane_id must be google-mvp-a")
if google_mvp_example["source_of_truth"] != "vault":
    raise SystemExit("examples/google-mvp-binder-trigger.json source_of_truth must be vault")
if google_mvp_example["target"].get("remote_role") != "firestore-mirror":
    raise SystemExit("examples/google-mvp-binder-trigger.json target remote_role must be firestore-mirror")
if google_mvp_example["artifact"].get("approved_for_mirror") is not True:
    raise SystemExit("examples/google-mvp-binder-trigger.json artifact approved_for_mirror must be true")
if google_mvp_extract.get("lane_id") != "google-mvp-a":
    raise SystemExit("examples/google-mvp-generated-service-extract.json lane_id must be google-mvp-a")
if google_mvp_extract.get("service", {}).get("name") != "google-mvp-binder-trigger":
    raise SystemExit("examples/google-mvp-generated-service-extract.json service name must be google-mvp-binder-trigger")
if google_mvp_extract.get("service", {}).get("remote_role") != "firestore-mirror":
    raise SystemExit("examples/google-mvp-generated-service-extract.json remote_role must be firestore-mirror")

mapping_required = {"label", "source_system", "event_type", "target_scope", "target_entity", "template_version", "field_map", "required_fields"}
for name, payload in {
    "src/webhooks/mappings/default-contact-master.json": default_contact_master,
    "src/webhooks/mappings/google-lead-enrichment.json": google_lead_enrichment,
    "src/webhooks/mappings/calendar-followup-task.json": calendar_followup_task,
}.items():
    missing = sorted(mapping_required - payload.keys())
    if missing:
        raise SystemExit(f"{name} missing required fields: {missing}")
    if not isinstance(payload["field_map"], dict) or not payload["field_map"]:
        raise SystemExit(f"{name} field_map must be a non-empty object")
    if not isinstance(payload["required_fields"], list) or not all(isinstance(item, str) for item in payload["required_fields"]):
        raise SystemExit(f"{name} required_fields must be a list of strings")
PY

if command -v rg >/dev/null 2>&1; then
    if rg -n '/Users/fredbook/Code|~/Users/fredbook/Code' \
        "$REPO_ROOT/README.md" \
        "$REPO_ROOT/docs" \
        "$REPO_ROOT/src" \
        "$REPO_ROOT/tests" \
        "$REPO_ROOT/examples" \
        "$REPO_ROOT/config"; then
        echo "private local-root reference found in uDOS-empire" >&2
        exit 1
    fi
else
    if grep -RInE -I --exclude-dir='__pycache__' '/Users/fredbook/Code|~/Users/fredbook/Code' \
        "$REPO_ROOT/README.md" \
        "$REPO_ROOT/docs" \
        "$REPO_ROOT/src" \
        "$REPO_ROOT/tests" \
        "$REPO_ROOT/examples" \
        "$REPO_ROOT/config"; then
        echo "private local-root reference found in uDOS-empire" >&2
        exit 1
    fi
fi

"$PYTHON_BIN" "$REPO_ROOT/scripts/smoke/sync_plan.py" --json >/dev/null
"$PYTHON_BIN" "$REPO_ROOT/scripts/smoke/sync_plan.py" --json --local-app >/dev/null
"$PYTHON_BIN" "$REPO_ROOT/scripts/smoke/sync_plan.py" --json --local-app --execution-brief >/dev/null
"$PYTHON_BIN" "$REPO_ROOT/scripts/smoke/pack_catalog.py" --json >/dev/null
"$PYTHON_BIN" "$REPO_ROOT/scripts/smoke/pack_preview.py" --json >/dev/null
"$PYTHON_BIN" "$REPO_ROOT/scripts/smoke/pack_preview.py" --json --pack event-launch >/dev/null
"$PYTHON_BIN" "$REPO_ROOT/scripts/smoke/pack_preview.py" --json --pack event-launch --execution-brief >/dev/null
"$PYTHON_BIN" "$REPO_ROOT/scripts/smoke/pack_run.py" --json --pack campaign-starter --local-host-app >/dev/null
"$PYTHON_BIN" "$REPO_ROOT/scripts/smoke/pack_run.py" --json --pack event-launch --local-host-app >/dev/null
"$PYTHON_BIN" "$REPO_ROOT/scripts/smoke/hubspot_lane_gate.py" --json >/dev/null
"$PYTHON_BIN" "$REPO_ROOT/scripts/smoke/wordpress_md_publish_smoke.py" --json >/dev/null
"$PYTHON_BIN" "$REPO_ROOT/scripts/smoke/data_safety_smoke.py" --json >/dev/null
"$PYTHON_BIN" -m unittest discover -s tests -p 'test_*.py'

echo "uDOS-empire checks passed"
