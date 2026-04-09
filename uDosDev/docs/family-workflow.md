# uDOS v2 Family Workflow

## Purpose

This document defines the shared development workflow for the public uDOS v2 family.

`uDOS-dev` owns the workflow and promotion process.
`uDOS-core` owns the semantic boundary and dependency contract.

**PR discipline:** **`docs/pr-checklist.md`**. **Distributable brief templates** (local **`@dev/inbox/`** stays scratch): **`docs/dev-inbox-framework.md`** and **`docs/dev-inbox/`**.

## Lifecycle

Every non-trivial public-family change moves through the same lifecycle:

1. `Open`
2. `Hand off`
3. `Advance`
4. `Review`
5. `Commit`
6. `Complete`
7. `Compile`
8. `Promote`

## Lifecycle Meaning

### `Open`

- create or identify a tracked work item
- assign a binder ID
- record target repos and dependency order
- for non-trivial family-scale briefs, start from **`docs/dev-inbox/02-dev-brief-template.md`** (and **`docs/dev-inbox/`** guardrails as needed); keep **`@dev/inbox/`** for local drafts only

### `Hand off`

- place cross-repo coordination work in `uDOS-dev/@dev`
- place repo-owned execution work in the target repo's local `@dev/`
- move repo-specific instructions, upgrade notes, and deep-dive round material
  into the owning repo's local `@dev/` tree
- define owner, scope, blockers, and success criteria

### `Advance`

- do the active local work in the owning repo and its local `@dev/`
- keep changes bounded to one objective at a time
- keep cross-repo work sequenced by dependency owner first
- scheduled work may gather evidence and refresh status, but it does not replace
  human review or promotion decisions

### `Review`

- confirm boundary ownership
- confirm docs and repo requirements still hold
- confirm promotable outputs are separated from notes and scratch material
- scheduled work may prepare review evidence; humans still decide lifecycle
  movement beyond `Review`

### `Commit`

- checkpoint local progress in the relevant repo
- use commit messages that describe the outcome, not the activity

### `Complete`

- the binder objective is materially finished
- tests, docs, and examples are updated where required

### `Compile`

- clean the binder output into reviewable repo-facing changes
- remove stale notes, temporary files, and ambiguous promotion candidates

### `Promote`

- land changes on **`main`** (direct push is the default for solo linear work)
- open a **PR** only when you want review isolation or a merge artifact—not as a
  habit; align GitHub branch rules with that (see
  **`docs/github-actions-family-contract.md`** § Branch protection and solo
  maintenance)
- release tags are cut from **`main`**

## `@dev` Structure

`uDOS-dev/@dev` is the operational workspace for family-wide development
coordination. Repo-local rounds and repo-owned records live in each repo's own
`@dev/`.

### `@dev/inbox/`

- **gitignored** local intake (not pushed); ingest outcomes into `docs/`,
  `@dev/notes/`, `@dev/requests/`, etc.
- Distributable **templates and policy:** `docs/dev-inbox-framework.md` and
  `docs/dev-inbox/`
- local-only first-pass brief capture
- incoming architectural decisions before normalization
- raw cross-repo requests before handoff
- source material that still needs processing into a canonical doc home
- compost or move to a local-only processed folder once handled

### `@dev/requests/`

- incoming family work
- cross-repo requests
- dependency and boundary clarifications

### `@dev/submissions/`

- finished or review-ready family work
- cross-repo candidate outputs waiting for promotion or merge

### `@dev/triage/`

- normalized family scope and boundary notes
- owning repo and dependency assessment
- source-of-truth and downstream doc decisions

### `@dev/routing/`

- brief routing manifests
- downstream repo targeting rules
- promotion intent and transform modes

### `@dev/promotions/`

- repo-facing outputs prepared from triaged briefs
- ready vs applied staging
- promotion-safe transformed docs rather than raw copies

### `@dev/pathways/`

- contributor learning paths
- binder templates
- repeatable family processes

### `@dev/notes/`

- active coordination notes
- release planning notes
- cross-repo status snapshots
- roadmap status and generated family reports

### `@dev/logs/`

- routing history
- promotion history
- traceability for cross-repo brief movement

### Repo-local `@dev/`

Each active family repo should expose:

- `@dev/README.md`
- `@dev/requests/`
- `@dev/submissions/`
- `@dev/notes/`
- `@dev/rounds/`

Keep repo-specific rounds, requests, submissions, and notes in the owning repo.
Use `uDOS-dev/@dev` only when the work is truly cross-repo or family-governed.
When one repo needs a narrow focused pass, add a repo-local subfolder such as
`@dev/v2-upgrade/` there instead of expanding the family control plane.

See `docs/repo-local-dev-workspaces.md` for the canonical split and version
baseline rule.

## Binder Rules

### Binder ID format

Use:

`#binder/<repo-or-stream>-<objective>`

Examples:

- `#binder/core-dependency-matrix`
- `#binder/dev-family-sync-policy`
- `#binder/wizard-provider-boundary`

### Binder states

- `open`
- `handed-off`
- `in-progress`
- `review`
- `complete`
- `compiled`
- `promoted`
- `blocked`

### Scheduled versus manual progression

The active `v2.3` rule is:

- scheduled work may move binders only through bounded evidence states
- manual work owns `Commit`, `Complete`, `Compile`, and `Promote`

See `docs/workflow-schedule-operations.md` for the current version-round model.

### Required binder fields

Each binder-backed work item must state:

- binder ID
- owning repo or stream
- objective
- dependent repos
- blocked-by or prerequisite work
- promotion target
- acceptance criteria

## Branch And Promotion Model

### Public repos

- `main` is release-ready
- `develop` is the integration branch
- short-lived working branches branch from `develop`
- PRs target `develop` unless the change is release-only
- promotion moves from `develop` to `main`

### Private repos

- `main` may be used directly with short-lived branches
- private repos do not require the public release-promotion workflow
- they still follow the same naming and documentation hygiene where practical

## Cross-Repo Order

For changes spanning multiple repos:

1. contract owner
2. downstream consumers
3. packaging and deployment repos
4. docs and release surfaces

Applied to the public family:

1. `uDOS-core`
2. `uDOS-shell`, `uDOS-wizard`, `uHOME-server`, `uHOME-client`, `uDOS-plugin-index`
3. `sonic-screwdriver`, `uDOS-alpine`, `uDOS-host`, `sonic-ventoy`
4. `uDOS-docs`

`uDOS-dev` coordinates the checklist and binder state but does not own runtime behavior.

## Promotion Gates

A public repo may be promoted only when:

- the binder is in `compiled`
- required docs exist
- repo policy checks pass
- repo-specific validation passes
- dependency order has been respected
- release notes or promotion notes are present when needed
