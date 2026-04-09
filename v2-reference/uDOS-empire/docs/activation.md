# uDOS-empire Activation

## Purpose

This document marks strict local-lab completion posture for `uDOS-empire`.

The activation goal is to keep WordPress-plugin operations fully checkable and
operational without broadening ownership beyond:

- WordPress plugin architecture and admin surfaces
- WordPress-backed CRM record handling
- local import, dedupe, enhancement, and notes workflows
- WordPress-centred email and contact operations
- markdown-to-WordPress publish lane and workflow automation proofs

## Activated Surfaces

- `src/` as the plugin-owned source and stable contract lane
- `scripts/run-empire-checks.sh` as the repo validation entrypoint
- `tests/` as the workflow contract validation lane
- `config/` as the checked-in operational config lane
- `docs/wordpress-plugin-architecture.md` as the public architecture anchor
- `docs/wordpress-plugin-data-model.md` as the public data-model anchor
- `examples/basic-empire-flow.json` as the baseline workflow example

## Current Validation Contract

Run:

```bash
bash scripts/run-empire-strict-completion-gate.sh
```

This gate:

- verifies the required repo entry surfaces exist
- checks that the sample workflow contract is structurally valid
- rejects private local-root path leakage in tracked repo docs and scripts
- validates markdown-to-WordPress publishing contract and data safety smoke
- enforces stable plugin manifest posture

## Boundaries

This activation does not move ownership into `uDOS-empire` for:

- canonical runtime semantics
- host-owned Git or GitHub execution
- the central repo store
- Ubuntu runtime service ownership

Legacy Google, HubSpot, and webhook materials remain adapter surfaces only and
are not the default identity of this repo.
