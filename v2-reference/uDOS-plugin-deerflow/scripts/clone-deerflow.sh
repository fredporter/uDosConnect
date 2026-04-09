#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-$(pwd)}"
UPSTREAM_URL="${UPSTREAM_URL:-https://github.com/bytedance/deer-flow.git}"
TARGET_DIR="${ROOT_DIR}/vendor/deer-flow"

mkdir -p "${ROOT_DIR}/vendor"

if [ -d "${TARGET_DIR}/.git" ]; then
  echo "Deer Flow already cloned at ${TARGET_DIR}"
  exit 0
fi

git clone "${UPSTREAM_URL}" "${TARGET_DIR}"
cd "${TARGET_DIR}"

if git remote get-url origin >/dev/null 2>&1; then
  git remote rename origin upstream
fi

echo "Cloned Deer Flow to ${TARGET_DIR}"
echo "Primary remote is now named: upstream"
