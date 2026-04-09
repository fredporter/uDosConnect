# uDOS-dev Activation

## Purpose

This document marks the first active implementation tranche for `uDOS-dev`.

The activation goal is to make `uDOS-dev` explicitly runnable as the family
workflow and governance workspace without broadening ownership beyond:

- `@dev` intake and pathway structure
- roadmap and binder workflow tracking
- family conformance and structure sweeps
- shared automation and contributor education

## Activated Surfaces

- `@dev/` as the live intake, submission, pathway, and notes lane
- `scripts/run-dev-checks.sh` as the repo validation entrypoint
- `scripts/run-roadmap-status.sh` and sweep scripts as workflow support lanes
- `automation/` as the shared governance automation lane
- `docs/` as the development-practice teaching lane
- `docs/workflow-schedule-operations.md` as the active schedule/binder model

## Current Validation Contract

Run:

```bash
scripts/run-dev-checks.sh
```

This command:

- verifies the required `uDOS-dev` repo surfaces exist
- checks the roadmap workflow entry surfaces
- runs the Round C workflow-backed schedule demo
- regenerates the roadmap status report

## Boundaries

This activation does not move ownership into `uDOS-dev` for:

- canonical runtime semantics
- shell interaction behavior
- provider transport or control-plane logic
- private product behavior
