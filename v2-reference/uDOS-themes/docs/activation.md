# uDOS-themes Activation

Themes are active as the family visual contract lane.

## Activated Surfaces

- `src/` as the theme source and token lane
- `scripts/run-theme-checks.sh` as the repo validation entrypoint
- `tests/` as the theme contract validation lane
- `config/` as the checked-in theme config lane
- `examples/basic-theme.json` as the smallest theme contract example

## Validation Contract

Run:

```bash
bash scripts/run-theme-checks.sh
```

This path verifies the required repo surfaces and checks the sample theme
contract.

## Boundary Rule

Themes do not own shell interaction behavior, runtime semantics, private
product branding, or provider and transport ownership.
