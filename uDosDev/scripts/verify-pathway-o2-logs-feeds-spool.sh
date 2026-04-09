#!/usr/bin/env bash
# Verifies O2 promotion artefacts for the logs/feeds/spool pathway (uDOS-dev + optional sibling Core).
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CANDIDATE="$REPO_ROOT/@dev/pathways/logs-feeds-and-spool-candidate.md"
CHECKLIST="$REPO_ROOT/@dev/pathways/o2-logs-feeds-spool-execution-checklist.md"

if [ ! -f "$CANDIDATE" ]; then
  echo "missing pathway candidate: $CANDIDATE" >&2
  exit 1
fi
if [ ! -f "$CHECKLIST" ]; then
  echo "missing O2 checklist: $CHECKLIST" >&2
  exit 1
fi
if ! grep -q "Post-08 O2" "$CANDIDATE"; then
  echo "candidate missing O2 promotion marker" >&2
  exit 1
fi
if ! grep -q "feeds-and-spool.md" "$CHECKLIST"; then
  echo "checklist missing Core contract reference" >&2
  exit 1
fi

CORE_ROOT="${UDOS_CORE_ROOT:-$REPO_ROOT/../uDOS-core}"
FEEDS_DOC="$CORE_ROOT/docs/feeds-and-spool.md"
if [ -d "$CORE_ROOT" ]; then
  if [ ! -f "$FEEDS_DOC" ]; then
    echo "uDOS-core checkout present but missing: $FEEDS_DOC" >&2
    exit 1
  fi
  if ! grep -q "uDOS Feeds and Spool" "$FEEDS_DOC"; then
    echo "unexpected Core feeds doc content: $FEEDS_DOC" >&2
    exit 1
  fi
else
  echo "note: no sibling uDOS-core at $CORE_ROOT — skipped Core file check (set UDOS_CORE_ROOT for strict verify)" >&2
fi

echo "pathway O2 logs/feeds/spool verify passed"
