#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

bash "$REPO_ROOT/scripts/run-empire-checks.sh"
bash "$REPO_ROOT/scripts/run-empire-wizard-release-gate.sh"

echo "uDOS-empire strict completion gate passed"
