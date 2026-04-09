# uDOS-core Activation

## Purpose

This document marks the first active implementation tranche for `uDOS-core`.

The activation goal is to make Core explicitly runnable and teachable as the
semantic center of the family without broadening ownership beyond:

- deterministic runtime contracts
- action and workflow semantics
- binder and compile surfaces
- vault and plugin capability contracts
- family boundary enforcement owned by Core

## Activated Surfaces

- `contracts/` and `schemas/` as the contract-first semantic lane
- `udos_core/` as the active runtime implementation package
- `udos_core/dev_config.py` as the shared local development config lane
- `udos_core/local_state.py` as the shared local state lane
- `scripts/run-core-checks.sh` as the runtime validation entrypoint
- `scripts/run-contract-enforcement.sh` as the family-boundary validation lane
- `tests/` as the core semantic test lane

## Current Validation Contract

Run:

```bash
scripts/run-core-checks.sh
scripts/run-contract-enforcement.sh
```

These commands:

- run the current core test suite
- enforce the first family boundary and dependency rules owned by Core

## Boundaries

This activation does not move ownership into `uDOS-core` for:

- provider or API ownership
- network transport or MCP bridging
- shell UX ownership
- persistent home/server service ownership
