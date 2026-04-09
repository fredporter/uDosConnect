#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "missing required command: $1" >&2
    exit 1
  fi
}

require_cmd npm
require_cmd node
require_cmd go

if [ ! -d node_modules ]; then
  echo "Installing npm dependencies..."
  npm install
else
  echo "npm dependencies already present"
fi

echo "Building TypeScript shell lane..."
npm run build

echo "Launching Go TUI..."
exec go run ./cmd/ucode
