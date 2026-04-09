#!/usr/bin/env bash
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LANE="$REPO_ROOT/docs/image-ingestion-markdown-lane.md"
CANDIDATE="$REPO_ROOT/@dev/pathways/image-ingestion-md-candidate.md"
CHECKLIST="$REPO_ROOT/@dev/pathways/o2-image-ingestion-md-execution-checklist.md"

for f in "$LANE" "$CANDIDATE" "$CHECKLIST"; do
  if [ ! -f "$f" ]; then
    echo "missing required file: $f" >&2
    exit 1
  fi
done
if ! grep -q "Post-08 O2 promoted" "$CANDIDATE"; then
  echo "candidate missing O2 promotion marker" >&2
  exit 1
fi
if ! grep -q "image-ingestion-markdown-lane.md" "$CHECKLIST"; then
  echo "checklist missing lane doc reference" >&2
  exit 1
fi

echo "O2 image-ingestion lane verify passed"
