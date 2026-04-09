#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

require_file() {
  if [ ! -f "$1" ]; then
    echo "missing required file: $1" >&2
    exit 1
  fi
}

cd "$REPO_ROOT"

require_file "$REPO_ROOT/README.md"
require_file "$REPO_ROOT/docs/architecture.md"
require_file "$REPO_ROOT/docs/boundary.md"
require_file "$REPO_ROOT/docs/getting-started.md"
require_file "$REPO_ROOT/docs/examples.md"
require_file "$REPO_ROOT/docs/activation.md"
require_file "$REPO_ROOT/apkbuild/APKBUILD"
require_file "$REPO_ROOT/apkbuild/README.md"
require_file "$REPO_ROOT/distribution/README.md"
require_file "$REPO_ROOT/openrc/README.md"
require_file "$REPO_ROOT/openrc/udos-thinui-launcher.initd"
require_file "$REPO_ROOT/openrc/udos-thinui-launcher.confd"
require_file "$REPO_ROOT/profiles/README.md"
require_file "$REPO_ROOT/profiles/thinui-c64-launch.json"
require_file "$REPO_ROOT/scripts/README.md"
require_file "$REPO_ROOT/scripts/build-apk.sh"
require_file "$REPO_ROOT/scripts/demo-thinui-launch.sh"
require_file "$REPO_ROOT/tests/README.md"
require_file "$REPO_ROOT/examples/README.md"
require_file "$REPO_ROOT/examples/basic-alpine-build.md"

if command -v rg >/dev/null 2>&1; then
  if rg -n '/Users/fredbook/Code|~/Users/fredbook/Code' \
    "$REPO_ROOT/README.md" \
    "$REPO_ROOT/docs" \
    "$REPO_ROOT/tests" \
    "$REPO_ROOT/examples" \
    "$REPO_ROOT/apkbuild" \
    "$REPO_ROOT/distribution" \
    "$REPO_ROOT/openrc" \
    "$REPO_ROOT/profiles"; then
    echo "private local-root reference found in uDOS-alpine" >&2
    exit 1
  fi
else
  if grep -R -nE '/Users/fredbook/Code|~/Users/fredbook/Code' \
    "$REPO_ROOT/README.md" \
    "$REPO_ROOT/docs" \
    "$REPO_ROOT/tests" \
    "$REPO_ROOT/examples" \
    "$REPO_ROOT/apkbuild" \
    "$REPO_ROOT/distribution" \
    "$REPO_ROOT/openrc" \
    "$REPO_ROOT/profiles"; then
    echo "private local-root reference found in uDOS-alpine" >&2
    exit 1
  fi
fi

echo "uDOS-alpine checks passed"
