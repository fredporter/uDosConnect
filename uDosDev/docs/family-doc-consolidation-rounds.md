# Family Doc Consolidation Rounds

## Purpose

This document turns the current duplication scan into a forward-looking cleanup
plan for the active family repos.

The target state is:

- each repo exposes stable `/docs`, `/@dev`, and `/wiki` lanes
- public git contains stable docs plus forward-looking plans only
- historical dev summaries stay local and git-ignored
- each concept has one canonical public home
- docs remain easy to ingest through MCP without drift or overlap

## Scan Findings

### Active family shape

- every active family repo already has `docs/`
- every active family repo already has `@dev/`
- only `uDOS-wizard` currently has `wiki/`

### Repeated public doc types

These are common across the family and should stay standardized rather than
freeform:

- `architecture.md`
- `activation.md`
- `getting-started.md`
- `boundary.md`
- `examples.md`

### Main duplication sources

- `uDOS-dev` is still the biggest pressure point: `docs=58`, `@dev=194`
- `uDOS-host` still has a comparatively large tracked `@dev`
- `uDOS-core` has overlapping boundary and contract-reference docs
- `uDOS-empire` has overlap between `overview`, `quickstart`,
  `getting-started`, and `roadmap`
- `uDOS-groovebox` still has avoidable `@dev` clutter

### Exact duplicate pairs found in active paths

The latest active scan no longer finds exact duplicate markdown pairs in the
tracked public lanes.

That means the immediate duplicate mirrors were removed successfully. The next
problem is not exact duplication, but overlapping scope and drift.

## Consolidation Rules

- keep one canonical public doc per concept
- prefer repo-owned docs over mirrors in upgrade packs
- keep only forward-looking plans in tracked `@dev/`
- treat `@dev/inbox/` as a local processing lane and exclude it from git
- move or ignore historical devlogs, summaries, and scratch history
- remove unnecessary version framing and repeated repo naming where it does not
  help navigation
- use `/wiki` for education, onboarding units, quick reference, and practical
  exercises
- use `/docs` for stable specs, how-tos, and module reference

## Round 1: Policy Alignment

Goal: make the public structure consistent before deleting more files.

- update `uDOS-dev/docs/repo-local-dev-workspaces.md` to the new `docs/@dev/wiki`
  model
- add `wiki/` to every active family repo
- add `docs/README.md` and `wiki/README.md` where missing
- add repo-local ignore rules for `@dev/devlog.md`, `@dev/history/`,
  `@dev/archive/`, `@dev/summaries/`, and `@dev/scratch/`

## Round 2: `uDOS-dev` De-duplication

Goal: stop `uDOS-dev` from mirroring active repo docs.

- remove or compost mirrored files under `uDOS-dev/@dev/v2-upgrade/` when the
  owning repo already contains the same public doc
- keep upgrade-pack readmes short and explicit about the canonical repo doc home
- collapse overlapping family docs in `uDOS-dev/docs/` into fewer canonical
  guides:
  - release policy and release surfaces
  - repo family map and repo-local workspace policy
  - Ubuntu command-centre topology and commandd contract references

## Round 3: Repo Outlier Cleanup

Goal: shrink the repos with the highest active doc overlap.

Targets:

- `uDOS-host`
  - reduce `@dev`
  - move historical scaffolds out of tracked public planning
  - normalize generic titles like `Getting Started` and `Examples`
- `uDOS-core`
  - merge `boundary.md`, `core-boundary.md`, and `family-boundary.md`
  - decide which versioned docs remain canonical reference versus release history
- `uDOS-empire`
  - merge `overview.md`, `quickstart.md`, and `getting-started.md`
  - move roadmap-style content out of `docs/roadmap.md` if it is not stable
- `uDOS-groovebox`
  - remove duplicate `@dev` readmes and normalize the repo workspace

## Round 4: Wiki Rollout

Goal: every repo gets a minimal educational lane.

For each active family repo:

- add `wiki/README.md`
- add `wiki/unit-01-<module>-basics.md`
- include:
  - a short module introduction
  - a practical how-to
  - an executable or editable demo example
  - an outcome check or quiz

## Round 5: MCP Ingestability Sweep

Goal: make docs easier for local MCP tooling to consume consistently.

- ensure canonical paths are predictable across repos
- avoid repeated contradictory ownership statements
- make doc titles unambiguous where generic filenames remain
- prefer shorter focused docs over overlapping long summaries
- ensure every repo `README.md` points to the canonical docs and wiki entrypoints

## Recommended Order

1. Round 1 across all active repos
2. Round 2 inside `uDOS-dev`
3. Round 3 for `uDOS-host`, `uDOS-core`, `uDOS-empire`, and `uDOS-groovebox`
4. Round 4 wiki rollout to the rest of the family
5. Round 5 MCP-ingestability sweep across the whole tree

## Immediate First Targets

If work starts now, the highest-yield first edits are:

- `uDOS-dev/@dev/v2-upgrade/uDOS-plugin-deerflow-v0.1/`
- `uDOS-dev/@dev/v2-upgrade/uDOS-workspace/`
- `uDOS-host/@dev/`
- `uDOS-core/docs/*boundary*.md`
