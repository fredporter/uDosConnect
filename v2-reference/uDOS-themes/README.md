> **Archive (uDos v2/v3)**  
> This is a conceptual uDos v2/v3 project which has been archived for posterity.
>
> **Scheduled extension track:** **4.1.14** (uDos **4.1.0** line; numbers may be reprioritized in [`uDosDev/TASKS.md`](../uDosDev/TASKS.md)).
>
> **When to reintegrate:** after `uDosGo` is locked for **v4.0**, when a Task item for this module is scheduled in `uDosDev` (see [dev-process-v4.md](../uDosDev/docs/dev-process-v4.md)).
>
> **How:** rebuild against the current `uDosGo` contracts and tests; publish as a **submodule under `uDosConnect`** (not merged into `uDosGo`). Extension releases are numbered **4.1.1+** in order of landing.
>
> ---

# uDOS-themes

## Purpose

Public cross-surface themes, token sets, adapters, skins, and visual contracts
for the uDOS family.

## Ownership

- themes and skins
- design tokens
- reusable cross-surface presentation assets
- component primitives
- surface adapters for browser, ThinUI, TUI, workflow, publish, and forms
- teachable styling examples

## Non-Goals

- runtime semantics
- provider transport
- private product branding ownership
- direct consumption of external style libraries without an adapter boundary

## Spine

- `src/`
- `registry/`
- `docs/`
- `tests/`
- `scripts/`
- `config/`
- `examples/`

## Local Development

Keep themes modular, portable, and render-compatible across browser, ThinUI,
TUI, workflow, publish, and form surfaces.

## Family Relation

Themes provide the visual contract layer on top of the runtime family. Adapters
translate those contracts into renderable output for each surface.

## Activation

The repo activation path is documented in `docs/activation.md`.
The theme foundation is documented in `docs/v2.0.1-theme-foundation.md`.
The current integrated design system reference is documented in
`docs/v2.2.1-integrated-design-system.md`.

Run the current repo validation entrypoint with:

```bash
bash scripts/run-theme-checks.sh
```
