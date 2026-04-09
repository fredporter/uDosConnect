# Round: cursor-08 family convergence (final numbered lane)

- Date: 2026-04-01
- Workspace file: `cursor-08-family-convergence.code-workspace` (under **`uDOS-family/`**)

## Status

**CLOSED** **2026-04-01** — exit gate evidence: **`docs/workspace-08-exit-evidence.md`**. **Prior:** `@dev/notes/rounds/cursor-07-docs-wiki-courses-2026-04-01.md` **CLOSED**.

**Workspace file:** `uDOS-family/cursor-08-family-convergence.code-workspace`.

## Operator start

1. Open **`cursor-08-family-convergence.code-workspace`**.
2. Read **`docs/cursor-focused-workspaces.md` § Workspace 08** and **`docs/cursor-execution.md`** (step 8).
3. Work from the **gap-closure matrix** below and **`@dev/notes/reports/family-readiness-audit-2026-04-01.md` § Final round**.

## Lane authority

- Objectives, repos in scope, spec outputs, exit gate: `docs/cursor-focused-workspaces.md` § Workspace 08

## Spec outputs (Workspace 08) — fill on close

| Spec output | Primary artifact | Status |
| --- | --- | --- |
| Family architecture review | `docs/family-documentation-layout.md` + **`docs/family-workspace-08-scope.md`** (deferred / v1 / cross-cutting) | **Done** |
| Duplication and bloat report | `@dev/notes/reports/family-duplication-and-pathway-candidates-2026-04-01.md` | **Done** |
| Recommended steady-state repo and resource structure | `docs/next-family-plan-gate.md` + `v2-family-roadmap.md` / `CURSOR_HANDOVER_PLAN.md` (post-08) | **Done** |

## Exit gate (from `cursor-focused-workspaces.md`)

| Check | Evidence (record when done) |
| --- | --- |
| Overlapping ownership called out explicitly | **`docs/workspace-08-exit-evidence.md`** § 1 |
| Proposed convergence structure documented | **`docs/workspace-08-exit-evidence.md`** § 2 |
| Post-handover execution order clear | **`docs/workspace-08-exit-evidence.md`** § 3 |

## Gap-closure matrix (audit → this round)

**Legend — `Class`:** **08-doc** = resolved in Workspace 08 by writing/linking the three spec outputs (no full product implementation required). **Post-08** = engineering backlog after 08; name owner repo. **Next v2.x** = needs a future family plan slice, not Cursor 08. **Deferred** = explicitly out of local scope; pointer only. **Done** = already satisfied; matrix records where truth lives.

**Progress:** matrix **closed for Workspace 08** **2026-04-01**. Every row in **A–D** is at a **terminal status** for this lane (**08-doc done**, **Post-08**, **Deferred**, or **Done**). Further work is **Post-08** only — see **`docs/workspace-08-exit-evidence.md`** § 3, not additional matrix rows here.

### A. Family backlog and requests

| # | Gap | Class | Owner | Status | Evidence / next step |
| --- | --- | --- | --- | --- | --- |
| 1 | `@dev/requests/active-index.md` — docs / wiki / ubuntu wording | 08-doc + Post-08 | `uDOS-dev` coord | **08-doc done** | Layout + README pointers + host/broker wording (prior passes). **Manual dedup policy:** **`family-duplication-and-pathway-candidates-2026-04-01.md`** § Manual deduplication policy. **Post-08:** wiki units + `family-source.json` per `active-index.md`. |
| 2 | Next numbered **`v2.x`** after `v2.5` | Next v2.x | family | **08-doc done** | **`docs/next-family-plan-gate.md`** — default mode (repo semver + backlog + post-08); **dual trigger** for naming `v2.6+` (coordinated multi-repo scope **and** backlog overflow); what “opening” entails; examples. Wired: `v2-family-roadmap.md` § baseline + engineering backlog row; `v2-roadmap-status.md` baseline bullet; handoff authority line. **No** new plan opened in 08. |
| 3 | Pathways: logs/feeds/spool; image-ingestion-md | Post-08 | pathways + `uDOS-dev` | **08-doc done** | **`@dev/notes/reports/family-duplication-and-pathway-candidates-2026-04-01.md`** — table + row 9 migration-feed note + dup stub. **`@dev/pathways/README.md`** § Candidate pathways. Implementation stays Post-08 until binders open. |
| 4 | **v2.5 deferred:** remote Deer Flow clusters, graph editing, memory sync import/export | Deferred | — | **08-doc done** | **`docs/family-workspace-08-scope.md`** § Deferred features; pointers to `v2.5-rounds.md` Round D + `v2-roadmap-status.md` § Deferred. |
| 5 | Unified **`udos-commandd`** Python CLI | Post-08 | `uDOS-host` | **08-doc done** | **`family-duplication-and-pathway-candidates-2026-04-01.md`** § Post-08 engineering hooks + `@dev/notes/reports/runtime-loop-optimization-flags-2026-03-30.md`. Implementation Post-08. |
| 6 | **Themes** adapter beyond cursor-06 scaffold | Post-08 | `uDOS-themes` | **08-doc done** | Same duplication report § + **`uDOS-themes/@dev/next-round.md`**. Implementation Post-08. |

