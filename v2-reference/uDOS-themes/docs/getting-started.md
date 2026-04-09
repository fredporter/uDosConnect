# uDOS-themes Getting Started

1. Read `docs/README.md`.
2. Read `docs/v2.2.1-integrated-design-system.md`.
3. Define or update base tokens in `src/tokens/`.
4. Add or update component primitives in `src/components/`.
5. Add or update adapter contracts in `src/adapters/`.
6. Register themes, adapters, and skins under `registry/`.
7. Add examples that show cross-surface reuse.
8. Run `bash scripts/run-theme-checks.sh`.
9. Keep branding boundaries explicit.

## Upstream theme rollout

When integrating third-party CSS or fonts:

1. Read `docs/theme-upstream-index.md` and `wiki/credits-and-inspiration.md`.
2. Follow `docs/theme-fork-rollout.md` (fork, `vendor/` submodules, attribution).
3. Run `bash scripts/init-vendor-forks.sh` so `vendor/forks/*` submodules are populated.
4. Use `vendor/README.md` as the layout index.
