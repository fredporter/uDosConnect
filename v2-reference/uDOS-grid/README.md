> **Archive (uDos v2/v3)**  
> This is a conceptual uDos v2/v3 project which has been archived for posterity.
>
> **Scheduled extension track:** **4.1.6** (uDos **4.1.0** line; numbers may be reprioritized in [`uDosDev/TASKS.md`](../uDosDev/TASKS.md)).
>
> **When to reintegrate:** after `uDosGo` is locked for **v4.0**, when a Task Forge item for this module is scheduled in `uDosDev` (see [dev-process-v4.md](../uDosDev/docs/dev-process-v4.md)).
>
> **How:** rebuild against the current `uDosGo` contracts and tests; publish as a **submodule under `uDosConnect`** (not merged into `uDosGo`). Extension releases are numbered **4.1.1+** in order of landing.
>
> ---

# uDOS-grid

## Purpose

Canonical spatial identity, layers, locations, and place-bound artifact
attachment for uDOS.

## Ownership

- canonical spatial place identity
- layer and cell addressing
- place-bound artifact indexing
- seed spatial registries
- spatial condition and proximity-oriented contract surfaces

## Non-Goals

- gameplay rendering
- physics or scene simulation
- general shell ownership
- provider or network transport ownership

## Spine

- `contracts/`
- `seed/`
- `docs/`
- `tests/`
- `scripts/`
- `config/`
- `examples/`

## Local Development

Keep spatial truth deterministic, text-first, and renderer-independent.

## Family Relation

Grid should define canonical spatial truth that Shell, Wizard, Gameplay, and
apps may consume without redefining persistence identity.

## Activation

The repo activation path is documented in `docs/activation.md`.

Run the current repo validation entrypoint with:

```bash
scripts/run-grid-checks.sh
```
