# Tests

`tests/` is the documentation validation lane for `uDOS-docs`.

Current validation contract:

- `scripts/run-docs-checks.sh` verifies required entry surfaces
- repo docs must stay free of hardcoded private local-root paths
- family topic lanes must remain populated with markdown entry files

Phase 1 rule:

- keep tests lightweight and source-first
- use code-repo tests for implementation behavior, not this repo
