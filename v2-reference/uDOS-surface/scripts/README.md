# `scripts/`

This lane holds operational helpers for working on the browser-layer host in
`uDOS-wizard`.

## Current Scripts

- `validate_surface_profiles.py`
  - stdlib validation for `profiles/*/surface.json` and optional `input-mapping.json`
- `run-surface-checks.sh`
  - runs profile validation, then the Surface-era browser-layer checks
- `run-wizard-checks.sh`
  - compatibility validation entrypoint
  - runs the current repo unit tests
  - still exists during the rename

Keep scripts explicit, repo-relative, and bounded to the browser-layer host.
