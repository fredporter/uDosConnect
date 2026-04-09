#!/usr/bin/env bash
# One-shot bootstrap for the ThinUI + uDOS-themes GUI lane (sibling repos under the family root).
# Safe to re-run: submodules sync; npm install is idempotent.
set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEV_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAMILY_ROOT="$(cd "$DEV_ROOT/.." && pwd)"

THEMES_ROOT="$FAMILY_ROOT/uDOS-themes"
THINUI_ROOT="$FAMILY_ROOT/uDOS-thinui"

if [[ -f "$THEMES_ROOT/scripts/init-vendor-forks.sh" ]]; then
  echo "[install-thinui-themes-lane] uDOS-themes: vendor fork submodules"
  bash "$THEMES_ROOT/scripts/init-vendor-forks.sh"
elif [[ -d "$THEMES_ROOT" ]]; then
  echo "[install-thinui-themes-lane] skip: $THEMES_ROOT/scripts/init-vendor-forks.sh not found" >&2
else
  echo "[install-thinui-themes-lane] skip: uDOS-themes not at $THEMES_ROOT"
fi

if [[ -f "$THINUI_ROOT/package.json" ]]; then
  echo "[install-thinui-themes-lane] uDOS-thinui: npm install"
  (cd "$THINUI_ROOT" && npm install)
else
  echo "[install-thinui-themes-lane] skip: uDOS-thinui not at $THINUI_ROOT"
fi

echo "[install-thinui-themes-lane] done (optional: cd uDOS-thinui && bash scripts/run-thinui-checks.sh)"
