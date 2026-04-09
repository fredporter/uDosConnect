# Data safety and rollback

## Purpose

Define baseline safety posture for WordPress-backed Empire workflows.

## Safety rules

- Every import/publish workflow must support **dry-run first**.
- Write paths must include an **audit event** in local runtime state.
- Backup snapshots must be restorable without remote dependencies.
- Migration changes must be reversible or provide deterministic rollback steps.

## Minimal local backup shape

- `contacts.json` (or equivalent extracted record envelope)
- `activity-log.json`
- `publish-log.json`
- `manifest.json` with snapshot metadata and source versions

## Rollback sequence

1. Pause write workflows.
2. Restore latest verified snapshot to local state.
3. Run integrity checks on restored shape.
4. Resume workflows only if integrity checks pass.

## Validation

Run:

```bash
python3 scripts/smoke/data_safety_smoke.py --json
```

Expected: snapshot creation, restore, and integrity verification all pass.
