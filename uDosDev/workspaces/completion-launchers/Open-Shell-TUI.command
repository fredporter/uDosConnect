#!/usr/bin/env bash
# macOS Finder launcher: run uDOS-shell Bubble Tea TUI (measurable terminal UI).
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../uDOS-shell" && pwd)"
cd "$REPO_ROOT"
if [ ! -f package.json ]; then
  echo "missing package.json in $REPO_ROOT" >&2
  exit 1
fi
if [ ! -d node_modules ]; then
  echo "Install dependencies first, then re-run:" >&2
  echo "  cd \"$REPO_ROOT\" && npm ci" >&2
  exit 1
fi
exec npm run go:run
