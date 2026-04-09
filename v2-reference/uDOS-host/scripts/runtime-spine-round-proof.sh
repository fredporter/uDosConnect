#!/usr/bin/env bash
# Automated portion of Workspace 01 round closure: HTTP artefact check + full workspace TUI.
# This script completes steps 1–2 only. Step 3 (final GUI render in a real browser) is mandatory
# and is NOT automated here — see uDOS-dev/docs/round-closure-three-steps.md
#
# Usage:
#   bash scripts/runtime-spine-round-proof.sh

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[1/3] Automated: command-centre HTTP (curl — not a GUI substitute)"
bash "$SCRIPT_DIR/verify-command-centre-http.sh"
echo ""
echo "[2/3] Automated: workspace TUI cycle (all repos in cursor-01-runtime-spine)"
bash "$SCRIPT_DIR/runtime-spine-workspace-tui.sh" "$@"
echo ""
echo "[3/3] FINAL GUI RENDER — mandatory (round stays OPEN until you do this)"
echo "  Automated steps [1/3] and [2/3] passed. Step [3/3] requires a real browser and human eyes."
echo "  In another terminal (keep it open), run ONE of:"
echo "    bash $SCRIPT_DIR/serve-command-centre-demo.sh          # localhost"
echo "    bash $SCRIPT_DIR/serve-command-centre-demo-lan.sh     # LAN (preferred for sign-off)"
echo "  Open the printed URL and CONFIRM you SEE the uDOS command centre page."
echo "  Record sign-off: uDOS-dev @dev/notes/rounds/ or @dev/notes/devlog.md"
echo "  Doc: uDOS-dev/docs/round-closure-three-steps.md"
echo ""
echo "runtime-spine-round-proof: automated gates [1/3][2/3] passed — step [3/3] is operator-only."
