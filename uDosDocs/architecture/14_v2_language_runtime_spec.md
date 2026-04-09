# v2 Language & Runtime Specification

Version: 2.0
Status: canonical — promoted from `@dev/inbox/decisions/LANGUAGE_RUNTIME_SPEC.md`

---

## Core Decision

uDOS v2 standardizes the platform architecture around a clear separation of concerns:

- **Go** — Core runtime and TUI
- **uCode** — Canonical command and workflow language
- **TypeScript** — UI / Web / Presentation runtime
- **Python** — Optional scripting / utility lane

This avoids inventing a new programming language while preserving a distinct command language.

---

## Runtime Layers

### Go (Core Runtime)

Go implements the canonical runtime environment including:

- uCode parser and dispatcher
- CLI and TUI shell
- workflow engine
- binder lifecycle engine
- scheduler / task runner
- filesystem and workspace primitives
- plugin/provider boundaries

Go represents the **source of runtime truth**.

---

### uCode (Command Language)

uCode is the canonical operational language of uDOS.

It defines:

- command verbs
- workflow syntax
- binder lifecycle
- runtime operations
- execution grammar

Example:

```
STATUS
MAP
BINDER STATUS system
WORKFLOW RUN onboarding
```

uCode is not a general programming language. It is a **deterministic command DSL**.

---

### TypeScript (UI / Web Runtime)

TypeScript powers presentation systems:

- script rendering
- UI components
- story workflows
- grid and visualization layers
- Wizard interfaces

TypeScript interprets presentation blocks inside script documents.

---

### Python (Optional)

Python is available for:

- helper utilities
- data transforms
- optional scripting extensions

Python does **not define runtime semantics**.

---

## Final Language Model

| Layer | Language |
|---|---|
| Core runtime | Go |
| Command language | uCode |
| UI runtime | TypeScript |
| Script artifacts | Markdown (`-script.md`) |
| Helper scripting | Python (optional) |

---

## Ownership and Boundary Rules

| Concern | Owner |
|---|---|
| uCode parser and dispatcher | `uDOS-core` (Go, future: `uDOS-shell`) |
| TUI shell and CLI | `uDOS-shell` |
| Workflow engine | `uDOS-wizard` (orchestration), `uDOS-core` (contracts) |
| Binder lifecycle engine | `uDOS-core` |
| Story block rendering | `uDOS-wizard` (UI), `uDOS-themes` (presentation) |
| Grid and visualization | `uDOS-grid` |
| Python utility scripts | any repo — does not require centralized ownership |

---

## Related Documents

- [04_command_language.md](04_command_language.md) — command language model and uCode verb reference
- [15_v2_script_system.md](15_v2_script_system.md) — script system specification (uSCRIPT, `-script.md` format)
- [13_v2_workflow_automation_runtime_split.md](13_v2_workflow_automation_runtime_split.md) — runtime authority split across repos
