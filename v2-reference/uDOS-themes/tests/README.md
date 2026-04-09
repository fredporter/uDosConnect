# Tests

`tests/` is the theme contract validation lane for `uDOS-themes`.

Current validation contract:

- `scripts/run-theme-checks.sh` verifies required repo surfaces
- checked-in theme token contracts must stay structurally valid
- registries must reference valid adapters, themes, and skins
- cross-surface minimum coverage must remain present
- private local-root references must not leak into tracked theme docs

Phase 1 rule:

- keep tests lightweight and contract-focused
- keep interactive behavior outside this repo
