#!/usr/bin/env bash
# Visual UX demo for uDOS-shell: user-facing ASCII layouts, not parser/route previews.
#
# Usage:
#   bash scripts/demo-ux-walk.sh              # interactive TUI (cycle scenes)
#   bash scripts/demo-ux-walk.sh --static     # print all fixtures to stdout
#
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

if [[ "${1:-}" == "--static" ]]; then
  exec go run ./cmd/demo-ux --static
fi

exec go run ./cmd/demo-ux "$@"
