# Family readiness audit

- **Generated:** 2026-04-01  
- **Purpose:** Snapshot **current vs planned release-shaped work**, backlog, doc
  alignment, and **cross-cutting themes** through **Cursor Workspace 08** (**closed**
  **2026-04-01** — final numbered lane) and post-`v2.5` repo-local semver.

## Supersedes

- **`family-readiness-audit-2026-03-30.md`** — keep for history; use this file
  as the active checklist until the next dated pass.

## Final round (Workspace 08) — close the gaps

**Closed 2026-04-01:** `cursor-08-family-convergence.code-workspace` — **`@dev/notes/rounds/cursor-08-family-convergence-2026-04-01.md`** **CLOSED**; exit evidence **`docs/workspace-08-exit-evidence.md`**.

Workspace 08 is the **integration pass** for everything still open below: each row should end as **done**, **documented with follow-up**, or **explicitly deferred** in the round’s spec outputs (architecture review + duplication report + steady-state recommendation). **Working matrix (closed for Workspace 08):** the round note § **Gap-closure matrix** is the authoritative ledger—classifications, owners, and evidence columns supersede the summary table below; **Post-08** work does not reopen matrix rows without a new family decision.

| Source | Gap | Target resolution |
| --- | --- | --- |
| Backlog | `@dev/requests/active-index.md` — docs consolidation; wiki unit per repo | **08-doc done (row 1 / 7):** layout + dedup policy + tier-1 README pointers + host/broker wording. **Post-08:** wiki units + `family-source.json` (requests 1 tail + 3) |
| Backlog | Next numbered **`v2.x`** after `v2.5` | **Done (row 2):** `uDOS-dev/docs/next-family-plan-gate.md` + roadmap/status links |
| Backlog | Pathways: logs/feeds/spool; image-ingestion-md | **Placed:** `@dev/notes/reports/family-duplication-and-pathway-candidates-2026-04-01.md` + `@dev/pathways/README.md` |
| Backlog | **v2.5 deferred** (remote Deer Flow, graph editing, memory sync) | **Done (row 4):** `docs/family-workspace-08-scope.md` § Deferred |
| Backlog | Unified **`udos-commandd`** Python CLI | **Placed (row 5):** duplication report § Post-08 hooks — implementation Post-08 |
| Backlog | **Themes** adapter beyond scaffold | **Placed (row 6):** duplication report § Post-08 hooks + `uDOS-themes/@dev/next-round.md` |
| Docs alignment | Public `docs/` vs `@dev/` vs `wiki/` | **Done (row 7):** `docs/family-documentation-layout.md` + boundary doc |
| Docs alignment | **v1** files in `uDOS-docs` | **Done (row 8):** `docs/family-workspace-08-scope.md` § v1 |
| Docs alignment | Feeds/spool + optional migration feed | **Status:** `family-duplication-and-pathway-candidates-2026-04-01.md` § Row 9 |
| Tier 1 | Core, Ubuntu, Wizard, Shell, docs, ThinUI, themes, workspace, grid | **Done (matrix § C):** **08-doc snapshot** — `docs/workspace-08-exit-evidence.md` § 1 + round note § C + duplication report § Tier-1 snapshot |

## Cross-cutting themes (lanes 01–08)

| Theme | Intent | Primary lanes |
| --- | --- | --- |
| **Binder + DeerFlow workflow** | Documented compile/execution path: Binder ↔ Wizard Deer Flow ↔ workspace consumption; preview vs controlled execution clear. | 05, 07, 08 |
| **Binder + spool synchronicity** | Feeds/spool semantics aligned with binder lifecycle. | 01, 05, 07, 08 |
| **Clean as we go** | Each lane leaves repos tidier: scripts, docs, `@dev` notes. | all |
| **Compost heap** | `.compost` / superseded material: build, compact, rotate; local-only policy. | 02, 08 |
| **System vitals** | Health checks and optimisation for `~/.udos/`, Ubuntu hosts, family scripts. | 01, 02, 08 |

**Narrative (Workspace 08):** `docs/family-workspace-08-scope.md` § Cross-cutting themes.

## Family backlog (open)

Track resolution in **§ Final round** above. **Workspace 08** closes **08-doc** items below; unchecked lines are **Post-08** only.

- [x] **`@dev/requests/active-index.md` (08-doc):** docs layout + manual dedup policy + tier-1 `docs/README.md` pointers + Ubuntu/Wizard host vs broker vocabulary — gap matrix **row 1** / **7** + **`family-duplication-and-pathway-candidates-2026-04-01.md`** § Manual deduplication policy  
- [x] **`family-source.json` hub list (Post-08 tranche 1):** tier-1 + Wizard + Dev wiki units wired in learning **Wiki Units** + **`wiki_units`**; Ubuntu URLs on **`main`** — see `v2-roadmap-status.md` § Recent Outputs  
- [ ] **`@dev/requests/active-index.md` (Post-08 remainder):** optional/product repos with `wiki/` not yet on the hub; ongoing **family-source.json** sync when new units ship (requests **1** acceptance tail + **3**)  
- [x] **Next numbered family plan** after `v2.5` — **gate documented** in `docs/next-family-plan-gate.md` (open `v2.6+` only when coordinated multi-repo scope **and** backlog overflow; else patch bumps + engineering backlog)  
- [x] Pathways: logs/feeds/spool + image-ingestion-md — **indexed** in `@dev/notes/reports/family-duplication-and-pathway-candidates-2026-04-01.md`; promotion to binders remains Post-08  
- [x] **v2.5 deferred:** remote Deer Flow clusters, graph editing, memory sync — **canonical:** `docs/family-workspace-08-scope.md` § Deferred (still future work, not blockers)  
- [x] **Runtime script optimisation:** unified `udos-commandd` Python CLI — **indexed** in `family-duplication-and-pathway-candidates-2026-04-01.md` § Post-08 hooks; detail in `runtime-loop-optimization-flags-2026-03-30.md`  
- [x] **Themes:** adapter beyond scaffold — **indexed** in duplication report § Post-08 hooks; execution in `uDOS-themes/@dev/next-round.md`

