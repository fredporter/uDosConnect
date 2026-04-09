#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

require_file() {
  if [ ! -f "$1" ]; then
    echo "missing required file: $1" >&2
    exit 1
  fi
}

echo "[uDOS-dev] v2.3 Round C workflow-backed schedule demo"
echo ""

require_file "$REPO_ROOT/docs/workflow-schedule-operations.md"
require_file "$REPO_ROOT/docs/family-workflow.md"
require_file "$REPO_ROOT/docs/roadmap-workflow.md"
require_file "$REPO_ROOT/@dev/fixtures/binder-dev-v2-3-workflow-schedules.md"

# Sonic may live under the family root or alongside it (e.g. sonic-family layout).
SONIC_REPO=""
if [ -n "${SONIC_SCREWDRIVER_ROOT:-}" ] && [ -f "${SONIC_SCREWDRIVER_ROOT}/@dev/requests/binder-sonic-v2-3-live-install-recovery.md" ]; then
  SONIC_REPO="$(cd "${SONIC_SCREWDRIVER_ROOT}" && pwd)"
elif [ -f "$REPO_ROOT/../sonic-screwdriver/@dev/requests/binder-sonic-v2-3-live-install-recovery.md" ]; then
  SONIC_REPO="$(cd "$REPO_ROOT/../sonic-screwdriver" && pwd)"
elif [ -f "$REPO_ROOT/../../sonic-family/sonic-screwdriver/@dev/requests/binder-sonic-v2-3-live-install-recovery.md" ]; then
  SONIC_REPO="$(cd "$REPO_ROOT/../../sonic-family/sonic-screwdriver" && pwd)"
else
  echo "run-v2-3-workflow-schedule-demo: missing Sonic binder fixture; set SONIC_SCREWDRIVER_ROOT" >&2
  exit 1
fi
require_file "$SONIC_REPO/@dev/requests/binder-sonic-v2-3-live-install-recovery.md"

echo "Scheduled work is limited to bounded evidence refresh and review preparation."
echo "Manual work owns commit, complete, compile, and promote transitions."
echo ""
echo "Allowed scheduled binder movement:"
echo "- Open -> Hand off"
echo "- Hand off -> Advance"
echo "- Advance -> Review"
echo ""
echo "Manual-only binder movement:"
echo "- Review -> Commit"
echo "- Commit -> Complete"
echo "- Complete -> Compile"
echo "- Compile -> Promote"
echo ""
echo "[uDOS-dev] Refreshing roadmap status report"
bash "$REPO_ROOT/scripts/run-roadmap-status.sh" >/dev/null
echo "[uDOS-dev] Roadmap status refresh complete"
