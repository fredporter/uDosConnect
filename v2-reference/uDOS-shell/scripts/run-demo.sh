#!/usr/bin/env bash

# run-demo.sh — build, test, and demo-walk the uDOS-shell Go TUI stack.
#
# Usage:  bash scripts/run-demo.sh
#
# Exits non-zero on any failure.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

# ─── colours ──────────────────────────────────────────────────────────────────
BOLD='\033[1m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RESET='\033[0m'

header() { echo -e "\n${BOLD}${CYAN}▶ $1${RESET}"; }
ok()     { echo -e "${GREEN}✓ $1${RESET}"; }

# ─── 1. build ─────────────────────────────────────────────────────────────────
header "Building uDOS-shell (go build ./...)"
go build ./...
ok "Build clean"

# ─── 2. full package test suite ───────────────────────────────────────────────
header "Running full Go test suite"
go test ./... -count=1
ok "All packages pass"

# ─── 3. demo integration test (verbose) ───────────────────────────────────────
header "Running demo integration test (verbose)"
go test ./tests/... -v -count=1 -run .

# ─── 4. TUI binary smoke-check ────────────────────────────────────────────────
header "Verifying TUI binary"
BINARY_PATH="$(go env GOPATH)/bin/ucode"
go build -o "$BINARY_PATH" ./cmd/ucode
if [[ -x "$BINARY_PATH" ]]; then
  ok "Binary built → $BINARY_PATH"
else
  echo "Binary not found after build: $BINARY_PATH" >&2
  exit 1
fi

# ─── 5. feature walk (non-TUI) ──────────────────────────────────────────────────
header "Feature walk (command preview coverage)"
bash scripts/demo-feature-walk.sh
ok "Feature walk completed"

# ─── 5b. visual UX fixtures (static — not parser/route preview) ────────────────
header "UX demo static walk (ASCII shell fixtures)"
go run ./cmd/demo-ux --static >/dev/null
ok "UX static walk rendered (golden fixtures)"

# ─── 6. summary ───────────────────────────────────────────────────────────────
header "Demo complete"
echo ""
echo "  Launch the TUI with:"
echo "    go run ./cmd/ucode"
echo ""
echo "  Visual UX demo (layouts, not route preview):"
echo "    bash scripts/demo-ux-walk.sh"
echo "    go run ./cmd/demo-ux --static"
echo ""
echo "  Demo inputs to try (from examples/basic-ucode-session.md):"
echo "    #binder create shell-activation"
echo "    #wizard assist topic:shell"
echo "    ? summarize the current workflow state"
echo "    health startup"
echo "    setup story"
echo "    demo list"
echo "    demo run thinui-c64"
echo "    demo run thinui-teletext"
echo "    contract workflow-state"
echo "    workflow state demo-workflow"
echo "    automation queue runtime.command-registry"
echo "    session workflows"
echo "    :  (open menu, then / to filter)"
echo "    Ctrl+A / Ctrl+E / Ctrl+W / Left / Right"
echo ""
