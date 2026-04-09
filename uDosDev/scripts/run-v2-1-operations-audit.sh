#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEV_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ROOT="$(cd "$DEV_ROOT/.." && pwd)"
PASS=0
FAIL=0

check_file() {
  local label="$1"
  local path="$2"
  if [[ -f "$path" ]]; then
    echo "[pass] $label :: $path"
    PASS=$((PASS+1))
  else
    echo "[fail] $label :: missing $path"
    FAIL=$((FAIL+1))
  fi
}

check_executable() {
  local label="$1"
  local path="$2"
  if [[ -x "$path" ]]; then
    echo "[pass] $label :: $path"
    PASS=$((PASS+1))
  else
    echo "[fail] $label :: not executable $path"
    FAIL=$((FAIL+1))
  fi
}

echo "v2.1 operations audit"
echo "root: $ROOT"

audit() {
  check_file "core readme" "$ROOT/uDOS-core/README.md"
  check_executable "core checks" "$ROOT/uDOS-core/scripts/run-core-checks.sh"
  check_file "core mcp contract" "$ROOT/uDOS-core/contracts/mcp-tool-contract.json"
  check_file "core plugin schema" "$ROOT/uDOS-core/schemas/plugin-manifest.schema.json"

  check_file "shell readme" "$ROOT/uDOS-shell/README.md"
  check_executable "shell checks" "$ROOT/uDOS-shell/scripts/run-shell-checks.sh"
  check_file "shell cli entry" "$ROOT/uDOS-shell/src/cli.ts"

  check_file "wizard quickstart" "$ROOT/uDOS-wizard/docs/first-launch-quickstart.md"
  check_executable "wizard checks" "$ROOT/uDOS-wizard/scripts/run-wizard-checks.sh"
  check_file "wizard mcp registry" "$ROOT/uDOS-wizard/wizard/mcp_registry.py"

  check_file "plugin index readme" "$ROOT/uDOS-plugin-index/README.md"
  check_executable "plugin index checks" "$ROOT/uDOS-plugin-index/scripts/run-plugin-index-checks.sh"

  check_file "uhome quickstart" "$ROOT/uHOME-server/QUICKSTART.md"
  check_executable "uhome checks" "$ROOT/uHOME-server/scripts/run-uhome-server-checks.sh"
  check_file "uhome launcher service" "$ROOT/uHOME-server/services/launcher/README.md"

  check_file "alpine readme" "$ROOT/uDOS-alpine/README.md"
  check_executable "alpine checks" "$ROOT/uDOS-alpine/scripts/run-alpine-checks.sh"

  check_file "sonic readme" "$ROOT/sonic-screwdriver/README.md"
  check_executable "sonic checks" "$ROOT/sonic-screwdriver/scripts/run-sonic-checks.sh"
  check_file "sonic mcp service" "$ROOT/sonic-screwdriver/services/mcp_server.py"
  check_file "sonic uhome launcher" "$ROOT/sonic-screwdriver/distribution/launchers/uhome/uhome-console.sh"

  check_file "thinui state contract" "$ROOT/uDOS-thinui/src/contracts/state.ts"
  check_file "thinui event contract" "$ROOT/uDOS-thinui/src/contracts/event.ts"
  check_file "thinui runtime loop" "$ROOT/uDOS-thinui/src/runtime/runtime-loop.ts"
  check_file "thinui boot-loader view" "$ROOT/uDOS-thinui/src/views/boot-loader.ts"

  check_file "@dev operations module" "$ROOT/uDOS-dev/@dev/operations/README.md"
  check_file "@dev ok assist mcp support" "$ROOT/uDOS-dev/@dev/operations/mcp/ok-assist-mcp-support.md"
  check_file "v2.1 launch matrix" "$ROOT/uDOS-dev/@dev/operations/checklists/v2.1-launch-and-capability-matrix.md"
}

audit

echo
if [[ $FAIL -eq 0 ]]; then
  echo "audit result: PASS ($PASS checks)"
  exit 0
fi

echo "audit result: FAIL ($FAIL failing checks, $PASS passing checks)"
exit 1
