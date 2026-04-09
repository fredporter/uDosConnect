# Workspace and binder spine v1 (consumption)

**Owner:** `uDOS-workspace` (presentation lane)  
**Canonical schema:** `uDOS-core` `schemas/binder-spine-payload.v1.schema.json` and `docs/binder-spine-payload.md`  
**ThinUI bridge:** `uDOS-dev` `docs/thinui-unified-workspace-entry.md`

## Role

`uDOS-workspace` **consumes** binder spine JSON for operator UX (counts, record-type mix, inspector copy). It does **not** own persistence, compile execution, or the canonical schema.

The web app validates a **sample** spine payload at module load (`apps/web/src/lib/data/sample.ts`) using the same structural rules as Core v1 (`apps/web/src/lib/spine/binder-spine-v1.ts`). Runtime fetch/API wiring is deferred; the operator snapshot reports `source: sample-spine-v1`.

## Related

- `v2.6` Round C (`#binder/workspace-v2-6-binder-consumption`) — `@dev/notes/roadmap/v2.6-rounds.md`