## Done or improved (2026-04-01)

- [x] **Roadmap drift:** `v2-roadmap-status.md` § Current focus aligned with **completed `v2.5`**, **Workspaces 01–08 closed**, and **`docs/workspace-08-exit-evidence.md`**  
- [x] **`v2-family-roadmap.md`** Cursor handoff and baseline refreshed (post-08)  
- [x] **Workspace 08 exit gate:** `docs/workspace-08-exit-evidence.md`; `docs/cursor-focused-workspaces.md` § Workspace 08 **Closed**; `CURSOR_HANDOVER_PLAN.md` post-08 position  
- [x] **Gap-closure matrix ledger:** round note **Progress** terminal; duplication report + bloat ledger marked **Done**; tier-1 **08-doc snapshots** checked; `active-index` splits 08-doc vs Post-08 wiki  
- [x] **GitHub contract:** explicit `docs/github-actions-family-contract.md`  
- [x] **Workspace 05 spec baseline:** `docs/gui-system-family-contract.md`  
- [x] **Songscribe stem stack:** optional Compose overlay in `uDOS-groovebox/containers/songscribe/docker-compose.stem.yml` (clone upstream API beside compose)
- [x] **v2.3 schedule binder fixture** moved to `@dev/fixtures/binder-dev-v2-3-workflow-schedules.md` so `@dev/requests/` no longer lists a completed binder as an “active” request  
- [x] **Final round scaffold:** `@dev/notes/rounds/cursor-08-family-convergence-2026-04-01.md`, `docs/cursor-execution.md` § Step 8  
- [x] **Roadmap status reports:** `scripts/run-roadmap-status.sh` extracts `## Current Focus` correctly

## Docs alignment

- [x] **Public `docs/`** vs **`@dev/`** vs **`wiki/`** — **`docs/family-documentation-layout.md`** + `uDOS-docs/docs/local-vs-github-docs-boundary.md`  
- [x] **v1** architecture files in `uDOS-docs` — **`docs/family-workspace-08-scope.md`** § v1  
- [x] **Feeds/spool** — Core **`feeds-and-spool.md`** stable; pathway index + migration-feed defer recorded in **`family-duplication-and-pathway-candidates-2026-04-01.md`**  

## Tier 1 repos — quick checklist

**Workspace 08:** each row **closed** as an **08-doc snapshot** (gap matrix § C + exit evidence § 1). Ongoing product alignment stays **Post-08** / repo-local PRs, not open matrix rows.

| Repo | Aligned structure / install story | Notes |
| --- | --- | --- |
| uDOS-core | [x] 08-doc snapshot | pathways + **`feeds-and-spool.md`** stable ref — matrix § C |
| uDOS-ubuntu | [x] 08-doc snapshot | command-centre, vitals, compost, **`docs/github-actions-family-contract.md`** — exit § 1 |
| uDOS-wizard | [x] 08-doc snapshot | orchestration, Deer Flow, Svelte operator — exit § 1 + GUI contract |
| uDOS-shell | [x] 08-doc snapshot | Core invoke + health — matrix § C |
| uDOS-dev | [x] roadmap + handoffs + audit refreshed | control plane |
| uDOS-docs | [x] 08-doc snapshot | hub + GKL + publishing trio; wiki/card sync **Post-08** |
| uDOS-thinui | [x] 08-doc snapshot | surfaces vs Core — **`docs/gui-system-family-contract.md`** |
| uDOS-themes | [x] 08-doc snapshot | scaffold + Post-08 adapter — matrix row 6 |
| uDOS-workspace | [x] 08-doc snapshot | binder + execution — matrix § C |
| uDOS-grid | [x] 08-doc snapshot | **`docs/repo-family-map.md`** — matrix § C |

## Cursor execution position

- **Closed:** Workspaces **01–08** (round files through `@dev/notes/rounds/cursor-08-family-convergence-2026-04-01.md` **CLOSED**).  
- **Post-08:** no Workspace 09; follow **`docs/workspace-08-exit-evidence.md` § 3** and **`CURSOR_HANDOVER_PLAN.md`**; engineering backlog in **`v2-family-roadmap.md`**.

## Next actions

1. **Post-08 execution:** backlog items in **`@dev/requests/active-index.md`**, pathway promotion per **`docs/next-family-plan-gate.md`**, and **`v2-family-roadmap.md` § Engineering backlog** — see exit evidence § 3.  
2. **Optional:** open a **new dated** audit when a coordinated **`v2.x`** family plan is named or major backlog themes shift.
