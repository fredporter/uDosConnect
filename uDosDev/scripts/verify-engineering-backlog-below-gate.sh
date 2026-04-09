#!/usr/bin/env bash
# Continuous engineering backlog checks that do *not* open a new v2.x plan.
# See docs/next-family-plan-gate.md (gate criteria) and
# @dev/notes/roadmap/next-plan-readiness.md (how to prepare a future plan).

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

bash "$REPO_ROOT/scripts/verify-next-family-plan-gate-docs.sh"
bash "$REPO_ROOT/automation/check-github-contract-rollforward.sh"

echo "engineering backlog below-gate checks passed"
