#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAMILY_ROOT="$(cd "$REPO_ROOT/.." && pwd)"

require_file() {
  if [ ! -f "$1" ]; then
    echo "missing required file: $1" >&2
    exit 1
  fi
}

cd "$REPO_ROOT"

require_file "$REPO_ROOT/docs/release-surfaces.md"
require_file "$REPO_ROOT/docs/release-matrix.md"
require_file "$REPO_ROOT/docs/versioning-policy.md"

for repo in \
  uDOS-core \
  uDOS-shell \
  uDOS-wizard \
  sonic-screwdriver \
  uHOME-server \
  uHOME-client \
  uDOS-empire \
  uHOME-matter \
  uDOS-alpine \
  uDOS-host \
  sonic-ventoy \
  uDOS-gameplay \
  uDOS-plugin-index \
  uDOS-themes \
  uDOS-docs \
  uDOS-dev
do
  repo_root="$FAMILY_ROOT/$repo"
  if [ ! -d "$repo_root" ]; then
    echo "missing repo directory: $repo_root" >&2
    exit 1
  fi
  if [ ! -f "$repo_root/README.md" ]; then
    echo "missing README for $repo" >&2
    exit 1
  fi
done

for policy_repo in \
  sonic-screwdriver \
  uDOS-alpine
do
  if [ ! -f "$FAMILY_ROOT/$policy_repo/docs/release-policy.md" ]; then
    echo "missing release policy for $policy_repo" >&2
    exit 1
  fi
done

if command -v rg >/dev/null 2>&1; then
  if rg -n 'uHOME-empire' \
    "$REPO_ROOT/docs" \
    "$REPO_ROOT/automation" \
    "$REPO_ROOT/@dev/notes/roadmap/v3-feed.md" \
    "$REPO_ROOT/@dev/requests" \
    "$REPO_ROOT/@dev/submissions" \
    "$REPO_ROOT/README.md"; then
    echo "stale uHOME-empire reference found in active dev governance surfaces" >&2
    exit 1
  fi
else
  if grep -R -n 'uHOME-empire' \
    "$REPO_ROOT/docs" \
    "$REPO_ROOT/automation" \
    "$REPO_ROOT/@dev/notes/roadmap/v3-feed.md" \
    "$REPO_ROOT/@dev/requests" \
    "$REPO_ROOT/@dev/submissions" \
    "$REPO_ROOT/README.md"; then
    echo "stale uHOME-empire reference found in active dev governance surfaces" >&2
    exit 1
  fi
fi

echo "Release surface checks passed"
