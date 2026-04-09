#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPORT_DIR="$REPO_ROOT/@dev/notes/reports"
STAMP="$(date '+%Y-%m-%d-%H%M%S')"
REPORT_PATH="$REPORT_DIR/roadmap-status-$STAMP.md"
FEED_FILE="$REPO_ROOT/@dev/notes/roadmap/v3-feed.md"
ROADMAP_FILE="$REPO_ROOT/@dev/notes/roadmap/v3-roadmap.md"

mkdir -p "$REPORT_DIR"

{
  echo "# Roadmap Status Report"
  echo
  echo "- generated: $STAMP"
  echo "- source roadmap: $ROADMAP_FILE"
  echo "- source feed: $FEED_FILE"
  echo

  echo "## Active Roadmap"
  echo
  sed -n '1,200p' "$ROADMAP_FILE"
  echo

  echo "## Current Feed Entries"
  echo
  sed -n '1,240p' "$FEED_FILE"
  echo

  echo "## Active Roadmap Requests"
  echo
  if [ -d "$REPO_ROOT/@dev/requests" ]; then
    find "$REPO_ROOT/@dev/requests" -maxdepth 1 -type f -name 'binder-*.md' | sort | while read -r file; do
      printf -- "- %s\n" "$(basename "$file")"
    done
  fi
  echo

  echo "## Active Roadmap Submissions"
  echo
  if [ -d "$REPO_ROOT/@dev/submissions" ]; then
    find "$REPO_ROOT/@dev/submissions" -maxdepth 1 -type f -name 'submission-*.md' | sort | while read -r file; do
      printf -- "- %s\n" "$(basename "$file")"
    done
  fi
} >"$REPORT_PATH"

echo "Wrote $REPORT_PATH"
