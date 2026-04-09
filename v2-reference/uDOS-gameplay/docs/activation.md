# uDOS-gameplay Activation

Gameplay is active as the family gameplay and interaction-pattern lane.

## Active Surfaces

- `src/` for gameplay modules
- `tests/` for gameplay validation
- `config/` for checked-in gameplay config
- `examples/basic-gameplay-state.json` for the smallest gameplay example
- `examples/basic-grid-gameplay-state.json` for the first Grid-backed example
- `src/grid-consumption.json` for the Grid boundary note
- `scripts/run-gameplay-checks.sh` for repo validation

## Validation Contract

Run:

```bash
bash scripts/run-gameplay-checks.sh
```

This path verifies the required repo surfaces and checks the sample gameplay
artifacts.

## Boundary Rule

Gameplay does not own canonical runtime semantics, canonical spatial identity,
server services, provider bridges, or shell ownership.
