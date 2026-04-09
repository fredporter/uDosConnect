# uDOS-grid Activation

Grid is active as the family spatial reference lane.

## Active Surfaces

- `contracts/` for spatial contracts
- `seed/` for checked-in seed registries
- `tests/` for validation
- `config/` for checked-in config examples
- `examples/basic-place-record.json` for the smallest place example
- `scripts/run-grid-checks.sh` for repo validation

## Validation Contract

Run:

```bash
bash scripts/run-grid-checks.sh
```

This path validates the core repo surfaces and rejects broken sample data or
tracked private-path leakage.

## GitHub Actions

On **push** and **pull_request** to **`main`**, CI runs **`bash scripts/run-grid-checks.sh`** (`validate.yml`) and the reusable family policy workflow from **`uDOS-dev`** (`family-policy-check.yml`). Canonical contract: **`uDOS-dev/docs/github-actions-family-contract.md`**.

## Boundary Rule

Grid does not own gameplay rendering, network transport, shell interaction, or
non-spatial runtime semantics.
