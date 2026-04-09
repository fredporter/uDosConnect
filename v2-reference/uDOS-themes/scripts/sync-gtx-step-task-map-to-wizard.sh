#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
THEMES_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAMILY_ROOT="$(cd "$THEMES_ROOT/.." && pwd)"
WIZARD_ROOT="${UDOS_WIZARD_ROOT:-$FAMILY_ROOT/uDOS-wizard}"
SRC="$THEMES_ROOT/src/adapters/workflow/gtx-step-task-map.json"
DST="$WIZARD_ROOT/apps/surface-ui/src/lib/contracts/gtx-step-task-map.json"

if [ ! -f "$SRC" ]; then
  echo "missing source map: $SRC" >&2
  exit 1
fi

if [ ! -d "$(dirname "$DST")" ]; then
  echo "uDOS-wizard contracts path missing: $(dirname "$DST")" >&2
  exit 1
fi

mkdir -p "$(dirname "$DST")"
cp "$SRC" "$DST"
echo "synced: $SRC -> $DST"
