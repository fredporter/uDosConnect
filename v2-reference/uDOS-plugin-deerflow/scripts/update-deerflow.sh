#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-$(pwd)}"
TARGET_DIR="${ROOT_DIR}/vendor/deer-flow"

if [ ! -d "${TARGET_DIR}/.git" ]; then
  echo "Deer Flow clone missing: ${TARGET_DIR}"
  echo "Run scripts/clone-deerflow.sh first."
  exit 1
fi

cd "${TARGET_DIR}"
git fetch --tags upstream

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
echo "Current branch: ${CURRENT_BRANCH}"
echo "Fetched latest refs from upstream."
echo "Review changes, then pin a tested commit in the plugin version matrix."
