# Themes Docs

`/docs` is the stable reference lane for `uDOS-themes`.

Use it for:

- theme repo purpose and ownership
- activation and setup
- stable theme, token, and adapter references
- examples and boundary rules

Use `/wiki` for beginner-friendly learning units and quick practical guides.

**Family checkout:** [`uDOS-dev/docs/family-documentation-layout.md`](../../uDOS-dev/docs/family-documentation-layout.md).

## Start Here

- `getting-started.md`
- `activation.md`
- `architecture.md`
- `boundary.md`
- `examples.md`

## Classic Modern MVP 0.1

Pack index and **`--cm-*`** token spec: **`uDOS-docs/docs/classic-modern-mvp-0.1/README.md`** (sibling repo). ThinUI consumes the palette today as theme id **`udos-default`** (`uDOS-thinui/src/runtime/default-theme-resolver.ts`). This repo owns future CSS/token export and ThinUI skin adapters (`src/adapters/thinui/`).

## Core References

- `v2.0.1-theme-foundation.md`
- `v2.2.1-integrated-design-system.md`
- `theme-upstream-index.md` (third-party repos, demos, fork targets, teletext)
- `theme-fork-rollout.md` (fork → submodule → adapter checklist)
- `display-modes.md` — surface vocabulary (Workspace 06)
- `theme-token-standard.md` — token schema and consumers
- `step-form-presentation-rules.md` — GTX / wizard interaction rules
- `adapter-skin-registry-plan.md` — registries and rollout phases
- `integration-thinui-workflow-prose-gtx.md` — cross-repo integration plan

## Rule

Keep stable reference here. Keep next-round planning in `@dev/`.
