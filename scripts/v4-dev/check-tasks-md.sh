#!/usr/bin/env bash
# Verify TASKS.md exists at repo roots under ~/Code (v4 working set).
# If a listed repo directory is absent (sparse workspace), skip with SKIP (not a failure).
# **Required** clones must have TASKS.md; optional product repos warn if missing.
set -eu
CODE_ROOT="${UDOS_CODE_ROOT:-$HOME/Code}"
REQUIRED=(
  uDosConnect
  uDosGo
  UniversalSurfaceXD
  SonicScrewdriver
)
OPTIONAL=(
  Linkdown
  Linkdown-premium
  Syncdown-app
  Chatdown
)
missing=0
check_repo() {
  local name="$1"
  local required="$2"
  local root="$CODE_ROOT/$name"
  local f="$root/TASKS.md"
  if [[ ! -d "$root" ]]; then
    echo "SKIP  $name (not cloned under $CODE_ROOT)"
    return 0
  fi
  if [[ -f "$f" ]]; then
    echo "OK  $name"
    return 0
  fi
  if [[ "$required" == "1" ]]; then
    echo "MISSING  $name → $f"
    missing=1
  else
    echo "WARN  $name (no TASKS.md yet) → $f"
  fi
}
for name in "${REQUIRED[@]}"; do
  check_repo "$name" 1
done
for name in "${OPTIONAL[@]}"; do
  check_repo "$name" 0
done
# uDosConnect uses uDosDev/TASKS.md as primary governance surface
if [[ -f "$CODE_ROOT/uDosConnect/uDosDev/TASKS.md" ]]; then
  echo "OK  uDosConnect/uDosDev/TASKS.md"
else
  echo "MISSING  uDosConnect/uDosDev/TASKS.md"
  missing=1
fi
exit "$missing"
