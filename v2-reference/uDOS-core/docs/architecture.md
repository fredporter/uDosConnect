# uDOS-core Architecture

uDOS-core is the semantic center of the public family.

## Language and Runtime Model

uDOS v2 defines a clear separation of runtime concerns:

| Layer | Language | Owner |
|---|---|---|
| Core runtime | Go | `uDOS-core` / `uDOS-shell` |
| Command language | uCode | `uDOS-core` (contracts) |
| UI runtime | TypeScript | `uDOS-wizard`, `uDOS-themes` |
| Script artifacts | Markdown (`-script.md`) | authoring — any repo |
| Helper scripting | Python (optional) | utility lane only |

Go is the source of runtime truth. uCode is the deterministic command DSL dispatched by the Go runtime.
Python does not define runtime semantics.

See `boundary.md` for the practical ownership split.

## Main Areas

- `contracts/` defines public runtime contracts.
- `schemas/` holds stable machine-readable formats.
- `runtime/` contains deterministic execution rules. *(currently empty — Go runtime implementation is staged for a future round)*
- `binder/`, `compile/`, `vault/`, and `plugins/` separate major responsibilities.
- `scripts/run-core-checks.sh` and `scripts/run-contract-enforcement.sh` are the
  activation validation entrypoints.

## Event Layer

Logs, feeds, and spools form a bounded event layer inside Core.

Logs record execution, feeds carry meaningful change, and spools retain and
transform feed items locally. None of these surfaces replace canonical records
or durable workspace truth.

## Design Rule

Core stays offline-first and deterministic. Network-facing features belong elsewhere.
