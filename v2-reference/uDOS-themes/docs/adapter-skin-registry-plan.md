# Adapter and skin registry plan

How `registry/theme-registry.json`, `registry/adapter-registry.json`, and `registry/skin-registry.json` relate to consumers and how to extend them safely.

## Purpose

| Registry | Contents |
| --- | --- |
| **theme-registry** | `theme_id` → JSON theme file (`theme_ref`) — logical bundles (browser-default, thinui-c64, …). |
| **adapter-registry** | `adapter_id` → surface + `contract_ref` (JSON or TS path for ThinUI lane). |
| **skin-registry** | `skin_id` → `base_theme` + `skin_ref` JSON overrides (tone, loader hints, accents). |

Validation: `scripts/run-theme-checks.sh` enforces required ids and file paths.

## Consumption order (recommended)

1. Resolve **theme** for the surface (from app config or shell map).
2. If a **skin** is selected, call **`loadSkinBundle(skinId)`** in `src/load-skin.mjs` to merge skin overrides with the base theme payload.
3. Pick **adapter** from `primitive_surface_map` in `examples/cross-surface-rendering-matrix.json` or from the theme’s `adapters` list in theme JSON.

## Rollout phases

| Phase | Status | Work |
| --- | --- | --- |
| **A** — Registries + contracts | Done | JSON registries, adapter contracts, Node adapter modules + smoke. |
| **B** — Skin loader | Done | `loadSkinBundle`, smoke in `scripts/smoke-adapters.mjs`. |
| **C** — ThinUI hydration | Next | Map registry theme ids + skin loader hints into `uDOS-thinui` resolver without forking the runtime loop (see ThinUI bridge doc). |
| **D** — Workspace / Wizard | In progress | Workspace consumes `theme-tokens.json`; Wizard surfaces should reuse adapter ids for Thin GUI links (Core maps). |
| **E** — Publish / Tailwind | Next | Ship a shared prose class list or CSS package consumed by workspace and static publish pipelines. |

## Adding a new theme

1. Add `src/themes/<id>.json` and an entry in `registry/theme-registry.json`.
2. Ensure required adapters exist or reference existing `adapter_id`s.
3. Run `bash scripts/run-theme-checks.sh`.

## Adding a new skin

1. Add `src/skins/<id>.json` with `skin_id` and `overrides`.
2. Point `base_theme` at an existing `theme_id`.
3. Register in `registry/skin-registry.json`.

## Related

- `registry/README.md`
- `docs/theme-token-standard.md`
- `docs/integration-thinui-workflow-prose-gtx.md`
