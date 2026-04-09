# Command Language Model

## Intent Pipeline

```
Human intent → logic input handler → uCode/workflow/knowledge/guidance → machine action graph → execution + verify + logs
```

---

## Language and Runtime Layers

uDOS v2 standardizes platform architecture around a clear separation of concerns.
See [14_v2_language_runtime_spec.md](14_v2_language_runtime_spec.md) for the full specification.

| Layer | Language | Responsibility |
|---|---|---|
| Core runtime | Go | Parser, dispatcher, CLI/TUI shell, workflow engine, binder lifecycle, scheduler, filesystem primitives, plugin/provider boundaries |
| Command language | uCode | Command verbs, workflow syntax, binder lifecycle, runtime operations, execution grammar |
| UI runtime | TypeScript | Script rendering, UI components, story workflows, grid and visualization layers, Wizard interfaces |
| Script artifacts | Markdown (`-script.md`) | Executable documents combining documentation, uCode blocks, and story blocks |
| Helper scripting | Python (optional) | Helper utilities, data transforms, optional scripting extensions — does not define runtime semantics |

---

## uCode

uCode is the canonical operational language of uDOS. It is a deterministic command DSL — not a general programming language.

### Verb pattern

```
SET variable value
STATUS
MAP
BINDER STATUS system
WORKFLOW RUN onboarding
DRAW BLOCK assets/ucodesmile-ascii.md
```

### What uCode defines

- command verbs and argument patterns
- workflow invocation syntax
- binder lifecycle commands
- runtime operation expressions
- execution grammar consumed by the Go dispatcher

---

## uSCRIPT

uSCRIPT refers to executable uCode scripts written in the `-script.md` format.
See [15_v2_script_system.md](15_v2_script_system.md) for the full specification.

Scripts combine markdown documentation with executable blocks:

```
---
id: startup
type: script
version: 2
entry: boot
permissions:
  - read
  - draw
runtime:
  - tui
  - web
---

# Startup

Initializes system state and renders boot banner.
```

```ucode
SET system.status startup
DRAW BLOCK assets/ucodesmile-ascii.md
```

---

## Runtime Boundary Rules

- Go is the source of runtime truth — it parses, dispatches, and executes uCode
- TypeScript interprets presentation blocks; it does not execute uCode directly
- Python does not define runtime semantics; it is a utility lane only
- uCode is not a general programming language; avoid language-style variable assignment
