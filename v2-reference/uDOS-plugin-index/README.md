> **Archive (uDos v2/v3)**  
> This is a conceptual uDos v2/v3 project which has been archived for posterity.
>
> **Scheduled extension track:** **4.1.10** (uDos **4.1.0** line; numbers may be reprioritized in [`uDosDev/TASKS.md`](../uDosDev/TASKS.md)).
>
> **When to reintegrate:** after `uDosGo` is locked for **v4.0**, when a Task Forge item for this module is scheduled in `uDosDev` (see [dev-process-v4.md](../uDosDev/docs/dev-process-v4.md)).
>
> **How:** rebuild against the current `uDosGo` contracts and tests; publish as a **submodule under `uDosConnect`** (not merged into `uDosGo`). Extension releases are numbered **4.1.1+** in order of landing.
>
> ---

# uDOS-plugin-index

## Purpose

Public index for plugin manifests, package metadata, and capability declarations.

## Ownership

- plugin manifests
- adapter metadata
- capability contracts
- distribution compatibility notes

## Non-Goals

- runtime execution ownership
- provider bridge implementation
- package installation tooling

## Spine

- `contracts/`
- `schemas/`
- `docs/`
- `tests/`
- `scripts/`
- `config/`
- `examples/`

## Local Development

Keep manifests source-first and easy to audit.

## Family Relation

This repo describes what can plug into the family; it does not execute those plugins.

## Activation

The repo activation path is documented in `docs/activation.md`.
The registry foundation is documented in `docs/v2.0.1-registry-foundation.md`.

Run the current repo validation entrypoint with:

```bash
bash scripts/run-plugin-index-checks.sh
```
