#!/usr/bin/env bash
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

require_file() {
  if [ ! -f "$1" ]; then
    echo "missing required file: $1" >&2
    exit 1
  fi
}

require_file "$REPO_ROOT/README.md"
require_file "$REPO_ROOT/actions/export-openapi.json"
require_file "$REPO_ROOT/docs/source-packs/README.md"
require_file "$REPO_ROOT/docs/agent-digital-v2_1-spec.md"
require_file "$REPO_ROOT/docs/agent-digital-export-integration.md"
require_file "$REPO_ROOT/docs/local-helper.md"
require_file "$REPO_ROOT/docs/agent-digital-commands.md"
require_file "$REPO_ROOT/prompts/patches/agent-digital-dev-routing.md"
require_file "$REPO_ROOT/docs/udos-developer-export-integration.md"
require_file "$REPO_ROOT/docs/action-schema.md"
require_file "$REPO_ROOT/docs/activation.md"

python3 - <<'PY' || exit 1
import json, pathlib
root = pathlib.Path(".")
json.loads((root / "actions" / "export-openapi.json").read_text(encoding="utf-8"))
for p in (root / "examples").glob("*.json"):
    json.loads(p.read_text(encoding="utf-8"))
print("uDOS-gpthelper JSON checks passed")
PY

echo "uDOS-gpthelper checks passed"
