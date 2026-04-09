# Surface Rename Targets

## Scope

This is the safe rename set for the browser GUI layer only.

It does not rename Ubuntu-owned runtime surfaces.

## First-Pass Targets

- repo identity: `uDOS-wizard` -> `uDOS-surface`
- product label: `Wizard` -> `Surface`
- app label: `Wizard UI` -> `Surface UI`
- browser copy: `Wizard operator GUI` -> `Surface operator GUI`
- docs that describe browser presentation only

## Keep Stable Temporarily

These can stay in place until the mechanical rename pass:

- Python package path: `wizard/`
- app path: `apps/wizard-ui/`
- env var names like `VITE_WIZARD_API_URL`
- scripts like `run-wizard-checks.sh`
- command names like `udos-wizard-demo`

## Rename Later, With Coordination

These should only change in a coordinated repo migration:

- module path `wizard/` -> `surface/`
- package metadata and console scripts
- API route names if they expose `wizard` in public paths
- CI workflow labels
- release job names
- cross-repo automation scripts that refer to `uDOS-wizard`

## Module Mapping

- `uDOS-wizard` -> `uDOS-surface`
- `apps/wizard-ui` -> `apps/surface-ui`
- `wizard/render_preview.py` -> likely `surface/render_preview.py`
- `static/wizard-gui.*` -> `static/surface-gui.*`
- `docs/wizard-boundary.md` -> `docs/surface-boundary.md`

## Do Not Move Into Surface

These are no longer GUI-owned and should migrate toward Ubuntu instead of being
renamed in place:

- provider routing
- budget enforcement
- managed MCP registry and bridge authority
- beacon runtime ownership
- secret-backed runtime control
- network policy application

## Wording Rule

If the text means browser rendering, preview, portal, operator pages, or
thin-client access, rename it to `Surface`.

If the text means runtime authority, keep it with Ubuntu and rewrite the
ownership statement instead of renaming it.
