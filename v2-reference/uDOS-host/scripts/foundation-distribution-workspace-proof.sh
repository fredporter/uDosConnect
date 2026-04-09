#!/usr/bin/env bash
# Terminal integration proof for cursor-02-foundation-distribution.code-workspace:
# runs automated checks for each in-scope repo (Sonic sibling, Ubuntu lane, core,
# plugin-index, alpine, docs, dev). Completes Workspace 02 step 2 when used with step 1
# (same script is the automated bundle — see round-proof wrapper).
#
# sonic-ventoy: optional; if ../sonic-family/sonic-ventoy is missing, a notice is
# printed and the round still proceeds (Ventoy contract is exercised via Sonic tests).
#
# Environment (optional):
#   SONIC_SCREWDRIVER_ROOT   default: $FAMILY_ROOT/../sonic-family/sonic-screwdriver
#   UDOS_VENTOY_ROOT         default: $FAMILY_ROOT/../sonic-family/sonic-ventoy
#
# Usage (from uDOS-host):
#   bash scripts/foundation-distribution-workspace-proof.sh

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
UBUNTU_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAMILY_ROOT="$(cd "$UBUNTU_ROOT/.." && pwd)"

SONIC_ROOT="${SONIC_SCREWDRIVER_ROOT:-$FAMILY_ROOT/../sonic-family/sonic-screwdriver}"
VENTOY_ROOT="${UDOS_VENTOY_ROOT:-$FAMILY_ROOT/../sonic-family/sonic-ventoy}"
CORE_ROOT="$FAMILY_ROOT/uDOS-core"
PLUGIN_INDEX_ROOT="$FAMILY_ROOT/uDOS-plugin-index"
ALPINE_ROOT="$FAMILY_ROOT/uDOS-alpine"
DOCS_ROOT="$FAMILY_ROOT/uDOS-docs"
DEV_ROOT="$FAMILY_ROOT/uDOS-dev"

echo "foundation-distribution-workspace-proof: family root $FAMILY_ROOT"
echo ""

phase=0

run_phase() {
  phase=$((phase + 1))
  echo "[$phase] $*"
}

if [ -d "$SONIC_ROOT" ] && [ -f "$SONIC_ROOT/scripts/run-sonic-checks.sh" ]; then
  run_phase "sonic-screwdriver: run-sonic-checks.sh"
  bash "$SONIC_ROOT/scripts/run-sonic-checks.sh"
  echo ""
else
  run_phase "sonic-screwdriver: SKIP (missing or no run-sonic-checks.sh at $SONIC_ROOT)"
  echo "  Set SONIC_SCREWDRIVER_ROOT if Sonic lives elsewhere." >&2
  exit 1
fi

if [ -d "$VENTOY_ROOT" ]; then
  echo "[note] sonic-ventoy present at $VENTOY_ROOT — no standalone check script in this round;"
  echo "       Sonic tests cover Ventoy integration smoke where applicable."
  echo ""
else
  echo "[note] sonic-ventoy not checked out (optional for core lane); Sonic CI covers contract."
  echo ""
fi

run_phase "uDOS-host: run-ubuntu-checks.sh"
bash "$SCRIPT_DIR/run-ubuntu-checks.sh"
echo ""

run_phase "uDOS-host: verify-command-centre-http.sh"
bash "$SCRIPT_DIR/verify-command-centre-http.sh"
echo ""

run_phase "uDOS-core: run-core-checks.sh"
bash "$CORE_ROOT/scripts/run-core-checks.sh"
echo ""

run_phase "uDOS-plugin-index: run-plugin-index-checks.sh"
bash "$PLUGIN_INDEX_ROOT/scripts/run-plugin-index-checks.sh"
echo ""

run_phase "uDOS-alpine: run-alpine-checks.sh"
bash "$ALPINE_ROOT/scripts/run-alpine-checks.sh"
echo ""

run_phase "uDOS-docs: run-docs-checks.sh"
bash "$DOCS_ROOT/scripts/run-docs-checks.sh"
echo ""

run_phase "uDOS-dev: run-dev-checks.sh"
(
  export SONIC_SCREWDRIVER_ROOT="$SONIC_ROOT"
  cd "$DEV_ROOT"
  bash scripts/run-dev-checks.sh
)
echo ""

echo "foundation-distribution-workspace-proof: all phases OK."
