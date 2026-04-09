#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEV_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAMILY_ROOT="$(cd "$DEV_ROOT/.." && pwd)"
REPORT_DIR="$DEV_ROOT/@dev/notes/reports"
STAMP="$(date '+%Y-%m-%d-%H%M%S')"
REPORT_PATH="$REPORT_DIR/v2-5-release-pass-$STAMP.md"

mkdir -p "$REPORT_DIR"

WORKSPACE_ROOT="$FAMILY_ROOT/uDOS-workspace"
CORE_ROOT="$FAMILY_ROOT/uDOS-core"
WIZARD_ROOT="$FAMILY_ROOT/uDOS-wizard"
DEERFLOW_ROOT="$FAMILY_ROOT/uDOS-plugin-deerflow"

{
  echo "# v2.5 Release Pass"
  echo
  echo "- generated: $STAMP"
  echo "- binder: #binder/dev-v2-5-release-pass"
  echo

  echo "## Validation"
  echo
  bash "$WORKSPACE_ROOT/scripts/run-workspace-checks.sh"
  (
    cd "$CORE_ROOT"
    python3 -m pytest tests/test_mdc_runtime.py -q
  )
  (
    cd "$DEERFLOW_ROOT"
    PYTHONPATH="$DEERFLOW_ROOT/src/python/udos_plugin_deerflow" python3 -m pytest tests/test_translation.py -q
  )
  (
    cd "$WIZARD_ROOT"
    PYTHONPATH="$WIZARD_ROOT" python3 -m unittest tests.test_orchestration_round_v24
  )
  bash "$DEV_ROOT/scripts/run-roadmap-status.sh" >/dev/null
  echo

  echo "## Scope Closed"
  echo
  echo "- Deer Flow now supports preview and controlled execution modes through Wizard compile dispatch."
  echo "- Wizard persists backend-aware compile results, execution mode, pin status, and artifacts."
  echo "- Workspace surfaces now expose execution mode and artifact-aware history and publish queue state."
  echo "- Core MDC now covers additional document normalization paths for RTF and DOCX-like inputs."
  echo

  echo "## Still Outside Local Scope"
  echo
  echo "- remote Deer Flow clusters"
  echo "- graph editing"
  echo "- memory sync import/export"
} >"$REPORT_PATH"

echo "Wrote $REPORT_PATH"
