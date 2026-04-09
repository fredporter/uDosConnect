#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SHARED_PYTHON_BIN="${UDOS_SHARED_PYTHON_BIN:-}"
USE_SHARED_RESOURCES="${UDOS_USE_SHARED_RESOURCES:-1}"
PYTHON_BIN="${PYTHON:-python3}"

require_file() {
  if [ ! -f "$1" ]; then
    echo "missing required file: $1" >&2
    exit 1
  fi
}

cd "$REPO_ROOT"

UBUNTU_REQUIRED_FILES_MANIFEST="$REPO_ROOT/scripts/lib/ubuntu-check-required-files.v1.list"
require_file "$UBUNTU_REQUIRED_FILES_MANIFEST"
while IFS= read -r raw || [ -n "$raw" ]; do
  if [[ "$raw" =~ ^[[:space:]]*# ]]; then
    continue
  fi
  rel="${raw#"${raw%%[![:space:]]*}"}"
  rel="${rel%"${rel##*[![:space:]]}"}"
  if [ -z "$rel" ]; then
    continue
  fi
  require_file "$REPO_ROOT/$rel"
done < "$UBUNTU_REQUIRED_FILES_MANIFEST"

if [ "$USE_SHARED_RESOURCES" = "1" ] && [ -z "$SHARED_PYTHON_BIN" ]; then
  FAMILY_HELPER="$REPO_ROOT/../scripts/lib/family-python.sh"
  if [ -f "$FAMILY_HELPER" ]; then
    # shellcheck source=/dev/null
    . "$FAMILY_HELPER"
    ensure_shared_python
    SHARED_PYTHON_BIN="${UDOS_SHARED_PYTHON_BIN:-}"
  fi
fi
if [ -n "$SHARED_PYTHON_BIN" ] && [ -x "$SHARED_PYTHON_BIN" ]; then
  PYTHON_BIN="$SHARED_PYTHON_BIN"
fi

"$PYTHON_BIN" "$REPO_ROOT/scripts/lib/verify-ubuntu-static-contracts.py"

TMP_HOME="$(mktemp -d)"
trap 'rm -rf "$TMP_HOME"' EXIT
UDOS_HOME="$TMP_HOME/.udos" bash "$REPO_ROOT/scripts/udos-hostd.sh" layout-only >/dev/null
test -f "$TMP_HOME/.udos/state/hostd/runtime-layout.json"
test -d "$TMP_HOME/.udos/vault/inbox"
test -d "$TMP_HOME/.udos/sync/queue"
test -d "$TMP_HOME/.udos/state/web"
test -d "$TMP_HOME/.udos/repos"
UDOS_HOME="$TMP_HOME/.udos" bash "$REPO_ROOT/scripts/udos-gitd.sh" init-layout >/dev/null
UDOS_HOME="$TMP_HOME/.udos" bash "$REPO_ROOT/scripts/udos-gitd.sh" repo-list >/dev/null
UDOS_HOME="$TMP_HOME/.udos" bash "$REPO_ROOT/scripts/udos-gitd.sh" >/dev/null
UDOS_HOME="$TMP_HOME/.udos" bash "$REPO_ROOT/scripts/udos-commandd.sh" list-operations repo >/dev/null
UDOS_HOME="$TMP_HOME/.udos" "$REPO_ROOT/scripts/udos_commandd.py" list-operations repo >/dev/null
UDOS_HOME="$TMP_HOME/.udos" bash "$REPO_ROOT/scripts/udos-commandd.sh" surface-summary git >/dev/null
UDOS_HOME="$TMP_HOME/.udos" "$REPO_ROOT/scripts/udos_commandd.py" surface-summary git >/dev/null
UDOS_HOME="$TMP_HOME/.udos" bash "$REPO_ROOT/scripts/udos-commandd.sh" policy-summary >/dev/null
UDOS_HOME="$TMP_HOME/.udos" "$REPO_ROOT/scripts/udos_commandd.py" policy-summary >/dev/null
UDOS_HOME="$TMP_HOME/.udos" bash "$REPO_ROOT/scripts/udos-commandd.sh" repo-op repo.list >/dev/null
UDOS_HOME="$TMP_HOME/.udos" "$REPO_ROOT/scripts/udos_commandd.py" repo-op repo.list >/dev/null
repo_push_output="$(UDOS_HOME="$TMP_HOME/.udos" bash "$REPO_ROOT/scripts/udos-commandd.sh" repo-op repo.push uDOS-host || true)"
printf '%s' "$repo_push_output" | grep -q 'status=blocked'
github_gate_output="$(UDOS_HOME="$TMP_HOME/.udos" bash "$REPO_ROOT/scripts/udos-commandd.sh" repo-op github.pr.create uDOS-host || true)"
printf '%s' "$github_gate_output" | grep -q 'status=policy-gated'

if command -v rg >/dev/null 2>&1; then
  if rg -n '/Users/fredbook/Code|~/Users/fredbook/Code' \
    --glob '!.compost/**' \
    "$REPO_ROOT/README.md" \
    "$REPO_ROOT/docs" \
    "$REPO_ROOT/examples" \
    "$REPO_ROOT/config"; then
    echo "private local-root reference found in uDOS-host" >&2
    exit 1
  fi
else
  if grep -RInE -I --exclude-dir='__pycache__' --exclude-dir='.compost' '/Users/fredbook/Code|~/Users/fredbook/Code' \
    "$REPO_ROOT/README.md" \
    "$REPO_ROOT/docs" \
    "$REPO_ROOT/examples" \
    "$REPO_ROOT/config"; then
    echo "private local-root reference found in uDOS-host" >&2
    exit 1
  fi
fi

bash "$REPO_ROOT/scripts/verify-docker-compose-compatibility-doc.sh"
bash "$REPO_ROOT/scripts/verify-udos-runtime-daemons.sh"

echo "uDOS-host checks passed"
