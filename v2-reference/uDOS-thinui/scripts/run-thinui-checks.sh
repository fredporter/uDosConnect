#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

require_file() {
  if [ ! -f "$1" ]; then
    echo "missing required file: $1" >&2
    exit 1
  fi
}

cd "$REPO_ROOT"

require_file "$REPO_ROOT/README.md"
require_file "$REPO_ROOT/docs/spec.md"
require_file "$REPO_ROOT/docs/thinui-boot-launch-sequence.md"
require_file "$REPO_ROOT/docs/themes-sibling-bridge.md"
require_file "$REPO_ROOT/scripts/print-themes-skin.mjs"
require_file "$REPO_ROOT/src/runtime/bootstrap.ts"
require_file "$REPO_ROOT/src/runtime/default-theme-resolver.ts"
require_file "$REPO_ROOT/src/views/boot-loader.ts"
require_file "$REPO_ROOT/src/views/teletext-display.ts"
require_file "$REPO_ROOT/src/views/home-launcher.ts"
require_file "$REPO_ROOT/scripts/README.md"
require_file "$REPO_ROOT/scripts/demo-thinui.js"
require_file "$REPO_ROOT/package.json"
require_file "$REPO_ROOT/scripts/demo-thinui-run.ts"
require_file "$REPO_ROOT/demo/theme-fonts.css"
require_file "$REPO_ROOT/demo/teletext-newsdesk-html.ts"

npm install --silent
npm run typecheck
npm run validate:binder-spine

SURFACE_REPO="$(cd "$REPO_ROOT/.." && pwd)/uDOS-surface"
if [[ -f "$SURFACE_REPO/scripts/validate_surface_profiles.py" ]]; then
  python3 "$SURFACE_REPO/scripts/validate_surface_profiles.py" --root "$SURFACE_REPO"
fi

npm run demo -- --theme thinui-c64 >/dev/null
npm run demo -- --theme thinui-nes-sonic >/dev/null
npm run demo -- --theme thinui-teletext --view teletext-display >/dev/null
npm run demo:tour >/dev/null
npm run demo -- --profile ubuntu-gnome >/dev/null
if [[ -f "$SURFACE_REPO/profiles/ubuntu-gnome/surface.json" ]]; then
  npm run demo -- --surface-profile-file "$SURFACE_REPO/profiles/ubuntu-gnome/surface.json" >/dev/null
fi
npm run build:demo >/dev/null

node "$REPO_ROOT/scripts/demo-thinui.js" --theme thinui-c64 >/dev/null
node "$REPO_ROOT/scripts/demo-thinui.js" --theme thinui-nes-sonic >/dev/null
node "$REPO_ROOT/scripts/demo-thinui.js" --theme thinui-teletext --view teletext-display >/dev/null

echo "uDOS-thinui checks passed"
