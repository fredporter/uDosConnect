> **Archive (uDos v2/v3)**  
> This is a conceptual uDos v2/v3 project which has been archived for posterity.
>
> **Scheduled extension track:** **4.1.18** (uDos **4.1.0** line; numbers may be reprioritized in [`uDosDev/TASKS.md`](../uDosDev/TASKS.md)).
>
> **When to reintegrate:** after `uDosGo` is locked for **v4.0**, when a Task Forge item for this module is scheduled in `uDosDev` (see [dev-process-v4.md](../uDosDev/docs/dev-process-v4.md)).
>
> **How:** rebuild against the current `uDosGo` contracts and tests; publish as a **submodule under `uDosConnect`** (not merged into `uDosGo`). Extension releases are numbered **4.1.1+** in order of landing.
>
> ---

# uDOS-workspace

uDOS-workspace is the binder-first visual operator shell for the uDOS family.

It stages the browser workspace lane for docs, tasks, calendar, map, publish,
and compile surfaces inside one workspace shell, with ThinUI framing and
Surface, Wizard, or Empire handoff points held at the boundary rather than
absorbed into this repo.

## Position In The Family

- `uDOS-core` owns canonical binder, task, and spatial contracts
- `uDOS-workspace` presents and edits those contracts without owning them
- `uDOS-surface` is the browser presentation boundary for host-backed operations
- `uDOS-wizard` is the broker and delegation boundary
- `uDOS-empire` may extend publishing and social scheduling when that optional module is in scope
- `uDOS-themes` owns shared theme and token output
- `uDOS-thinui` remains the low-resource takeover GUI lane

Workspace is the operator of truth, not the owner of truth.

## Activated Surfaces

- browser workspace scaffold under `apps/web/`
- workspace package boundaries under `packages/`
- compile-manifest and spatial-consumer docs under `docs/contracts/`
- binder spine v1 consumption note under `docs/workspace-binder-spine.md` (Core-owned schema)
- sample binders and compile manifests under `examples/`
- repo validation entrypoint under `scripts/run-workspace-checks.sh`

## Current Prototype Scope

- binder navigation and shell framing
- docs, tasks, calendar, map, publish, and compile surfaces
- right-side inspector and bottom operational tray
- sample compile manifest preview
- explicit Surface, Wizard, and Empire handoff placeholders

Deferred from the first activation slice:

- live broker-backed compile execution
- live Empire runtime embedding
- real Typo integration
- live map providers
- multi-user collaboration

## Validation

Run:

```bash
bash scripts/run-workspace-checks.sh
```

When workspace dependencies are installed, the same script will also run the
web app type-check pass.
