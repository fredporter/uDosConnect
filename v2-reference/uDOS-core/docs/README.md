# Core Docs

`/docs` is the stable reference lane for `uDOS-core`.

Use it for:

- architecture and ownership boundaries
- activation and setup
- contracts and deterministic runtime rules
- examples and contributor guidance

Use `/wiki` for learning material and quick practical education.

**Family checkout:** where `docs/` vs `@dev/` vs `wiki/` sit across repos —
[`uDOS-dev/docs/family-documentation-layout.md`](../../uDOS-dev/docs/family-documentation-layout.md).

## Start Here

- `getting-started.md`
- `architecture.md`
- `boundary.md`
- `activation.md`
- `examples.md`

## Reference Docs

- `wizard-surface-delegation-boundary.md` (Wizard/Surface vs Ubuntu host; Core contract field semantics)
- `family-boundary.md`
- `dependency-matrix.md`
- `contract-enforcement.md`
- `repo-requirements.md`
- `logging-policy.md`
- `feeds-and-spool.md`
- `mcp-event-surface.md`
- contract and queue references such as:
  - `MCP-SCHEMA.md`
  - `DEFERRED-QUEUE-CONTRACT.md`
  - `OK-AGENT-CORE-CONTRACT.md`
  - `AUTONOMY-CLASSES.md`

## Rule

Keep one public doc per concept. If two docs say the same thing, merge them or
compost one of them.
