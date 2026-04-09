# uDOS-gpthelper architecture

This repo holds **GPT bridge artifacts** (OpenAPI snippets, prompt patches, examples) for custom GPTs that integrate with uDOS. It is **not** a runtime service; the optional local export HTTP service lives under **`uDOS-host`** (`services/gpt-export-helper`).

## v2.1 alignment

- **Agent Digital** targets **structured Binder outputs** with a fixed export priority (see **`docs/agent-digital-v2_1-spec.md`**).
- **No GitHub-as-mode:** Git push flows are out of scope; repo-shaped trees may still appear inside a Binder.
- **Dev routing** sends full-stack build requests to **uDOS Developer** (`docs/udos-developer-export-integration.md`).
- **Local helper:** alias-based paths and safe writes are documented in **`docs/local-helper.md`**; implementation is split between this repo (docs/schemas) and the host export helper.

## Components

- **`actions/`** — OpenAPI fragments for GPT Actions (ZIP export).
- **`docs/`** — integration guides, **v2.1** spec, commands, local-helper rules.
- **`examples/`** — JSON payload examples for export flows.
- **`prompts/`** — operator prompt patches (file output, dev routing).
