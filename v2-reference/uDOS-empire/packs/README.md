# uDOS-empire Packs

`packs/` holds inspectable operational containers for `uDOS-empire`.

Each pack should be small enough to study, safe enough to dry-run first, and
structured enough to be reused or remixed.

Minimum pack contents:

- `pack.json` manifest
- `README.md`

Recommended additions as the pack grows:

- `templates/`
- `sample-data/`
- `docs/`
- `tests/`

Starter packs currently included:

- `campaign-starter/`
- `event-launch/`
- `weekly-bulletin/`
- `contact-import-cleanup/`
- `wordpress-contact-import/`

Current default direction:

- `wordpress-contact-import/` is the active WordPress-first pack

Legacy-transition packs:

- `campaign-starter/`
- `contact-import-cleanup/`
- `event-launch/`
- `launcher-installer/`
- `quickstart/`
- `weekly-bulletin/`

See `legacy/README.md` for the compatibility inventory.

Pack manifests should align to `schemas/pack-manifest.schema.json`.
