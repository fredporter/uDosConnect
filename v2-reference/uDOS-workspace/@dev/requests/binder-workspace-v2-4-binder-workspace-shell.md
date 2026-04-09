# Request: `#binder/workspace-v2-4-binder-workspace-shell`

- title: Activate `uDOS-workspace` as the Round A repo for the `v2.4`
  workspace-led upgrade lane
- requested by: `v2.4` family roadmap activation
- owning repo or stream: `uDOS-workspace`
- binder: `#binder/workspace-v2-4-binder-workspace-shell`
- summary: Promote the staged workspace pack into a real public family repo with
  browser shell scaffolding, explicit contract docs, sample binder and compile
  artifacts, and a repo-local validation command.
- acceptance criteria:
  - `uDOS-workspace` exposes a repo activation doc
  - the browser workspace scaffold is present under `apps/web/`
  - compile-manifest and spatial-consumer contract docs are committed
  - examples and package boundaries are present
  - repo validation exists under `scripts/`
- dependencies:
  - `uDOS-dev/@dev/notes/roadmap/v2.4-rounds.md`
  - `uDOS-dev/@dev/v2-upgrade/uDOS-workspace/`
- boundary questions:
  - workspace remains the operator of truth, not the owner of canonical truth
  - compile execution remains Wizard-owned
  - publishing semantics remain Empire-owned
- due or milestone: `v2.4` Round A

## Binder Fields

- state: `in-progress`
- owner: `family`
- dependent repos:
  - `uDOS-dev`
  - `uDOS-core`
  - `uDOS-wizard`
  - `uDOS-empire`
- blocked by:
  - none
- target branch: `develop`
- objective:
  - materialize `uDOS-workspace` as a distinct public repo with a runnable
    scaffold and clear contract boundaries
- promotion criteria:
  - repo activation docs, scaffold, examples, and validation command are
    committed
  - the family map and active roadmap surfaces point to the new repo
- files or areas touched:
  - `uDOS-workspace/`
  - `uDOS-dev/@dev/notes/roadmap/`
  - `uDOS-dev/docs/`

## Lifecycle Checklist

- [x] Open
- [x] Hand off
- [x] Advance
- [ ] Review
- [ ] Commit
- [ ] Complete
- [ ] Compile
- [ ] Promote
