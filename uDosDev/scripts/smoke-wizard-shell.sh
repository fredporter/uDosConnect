#!/usr/bin/env bash
# smoke-wizard-shell.sh — optional family probe: HTTP smoke against a running Wizard
# from the uDOS-shell repo (sibling checkout).
#
# Does not start Wizard or Shell. Set UDOS_WIZARD_HOST / UDOS_WIZARD_PORT as needed.
#
# Usage (from uDOS-dev):
#   bash scripts/smoke-wizard-shell.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEV_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SHELL_ROOT="$(cd "$DEV_ROOT/../uDOS-shell" && pwd)"
SMOKE="$SHELL_ROOT/scripts/smoke-wizard-http.sh"

if [[ ! -x "$SMOKE" ]] && [[ -f "$SMOKE" ]]; then
  chmod +x "$SMOKE" || true
fi

if [[ ! -f "$SMOKE" ]]; then
  echo "missing uDOS-shell smoke script: $SMOKE" >&2
  echo "clone uDOS-shell as a sibling of uDOS-dev or adjust paths." >&2
  exit 1
fi

echo "Delegating to $SMOKE"
bash "$SMOKE"
