# Repo-Local Dev Workspaces

## Purpose

This document defines the split between family-wide development coordination in
`uDOS-dev/@dev` and repo-owned development state in each repo-local workspace.

For **public `docs/`** vs **`@dev/`** vs **`wiki/`** (reader vs maintainer
surfaces), see **`docs/family-documentation-layout.md`**.

The goal is simple:

- each family repo should be operable with only that repo checked out
- repo-specific planning should live with the repo it describes
- historical scratch notes and summaries should stay local and out of public git
- `uDOS-dev/@dev` should coordinate the family, not store every repo's internal
  history
- working files should start compact so they do not need large historical
  cleanup later

## Ownership Split

### Repo-local workspace

Each active family repo owns its own local planning workspace.

Keep these items in the owning repo:

- forward-looking roadmap items
- repo-local implementation todos
- public dev workspace guidance
- repo-specific upgrade packs and targeted deep-dive planning folders when they
  are still active

Keep these items local-only and git-ignored:

- inbox queues
- devlogs
- historical summaries
- scratch notes
- archives
- obsolete round transcripts

### `uDOS-dev/@dev`

Keep only family-level coordination here:

- family roadmap and release coordination
- cross-repo planning and routing
- shared templates, runbooks, and automation policy
- family validation matrix and promotion gates
- cross-family audit, archive, and migration records

If a document can be understood and acted on within one repo, it belongs in that
repo's workspace, not in `uDOS-dev/@dev`.

## Canonical Repo Layout

Every active family repo should expose this minimal structure:

- `docs/`
- `@dev/`
- `wiki/`

Recommended public structure:

- `docs/README.md`
- `docs/architecture.md`
- `docs/getting-started.md`
- `docs/activation.md`
- `docs/examples.md`
- `docs/boundary.md`
- `@dev/README.md`
- `@dev/roadmap.md`
- `@dev/todos.md`
- `wiki/README.md`
- `wiki/unit-01-<module>-basics.md`

Recommended ignored local-only structure:

- `@dev/inbox/`
- `@dev/devlog.md`
- `@dev/history/`
- `@dev/archive/`
- `@dev/summaries/`
- `@dev/scratch/`

Recommended meanings:

- `docs/`: stable module reference, contracts, how-tos, guides, and examples
- `@dev/`: forward-looking public planning only
- `wiki/`: educational units, quick reference, checklists, and practical demos

## Compression Rule

Public planning and working files should use a compressed structure by default.

Prefer:

- one short purpose section
- one compact definition block
- one clear scope or rule list
- one small lifecycle or promotion path
- examples or schemas only when they materially clarify the concept

Avoid:

- long narrative history
- repeated decision summaries
- round-by-round storytelling
- roadmap duplication
- large pasted payloads or verbose appendix material

If a topic needs more depth, split it into:

- stable reference in `docs/`
- educational walkthrough in `wiki/`
- compact current planning in `@dev/`

Do not let `@dev` become a second documentation tree.

### Compressed Working File Pattern

Use this shape for new public planning files whenever possible:

1. title
2. status
3. purpose or outcome
4. core definitions
5. scope and non-scope
6. key rules or lifecycle
7. promotion path or acceptance criteria

This format should also be used for tracked devlogs when a devlog must stay in
git: summarize the meaningful state, not the full transcript.

Inbox rule:

- `@dev/inbox/` is a processing lane only
- `@dev/inbox/` must stay flat: no subfolders, no nested packs, no long-lived trees
- drop new specs, decisions, scaffolds, or raw notes there locally
- expand or normalize them into their real public destination
- if a bundle arrives, unpack it immediately and route the useful parts into
  `docs/`, `wiki/`, code, contracts, or compost
- clear the inbox copy once processed

Repos may add more folders when needed, but should avoid reviving large public
historical note trees.

Retirement rule:

- do not keep public `@dev/archive-imports/` mirrors
- do not keep public `@dev/v2-upgrade/` buckets once material has been routed
- distill surviving ideas into lean `docs/`, `wiki/`, or `@dev/pathways/`
  entries, then delete the bulk source folder

Historical compression rule:

- if a tracked devlog is kept, compress it into dated summary entries
- keep outcome, decisions, validation, blockers, and next action
- remove chatty narration, repeated context, and stale intermediate steps
- reduce logs and historical notes into summaries, feeds, or pathway notes

## Execution Loop

Use this flow from now on:

1. Open or update a cross-repo objective in `uDOS-dev/@dev` if family routing is
   required.
2. Drop raw incoming material into a local-only `@dev/inbox/` if it still needs
   processing.
   Keep the inbox flat. Do not create subfolders inside it.
3. Put the repo-owned next steps in the target repo's `@dev/roadmap.md` or
   `@dev/todos.md`.
4. Land the durable result in code, contracts, docs, or wiki material.
5. Compost or delete the inbox copy after processing.
6. Keep historical notes locally if they are still useful, but do not publish
   them by default.
7. Return to `uDOS-dev/@dev` only for family reconciliation, release planning,
   or dependency sequencing.

This keeps repo work focused and self-contained while preserving a clear
family-wide coordination lane.

## Version Baseline

From the `v2.3` family plan onward, each active family repo manages an
independent three-part semantic version.

Baseline:

- every active family repo starts at `2.3.0`

Default increment rule:

- patch bumps are the default: `2.3.1`, `2.3.2`, `2.3.3`

Escalation rule:

- minor bumps require explicit family-plan approval: `2.4.0`
- major bumps require explicit family-plan approval: `3.0.0`

The family roadmap may still coordinate one active family plan at a time, but
that plan no longer forces every repo into a single shared release number.

## Current Public Repo Baseline

The public family repos covered by this rule are:

- `uDOS-core`
- `uDOS-shell`
- `uDOS-grid`
- `uDOS-wizard`
- `uDOS-dev`
- `uDOS-docs`
- `uDOS-plugin-index`
- `uDOS-themes`
- `uDOS-thinui`
- `uDOS-alpine`
- `uDOS-host`
- `sonic-ventoy`
- `uDOS-gameplay`
- `sonic-screwdriver`
- `uHOME-server`
- `uHOME-client`
- `uDOS-empire`
- `uHOME-matter`
- `uHOME-app-android`
- `uHOME-app-ios`

Private or detached companion apps manage their own release line outside this
family policy unless a public family plan explicitly says otherwise.
