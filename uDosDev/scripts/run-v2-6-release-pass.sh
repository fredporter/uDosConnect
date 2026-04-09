#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEV_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAMILY_ROOT="$(cd "$DEV_ROOT/.." && pwd)"
REPORT_DIR="$DEV_ROOT/@dev/notes/reports"
STAMP="$(date '+%Y-%m-%d-%H%M%S')"
REPORT_PATH="$REPORT_DIR/v2-6-release-pass-$STAMP.md"

mkdir -p "$REPORT_DIR"

WORKSPACE_ROOT="$FAMILY_ROOT/uDOS-workspace"
CORE_ROOT="$FAMILY_ROOT/uDOS-core"
THINUI_ROOT="$FAMILY_ROOT/uDOS-thinui"
HOST_ROOT="$FAMILY_ROOT/uDOS-host"

{
  echo "# v2.6 Release Pass"
  echo
  echo "- generated: $STAMP"
  echo "- binder: #binder/dev-v2-6-release-pass"
  echo

  echo "## Validation"
  echo
  for repo in "$WORKSPACE_ROOT" "$CORE_ROOT" "$THINUI_ROOT" "$HOST_ROOT"; do
    if [ ! -d "$repo" ]; then
      echo "missing sibling repo: $repo" >&2
      exit 1
    fi
  done

  bash "$WORKSPACE_ROOT/scripts/run-workspace-checks.sh"
  (
    cd "$CORE_ROOT"
    PYTHONPATH="$CORE_ROOT" python3 -m pytest tests/test_binder_spine_contract.py -q --tb=line
  )
  (
    cd "$THINUI_ROOT"
    npm run validate:binder-spine
    npm run typecheck
  )
  bash "$HOST_ROOT/scripts/run-ubuntu-checks.sh"
  bash "$DEV_ROOT/scripts/run-roadmap-status.sh" >/dev/null
  echo

  echo "## Scope closed (v2.6 binder/workspace spine)"
  echo
  echo "- Core: binder spine payload v1 schema, validation helpers, contract tests."
  echo "- ThinUI: spine v1 bridge (binder-spine-v1.ts), fetch vs legacy query params, npm run validate:binder-spine."
  echo "- Workspace: spine validation + operator snapshot in the web shell (docs/workspace-binder-spine.md)."
  echo "- Ubuntu host: run-ubuntu-checks.sh green; docs/activation.md section v2.6 family spine parity."
  echo

  echo "## Deferred (RFC-only; see docs/deferred-product-rfc-stubs.md)"
  echo
  echo "- Remote Deer Flow clusters"
  echo "- Graph editing"
  echo "- Memory sync import/export"
} >"$REPORT_PATH"

echo "Wrote $REPORT_PATH"
