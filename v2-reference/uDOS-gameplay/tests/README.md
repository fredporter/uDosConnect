# Tests

`tests/` is the gameplay contract validation lane for `uDOS-gameplay`.

Current validation contract:

- `scripts/run-gameplay-checks.sh` verifies required repo surfaces
- checked-in gameplay state contracts must stay structurally valid
- private local-root references must not leak into tracked gameplay docs

Phase 1 rule:

- keep tests lightweight and contract-focused
- use `uDOS-core` and consumer repos for deeper runtime behavior
