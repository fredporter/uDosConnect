# uDOS-workspace v2

## Decision

Create **uDOS-workspace** as a distinct family repo.

This repo owns the visual workspace shell for binder-driven authoring, docs,
tasks, publish, and compile surfaces.

It is not:
- a theme pack
- the Wizard control plane
- the Empire publishing runtime
- the Core source of truth

## Primary stack

- **ThinUI** for shell framing and low-resource app-like operation
- **SvelteKit** for browser/runtime app structure
- **Typo** for markdown-first authoring
- **AppFlowy-like views** for tasks and table, with calendar as an optional later surface
- **Budibase-inspired compiler UI** for binder → app surface mapping
- **Empire panels** only when the optional Empire module is in scope
- **Wizard adapters** for orchestration and execution
- **Core contracts** for canonical truth

## Principle

Workspace is the **operator of truth**, not the **owner of truth**.
