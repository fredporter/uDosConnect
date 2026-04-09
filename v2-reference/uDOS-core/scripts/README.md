# `scripts/`

This lane holds operational helpers for validating and working on `uDOS-core`.

## Current Scripts

- `run-green-proof.sh`
  - runs **only** `pytest -m green_proof` (logs/feeds/spool minimal gate; see `docs/feeds-and-spool.md` and `uDOS-dev/docs/pr-checklist.md`)

- `run-core-checks.sh`
  - runs the **full** core test suite from the repo root
  - acts as the default validation entrypoint for local contract work
  - binder spine v1: `pytest tests/test_binder_spine_contract.py` (needs `jsonschema` and `referencing` in the environment; see `docs/binder-spine-payload.md`)

- `run-contract-enforcement.sh`
  - validates the first enforceable family boundary rules derived from `uDOS-core`
  - checks public repo README sections and boundary-safe implementation surfaces
  - acts as the local contract-enforcement entrypoint

Keep scripts small, explicit, and repo-relative.
