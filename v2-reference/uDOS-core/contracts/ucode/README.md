# uCode Contract

Human → uCode → machine action boundary.

## Contents

- `ucode-verb-contract.json` — canonical verb grammar and dispatch table

## Summary

uCode is the canonical operational language of uDOS. It is a deterministic command DSL — not a general programming language.

The Core runtime parses and dispatches uCode expressions. The contract describes:

- verb pattern (`<VERB> [<TARGET>] [<VALUE>]`)
- core verb groups (state, status, workflow, binder, script, draw)
- grammar rules
- ownership of parsing and dispatch

## Related

- `uDOS-docs/architecture/04_command_language.md` — command language model
- `uDOS-docs/architecture/14_v2_language_runtime_spec.md` — runtime layer spec
