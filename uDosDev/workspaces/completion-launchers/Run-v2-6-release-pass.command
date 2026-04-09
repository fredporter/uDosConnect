#!/usr/bin/env bash
# macOS Finder launcher: full family v2.6 spine verification (sibling repos required).
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$REPO_ROOT"
bash scripts/run-v2-6-release-pass.sh
