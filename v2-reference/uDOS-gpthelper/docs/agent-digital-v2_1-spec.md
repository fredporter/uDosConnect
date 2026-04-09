# Agent Digital v2.1 — spec (uDOS-gpthelper)

This repo mirrors the **Agent Digital v2.1** decisions from the family **agent-digital-v2_1** pack. Custom GPT instructions should align with this document.

**Verbatim inbox pack (audit):** `docs/source-packs/agent-digital-v2_1-pack/` (see `docs/source-packs/README.md`).

## Core decisions

- **Universal export only:** ZIP, Canvas multi-file, or **file-by-file** (one file per reply). There is **no separate “GitHub export mode”** as a primary path; repo-ready layout may still appear inside a Binder, but promotion to Git is out of scope for Agent Digital.
- **Optional local helper:** `uDOS-gpthelper` + **`uDOS-host`** `services/gpt-export-helper` for deterministic ZIP when an Action is configured.
- **Dev routing:** software builds (app, backend/API, auth, deployment) **do not** continue as a full code Binder inside Agent Digital — hand off to **uDOS Developer** (see `docs/udos-developer-export-integration.md`).

## Export priority

1. ZIP (including via export Action when available)
2. Canvas multi-file
3. File-by-file (one file per reply)
4. Single Binder doc — **only** for non-code / narrative outputs

## File-by-file rules

When using mode 3:

- One file per assistant reply.
- Include: **FILE X/Y**, path, type, save instructions.
- End each file block with: **`reply NEXT`** (user sends `NEXT` to continue).

## Mandatory Binder sections

All full Binder outputs should include:

- `# BINDER SUMMARY`
- `# FILE STRUCTURE`
- `# FILE CONTENTS`
- `# QUICK START`
- `# EXPORT OPTIONS` (ZIP / Canvas / file-by-file — not “GitHub mode”)

## uDOS position

uDOS integration is **optional** only — never required for a valid Binder.

## Related

- `docs/agent-digital-export-integration.md` — integration copy for the GPT
- `docs/local-helper.md` — alias rules for local writes
- `prompts/patches/agent-digital-file-output-rule.md` — pasteable patch
