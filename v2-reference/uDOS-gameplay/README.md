> **Archive (uDos v2/v3)**  
> This is a conceptual uDos v2/v3 project which has been archived for posterity.
>
> **Scheduled extension track:** **4.1.4** (uDos **4.1.0** line; numbers may be reprioritized in [`uDosDev/TASKS.md`](../uDosDev/TASKS.md)).
>
> **When to reintegrate:** after `uDosGo` is locked for **v4.0**, when a Task Forge item for this module is scheduled in `uDosDev` (see [dev-process-v4.md](../uDosDev/docs/dev-process-v4.md)).
>
> **How:** rebuild against the current `uDosGo` contracts and tests; publish as a **submodule under `uDosConnect`** (not merged into `uDosGo`). Extension releases are numbered **4.1.1+** in order of landing.
>
> ---

# uDOS-gameplay

## Purpose

Gameplay and interactive simulation patterns built on canonical uDOS state.

## Ownership

- gameplay-facing modules
- interaction experiments
- educational samples around spatial or stateful flows

## Non-Goals

- canonical runtime ownership
- networking ownership
- general-purpose shell ownership

## Spine

- `src/`
- `docs/`
- `tests/`
- `scripts/`
- `config/`
- `examples/`

## Local Development

Keep experiments modular and grounded in stable public contracts.

## Family Relation

Gameplay should consume family contracts without redefining them.
Gameplay treats `uDOS-grid` as the canonical spatial source for place and
artifact truth.

## Activation

The repo activation path is documented in `docs/activation.md`.

Run the current repo validation entrypoint with:

```bash
scripts/run-gameplay-checks.sh
```
