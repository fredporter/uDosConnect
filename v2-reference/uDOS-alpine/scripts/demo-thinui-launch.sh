#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PAYLOAD="$REPO_ROOT/profiles/thinui-c64-launch.json"
THINUI_DEMO="$REPO_ROOT/../uDOS-thinui/scripts/demo-thinui.js"

echo "[uDOS-alpine] ThinUI launcher payload"
cat "$PAYLOAD"
echo ""

if command -v node >/dev/null 2>&1 && [ -f "$THINUI_DEMO" ]; then
  echo "[uDOS-alpine] Launching ThinUI C64 demo"
  node "$THINUI_DEMO" --theme thinui-c64 --view boot-loader --title "uDOS Alpine Boot" --subtitle "C64-style startup handoff"
else
  echo "[uDOS-alpine] ThinUI sibling demo not available; payload emitted only."
fi
