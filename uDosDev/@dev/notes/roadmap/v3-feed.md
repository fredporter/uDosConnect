# v3 Feed (Roadmap + Backlog)

Format:

`YYYY-MM-DD | status | area | summary | evidence`

---

2026-04-09 | done | udos-v3-backlog | Closed v3.0.3 dev backlog: feed `metadata.surfaceRef`, `feed.received` payload, ThinUI field; BACKLOG/ROADMAP/MILESTONES M8; `docs/media/` placeholder. | `uDOS-v3/docs/BACKLOG.md`, `uDOS-v3/apps/host/src/feed-metadata.ts`, `uDOS-v3/docs/MILESTONES.md`

2026-04-09 | done | docs-migration | Marked complete: v2 dev docs archived under `uDOS-dev/docs/archive/v2/`; v3-only forward roadmap. | `uDOS-dev/docs/archive/v2/README.md` (and sibling files)

2026-04-09 | done | docs-structure | Marked complete: v2 historical docs under `uDOS-docs/docs/v2/` with README. | `uDOS-docs/docs/v2/README.md`, `uDOS-docs/docs/v2/classic-modern-mvp-0.1/`

2026-04-08 | done | startup | Hardened v3 launcher flow to prompt for missing prerequisites (npm, Docker) instead of hard-fail. | `uDOS-v3/scripts/launch-dev.mjs`, `uDOS-v3/scripts/launch-with-wp.mjs`, `uDOS-v3/scripts/check-prereqs.mjs`

2026-04-08 | done | thinui-dev | Bound ThinUI dev server for reliable local access and improved launcher URL handling. | `uDOS-v3/apps/thinui/vite.config.ts`, `uDOS-v3/scripts/launch-dev.mjs`

2026-04-08 | done | workspace | Unified active workspace around v3 + UniversalSurfaceXD + themes. | `uDOS-v3.code-workspace`

2026-04-08 | done | governance | Archived v2 workspace JSON manifests under `uDOS-dev/workspaces/archive/v2` and updated references. | `uDOS-dev/workspaces/archive/v2/README.md`, `uDOS-dev/workspaces/README.md`

---

## Notes

- Add one line per material change.
- Keep newest entries at top.
- Link to files or reports, not broad folders when possible.

- Gate policy for any future named family plan: `docs/next-family-plan-gate.md`.
