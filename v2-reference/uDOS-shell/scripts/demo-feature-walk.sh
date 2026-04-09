#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "uDOS-shell feature walk (human demo copy + routing preview)"
echo "  Compact lines:  go run ./cmd/feature-walk -compact"
echo "  JSON + samples: go run ./cmd/feature-walk -json"
echo

go run ./cmd/feature-walk

