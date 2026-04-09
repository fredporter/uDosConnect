# Tests

`tests/` is the packaging and profile validation lane for `uDOS-alpine`.

Current validation contract:

- `scripts/run-alpine-checks.sh` verifies required Alpine repo surfaces
- private local-root references must not leak into tracked packaging docs

Phase 1 rule:

- keep validation lightweight and packaging-aware
- use runtime repos for runtime behavior tests
