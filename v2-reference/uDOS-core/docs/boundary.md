# uDOS-core Boundary

`uDOS-core` is the deterministic and offline-first root of the public family.

## Core Owns

- canonical parsing and action framing
- workflow and binder semantics
- compile and packaging semantics
- shared render and output contracts derived from compiled artifacts
- local-first fallback behavior
- uCode verb contract and grammar (`contracts/ucode/ucode-verb-contract.json`)
- script document contract for the `-script.md` uSCRIPT format (`contracts/script-document-contract.json`)
- uCode parser and dispatcher (Go runtime — staged for future round, see `runtime/README.md`)
- script frontmatter parsing (Go runtime — staged with runtime)

## Core Does Not Own

- provider clients
- API gateways
- MCP transport
- budgeting and autonomy policies
- story block rendering and browser GUI
- presentation theming (owned by `uDOS-themes`)
- TUI shell and CLI surface
- host runtime uptime, scheduling, or network control
- secret-backed execution

## Practical Split

Use this simple ownership split:

- Core defines contracts and deterministic semantics
- Shell consumes Core for TUI and command interaction
- Surface or browser layers consume Core for GUI and rendering
- Ubuntu or other always-on runtimes consume Core for managed execution

## Language Boundary Rule

Core defines the language contracts. It does not become the UI runtime.

| Concern | Owner |
| --- | --- |
| uCode grammar contract | `uDOS-core` |
| deterministic parser and dispatcher | `uDOS-core` |
| shell interaction surfaces | `uDOS-shell` |
| browser rendering surfaces | consumer repos |
| presentation theming | `uDOS-themes` |
| Python utility scripts | utility only |

## Beginner Rule

If a change introduces network dependence, provider policy, browser rendering,
or secret-backed execution, it probably does not belong in Core.
