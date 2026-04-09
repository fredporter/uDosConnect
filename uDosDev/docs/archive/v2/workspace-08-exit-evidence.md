# Workspace 08 — exit gate evidence

**Date:** 2026-04-01  
**Round:** `@dev/notes/rounds/cursor-08-family-convergence-2026-04-01.md` **CLOSED**  
**Authority:** `docs/archive/v2/cursor-focused-workspaces.md` § Workspace 08

This file satisfies the three Workspace **08** exit checks: overlapping
ownership, convergence structure, and **post–Workspace 08** execution order.

## 1. Overlapping ownership (explicit)

| Concern | **Owns** | **Delegates / consumes** | **Does not own** |
| --- | --- | --- | --- |
| **Runtime host** (**uDOS-host** / **uDOS-server** profile), command-centre HTTP, `~/.udos/` materialisation | **`uDOS-host`** (implementation repo) | Wizard delegation envelopes, Core contracts | `docs/udos-host-platform-posture.md` |
| **Canonical semantics**, uCode, feeds/spool contracts, vault survival | **`uDOS-core`** | Shell invocation, Wizard/Surface preview | product HTML |
| **Surface browser UI**, **Wizard** broker, MCP adapters, dev demo HTTP | **`uDOS-wizard`** | Ubuntu host surfaces per `wizard-host-surface.v1.json` | primary runtime uptime authority |
| **TUI**, session commands, managed MCP to Wizard | **`uDOS-shell`** | Core | host policy |
| **Family roadmap**, Cursor lanes, governance, pathway templates | **`uDOS-dev`** | — | tier-1 operator manuals |
| **Library shell**, Pages metadata, GKL, cross-repo onboarding | **`uDOS-docs`** | Links to tier-1 `docs/` | full v2 manuals for another repo’s binary |
| **Binder-facing operator shell**, compile manifest consumption | **`uDOS-workspace`** | Core, Wizard execution results | Core contract authorship |
| **Themes / tokens / adapters** | **`uDOS-themes`** | ThinUI, Wizard GTX | host processes |
| **Spatial identity / grid** | **`uDOS-grid`** | Core, Gameplay consumption | — |

**GUI vocabulary** shared across Ubuntu / Wizard / ThinUI: `docs/gui-system-family-contract.md`.  
**Wizard vs host fields:** `uDOS-core/docs/wizard-surface-delegation-boundary.md`.

## 2. Proposed convergence structure (documented)

Stable **documentation plane:**

- `docs/family-documentation-layout.md` — `docs/` / `@dev/` / `wiki/`
- `docs/archive/v2/family-workspace-08-scope.md` — deferred post-`v2.5`, v1 hub posture, cross-cutting themes
- `uDOS-docs/docs/local-vs-github-docs-boundary.md` — local vs Pages vs `blob`

**Planning plane:**

- `v2.5` **complete**; **`docs/next-family-plan-gate.md`** for when to name `v2.6+`
- `v2-family-roadmap.md` § **Engineering backlog** — continuous work
- `v2-roadmap-status.md` — live ledger

**Duplication / pathways:**

- `@dev/notes/reports/family-duplication-and-pathway-candidates-2026-04-01.md`

**Gap-closure matrix (audit → round):**

- `@dev/notes/rounds/cursor-08-family-convergence-2026-04-01.md` § **Gap-closure matrix** — **closed** for Workspace **08** **2026-04-01** (all rows terminal; Post-08 per § 3 below).

**Adjacent families** (not core working-set): `sonic-screwdriver`, `sonic-ventoy`, `uHOME-*` per `CURSOR_HANDOVER_PLAN.md`.

## 3. Post–Workspace 08 execution order

Work **no longer** follows a numbered Cursor workspace **09**. Use this order unless family reopens a new plan:

1. **`v2-family-roadmap.md` § Engineering backlog** — pick tracks (e.g. GitHub contract roll-forward, Groovebox/Songscribe Docker depth) with normal PR discipline on **`main`**.
2. **Pathway candidates** — promote to binders only when `docs/next-family-plan-gate.md` criteria fit; see `@dev/pathways/README.md` and the duplication report.
3. **`@dev/requests/active-index.md`** — docs/wiki consolidation and per-repo wiki units; update **`uDOS-docs`** `site/data/family-source.json` when listing new `wiki/` units.
4. **Post-08 hooks** — `udos-commandd` CLI (`uDOS-host` + runtime-loop report); themes phases C–E (`uDOS-themes/@dev/next-round.md`).
5. **Health of the ledger** — `bash scripts/run-roadmap-status.sh`; refresh `@dev/notes/reports/family-readiness-audit-*.md` after major lane changes.
6. **Next `v2.x`** — only after the dual trigger in `docs/next-family-plan-gate.md`; then add `v2.X-rounds.md` and update status.

## Related

- **`docs/archive/v2/post-08-backlog-snapshot.md`** — single checklist for post-08 gaps, deferred work, and spec vigilance
- `CURSOR_HANDOVER_PLAN.md` — family handover (updated when 08 closed)
- `docs/archive/v2/cursor-execution.md` § Step 8
- `@dev/notes/rounds/cursor-08-family-convergence-2026-04-01.md`
