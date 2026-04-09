#!/usr/bin/env bash
# Initialize theme fork submodules (fredporter/* under vendor/forks).
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"
git submodule update --init --recursive vendor/forks/c64css3 vendor/forks/NES.css vendor/forks/svelte-notion-kit vendor/forks/bedstead
echo "vendor/forks submodules ready"
