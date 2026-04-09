#!/usr/bin/env bash
# Workspace 02 (foundation / distribution): automated steps bundle + reminder for
# mandatory step 3 (real browser). Steps 1–2 here do NOT close the round without
# step 3 — see uDOS-dev/docs/round-closure-three-steps.md
#
# Usage:
#   bash scripts/foundation-distribution-round-proof.sh

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[Workspace 02] Automated integration: foundation-distribution-workspace-proof.sh"
bash "$SCRIPT_DIR/foundation-distribution-workspace-proof.sh"
echo ""
echo "[3/3] FINAL GUI RENDER — mandatory (Workspace 02 stays OPEN until you do this)"
echo "  Until Sonic/Ventoy defines a different primary operator GUI, confirm the"
echo "  uDOS command centre in a real browser (not curl alone):"
echo "    bash $SCRIPT_DIR/serve-command-centre-demo.sh"
echo "    bash $SCRIPT_DIR/serve-command-centre-demo-lan.sh"
echo "  Record sign-off: uDOS-dev @dev/notes/rounds/cursor-02-foundation-distribution-*.md"
echo "  Pathway: uDOS-dev/@dev/pathways/foundation-distribution-workspace-round-closure.md"
echo ""
echo "foundation-distribution-round-proof: automated gates passed — step [3/3] is operator-only."
