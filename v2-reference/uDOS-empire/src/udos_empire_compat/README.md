# Compatibility Runtime

`src/udos_empire_compat/` holds the explicitly non-primary runtime surface kept
only for migration and compatibility during the Empire refactor.

Current contents:

- `legacy_sync_runtime.py` for older sync, automation, and webhook handoff
  helpers that still power legacy-transition packs and smoke scaffolds

Boundary rule:

- keep new WordPress plugin logic in `../wordpress-plugin/`
- keep active pack/runtime helpers in `../udos_empire/`
- only add code here when it exists to preserve or retire old sync/webhook
  behavior safely
