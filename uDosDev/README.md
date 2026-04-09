# uDosDev

## Purpose

Shared public development culture, contributor intake, education, and maintenance workflows for the uDos family (governance — not runtime code).

## Ownership

- `@dev/` intake and pathway structure
- automation support
- courses and contributor learning
- shared maintenance notes and scripts

## Non-Goals

- canonical runtime ownership
- provider transport ownership
- private product ownership

## Spine

- `@dev/requests/`
- `@dev/submissions/`
- `@dev/pathways/`
- `@dev/notes/`
- `automation/`
- `courses/`
- `docs/`
- `scripts/`

## Local Development

Use this repo to coordinate work across the family without turning it into a monolith.
The active `v2.3` lane now uses a workflow-backed schedule model where
scheduled work refreshes evidence and manual work owns final binder lifecycle
transitions.

## Governance Surfaces

- `docs/family-workflow.md`
- `docs/repo-sync-policy.md`
- `docs/repo-family-map.md`
- `docs/conformance-sweep.md`
- `docs/public-structure-sweep.md`
- `@dev/notes/roadmap/v2-family-roadmap.md`
- `docs/development-roadmap.md`
- `docs/roadmap-workflow.md`
- `docs/workflow-schedule-operations.md`
- `docs/release-surfaces.md`
- `docs/release-matrix.md`
- `docs/release-backlog.md`
- `docs/versioning-policy.md`
- `docs/activation.md`
- `automation/`
- `.github/workflows/`

## Family Relation

**uDosDev** defines development practice, not runtime semantics. **Local planning paths:** [`../docs/family-workspace-layout.md`](../docs/family-workspace-layout.md).

## Activation

The v2 repo activation path is documented in `docs/activation.md`.

Run the current repo validation entrypoint with:

```bash
scripts/run-dev-checks.sh
```
