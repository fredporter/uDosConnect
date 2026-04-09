#!/usr/bin/env bash
# Row 1 (engineering backlog): next v2.x plan stays gate-controlled — no new
# rounds file until docs/next-family-plan-gate.md criteria are met. This script
# only verifies the gate packet and ledger pointers remain present in uDOS-dev.

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

require_file() {
  if [ ! -f "$1" ]; then
    echo "missing required file: $1" >&2
    exit 1
  fi
}

cd "$REPO_ROOT"

require_file "$REPO_ROOT/docs/next-family-plan-gate.md"
require_file "$REPO_ROOT/@dev/notes/reports/optional-backlog-round-5-2026-04-03.md"
require_file "$REPO_ROOT/@dev/notes/roadmap/v3-roadmap.md"
require_file "$REPO_ROOT/@dev/notes/roadmap/v3-feed.md"

if ! grep -q "next-family-plan-gate" "$REPO_ROOT/@dev/notes/roadmap/v3-feed.md"; then
  echo "v3-feed.md should reference docs/next-family-plan-gate.md" >&2
  exit 1
fi

echo "next-family-plan-gate documentation checks passed"
