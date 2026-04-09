#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

if [ ! -d node_modules ]; then
  npm install
fi

npm run build
npm test

if [ -f go.mod ]; then
  go test ./...
fi
