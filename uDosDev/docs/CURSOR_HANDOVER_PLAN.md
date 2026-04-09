# uDOS Family Cursor Handover Plan

This workspace is now Cursor-first.

Cursor should open one focused `.code-workspace` at a time, complete that lane
to a working spec and release-ready plan, then move to the next numbered
workspace. **All workspace files live in `uDOS-dev/workspaces/`** (see
**`CURSOR-WORKSPACES.md`** at the family root).

## Operating Rules

- use Cursor with the numbered focused workspaces in this file
- treat `.code-workspace` files as Cursor-compatible workspace manifests
- do not run multiple family lanes in parallel unless a lane explicitly depends
  on shared validation only
- each lane must leave behind updated specs, repo-local `@dev` notes, and clear
  release gates before the next lane starts
- `uDOS-dev` remains the family control plane
- family **operator organisation** (host, Wizard, Sonic, first-run, health/disk):
  `uDOS-dev/docs/family-operator-organisation-map.md`
- repo-local `@dev/` folders remain the owner of repo-specific round state
- prepare `sonic-screwdriver` plus `sonic-ventoy` and the full `uHOME-*`
  stream as adjacent families rather than permanent core-working-set repos

## Current position (2026-04-02)

- **Family plan:** `v2.5` is **completed**; ledger: `uDOS-dev/@dev/notes/roadmap/v2-roadmap-status.md`. **Next `v2.x`:** open only per **`uDOS-dev/docs/next-family-plan-gate.md`**; otherwise repo-local patch bumps from `2.3.0` + `v2-family-roadmap.md` engineering backlog.
- **Cursor numbered lanes:** **Workspaces 01–09** **closed** **2026-04-02** (09 optional post-08). **Workspace 08:** `uDOS-dev/workspaces/cursor-08-family-convergence.code-workspace`; round `cursor-08-family-convergence-2026-04-01.md` **CLOSED**; exit evidence `uDOS-dev/docs/workspace-08-exit-evidence.md`. **Workspace 09:** `uDOS-dev/workspaces/cursor-09-classic-modern-mvp.code-workspace`; round `cursor-09-classic-modern-mvp-2026-04-02.md` **CLOSED**; canonical pack `uDOS-docs/docs/classic-modern-mvp-0.1/README.md`.
- **Post-08:** follow **`uDOS-dev/docs/workspace-08-exit-evidence.md`** section 3 — engineering backlog, pathway promotion rules, `active-index` wiki work, post-08 hooks, roadmap reports, optional `v2.x` per `uDOS-dev/docs/next-family-plan-gate.md`. Primary ledger: `uDOS-dev/@dev/notes/roadmap/v2-family-roadmap.md`, `uDOS-dev/@dev/notes/roadmap/v2-roadmap-status.md`.
- **Optional rounds O1–O4:** sequence in **`uDOS-dev/@dev/notes/roadmap/post-08-optional-rounds.md`** (next: **O1** themes integration unless parked).

## Runtime And Install Baseline

Standardize local-first paths around the user home directory:

- source checkout root: `~/Code/uDOS-family`
- managed runtime root: `~/.udos/`
- shared Python envs: `~/.udos/envs/`
- runtime state and service data: `~/.udos/state/`
- logs: `~/.udos/logs/`
- caches and temp files: `~/.udos/cache/` and `~/.udos/tmp/`
- local tools and launchers: `~/.udos/tools/` and `~/.udos/bin/`
- local vault root: `~/.udos/vault/`
- memory and session artifacts: `~/.udos/memory/`
- mirrored libraries, downloads, and source payloads: `~/.udos/library/`
- sync staging and network replication state: `~/.udos/sync/`

Repos stay clean. Runtime state, vault content, downloads, logs, and generated
artifacts should live under `~/.udos/` unless a repo explicitly needs checked-in
fixtures or build outputs.

## Execution prep

- Targeted runbook: `uDOS-dev/docs/cursor-execution.md` (sequence **01 → 08** **complete** **2026-04-01**; **post-08** per `uDOS-dev/docs/workspace-08-exit-evidence.md` § 3).
- Optional: open `uDOS-dev/workspaces/uDOS-v2-public.code-workspace` for orientation only; numbered
  lanes **01–08** were the historical completion gates.
