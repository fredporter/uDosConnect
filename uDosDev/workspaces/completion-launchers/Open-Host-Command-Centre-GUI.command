#!/usr/bin/env bash
# macOS Finder launcher: prove uDOS-host command-centre HTTP demo (GUI lane).
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../uDOS-host" && pwd)"
cd "$REPO_ROOT"
bash scripts/verify-command-centre-http.sh
