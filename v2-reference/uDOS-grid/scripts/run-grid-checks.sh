#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

require_file() {
  if [ ! -f "$1" ]; then
    echo "missing required file: $1" >&2
    exit 1
  fi
}

cd "$REPO_ROOT"

require_file "$REPO_ROOT/README.md"
require_file "$REPO_ROOT/docs/architecture.md"
require_file "$REPO_ROOT/docs/boundary.md"
require_file "$REPO_ROOT/docs/getting-started.md"
require_file "$REPO_ROOT/docs/examples.md"
require_file "$REPO_ROOT/docs/activation.md"
require_file "$REPO_ROOT/scripts/README.md"
require_file "$REPO_ROOT/tests/README.md"
require_file "$REPO_ROOT/config/README.md"
require_file "$REPO_ROOT/contracts/README.md"
require_file "$REPO_ROOT/contracts/place-record.contract.json"
require_file "$REPO_ROOT/contracts/layer-record.contract.json"
require_file "$REPO_ROOT/contracts/artifact-record.contract.json"
require_file "$REPO_ROOT/seed/README.md"
require_file "$REPO_ROOT/examples/basic-place-record.json"
require_file "$REPO_ROOT/examples/basic-artifact-record.json"
require_file "$REPO_ROOT/seed/basic-layer-registry.json"
require_file "$REPO_ROOT/seed/basic-place-registry.json"
require_file "$REPO_ROOT/seed/basic-artifact-registry.json"
require_file "$REPO_ROOT/seed/canonical-demo-index.json"

python3 - <<'PY'
import json
from pathlib import Path

repo_root = Path(".").resolve()
place = json.loads((repo_root / "examples" / "basic-place-record.json").read_text(encoding="utf-8"))
artifact = json.loads((repo_root / "examples" / "basic-artifact-record.json").read_text(encoding="utf-8"))
place_contract = json.loads((repo_root / "contracts" / "place-record.contract.json").read_text(encoding="utf-8"))
layer_contract = json.loads((repo_root / "contracts" / "layer-record.contract.json").read_text(encoding="utf-8"))
artifact_contract = json.loads((repo_root / "contracts" / "artifact-record.contract.json").read_text(encoding="utf-8"))
layers = json.loads((repo_root / "seed" / "basic-layer-registry.json").read_text(encoding="utf-8"))
places = json.loads((repo_root / "seed" / "basic-place-registry.json").read_text(encoding="utf-8"))
artifacts = json.loads((repo_root / "seed" / "basic-artifact-registry.json").read_text(encoding="utf-8"))
demo_index = json.loads((repo_root / "seed" / "canonical-demo-index.json").read_text(encoding="utf-8"))

if not {"place_id", "layer", "cell", "space", "anchor"}.issubset(place):
    raise SystemExit("examples/basic-place-record.json missing required place fields")
if not {"artifact_id", "artifact_type", "places"}.issubset(artifact):
    raise SystemExit("examples/basic-artifact-record.json missing required artifact fields")
if not isinstance(artifact["places"], list) or not artifact["places"]:
    raise SystemExit("examples/basic-artifact-record.json places must be a non-empty list")
if not isinstance(layers, list) or not layers:
    raise SystemExit("seed/basic-layer-registry.json must be a non-empty list")
if not isinstance(places, list) or not places:
    raise SystemExit("seed/basic-place-registry.json must be a non-empty list")
if not isinstance(artifacts, list) or not artifacts:
    raise SystemExit("seed/basic-artifact-registry.json must be a non-empty list")
if demo_index.get("seed_scope") != "canonical-demo":
    raise SystemExit("seed/canonical-demo-index.json seed_scope must be canonical-demo")
if demo_index.get("review_status") != "reviewed-v2.0.3":
    raise SystemExit("seed/canonical-demo-index.json review_status must be reviewed-v2.0.3")
for name, payload, required in (
    ("contracts/place-record.contract.json", place_contract, {"version", "owner", "required_fields"}),
    ("contracts/layer-record.contract.json", layer_contract, {"version", "owner", "required_fields"}),
    ("contracts/artifact-record.contract.json", artifact_contract, {"version", "owner", "required_fields"}),
):
    if not required.issubset(payload):
        raise SystemExit(f"{name} missing required contract fields")
for name, items in (
    ("seed/basic-layer-registry.json", layers),
    ("seed/basic-place-registry.json", places),
    ("seed/basic-artifact-registry.json", artifacts),
):
    for item in items:
        if item.get("seed_scope") != "canonical-demo":
            raise SystemExit(f"{name} items must use seed_scope canonical-demo")
        if item.get("review_status") != "reviewed-v2.0.3":
            raise SystemExit(f"{name} items must use review_status reviewed-v2.0.3")
PY

python3 -m unittest tests/test_grid_contracts.py

if command -v rg >/dev/null 2>&1; then
    if rg -n '/Users/fredbook/Code|~/Users/fredbook/Code' \
        "$REPO_ROOT/README.md" \
        "$REPO_ROOT/docs" \
        "$REPO_ROOT/examples" \
        "$REPO_ROOT/config" \
        "$REPO_ROOT/contracts" \
        "$REPO_ROOT/seed"; then
        echo "private local-root reference found in uDOS-grid" >&2
        exit 1
    fi
else
    if grep -R -nE '/Users/fredbook/Code|~/Users/fredbook/Code' \
        "$REPO_ROOT/README.md" \
        "$REPO_ROOT/docs" \
        "$REPO_ROOT/examples" \
        "$REPO_ROOT/config" \
        "$REPO_ROOT/contracts" \
        "$REPO_ROOT/seed"; then
        echo "private local-root reference found in uDOS-grid" >&2
        exit 1
    fi
fi

echo "uDOS-grid checks passed"
