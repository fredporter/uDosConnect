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
require_file "$REPO_ROOT/docs/google-mvp-world-contract.md"
require_file "$REPO_ROOT/docs/activation.md"
require_file "$REPO_ROOT/src/README.md"
require_file "$REPO_ROOT/src/gameplay-state.json"
require_file "$REPO_ROOT/src/grid-consumption.json"
require_file "$REPO_ROOT/scripts/README.md"
require_file "$REPO_ROOT/tests/README.md"
require_file "$REPO_ROOT/config/README.md"
require_file "$REPO_ROOT/examples/README.md"
require_file "$REPO_ROOT/examples/basic-gameplay-state.json"
require_file "$REPO_ROOT/examples/basic-grid-gameplay-state.json"
require_file "$REPO_ROOT/examples/google-mvp-crypt-placement-world.json"

python3 - <<'PY'
import json
from pathlib import Path

repo_root = Path(".").resolve()
source = json.loads((repo_root / "src" / "gameplay-state.json").read_text(encoding="utf-8"))
grid = json.loads((repo_root / "src" / "grid-consumption.json").read_text(encoding="utf-8"))
example = json.loads((repo_root / "examples" / "basic-gameplay-state.json").read_text(encoding="utf-8"))
grid_example = json.loads((repo_root / "examples" / "basic-grid-gameplay-state.json").read_text(encoding="utf-8"))
google_mvp_example = json.loads((repo_root / "examples" / "google-mvp-crypt-placement-world.json").read_text(encoding="utf-8"))

required = {"mode", "state_owner", "loop", "capabilities"}
for name, payload in {
    "src/gameplay-state.json": source,
    "examples/basic-gameplay-state.json": example,
    "examples/basic-grid-gameplay-state.json": grid_example,
    "examples/google-mvp-crypt-placement-world.json": google_mvp_example,
}.items():
    missing = sorted(required - payload.keys())
    if missing:
        raise SystemExit(f"{name} missing required fields: {missing}")
    if not isinstance(payload["capabilities"], list) or not all(isinstance(item, str) for item in payload["capabilities"]):
        raise SystemExit(f"{name} capabilities must be a list of strings")

if grid.get("owner") != "uDOS-grid":
    raise SystemExit("src/grid-consumption.json owner must be uDOS-grid")
if grid.get("consumer") != "uDOS-gameplay":
    raise SystemExit("src/grid-consumption.json consumer must be uDOS-gameplay")
if not isinstance(grid.get("contracts"), list) or len(grid["contracts"]) < 3:
    raise SystemExit("src/grid-consumption.json contracts must list the Grid contract lane")
if grid_example.get("grid_context", {}).get("source_owner") != "uDOS-grid":
    raise SystemExit("examples/basic-grid-gameplay-state.json grid_context.source_owner must be uDOS-grid")
if google_mvp_example.get("prototype_owner") != "uDOS-gameplay":
    raise SystemExit("examples/google-mvp-crypt-placement-world.json prototype_owner must be uDOS-gameplay")
if google_mvp_example.get("export_rules", {}).get("canonical_truth") != "repo-owned gameplay artifacts":
    raise SystemExit("examples/google-mvp-crypt-placement-world.json export_rules.canonical_truth must stay repo-owned")
PY

if command -v rg >/dev/null 2>&1; then
  if rg -n '/Users/fredbook/Code|~/Users/fredbook/Code' \
    "$REPO_ROOT/README.md" \
    "$REPO_ROOT/docs" \
    "$REPO_ROOT/src" \
    "$REPO_ROOT/tests" \
    "$REPO_ROOT/examples" \
    "$REPO_ROOT/config"; then
    echo "private local-root reference found in uDOS-gameplay" >&2
    exit 1
  fi
else
  if grep -R -nE '/Users/fredbook/Code|~/Users/fredbook/Code' \
    "$REPO_ROOT/README.md" \
    "$REPO_ROOT/docs" \
    "$REPO_ROOT/src" \
    "$REPO_ROOT/tests" \
    "$REPO_ROOT/examples" \
    "$REPO_ROOT/config" >/dev/null 2>&1; then
    echo "private local-root reference found in uDOS-gameplay" >&2
    exit 1
  fi
fi

echo "uDOS-gameplay checks passed"
