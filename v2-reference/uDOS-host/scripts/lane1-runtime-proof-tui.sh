#!/usr/bin/env bash
# Terminal proof for lane 1: uDOS-core (pytest) + uDOS-grid (checks + unittest).
# Run from uDOS-host with sibling repos: uDOS-core, uDOS-grid.

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
UBUNTU_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAMILY_ROOT="$(cd "$UBUNTU_ROOT/.." && pwd)"
CORE_ROOT="${UDOS_CORE_ROOT:-$FAMILY_ROOT/uDOS-core}"
GRID_ROOT="${UDOS_GRID_ROOT:-$FAMILY_ROOT/uDOS-grid}"

bold() { printf '\033[1m%s\033[0m\n' "$*"; }
rule() { printf '%s\n' "══════════════════════════════════════════════════════════════"; }

rule
bold "uDOS lane 1 — runtime proof (terminal)"
rule
echo "  Ubuntu: $UBUNTU_ROOT"
echo "  Core:   $CORE_ROOT"
echo "  Grid:   $GRID_ROOT"
echo ""

if [ ! -d "$CORE_ROOT" ] || [ ! -f "$CORE_ROOT/scripts/run-core-checks.sh" ]; then
  echo "uDOS-core not found at $CORE_ROOT (set UDOS_CORE_ROOT)" >&2
  exit 1
fi
if [ ! -d "$GRID_ROOT" ] || [ ! -f "$GRID_ROOT/scripts/run-grid-checks.sh" ]; then
  echo "uDOS-grid not found at $GRID_ROOT (set UDOS_GRID_ROOT)" >&2
  exit 1
fi

rule
bold "1) uDOS-core — contract tests (pytest)"
rule
( cd "$CORE_ROOT" && bash scripts/run-core-checks.sh )

echo ""
rule
bold "2) uDOS-grid — registry + contract checks"
rule
( cd "$GRID_ROOT" && bash scripts/run-grid-checks.sh )

echo ""
rule
bold "3) uDOS-host — structure + layout + commandd/gitd"
rule
( cd "$UBUNTU_ROOT" && bash scripts/run-ubuntu-checks.sh )

echo ""
rule
bold "3b) Operator-readable surface (not JSON-only)"
rule
python3 "$UBUNTU_ROOT/scripts/lib/human_readable_demo.py" "$UBUNTU_ROOT/examples/browser-workstation-scaffold.json"
echo ""
python3 "$UBUNTU_ROOT/scripts/lib/human_readable_demo.py" --kind thinui "$UBUNTU_ROOT/examples/thinui-c64-launch.json"

echo ""
rule
bold "Lane 1 terminal proof: complete"
rule
printf '\033[2m%s\033[0m\n' "  Open-work reminder: Core + Grid checks above are full-suite / contract validation."
printf '\033[2m%s\033[0m\n' "  Ubuntu: lane-1 HTTP daemons incl. commandd + six aux (see verify-udos-runtime-daemons.sh); deeper product behaviour still open."
printf '\033[2m%s\033[0m\n' "  Per-step WORKING vs SCAFFOLD vs STUB + open queue: bash $UBUNTU_ROOT/scripts/runtime-spine-workspace-tui.sh"
printf '\033[2m%s\033[0m\n' "  Round not closed without Step [3/3]: browser GUI — bash $UBUNTU_ROOT/scripts/serve-command-centre-demo.sh (see uDOS-dev/docs/round-closure-three-steps.md)"
echo ""
# shellcheck source=scripts/lib/udos-web-listen.sh
. "$UBUNTU_ROOT/scripts/lib/udos-web-listen.sh"
echo "  Browser: in another shell run:"
echo "    bash $UBUNTU_ROOT/scripts/serve-command-centre-demo.sh"
echo "  Then open $(udos_web_base_url)  (defaults: scripts/lib/udos-web-listen.sh)"
echo "  Full workspace round (HTTP + all repos): bash $UBUNTU_ROOT/scripts/runtime-spine-round-proof.sh"
echo "  Pathway: uDOS-dev @dev/pathways/runtime-spine-workspace-round-closure.md"
echo ""
