# Request: `#binder/alpine-activation`

- title: Activate `uDOS-alpine` as the next Tranche 4 repo-facing implementation surface
- requested by: v2 roadmap workflow
- owning repo or stream: `uDOS-alpine`
- binder: `#binder/alpine-activation`
- summary: Add the first repo-level activation and validation flow for `uDOS-alpine` while keeping ownership inside Alpine packaging, lean profiles, and Alpine service integration.
- acceptance criteria:
  - `uDOS-alpine` exposes an activation doc
  - `uDOS-alpine` exposes a local validation command under `scripts/`
  - `uDOS-alpine` includes a minimal operator walkthrough
  - repo entry surfaces point to the activation flow
- dependencies:
  - `#binder/core-contract-enforcement`
  - `#binder/docs-activation`
  - `uDOS-alpine` current package, profile, and OpenRC surfaces
- boundary questions:
  - activation should stay inside Alpine packaging ownership
  - runtime semantics remain in `uDOS-core`
  - broader deployment bootstrap remains in `uDOS-sonic-screwdriver`
- due or milestone: v2 roadmap tranche 4

## Binder Fields

- state: `completed`
- owner: `uDOS-alpine`
- dependent repos:
  - `uDOS-dev`
- blocked by:
  - none
- target branch: `develop`
- objective:
  - make `uDOS-alpine` runnable and teachable without broadening its ownership boundary
- promotion criteria:
  - Alpine activation docs, example, and validation entrypoint are committed
  - roadmap ledger reflects `uDOS-alpine` as the active repo-activation binder
- files or areas touched:
  - `uDOS-alpine/docs`
  - `uDOS-alpine/scripts`
  - `uDOS-alpine/tests`
  - `uDOS-alpine/examples`
  - `uDOS-dev/@dev`

## Lifecycle Checklist

- [x] Open
- [x] Hand off
- [x] Advance
- [x] Review
- [x] Commit
- [x] Complete
- [x] Compile
- [x] Promote
