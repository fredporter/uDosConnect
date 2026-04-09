#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

require_file() {
  local path="$1"
  if [[ ! -f "$path" ]]; then
    echo "[uDOS-plugin-deerflow] missing required file: $path" >&2
    exit 1
  fi
}

require_dir() {
  local path="$1"
  if [[ ! -d "$path" ]]; then
    echo "[uDOS-plugin-deerflow] missing required directory: $path" >&2
    exit 1
  fi
}

require_file "$REPO_ROOT/README.md"
require_file "$REPO_ROOT/VERSION"
require_file "$REPO_ROOT/docs/activation.md"
require_file "$REPO_ROOT/docs/architecture.md"
require_file "$REPO_ROOT/schemas/deerflow-translation.schema.json"
require_file "$REPO_ROOT/schemas/execution-result.schema.json"
require_file "$REPO_ROOT/src/python/udos_plugin_deerflow/translator.py"
require_file "$REPO_ROOT/src/python/udos_plugin_deerflow/executor.py"
require_file "$REPO_ROOT/src/go/cmd/df-validate/main.go"
require_file "$REPO_ROOT/src/ts/src/buildGraph.ts"
require_file "$REPO_ROOT/tests/test_translation.py"
require_dir "$REPO_ROOT/@dev/requests"

echo "[uDOS-plugin-deerflow] required repo surfaces present"

if command -v python3 >/dev/null 2>&1; then
  echo "[uDOS-plugin-deerflow] running translation smoke"
  (cd "$REPO_ROOT" && PYTHONPATH="$REPO_ROOT/src/python" python3 -m pytest tests/test_translation.py -q)
else
  echo "[uDOS-plugin-deerflow] skipping pytest (python3 unavailable)"
fi
