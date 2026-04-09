#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEV_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAMILY_ROOT="$(cd "$DEV_ROOT/.." && pwd)"
REPORT_DIR="$DEV_ROOT/@dev/notes/reports"
STAMP="$(date '+%Y-%m-%d-%H%M%S')"
REPORT_PATH="$REPORT_DIR/v2-4-release-pass-$STAMP.md"

mkdir -p "$REPORT_DIR"

WORKSPACE_ROOT="$FAMILY_ROOT/uDOS-workspace"
CORE_ROOT="$FAMILY_ROOT/uDOS-core"
SHELL_ROOT="$FAMILY_ROOT/uDOS-shell"
WIZARD_ROOT="$FAMILY_ROOT/uDOS-wizard"
DEERFLOW_ROOT="$FAMILY_ROOT/uDOS-plugin-deerflow"

{
  echo "# v2.4 Release Pass"
  echo
  echo "- generated: $STAMP"
  echo "- binder: #binder/dev-v2-4-release-pass"
  echo

  echo "## Repo Activation"
  echo
  for repo in "$WORKSPACE_ROOT" "$CORE_ROOT" "$SHELL_ROOT" "$WIZARD_ROOT" "$DEERFLOW_ROOT"; do
    if [ -d "$repo" ]; then
      echo "- present: $repo"
    else
      echo "- missing: $repo"
      exit 1
    fi
  done
  echo

  echo "## Validation"
  echo
  bash "$WORKSPACE_ROOT/scripts/run-workspace-checks.sh"
  (
    cd "$DEERFLOW_ROOT"
    PYTHONPATH="$DEERFLOW_ROOT/src/python/udos_plugin_deerflow" python3 -m pytest tests/test_translation.py -q
  )
  (
    cd "$CORE_ROOT"
    python3 -m pytest tests/test_mdc_runtime.py -q
  )
  (
    cd "$SHELL_ROOT"
    GOCACHE=/tmp/udos-shell-gocache go test ./internal/uci ./internal/tui/keymap
  )
  (
    cd "$WIZARD_ROOT"
    PYTHONPATH="$WIZARD_ROOT" python3 -m unittest tests.test_orchestration_round_v24
  )
  bash "$DEV_ROOT/scripts/run-roadmap-status.sh" >/dev/null
  echo

  echo "## Promotion Notes"
  echo
  echo "- Workspace now consumes live Wizard orchestration status, compile results, and publish queue state."
  echo "- Core MDC now preserves original-source routing metadata and expands structured normalization coverage."
  echo "- Shell UCI now includes a session model, radial keyboard contract, and prediction submission flow."
  echo "- Wizard and Deer Flow now persist compile results and expose backend-aware preview and queue state."
  echo

  echo "## Deferred"
  echo
  echo "- Remote Deer Flow cluster execution remains intentionally out of scope for v2.4."
  echo "- Rich media OCR / binary document extraction remains beyond the MVP normalization lane."
} >"$REPORT_PATH"

echo "Wrote $REPORT_PATH"
