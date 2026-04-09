# uDOS-gameplay Getting Started

Use this order:

1. Read `docs/README.md`.
2. Read `docs/boundary.md`.
3. Read `docs/activation.md`.
4. Inspect `src/gameplay-state.json`.
5. Inspect `src/grid-consumption.json`.
6. Compare `examples/basic-gameplay-state.json` with
   `examples/basic-grid-gameplay-state.json`.
7. Run `bash scripts/run-gameplay-checks.sh`.

Then move into the lane that matches the work:

- world model and interaction boundaries: `docs/architecture.md`
- generated world export rules: `docs/google-mvp-world-contract.md`
- sample artifacts: `docs/examples.md`

Keep modules in `src/` composable and testable, and add tests for any shared
mechanic or contract.