- Cross-cutting themes to carry through rounds: **Binder + DeerFlow workflow**,
  **Binder + spool synchronicity**, **clean as we go**, **compost heap** (build,
  compact, organic archive), **system vitals** (monitor and optimise). See
  `uDOS-dev/docs/cursor-execution.md` and `cursor-focused-workspaces.md` (cross
  cutting table). Readiness snapshot:
  `uDOS-dev/@dev/notes/reports/family-readiness-audit-2026-04-01.md`.

## Linear Completion Order

1. `uDOS-dev/workspaces/cursor-01-runtime-spine.code-workspace`
   Finalize the always-on runtime spine around `uDOS-host` as the primary
   uDOS runtime host, with Wizard reduced to orchestration instead of owning
   critical uptime.
2. `uDOS-dev/workspaces/cursor-02-foundation-distribution.code-workspace`
   Finalize install, packaging, bootstrap, path standards, Docker posture, and
   `sonic-screwdriver` as the first-entry distribution lane.
3. `uDOS-dev/workspaces/cursor-03-uhome-stream.code-workspace`
   Move `uHOME` into its own delayed stream after the runtime spine and distro
   foundations are stable.
4. `uDOS-dev/workspaces/cursor-04-groovebox-product.code-workspace`
   Turn `uDOS-groovebox` into a working product with sound-library browsing,
   audio-to-markdown project capture, and Songscribe processing.
5. `uDOS-dev/workspaces/cursor-05-gui-system.code-workspace`
   Standardize the GUI lane around ThinUI, browser GUI surfaces, shared Svelte
   components, and Typo-driven editing/prose views.
6. `uDOS-dev/workspaces/cursor-06-themes-display-modes.code-workspace`
   Finalize themes, presentation modes, step-by-step form patterns, and the
   shared visual/interaction language across GUI and TUI.
7. `uDOS-dev/workspaces/cursor-07-docs-wiki-courses.code-workspace`
   Consolidate docs, wiki, GitHub Pages style publishing, local web-hosted docs,
   and educational course hooks.
8. `uDOS-dev/workspaces/cursor-08-family-convergence.code-workspace`
   Review leftovers, remove duplication, unify architecture, and prepare the
   final release structure across the family.
9. `uDOS-dev/workspaces/cursor-09-classic-modern-mvp.code-workspace` (optional post-08 — Classic Modern / Sonic TUI; see `uDOS-dev/docs/cursor-focused-workspaces.md` § Workspace 09).

## Per-Lane Exit Requirement

Do not advance to the next focused workspace until the current lane has:

- an updated repo and family spec
- explicit ownership boundaries
- agreed runtime/storage paths where relevant
- release gates and validation commands documented
- repo-local `@dev` round artifacts updated
- `uDOS-dev` family reconciliation notes updated

## Immediate Architectural Direction

- `uDOS-host` becomes the always-on runtime host for local and offline-first
  networking, vault serving, beacon/portal support, and sync ownership
- `uHOME-server` remains a service lane, but the runtime center of gravity moves
  toward the Ubuntu-hosted uDOS server model
- `uDOS-wizard` should contract back to orchestration, provider routing, MCP,
  autonomy controls, and guided setup, not sole uptime-critical operations
- `sonic-screwdriver` becomes the first install and distribution surface for
  both standalone Sonic and full uDOS entry
- `sonic-ventoy` is a Sonic-owned boot-media dependency and should be prepared
  to fold into the Sonic family rather than remain a core uDOS lane
- the `uHOME` repos should be treated as an adjacent family that consumes the
  core runtime spine rather than expanding the active core completion scope
- local-language intelligence should be planned into the runtime foundation via
  a local model lane such as `gpt4all`, with clear hosting and fallback rules

## Detailed Lane Notes

See `uDOS-dev/docs/cursor-focused-workspaces.md`.
See `uDOS-dev/docs/family-split-prep.md`.
See `uDOS-dev/docs/ubuntu-wizard-empire-comparison.md`.
See `uDOS-dev/docs/release-tier-map.md`.
