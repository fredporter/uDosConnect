#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

require_file() {
  local path="$1"
  if [[ ! -f "$path" ]]; then
    echo "[uDOS-workspace] missing required file: $path" >&2
    exit 1
  fi
}

require_dir() {
  local path="$1"
  if [[ ! -d "$path" ]]; then
    echo "[uDOS-workspace] missing required directory: $path" >&2
    exit 1
  fi
}

require_file "$REPO_ROOT/README.md"
require_file "$REPO_ROOT/VERSION"
require_file "$REPO_ROOT/docs/activation.md"
require_file "$REPO_ROOT/docs/architecture/workspace-v2.md"
require_file "$REPO_ROOT/docs/contracts/step-2-binder-compiler-schema.md"
require_file "$REPO_ROOT/docs/contracts/step-3-spatial-layer-system.md"
require_file "$REPO_ROOT/docs/workspace-binder-spine.md"
require_file "$REPO_ROOT/apps/web/package.json"
require_file "$REPO_ROOT/apps/web/svelte.config.js"
require_file "$REPO_ROOT/apps/web/tsconfig.json"
require_file "$REPO_ROOT/apps/web/vite.config.ts"
require_file "$REPO_ROOT/apps/web/src/app.html"
require_file "$REPO_ROOT/apps/web/src/routes/+page.svelte"
require_file "$REPO_ROOT/apps/web/src/lib/theme/browserDefaultShell.ts"
require_file "$REPO_ROOT/apps/web/src/lib/theme/theme-tokens.json"
require_file "$REPO_ROOT/apps/web/src/lib/theme/README.md"
require_file "$REPO_ROOT/packages/workspace-core/src/contracts.ts"
require_file "$REPO_ROOT/packages/compiler-ui/src/manifest.ts"
require_file "$REPO_ROOT/examples/binders/footloose-adelaide-launch.md"
require_file "$REPO_ROOT/examples/compile/footloose-dashboard.yaml"
require_dir "$REPO_ROOT/@dev/requests"
require_dir "$REPO_ROOT/@dev/submissions"
require_dir "$REPO_ROOT/tests/contracts"

echo "[uDOS-workspace] required repo surfaces present"

if command -v npm >/dev/null 2>&1 && [[ -d "$REPO_ROOT/node_modules" ]]; then
  echo "[uDOS-workspace] running web app check"
  (cd "$REPO_ROOT/apps/web" && npx svelte-kit sync >/dev/null && npm run check)
elif command -v pnpm >/dev/null 2>&1 && [[ -d "$REPO_ROOT/node_modules" ]]; then
  echo "[uDOS-workspace] running pnpm check"
  (cd "$REPO_ROOT" && pnpm --filter @udos-workspace/web check)
else
  echo "[uDOS-workspace] skipping app check (workspace dependencies unavailable)"
fi
