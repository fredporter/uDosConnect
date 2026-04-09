# Family repo structure brief

## Core model

- `uDOS-family` local root is an organizer, not one monorepo.
- Each repo under it is independently versioned and released.
- Runtime state is under `~/.udos/`, not inside repo trees.

## Tiering summary

- Tier 1: required for coherent release (Core, Ubuntu, Wizard, Shell, Themes,
  ThinUI, Workspace, Docs, Dev, Grid, plugin index).
- Tier 2: optional product/extension lanes (Groovebox, Gameplay, Empire, Alpine).
- Tier 3: adjacent families and delayed streams (Sonic, Ventoy, uHOME family).

Canonical references:

- `uDOS-dev/docs/release-tier-map.md`
- `uDOS-dev/docs/repo-family-map.md`
- `uDOS-dev/docs/foundation-distribution.md`
- `uDOS-dev/docs/runtime-spine.md`

## Ownership boundaries

- Core owns contracts and semantics.
- Ubuntu owns always-on host runtime and `~/.udos/` posture.
- Wizard owns orchestration/broker surfaces, not host uptime ownership.
- Dev owns family workflow/governance/docs for execution coordination.
- Docs owns public narrative/hub and learning links.

## Execution order

- Numbered Cursor lanes 01–08 are closed and remain reference.
- Post-08 work is backlog-driven with gate for opening next `v2.x`.

Canonical references:

- `uDOS-dev/docs/cursor-execution.md`
- `uDOS-dev/docs/post-08-backlog-snapshot.md`
- `uDOS-dev/docs/next-family-plan-gate.md`
