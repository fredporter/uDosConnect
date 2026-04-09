#!/usr/bin/env bash
# Browser workstation intent: human-readable summary first; raw JSON optional.

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MANIFEST="$REPO_ROOT/examples/browser-workstation-scaffold.json"
HR_PY="$SCRIPT_DIR/lib/human_readable_demo.py"

echo "[uDOS-host] Browser workstation parity demo"
echo "1. Ubuntu first-run applies package and browser profile baseline"
echo "2. Browser workstation home opens as the binder-native operator surface"
echo "3. Workflow, review, publish, automation, and diagnostics views become the primary local lanes"
echo "4. Wizard remains the sibling control plane for publish, OK, and managed external integration"
echo ""
echo "[uDOS-host] What the operator gets (readable)"
python3 "$HR_PY" "$MANIFEST"
echo ""

if [ "${UDOS_DEMO_INCLUDE_RAW_JSON:-0}" = "1" ]; then
  echo "[uDOS-host] Raw manifest JSON"
  cat "$MANIFEST"
else
  echo "[uDOS-host] Machine-readable manifest: examples/browser-workstation-scaffold.json"
  echo "  Set UDOS_DEMO_INCLUDE_RAW_JSON=1 to print JSON here."
fi
