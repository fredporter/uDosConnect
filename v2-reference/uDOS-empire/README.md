> **Archive (uDos v2/v3)**  
> This is a conceptual uDos v2/v3 project which has been archived for posterity.
>
> **Scheduled extension track:** **4.1.3** (uDos **4.1.0** line; numbers may be reprioritized in [`uDosDev/TASKS.md`](../uDosDev/TASKS.md)).
>
> **When to reintegrate:** after `uDosGo` is locked for **v4.0**, when a Task item for this module is scheduled in `uDosDev` (see [dev-process-v4.md](../uDosDev/docs/dev-process-v4.md)).
>
> **How:** rebuild against the current `uDosGo` contracts and tests; publish as a **submodule under `uDosConnect`** (not merged into `uDosGo`). Extension releases are numbered **4.1.1+** in order of landing.
>
> ---

# uDOS-empire

## Purpose

WordPress-centred CRM, contact, email, and admin operations plugin for the
family, intended to run on the local `uDOS-host` host.

## Ownership

- WordPress plugin runtime and extension surfaces
- WordPress-backed CRM or contact records built on users and user meta
- consent-aware contact intake, dedupe, enhancement, and activity logging
- drag-and-drop admin import flows for CSV, TSV, and JSON contact data
- binder and workspace tagging on contact records
- WordPress-centred email audience and send workflows
- family contact-event intake into local WordPress records
- operator-facing admin workflows for inspectable CRM and messaging work

## Non-Goals

- canonical runtime semantics owned by `uDOS-core`
- always-on Git, GitHub, sync, AI, API, or security ownership owned by
  `uDOS-host`
- base Linux host runtime ownership owned by `uDOS-host`
- general GitHub sync brokerage or central repo-store ownership
- HubSpot as the canonical CRM host
- CSV consolidation as an end in itself

## Spine

- `packs/`
- `schemas/`
- `src/`
- `docs/`
- `tests/`
- `scripts/`
- `config/`
- `examples/`

## Local Development

Keep Empire local-first and WordPress-centred. Treat WordPress running on
`uDOS-host` as the CRM, consent, admin, and email host rather than treating
remote CRM adapters as the canonical source of truth.

## Family Relation

`uDOS-empire` now sits inside the Ubuntu-hosted local operations stack rather
than beside it as a separate generic remote-ops lane. It uses `uDOS-core`
semantics, relies on `uDOS-host` as the host source of truth, and may
consume Wizard assistance where useful without delegating plugin ownership.

`uDOS-host` owns the host runtime, central local repo store, Git and GitHub
execution surfaces, scheduling, secrets, and service orchestration. Empire owns
the WordPress plugin logic, contact workflows, admin UX, and WordPress-centred
email or CRM operations that live on that host.

## Core Docs

- `docs/wordpress-plugin-architecture.md`
- `docs/wordpress-plugin-data-model.md`
- `docs/architecture.md`
- `docs/quickstart.md`

## Activation

The v2 repo activation path is documented in `docs/activation.md`.

Run the current repo validation entrypoint with:

```bash
scripts/run-empire-checks.sh
```

The WordPress-first restructuring notes now live in:

- `docs/wordpress-plugin-architecture.md`
- `docs/wordpress-plugin-data-model.md`
