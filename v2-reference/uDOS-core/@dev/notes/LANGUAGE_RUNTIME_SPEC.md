
# uDOS v2 Language & Runtime Specification
Version: 2.0

## Core Decision

uDOS v2 standardizes the platform architecture around a clear separation of concerns:

- Go: Core runtime and TUI
- uCode: Canonical command and workflow language
- TypeScript: UI / Web / Presentation runtime
- Python: Optional scripting / utility lane

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
|------|----------|
| Core runtime | Go |
| Command language | uCode |
| UI runtime | TypeScript |
| Script artifacts | Markdown (`-script.md`) |
| Helper scripting | Python (optional) |
