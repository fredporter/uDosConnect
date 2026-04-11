#!/usr/bin/env bash
# Round E / Round F — family workspace sanity (uDosConnect monorepo).
# Run from repo root: ./scripts/shakedown.sh
# Optional: UDOS_SHAKEDOWN_FULL=1 also runs scripts/v4-dev/family-health-check.sh
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CODE_ROOT="${UDOS_CODE_ROOT:-$HOME/Code}"

echo "==> uDosConnect shakedown (v4 Round E)"
cd "$ROOT_DIR"

if [[ ! -f "$ROOT_DIR/uDosDev/TASKS.md" ]]; then
  echo "FAIL: uDosDev/TASKS.md missing (init submodules?)"
  exit 1
fi
if [[ ! -f "$ROOT_DIR/uDosDocs/TASKS.md" ]]; then
  echo "FAIL: uDosDocs/TASKS.md missing (init submodules?)"
  exit 1
fi
if [[ ! -f "$ROOT_DIR/uDosDev/docs/specs/v4/README.md" ]]; then
  echo "FAIL: uDosDev/docs/specs/v4/README.md missing"
  exit 1
fi

echo "==> validate-courses.sh"
bash "$SCRIPT_DIR/validate-courses.sh"

echo "==> check-tasks-md.sh (sparse-workspace aware)"
bash "$SCRIPT_DIR/v4-dev/check-tasks-md.sh"

if [[ -d "$CODE_ROOT/.compost" ]]; then
  echo "OK  $CODE_ROOT/.compost (archive root)"
else
  echo "WARN: $CODE_ROOT/.compost not found — create per Round F §3.2 (alpha archive)"
fi

if [[ "${UDOS_SHAKEDOWN_FULL:-}" == "1" ]]; then
  echo "==> family-health-check.sh (UDOS_SHAKEDOWN_FULL=1)"
  bash "$SCRIPT_DIR/v4-dev/family-health-check.sh"
fi

echo "Shakedown passed."