### B. Docs alignment

| # | Gap | Class | Owner | Status | Evidence / next step |
| --- | --- | --- | --- | --- | --- |
| 7 | Public `docs/` vs `@dev/` vs `wiki/` | Done + 08-doc | family | **08-doc done** | **`docs/family-documentation-layout.md`** + **`uDOS-docs/docs/local-vs-github-docs-boundary.md`**; tier-1 `docs/README.md` pointers (row 1). |
| 8 | **v1** architecture files in `uDOS-docs` | 08-doc | `uDOS-docs` | **08-doc done** | **`docs/family-workspace-08-scope.md`** § v1 + duplication ledger row. |
| 9 | Feeds/spool + optional **family migration feed** | 08-doc | Core + dev | **08-doc done** | **`family-duplication-and-pathway-candidates-2026-04-01.md`** § Row 9 — Core `feeds-and-spool.md` = stable ref; migration feed **Post-08**; binder↔spool narrative still cross-cutting (spec output 1 / architecture review). |

### C. Tier-1 repos (quick snapshot for duplication report)

| Repo | Alignment snapshot | Status |
| --- | --- | --- |
| uDOS-core | Contracts + pathways; feeds/spool as stable ref | **08-doc snapshot** — see **`docs/workspace-08-exit-evidence.md`** § 1 |
| uDOS-host | Command centre, vitals, compost, GitHub contract | **08-doc snapshot** — `docs/github-actions-family-contract.md`, `linux-first-run-quickstart.md` |
| uDOS-wizard | Orchestration, Deer Flow, Svelte operator surface | **08-doc snapshot** — `gui-system-family-contract.md`, activation |
| uDOS-shell | Core invoke + health entrypoints | **08-doc snapshot** |
| uDOS-dev | Roadmap, handoffs, audit, round notes | done |
| uDOS-docs | Hub, GKL, publishing trio, `family-source.json` | **08-doc snapshot** — wiki promotion Post-08 per `active-index` |
| uDOS-thinui | Surfaces vs Core; ThinUI boot paths | **08-doc snapshot** |
| uDOS-themes | Scaffold vs real adapter (Post-08) | **08-doc snapshot** — row 6 |
| uDOS-workspace | Binder + execution + Typo | **08-doc snapshot** |
| uDOS-grid | Branch/tag vs family map | **08-doc snapshot** — `docs/repo-family-map.md` |

### D. Cross-cutting themes (single narrative for architecture review)

| Theme | One-line intent (expand in spec output 1) | Status |
| --- | --- | --- |
| Binder + DeerFlow | Preview vs controlled execution, artifact persistence, where operators read results — same story in Wizard, workspace, and docs. | **08-doc done** — `docs/family-workspace-08-scope.md` § Cross-cutting |
| Binder + spool synchronicity | “Binder complete” implies feed/spool state per Core + host contracts; no silent drift. | **08-doc done** — same |
| Clean as we go | Each repo: scripts + docs + `@dev` notes leave a traceable trail after changes. | **08-doc done** — same |
| Compost heap | `.compost` = local organic archive only; build / compact / rotate; not runtime SOT. | **08-doc done** — same |
| System vitals | `~/.udos/`, Ubuntu checks, family scripts: documented runnable paths linked from onboarding. | **08-doc done** — same |

### Deferred features (v2.5+) — canonical paragraph

**Canonical doc:** **`docs/family-workspace-08-scope.md`** § Deferred features (row 4). This round does not duplicate the full text.

**Out of scope for full implementation in 08 (document only unless family expands the lane):** themes adapter phases C–E, unified `udos-commandd` CLI, optional family-wide migration feed, Songscribe/Groovebox Docker integration depth beyond existing docs — see duplication report § Post-08 hooks and `v2-family-roadmap.md` § Engineering backlog.

## Closure checklist

- [x] Spec output files written and linked from `v2-roadmap-status.md` § Recent Outputs
- [x] `family-readiness-audit-2026-04-01.md` updated (Cursor position → 08 **closed**)
- [x] `docs/cursor-focused-workspaces.md` § Workspace 08 → **Closed** with date
- [x] `CURSOR_HANDOVER_PLAN.md` § Current position → post-08 next steps
- [x] This file → **CLOSED** with evidence table filled (`docs/workspace-08-exit-evidence.md`)

## Next after this round

There is **no Workspace 09** in the current linear list. After 08 closes, execution continues via **`v2-family-roadmap.md` § Engineering backlog**, optional **next `v2.x` family plan**, and repo-local semver — recorded explicitly in the convergence spec outputs.
