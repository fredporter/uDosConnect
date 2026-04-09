# Display modes (Workspace 06)

Canonical inventory for how uDOS surfaces present guided and narrative UI. Theme tokens and adapters in this repo map to these modes; deeper GUI ownership stays in `docs/gui-system-family-contract.md` (uDOS-dev).

## Modes

| Mode | Typical surface | Owner repo | Themes adapter lane | Notes |
| --- | --- | --- | --- | --- |
| **Browser rich** | SvelteKit / web shell | `uDOS-workspace` | `browser-default` | Layout, hero, panels, Tailwind prose bridge; loads `theme-tokens.json` → `--ws-*` via `apps/web/src/lib/theme/browserDefaultShell.ts`. Sync copy: `bash uDOS-themes/scripts/sync-theme-tokens-to-workspace.sh` from family root. |
| **ThinUI takeover** | Full-screen terminal frame | `uDOS-thinui` | `thinui-default` | Theme packs, teletext / retro loaders |
| **TUI guided** | Full-viewport shell flows | `uDOS-shell` | `tui-default` | Step prompts, choice lists, progress line |
| **Workflow board** | Lanes / tasks | `uDOS-wizard` (and workspace) | `workflow-default` | Binder-adjacent story, status columns |
| **Publish prose** | Docs / email HTML | `uDOS-docs`, workspace publish | `publish-tailwind-prose` | `prose` classes, email-safe variant |
| **Forms step** | GTX step-by-step | Cross-surface | `forms-gtx-step` | Shared step model; renderers per surface |

## Rules

1. **Guided full-viewport** flows (setup wizards, installers) should use the **forms** adapter vocabulary (`examples/gtx-form-flow.json`) so browser, ThinUI, and TUI renderers stay aligned.
2. **Skins** override tone and loader hooks on top of a **base theme** from the theme registry; load via `src/load-skin.mjs` (see `registry/skin-registry.json`).
3. **Primitives** required across surfaces are listed in `examples/cross-surface-rendering-matrix.json`; each maps to a default adapter id per surface.

## Related

- `examples/cross-surface-rendering-matrix.json`
- `docs/architecture.md`
- `docs/theme-token-standard.md`
- `docs/step-form-presentation-rules.md`
- `docs/adapter-skin-registry-plan.md`
- `docs/integration-thinui-workflow-prose-gtx.md`
- `uDOS-thinui/docs/themes-sibling-bridge.md` (runtime vs registry boundary)
- `uDOS-shell/docs/tui-themes-parity.md` (TUI ↔ themes adapters)
- `uDOS-dev/docs/gui-system-family-contract.md`
- `uDOS-dev/docs/cursor-focused-workspaces.md` § Workspace 06
- `uDOS-docs/docs/themes-and-display-modes.md` (reader hub)
