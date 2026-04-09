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

require_dir() {
  if [ ! -d "$1" ]; then
    echo "missing required directory: $1" >&2
    exit 1
  fi
}

cd "$REPO_ROOT"

require_file "$REPO_ROOT/README.md"
require_file "$REPO_ROOT/docs/architecture.md"
require_file "$REPO_ROOT/docs/boundary.md"
require_file "$REPO_ROOT/docs/getting-started.md"
require_file "$REPO_ROOT/docs/inbox-ingest/README.md"
require_file "$REPO_ROOT/docs/archive/v2/completion-rounds-v2-6-alignment.md"
require_file "$REPO_ROOT/workspaces/completion-round-00-v2-6-spine-parity.md"
require_file "$REPO_ROOT/docs/dev-inbox/guidelines/README.md"
require_file "$REPO_ROOT/docs/dev-inbox/guidelines/how-to-submit-to-inbox.md"
require_file "$REPO_ROOT/docs/dev-inbox/guidelines/copy-paste-prompts.md"
require_file "$REPO_ROOT/docs/dev-inbox/local-inbox-README.md"
require_file "$REPO_ROOT/scripts/bootstrap-dev-inbox.sh"
require_file "$REPO_ROOT/docs/examples.md"
require_file "$REPO_ROOT/docs/activation.md"
require_file "$REPO_ROOT/docs/development-roadmap.md"
require_file "$REPO_ROOT/docs/roadmap-workflow.md"
require_file "$REPO_ROOT/docs/workflow-schedule-operations.md"
require_file "$REPO_ROOT/scripts/run-roadmap-status.sh"
require_file "$REPO_ROOT/scripts/run-family-conformance-sweep.sh"
require_file "$REPO_ROOT/scripts/run-public-structure-sweep.sh"
require_file "$REPO_ROOT/scripts/run-reference-consistency-sweep.sh"
require_file "$REPO_ROOT/scripts/run-ok-agent-fixture-check.sh"
require_file "$REPO_ROOT/scripts/run-dev-kill-switch.sh"
require_file "$REPO_ROOT/scripts/run-dev-log-rotate.sh"
require_file "$REPO_ROOT/scripts/run-v2-3-workflow-schedule-demo.sh"
require_file "$REPO_ROOT/scripts/run-shared-runtime-resource-check.sh"
require_file "$REPO_ROOT/scripts/verify-pathway-o2-logs-feeds-spool.sh"
require_file "$REPO_ROOT/scripts/verify-o3-docker-compat-siblings.sh"
require_file "$REPO_ROOT/scripts/verify-o4-operational-hygiene.sh"
require_file "$REPO_ROOT/scripts/verify-next-family-plan-gate-docs.sh"
require_file "$REPO_ROOT/scripts/verify-engineering-backlog-below-gate.sh"
require_file "$REPO_ROOT/@dev/fixtures/operational-hygiene-venv-lanes.v1.json"
require_file "$REPO_ROOT/@dev/notes/reports/operational-hygiene-cadence-o4-2026-04-02.md"
require_file "$REPO_ROOT/scripts/install-thinui-themes-lane.sh"
require_file "$REPO_ROOT/scripts/run-v2-1-operations-checks.sh"
require_file "$REPO_ROOT/scripts/run-v2-6-release-pass.sh"
require_file "$REPO_ROOT/@dev/notes/rounds/v2-6-family-plan-closed-2026-04-05.md"
require_dir "$REPO_ROOT/@dev/requests"
require_dir "$REPO_ROOT/@dev/submissions"
require_dir "$REPO_ROOT/@dev/pathways"
require_dir "$REPO_ROOT/@dev/notes"
require_dir "$REPO_ROOT/automation"
require_dir "$REPO_ROOT/courses"

"$REPO_ROOT/scripts/run-roadmap-status.sh" >/dev/null
"$REPO_ROOT/scripts/run-ok-agent-fixture-check.sh" >/dev/null
bash "$REPO_ROOT/scripts/run-v2-3-workflow-schedule-demo.sh" >/dev/null
bash "$REPO_ROOT/scripts/run-shared-runtime-resource-check.sh" >/dev/null
bash "$REPO_ROOT/scripts/verify-pathway-o2-logs-feeds-spool.sh" >/dev/null
bash "$REPO_ROOT/scripts/verify-o3-docker-compat-siblings.sh" >/dev/null
bash "$REPO_ROOT/scripts/verify-o4-operational-hygiene.sh" >/dev/null
bash "$REPO_ROOT/scripts/verify-engineering-backlog-below-gate.sh" >/dev/null

# Kill-switch smoke test: dry-run confirms the script parses and scans PID dir cleanly.
bash "$REPO_ROOT/scripts/run-dev-kill-switch.sh" --dry-run --all >/dev/null

# Log-rotate dry-run: confirms rotation script is functional.
bash "$REPO_ROOT/scripts/run-dev-log-rotate.sh" --dry-run >/dev/null

if command -v rg >/dev/null 2>&1; then
  if rg -n '/Users/[^/]+/Code/' \
    "$REPO_ROOT/README.md" \
    "$REPO_ROOT/docs"; then
    echo "machine-specific clone path found in published uDosDev README/docs (use <local-project-root> or ~)" >&2
    exit 1
  fi
else
  if grep -R -nE '/Users/[^/]+/Code/' \
    "$REPO_ROOT/README.md" \
    "$REPO_ROOT/docs"; then
    echo "machine-specific clone path found in published uDosDev README/docs (use <local-project-root> or ~)" >&2
    exit 1
  fi
fi

echo "uDosDev checks passed"
