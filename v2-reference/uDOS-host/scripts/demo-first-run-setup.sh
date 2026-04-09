#!/usr/bin/env bash
# First-run story: operator-facing prose first; JSON contract optional (see UDOS_DEMO_INCLUDE_RAW_JSON).

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
THINUI_DEMO="$REPO_ROOT/../uDOS-thinui/scripts/demo-thinui.js"
HR_PY="$SCRIPT_DIR/lib/human_readable_demo.py"

echo "[uDOS-host] First-run setup story"
echo "1. Sonic stages Ubuntu image and hooks"
echo "2. Ubuntu applies base package and desktop profile"
echo "3. Browser workstation home becomes the binder-native operator shell"
echo "4. Shell startup health summary and quickstart remain the local runtime entrypoint"
echo "5. ThinUI C64 first-run panel can render as the local setup surface"
echo ""
echo "[uDOS-host] Browser workstation — operator surface (readable)"
python3 "$HR_PY" "$REPO_ROOT/examples/browser-workstation-scaffold.json"
echo ""
echo "[uDOS-host] ThinUI — operator surface (readable)"
python3 "$HR_PY" --kind thinui "$REPO_ROOT/examples/thinui-c64-launch.json"
echo ""

if [ "${UDOS_DEMO_INCLUDE_RAW_JSON:-0}" = "1" ]; then
  echo "[uDOS-host] Raw contract JSON (browser workstation)"
  cat "$REPO_ROOT/examples/browser-workstation-scaffold.json"
  echo ""
  echo "[uDOS-host] Raw contract JSON (ThinUI)"
  cat "$REPO_ROOT/examples/thinui-c64-launch.json"
  echo ""
else
  echo "[uDOS-host] Contracts on disk: examples/browser-workstation-scaffold.json, examples/thinui-c64-launch.json"
  echo "  Set UDOS_DEMO_INCLUDE_RAW_JSON=1 to echo JSON here."
  echo ""
fi

if command -v node >/dev/null 2>&1 && [ -f "$THINUI_DEMO" ]; then
  echo "[uDOS-host] Launching ThinUI C64 first-run demo"
  node "$THINUI_DEMO" --theme thinui-c64 --view boot-loader --title "uDOS Ubuntu Desktop" --subtitle "First-run setup handoff"
else
  echo "[uDOS-host] ThinUI sibling demo skipped (optional Node + uDOS-thinui repo)."
  if ! command -v node >/dev/null 2>&1; then
    echo "  Need: Node.js on PATH (e.g. apt install nodejs, or use linux-family-bootstrap.sh)."
  elif [ ! -f "$THINUI_DEMO" ]; then
    echo "  Need: optional repo uDOS-thinui next to uDOS-host (expected: $THINUI_DEMO)."
  fi
fi
