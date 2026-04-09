#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

bash "$REPO_ROOT/scripts/run-ubuntu-checks.sh"
bash "$REPO_ROOT/scripts/verify-command-centre-http.sh"
bash "$REPO_ROOT/scripts/verify-command-centre-lan-continuity.sh"

echo "uDOS-host strict completion gate passed"
