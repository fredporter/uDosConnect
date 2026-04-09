#!/usr/bin/env bash

set -eu

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SHARED_PYTHON_BIN="${UDOS_SHARED_PYTHON_BIN:-}"
USE_SHARED_RESOURCES="${UDOS_USE_SHARED_RESOURCES:-1}"

if [ "$USE_SHARED_RESOURCES" = "1" ] && [ -z "$SHARED_PYTHON_BIN" ]; then
  FAMILY_HELPER="$REPO_ROOT/../scripts/lib/family-python.sh"
  if [ -f "$FAMILY_HELPER" ]; then
    # shellcheck source=/dev/null
    . "$FAMILY_HELPER"
    ensure_shared_python
    SHARED_PYTHON_BIN="${UDOS_SHARED_PYTHON_BIN:-}"
  fi
fi

cd "$REPO_ROOT"

if [ -n "$SHARED_PYTHON_BIN" ] && [ -x "$SHARED_PYTHON_BIN" ]; then
  "$SHARED_PYTHON_BIN" -m pytest tests
else
  python3 -m pytest tests
fi
