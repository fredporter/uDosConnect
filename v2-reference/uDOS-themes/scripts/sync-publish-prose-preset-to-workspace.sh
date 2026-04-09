#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
THEMES_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAMILY_ROOT="$(cd "$THEMES_ROOT/.." && pwd)"
WORKSPACE_ROOT="${UDOS_WORKSPACE_ROOT:-$FAMILY_ROOT/uDOS-workspace}"
SRC="$THEMES_ROOT/src/adapters/publish/tailwind-prose-preset.json"
DST="$WORKSPACE_ROOT/apps/web/src/lib/theme/publish/tailwind-prose-preset.json"

if [ ! -f "$SRC" ]; then
  echo "missing source preset: $SRC" >&2
  exit 1
fi

if [ ! -d "$WORKSPACE_ROOT/apps/web/src/lib/theme" ]; then
  echo "uDOS-workspace theme path missing: $WORKSPACE_ROOT/apps/web/src/lib/theme" >&2
  exit 1
fi

mkdir -p "$(dirname "$DST")"
cp "$SRC" "$DST"
echo "synced: $SRC -> $DST"
