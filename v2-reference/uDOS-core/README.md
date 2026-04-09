> **Archive (uDos v2/v3)**  
> This is a conceptual uDos v2/v3 project which has been archived for posterity.
>
> **Scheduled extension track:** **4.1.2** (uDos **4.1.0** line; numbers may be reprioritized in [`uDosDev/TASKS.md`](../uDosDev/TASKS.md)).
>
> **When to reintegrate:** after `uDosGo` is locked for **v4.0**, when a Task Forge item for this module is scheduled in `uDosDev` (see [dev-process-v4.md](../uDosDev/docs/dev-process-v4.md)).
>
> **How:** rebuild against the current `uDosGo` contracts and tests; publish as a **submodule under `uDosConnect`** (not merged into `uDosGo`). Extension releases are numbered **4.1.1+** in order of landing.
>
> ---

# uDOS-core

## Purpose

Deterministic runtime contracts and execution semantics for the uDOS v2 family.

## Ownership

- uCODE command contracts
- action and workflow semantics
- binder and compile surfaces
- vault and memory contracts
- plugin capability contracts
- offline-first local execution rules

## Non-Goals

- provider or API ownership
- network transport or MCP bridging
- Wizard budgeting or autonomy policy
- repo-local runtime sprawl

## Spine

- `contracts/`
- `schemas/`
- `runtime/`
- `binder/`
- `compile/`
- `vault/`
- `plugins/`
- `tests/`
- `docs/`
- `config/`

## Local Development

Run work from the repo root and keep toolchains under `~/.udos/`.
Use `scripts/run-core-checks.sh` as the default local validation entrypoint.

Current local runtime roots are driven by the shared dev config layer:

- `UDOS_HOME`
- `UDOS_STATE_ROOT`
- `UDOS_VAULT_ROOT`
- `UDOS_RENDER_ROOT`

Core now treats repo-root `.env`, `$UDOS_HOME/.env`, and persisted local state
as the development configuration inputs.

## Family Governance References

- `docs/family-boundary.md`
- `docs/repo-requirements.md`
- `docs/dependency-matrix.md`
- `docs/contract-enforcement.md`
- `docs/activation.md`
- `docs/v2.0.1-foundation.md`

## Quickstart And MCP

- `QUICKSTART.md`
- `docs/v2.1-api-mcp-quickstart.md`

## Family Relation

Core defines canonical semantics that Shell, Wizard, Sonic, and uHOME consume.

## Activation

The v2 repo activation path is documented in `docs/activation.md`.

Run the current validation entrypoints with:

```bash
scripts/run-core-checks.sh
scripts/run-contract-enforcement.sh
```
