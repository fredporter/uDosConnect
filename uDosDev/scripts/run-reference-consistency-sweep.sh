#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPORT_DIR="$REPO_ROOT/@dev/notes/reports"
STAMP="$(date '+%Y-%m-%d-%H%M%S')"
REPORT_PATH="$REPORT_DIR/reference-consistency-$STAMP.md"

mkdir -p "$REPORT_DIR"

# shellcheck disable=SC1091
. "$REPO_ROOT/automation/family-repos.sh"

patterns='\buDOS-sonic\b(?!-screwdriver)|fredporter/uDOS-sonic\b(?!-screwdriver)|<local-project-root>/uDOS-sonic\b(?!-screwdriver)'
active_total=0
archived_total=0

{
  echo "# Public Reference Consistency Sweep"
  echo
  echo "- generated: $STAMP"
  echo "- root: $ROOT_DIR"
  echo "- binder: #binder/dev-public-reference-consistency"
  echo "- patterns: \`uDOS-sonic\`, \`fredporter/uDOS-sonic\`, \`<local-project-root>/uDOS-sonic\`"
  echo

  for repo in "${public_repos[@]}"; do
    repo_path="$ROOT_DIR/$repo"
    active_matches="$(rg -n -P "$patterns" "$repo_path" \
      --glob '!**/docs/v1/**' \
      --glob '!**/@dev/notes/reports/**' \
      --glob '!**/docs/reference-consistency-sweep.md' \
      --glob '!**/scripts/run-reference-consistency-sweep.sh' \
      --glob '!**/requests/*reference-consistency*.md' \
      --glob '!**/submissions/*reference-consistency*.md' || true)"
    archived_matches="$(rg -n -P "$patterns" "$repo_path/docs/v1" 2>/dev/null || true)"

    active_count="$(printf '%s\n' "$active_matches" | sed '/^$/d' | wc -l | tr -d ' ')"
    archived_count="$(printf '%s\n' "$archived_matches" | sed '/^$/d' | wc -l | tr -d ' ')"

    active_total=$((active_total + active_count))
    archived_total=$((archived_total + archived_count))

    echo "## $repo"
    echo
    echo "- active matches: $active_count"
    echo "- archived matches: $archived_count"

    if [ "$active_count" -gt 0 ]; then
      echo
      echo "### Active Drift"
      printf '%s\n' "$active_matches"
    fi

    echo
  done

  echo "## Summary"
  echo
  echo "- active matches across public repos: $active_total"
  echo "- archived matches across public repos: $archived_total"
} >"$REPORT_PATH"

echo "Wrote $REPORT_PATH"
