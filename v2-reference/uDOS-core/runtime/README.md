# uDOS-core Runtime

This directory contains deterministic execution rules for the uDOS Core runtime.

## Status

Round A is active. The Python reference runtime in `udos_core/` now owns the
first working uCODE parser, dispatch surface, and markdown script executor.
The `runtime/` directory remains the design surface for the longer-term runtime
layout.

## Intended Contents

This directory defines the intended runtime layout for:

- uCode parser — tokenizes and validates verb expressions against `contracts/ucode/ucode-verb-contract.json`
- uCode dispatcher — routes parsed verbs to registered handlers
- script loader — reads `-script.md` frontmatter against `contracts/script-document-contract.json`
- block executor — sequences uCode blocks within a loaded script document
- binder lifecycle engine — manages binder open/advance/close operations
- workflow step runner — executes workflow steps in sequence, emitting `workflow-state-contract` transitions
- scheduler / task runner — deferred and repeating task management

## Design Rules

- The runtime is offline-first and deterministic
- No network calls are made from within the core runtime
- All network-facing work dispatches out to `uDOS-wizard`
- The runtime operates against canonical contracts from `contracts/` and schemas from `schemas/`

## Related Contracts

- `contracts/ucode/ucode-verb-contract.json` — verb grammar and dispatch table
- `contracts/ucode-script-execution-contract.json` — script execution entrypoints and failure model
- `contracts/script-document-contract.json` — script format and frontmatter spec
- `contracts/workflow-state-contract.json` — workflow state transitions
- `contracts/workflow-action-contract.json` — workflow action events

## Reference

- `uDOS-docs/architecture/14_v2_language_runtime_spec.md` — language and runtime layer spec
- `uDOS-docs/architecture/15_v2_script_system.md` — script system specification
