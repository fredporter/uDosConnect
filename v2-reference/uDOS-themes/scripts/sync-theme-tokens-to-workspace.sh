#!/usr/bin/env bash
# Copy canonical theme-tokens.json into uDOS-workspace web app (sibling under family root).
set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
THEMES_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAMILY_ROOT="$(cd "$THEMES_ROOT/.." && pwd)"

SRC="$THEMES_ROOT/src/theme-tokens.json"
DST="$FAMILY_ROOT/uDOS-workspace/apps/web/src/lib/theme/theme-tokens.json"

if [[ ! -f "$SRC" ]]; then
  echo "[sync-theme-tokens-to-workspace] missing source: $SRC" >&2
  exit 1
fi
if [[ ! -d "$FAMILY_ROOT/uDOS-workspace" ]]; then
  echo "[sync-theme-tokens-to-workspace] uDOS-workspace not found at $FAMILY_ROOT/uDOS-workspace" >&2
  exit 1
fi

mkdir -p "$(dirname "$DST")"
cp "$SRC" "$DST"
echo "[sync-theme-tokens-to-workspace] $SRC -> $DST"
