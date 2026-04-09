#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ROOT="$(cd "$REPO_ROOT/.." && pwd)"
REPORT_DIR="$REPO_ROOT/@dev/notes/reports"
mkdir -p "$REPORT_DIR"

TIMESTAMP="$(date -u +%Y-%m-%d-%H%M%S)"
REPORT_FILE="$REPORT_DIR/v2-1-archive-dependency-audit-$TIMESTAMP.md"

TARGET_ARCHIVES=(
  "uDOS-v1-8-archived"
  "uHOME-server-v1-archived"
  "uHOME-android-app-v1-archived"
  "OBSC-android-app-v1-archived"
  "OBSC-mac-app-v1-archived"
)

ACTIVE_REPOS=(
  "$ROOT/uDOS-core"
  "$ROOT/uDOS-shell"
  "$ROOT/sonic-screwdriver"
  "$ROOT/uDOS-plugin-index"
  "$ROOT/uDOS-wizard"
  "$ROOT/uDOS-gameplay"
  "$ROOT/uDOS-grid"
  "$ROOT/uDOS-empire"
  "$ROOT/uHOME-matter"
  "$ROOT/uHOME-app-android"
  "$ROOT/uHOME-app-ios"
  "$ROOT/uDOS-dev"
  "$ROOT/uDOS-themes"
  "$ROOT/uDOS-thinui"
  "$ROOT/uDOS-docs"
  "$ROOT/uDOS-alpine"
  "$ROOT/uDOS-host"
  "$ROOT/sonic-ventoy"
  "$ROOT/uHOME-client"
  "$ROOT/uHOME-server"
)

PATTERN="uDOS-v1-8-archived|uHOME-server-v1-archived|uHOME-android-app-v1-archived|OBSC-android-app-v1-archived|OBSC-mac-app-v1-archived|$ROOT/[^[:space:]]+-archived"
NAME_PATTERN='uDOS-v1-8-archived|uHOME-server-v1-archived|uHOME-android-app-v1-archived|OBSC-android-app-v1-archived|OBSC-mac-app-v1-archived'
SELF_SCAN_PATH="$REPO_ROOT/scripts/run-v2-1-archive-dependency-audit.sh"

if command -v rg >/dev/null 2>&1; then
  RUNTIME_REFS="$(rg -n -S --hidden \
    --glob '!**/.git/**' \
    --glob '!**/node_modules/**' \
    --glob '!**/docs/**' \
    --glob '!**/@dev/**' \
    --glob '!**/*.md' \
    "$PATTERN" "${ACTIVE_REPOS[@]}" || true)"

  ALL_REFS="$(rg -n -S --hidden \
    --glob '!**/.git/**' \
    --glob '!**/node_modules/**' \
    "$NAME_PATTERN" "${ACTIVE_REPOS[@]}" || true)"
else
  RUNTIME_REFS="$(grep -R -nE "$PATTERN" "${ACTIVE_REPOS[@]}" \
    --exclude-dir=.git \
    --exclude-dir=node_modules \
    --exclude-dir=docs \
    --exclude-dir=@dev \
    --exclude='*.md' 2>/dev/null || true)"

  ALL_REFS="$(grep -R -nE "$NAME_PATTERN" "${ACTIVE_REPOS[@]}" \
    --exclude-dir=.git \
    --exclude-dir=node_modules 2>/dev/null || true)"
fi

# Ignore this audit script's own literal pattern declarations.
RUNTIME_REFS="$(printf '%s\n' "$RUNTIME_REFS" | grep -v "$SELF_SCAN_PATH" || true)"

INVENTORY="$(find "$ROOT" -maxdepth 1 -type d -name '*archived*' -print | sed 's#^.*/##' | sort || true)"
if [[ -z "$INVENTORY" ]]; then
  INVENTORY="(none found)"
fi

RUNTIME_STATUS="PASS"
if [[ -n "$RUNTIME_REFS" ]]; then
  RUNTIME_STATUS="FAIL"
fi

{
  echo "# v2.1 Archive Dependency Audit"
  echo
  echo "Generated: $TIMESTAMP UTC"
  echo
  echo "## Runtime Dependency Result"
  echo
  echo "- status: $RUNTIME_STATUS"
  echo "- rule: no active v2.1 runtime/config dependency on archived folders"
  echo
  echo "## Archive Inventory (Code Root)"
  echo
  while IFS= read -r line; do
    [[ -n "$line" ]] && echo "- $line"
  done <<< "$INVENTORY"
  echo
  echo "## Target Archive Folder Presence"
  echo
  echo "| Folder | Exists |"
  echo "| --- | --- |"
  for folder in "${TARGET_ARCHIVES[@]}"; do
    if [[ -d "$ROOT/$folder" ]]; then
      echo "| $folder | yes |"
    else
      echo "| $folder | no |"
    fi
  done
  echo
  echo "## Runtime/Config Surface Matches (docs and @dev excluded)"
  echo
  if [[ -n "$RUNTIME_REFS" ]]; then
    echo '```'
    echo "$RUNTIME_REFS"
    echo '```'
  else
    echo "none"
  fi
  echo
  echo "## All References (for classification)"
  echo
  if [[ -n "$ALL_REFS" ]]; then
    echo '```'
    echo "$ALL_REFS"
    echo '```'
  else
    echo "none"
  fi
} > "$REPORT_FILE"

echo "Archive dependency audit result: $RUNTIME_STATUS"
echo "Wrote $REPORT_FILE"

if [[ "$RUNTIME_STATUS" == "FAIL" ]]; then
  exit 1
fi
