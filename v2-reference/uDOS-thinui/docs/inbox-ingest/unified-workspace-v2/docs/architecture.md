# ThinUI unified workspace — architecture (short)

## Ownership

- **ThinUI (`uDOS-thinui`)** — Shell: sidebar, topbar, command palette, main mode router, detail drawer, theme tokens for the workspace demo. View-only scaffold today; persistence and compile semantics stay out of the shell.
- **Core / workspace contracts (`uDOS-core`, binders)** — Source of truth for `#binder` identity, workflow routing, and persistence. The demo uses `parseDemoBinderJson` + static JSON until a real bridge exists.
- **Empire (`uDOS-empire`)** — Social/campaign domain when you replace the Mixpost-style queue with live data.
- **Wizard / automation** — Scheduled execution and tool connectivity; surfaces as Ops/automation panels later.

## Demo model

`WorkspaceItem` (in `uDOS-thinui/src/workspace/types.ts`) carries facets used by different modes: `status`, `markdown`, `dueAt` / `scheduledAt`, `platforms` / `postState` / `campaignId`, `recordType` / `fields`. The same `id` appears in every mode so the “one object, many views” claim stays visible.

## External references (UX only)

AppFlowy-like board/table, Outline-like docs tree, Cal/Socioboard-like calendar grouping, Mixpost-like social cards, Budibase-like ops fields, Typo-like markdown lane — **patterns only**, not runtime forks of those products.

## Next integration steps

1. Replace static JSON with a core-provided binder snapshot (or stream).
2. Make Editor mode read/write through the bridge with compile/preview boundaries.
3. Add a dedicated Dashboard mode (metrics cards) if not folded into Ops.
4. Empire adapter for social queue and campaign metadata.
