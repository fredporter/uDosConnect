# Theme and token standard (v2.2.1)

Canonical machine and human contract for cross-surface colours, typography, spacing, and related categories used by adapters and skins.

## Authoritative files

| Role | Path |
| --- | --- |
| Full token bundle (browser-default baseline) | `src/theme-tokens.json` |
| Category schema | `src/tokens/base-tokens.json` (`token_categories`) |
| Shell / thin mapping hints | `src/shell-theme-map.json`, `src/publishing-theme-map.json` |
| Consumer copy (workspace web) | `uDOS-workspace/apps/web/src/lib/theme/theme-tokens.json` — sync via `scripts/sync-theme-tokens-to-workspace.sh` |

## Version

- **`version`** field on `theme-tokens.json` and registry JSON: **`v2.2.1`** until a breaking family bump is declared.
- Themes, adapters, and skins in `registry/*.json` must agree on this version string where the schema requires it.

## Token categories

`theme-tokens.json` → `tokens` object must include every category listed in `src/tokens/base-tokens.json`: `color`, `typography`, `spacing`, `radius`, `border`, `shadow`, `motion`, `density`, `surface`, `state`, `feedback`, `focus`, `input`.

## Naming rules

1. **Semantic keys** inside categories (e.g. `color.accent`, `surface.panel`) — not raw CSS property names at the top level.
2. **Hex colours** as `#RRGGBB` unless a field explicitly allows gradients or CSS strings (e.g. `border.default`).
3. **New categories** require an update to `base-tokens.json` and `scripts/run-theme-checks.sh` validation logic if the contract tightens.

## Consumers

- **Workspace web:** maps tokens to `--ws-*` CSS variables (`apps/web/src/lib/theme/browserDefaultShell.ts` in `uDOS-workspace`).
- **Browser adapter:** `src/adapters/browser/index.mjs` (aligned palette / prose class hints).
- **ThinUI:** runtime resolver in `uDOS-thinui`; registries and skins in this repo are the vocabulary source for future hydration.

## Related

- `docs/display-modes.md`
- `docs/adapter-skin-registry-plan.md`
- `docs/integration-thinui-workflow-prose-gtx.md`
