#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
THEMES_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SRC="$THEMES_ROOT/src/adapters/publish/tailwind-prose-preset.json"
DST="$THEMES_ROOT/packages/tailwind-prose-preset/tailwind-prose-preset.json"

if [ ! -f "$SRC" ]; then
  echo "missing source preset: $SRC" >&2
  exit 1
fi

mkdir -p "$(dirname "$DST")"
cp "$SRC" "$DST"
echo "synced: $SRC -> $DST"
