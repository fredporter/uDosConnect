# Scripts

`scripts/` is the checked-in validation lane for `uDOS-themes`.

Current script surfaces include:

- `run-theme-checks.sh` for repo activation validation
- `init-vendor-forks.sh` for `git submodule update --init` on `vendor/forks/*` (fredporter theme forks)
- `smoke-adapters.mjs` for browser/TUI/workflow/publish/forms smoke coverage
- `sync-theme-tokens-to-workspace.sh` — copy `src/theme-tokens.json` to `uDOS-workspace/apps/web/src/lib/theme/theme-tokens.json` (run from a checkout where both repos sit next to each other under the family root)
- `sync-publish-prose-preset-to-workspace.sh` — copy `src/adapters/publish/tailwind-prose-preset.json` to `uDOS-workspace/apps/web/src/lib/theme/publish/tailwind-prose-preset.json`
- `sync-publish-prose-preset-to-package.sh` — copy the same file to `packages/tailwind-prose-preset/tailwind-prose-preset.json` for `file:` / local npm consumption
- `sync-gtx-step-task-map-to-wizard.sh` — copy `src/adapters/workflow/gtx-step-task-map.json` to `uDOS-wizard/apps/surface-ui/src/lib/contracts/gtx-step-task-map.json`
- `demo-gtx-form-tui.mjs` — shell CLI demo: prints `renderTuiFormStep` lines for **`examples/gtx-form-flow.json`** (options: `--step`, `--step-id`, `--json`, `--all`). Run from repo root: `node scripts/demo-gtx-form-tui.mjs`

Boundary rule:

- keep lightweight theme checks here
- keep behavior and runtime concerns in the owning repos
- keep contract validation aligned with the registries under `registry/`
