# uDOS v2 Contract Enforcement

## Purpose

This document defines the first enforceable checks derived from the uDOS v2
family boundary and dependency contract.

The goal is not to infer every architectural mistake automatically. The goal is
to catch the highest-signal contract drift early and consistently.

## Current Checks

`scripts/run-contract-enforcement.sh` currently enforces:

- required public README sections:
  - `## Purpose`
  - `## Ownership`
  - `## Non-Goals`
- required public repo doc entrypoints:
  - `docs/architecture.md`
  - `docs/boundary.md`
  - `docs/getting-started.md`
- no private OMD repo names in public implementation surfaces
- no consumer-repo dependency-style references in `uDOS-core` source and packaging surfaces

## Implementation Surfaces

These checks target code, config, packaging, and runtime lanes rather than
general documentation. Docs and public contract metadata may mention repo names
when describing boundaries, owners, or consumers.

For `uDOS-core`, the consumer-repo guard is intentionally narrower than a raw
string scan. It targets dependency-style sibling-repo coupling such as direct
workspace path references in source or packaging surfaces.

## Binder spine payload (v1)

Schema-level contract for workspace-facing binder JSON lives in
`docs/binder-spine-payload.md` with `@pytest.mark.contract` coverage in
`tests/test_binder_spine_contract.py`. This is separate from
`scripts/run-contract-enforcement.sh` (repo README and boundary guards).

## Command

Run:

```bash
scripts/run-contract-enforcement.sh
```

To validate a single repo explicitly:

```bash
scripts/run-contract-enforcement.sh uDOS-shell /path/to/uDOS-shell
```

## Current Limits

- this does not replace human review
- this does not infer semantic ownership from arbitrary prose
- this is a first-pass guardrail, not a complete dependency parser

## Next Expansion

Future tranches should add:

- stronger dependency metadata checks
- cross-repo acknowledgment rules for contract-owner changes
- packaging-owner wording checks in public docs
