# Legacy Source Inventory

`src/legacy/` documents source assets that still exist for compatibility while
the Empire refactor moves toward the WordPress-plugin model.

These assets remain live in their historical paths because current tests,
smokes, and transition packs still depend on them.

Current legacy-transition groups:

- `../sync-contract.json`
- `../sync-record-profile.json`
- `../containers/`
- `../webhooks/`

Use the active source lane for new work:

- `../wordpress-plugin/`

Rule:

- do not add new product direction to legacy assets
- only touch legacy assets for compatibility, migration, or retirement work
