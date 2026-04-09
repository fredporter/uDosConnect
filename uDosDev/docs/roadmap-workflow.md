# Roadmap Workflow

## Purpose

This document defines how the uDOS v2 development roadmap moves through the
`@dev` workspace as active work.

The stable roadmap overview lives in `docs/development-roadmap.md`.
The canonical live roadmap now lives in `@dev/notes/roadmap/`.
This workflow defines how to:

- track family-plan status
- route repo-owned rounds into repo-local `@dev` workspaces
- open roadmap-derived binders
- report roadmap progress
- compile promotable outputs

## Canonical Surfaces

- `@dev/notes/roadmap/v3-roadmap.md` / `@dev/notes/roadmap/v3-feed.md` (active v3)
- `@dev/notes/roadmap/v2-family-roadmap.md` / `@dev/notes/roadmap/v2-roadmap-status.md` (stubs; full v2 history in `@dev/notes/roadmap/archive/v2/`)
- `docs/next-family-plan-gate.md` (after `v2.5`: when to open `v2.6+`)
- `@dev/notes/roadmap/archive/v2/v2.0.3-rounds.md`
- `@dev/notes/roadmap/archive/v2/v2.0.4-rounds.md`
- `docs/development-roadmap.md`
- `@dev/requests/`
- `@dev/submissions/`
- `scripts/run-roadmap-status.sh`

## Workflow Loop

1. Review the current version and round order in
   `@dev/notes/roadmap/v2-family-roadmap.md`.
2. Update the live version-round ledger in
   `@dev/notes/roadmap/v2-roadmap-status.md`.
3. Open or advance the next binder-backed roadmap objective.
4. Hand repo-owned execution into the owning repo's local `@dev/`.
5. Land the output in the owning repo.
6. Record the round result in the owning repo's `@dev/submissions/`.
7. Update the family-level ledger only with the cross-repo outcome.
8. Use the generated report for review and promotion planning.

For the active `v2.3` workflow-backed operating model, also use:

- `docs/workflow-schedule-operations.md`
- `scripts/run-v2-3-workflow-schedule-demo.sh`

## Round Status Rules

Use these statuses in the roadmap ledger:

- `pending`
- `in-progress`
- `blocked`
- `completed`

Only one roadmap round should normally be `in-progress` at a time unless an
explicit cross-repo parallel pass is being tracked.

## Repo Version And Dev Mode Rules

Use the family roadmap to coordinate the active plan, but manage shipped repo
versions independently.

From the `v2.3` plan onward:

- each repo starts from `2.3.0`
- patch bumps are the default local increment
- minor or major bumps require explicit family-plan approval
- repo-local Dev Mode notes belong in the owning repo's `@dev/`

Family-wide integration lanes may still carry shared `@dev` tags when the work
is intentionally cross-repo and still in contract or sequencing mode.

Preferred Dev Mode statuses:

- `active`
- `stable`
- `version-locked`
- `queued`
- `blocked`
- `superseded`

Recommended repo form:

- `2.3.1`
  tags: `@dev/ucode-cli-fallback`, `@dev/local-gpt4all-update`
  status: `stable`

Recommended family-lane form:

- `v2.3`
  tags: `@dev/family-env-contract`, `@dev/wizard-secret-store`
  status: `active`

## Binder Rules

Roadmap-derived binders should:

- start from the highest-priority incomplete version round
- include the target version and round or objective
- identify the owning repo clearly
- identify the validation command or check path up front

Recommended binder form:

`#binder/<repo-or-stream>-v2-0-x-<objective>`

Examples:

- `#binder/dev-v2-development-roadmap`
- `#binder/core-v2-0-1-foundation-spine`
- `#binder/family-v2-0-2-product-rebuild`

Manual-versus-scheduled binder progression rules for the active family lane are
defined in `docs/workflow-schedule-operations.md`.

## Report Expectations

Every roadmap report should show:

- version-round status summary
- active roadmap binders
- newest roadmap submission records
- next recommended binder

## Promotion Use

Use roadmap reports during:

- round review
- promotion readiness checks
- release-planning checkpoints

Roadmap status does not replace repo-level validation. It exists to keep family
sequencing legible and current.
