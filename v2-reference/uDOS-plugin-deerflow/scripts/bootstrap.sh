#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash "${ROOT_DIR}/scripts/clone-deerflow.sh" "${ROOT_DIR}"

mkdir -p "${ROOT_DIR}/runtime/deerflow/sessions"
mkdir -p "${ROOT_DIR}/tmp"
echo "Bootstrap complete."
