#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPORT_DIR="$REPO_ROOT/@dev/notes/reports"
STAMP="$(date '+%Y-%m-%d-%H%M%S')"
REPORT_PATH="$REPORT_DIR/family-conformance-$STAMP.md"

mkdir -p "$REPORT_DIR"

# shellcheck disable=SC1091
. "$REPO_ROOT/automation/family-repos.sh"

{
  echo "# Family Conformance Sweep"
  echo
  echo "- generated: $STAMP"
  echo "- root: $ROOT_DIR"
  echo
  echo "## Public Repos"
  echo
  echo "### GitHub contract roll-forward snapshot"
  "$REPO_ROOT/automation/check-github-contract-rollforward.sh" --report | while IFS='|' read -r repo status validate policy script_owned; do
    if [ "$repo" = "repo" ]; then
      continue
    fi
    echo "- $repo: status=$status validate=$validate family_policy=$policy script_owned=$script_owned"
  done
  echo

  for repo in "${public_repos[@]}"; do
    echo "### $repo"
    if [ ! -d "$ROOT_DIR/$repo" ]; then
      echo "- local path: missing ($ROOT_DIR/$repo)"
      echo "- governance: skipped (repo not in this local root)"
      echo "- develop branch: skipped"
      echo "- main protection: skipped"
      echo "- local status: skipped"
      echo
      continue
    fi
    if "$REPO_ROOT/automation/check-repo-governance.sh" "$repo" "$ROOT_DIR/$repo" >/dev/null 2>&1; then
      echo "- governance: pass"
    else
      echo "- governance: fail"
    fi

    if git -C "$ROOT_DIR/$repo" branch --list develop | grep -q develop; then
      echo "- develop branch: present"
    else
      echo "- develop branch: missing"
    fi

    if gh api "repos/${OWNER}/${repo}/branches/main/protection" >/dev/null 2>&1; then
      echo "- main protection: enabled"
    else
      echo "- main protection: missing"
    fi

    if [ -z "$(git -C "$ROOT_DIR/$repo" status --short)" ]; then
      echo "- local status: clean"
    else
      echo "- local status: dirty"
    fi
    echo
  done

  echo "## Private Repos"
  echo

  for repo in "${private_repos[@]}"; do
    echo "### $repo"
    if [ ! -d "$ROOT_DIR/$repo" ]; then
      echo "- local path: missing ($ROOT_DIR/$repo)"
      echo "- governance: skipped (repo not in this local root)"
      echo "- local status: skipped"
      echo
      continue
    fi
    if "$REPO_ROOT/automation/check-repo-governance.sh" "$repo" "$ROOT_DIR/$repo" >/dev/null 2>&1; then
      echo "- governance: pass"
    else
      echo "- governance: fail"
    fi

    if [ -z "$(git -C "$ROOT_DIR/$repo" status --short)" ]; then
      echo "- local status: clean"
    else
      echo "- local status: dirty"
    fi
    echo
  done
} >"$REPORT_PATH"

echo "Wrote $REPORT_PATH"
