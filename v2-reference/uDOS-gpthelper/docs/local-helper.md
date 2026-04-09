# Local helper (uDOS-gpthelper + host export)

**v2.1 rule:** optional local helper for writing Binder-related files and mapping **folder aliases** — not raw paths from the model.

## Role

- Writing Binder files locally (when configured).
- Mapping **alias → directory** via local config.
- **Safe write** modes (append / replace policies are host/export-helper concerns).

## Path rules

- **GPTs must not send raw machine paths** (no `/Users/...`, no drive letters).
- Only **alias names** agreed in config (examples: `obsidian_binder`, `workspace_default`, `exports`).
- The optional HTTP export Action (`actions/export-openapi.json`) receives **structured `path` + `content`** for ZIP creation — still no client filesystem paths from the user’s OS in the *instruction* layer; the Action URL is operator-configured.

## Deployment

See **`uDOS-host`** `services/gpt-export-helper/README.md` and `docs/getting-started.md` here.
