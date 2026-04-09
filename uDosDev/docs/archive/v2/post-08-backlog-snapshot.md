# Post–Workspace 08 backlog snapshot (checklist)

**Status:** living checklist — refresh after major family moves  
**Updated:** 2026-04-04 (next-plan readiness cross-link)  
**Authority:** Cursor **01–08** are **closed**; continuation is **post-08** only — see `docs/archive/v2/workspace-08-exit-evidence.md` § 3, `docs/archive/v2/cursor-execution.md`, `CURSOR_HANDOVER_PLAN.md`.

Use this page as a **single entry** for “what is left after the numbered lanes.” It does **not** reopen the Workspace 08 gap matrix; items here are **backlog**, **elective**, or **future plan** material.

**Ledger (2026-04-02):** Sections **A–G** are **closed** in this snapshot (all items checked). Further multi-repo work is **gate-controlled** (`docs/next-family-plan-gate.md`) or **repo-local** maintenance (wiki hub sync, optional themes tranches).

**Optional backlog (2026-04-03):** Dedicated rounds **OB-R1–OB-R7** in **`docs/archive/v2/optional-backlog-rounds-1-7.md`** are **complete**. The **`v2-family-roadmap.md`** § Engineering backlog table was reconciled the same day (stale “next round” pointers removed; standing maintenance and gate doctrine retained).

**Execution rounds:** `@dev/notes/roadmap/post-08-optional-rounds.md` (O1–O4 — **complete**).

---

## How to use

- Treat unchecked items as **candidates** for repo-local work on **`main`** (or short-lived branches when needed).
- For **when to name `v2.6+`**, use **`docs/next-family-plan-gate.md`** only — do not infer a new plan from this list alone. When preparing evidence for a future plan, use **`@dev/notes/roadmap/next-plan-readiness.md`** (draft themes + checklist; not a named `v2.x`).
- After large doc or repo reshuffles, run **`bash scripts/run-roadmap-status.sh`** and consider refreshing `@dev/notes/reports/family-readiness-audit-*.md`.

---

## A. Active family requests (`@dev/requests/active-index.md`)

- [x] **Request 1 — acceptance tail (normalized):** converted from one-off backlog item into an **operational maintenance rule**. When new **`wiki/`** units ship in any repo, update **`uDOS-docs`** `site/data/family-source.json` (`wiki_units` + Learning Hub cards) and run `node scripts/generate-site-data.mjs` + `run-docs-checks.sh` in `uDOS-docs`.
- [x] **Request 3 — optional hub coverage:** optional/product repos with existing `wiki/unit-01-*` now included in **Learning Hub** `wiki_units` (`uDOS-groovebox`, `uDOS-alpine`, `uDOS-gameplay`, `uDOS-empire`, `uDOS-plugin-index`) and site data regenerated via `node scripts/generate-site-data.mjs` + `run-docs-checks.sh`.
- [x] **Request 2 — host vs broker wording (baseline):** post-08 baseline alignment complete; keep **Ubuntu / Wizard / Surface** vocabulary aligned during future doc edits (`gui-system-family-contract.md`, delegation boundary doc).

---

## B. Engineering backlog (`@dev/notes/roadmap/v3-roadmap.md` § Engineering backlog)

- [x] **Optional backlog rounds OB-R1–OB-R7 (2026-04-03):** ledger **`docs/archive/v2/optional-backlog-rounds-1-7.md`** — ThinUI workspace source, GitHub contract roll-forward, docs/wiki hygiene, Ubuntu static checks extraction, next-`v2.x` gate defer packet, deferred RFC stubs, dev-inbox adoption; reports under **`@dev/notes/reports/optional-backlog-round-*-2026-04-03.md`**.
- [x] **GitHub contract roll-forward (local-family sweep):** all locally available tracked repos in this workspace footprint are now aligned to **main-first + script-owned `Validate`** under **`docs/github-actions-family-contract.md`** (`uDOS-host` reference retained). **Tracking:** `automation/check-github-contract-rollforward.sh --report` currently shows all local targets aligned; only missing-local sibling repos report `missing-local-repo`.
- [x] **Unified `udos-commandd` Python CLI (baseline):** `uDOS-host/scripts/udos_commandd.py` now wraps `udos-commandd.sh` with matching subcommands and is validated in `uDOS-host/scripts/run-ubuntu-checks.sh`; family docs reference updated (`docs/udos-commandd-reference.md`). Optional deeper extraction from `run-ubuntu-checks` remains an optimisation choice, not a blocker.
- [x] **Ubuntu + Empire strict completion (local-lab):** strict contract + runbook published (`docs/ubuntu-empire-strict-completion-contract.md`, `docs/ubuntu-empire-strict-operations-runbook.md`), strict gates added in both repos (`uDOS-host/scripts/run-ubuntu-strict-completion-gate.sh`, `uDOS-empire/scripts/run-empire-strict-completion-gate.sh`), WordPress-md + data-safety contracts added in Empire, and readiness proof recorded (`@dev/notes/reports/ubuntu-empire-strict-readiness-2026-04-01.md`).
- [x] **Docker replacement (aggressive, backlog-normalized):** baseline family contract and Groovebox phase slices are complete; remaining broader rollout is now explicitly **next-plan gated** work (open only via `docs/next-family-plan-gate.md`, not as an unbounded post-08 checklist item).

---

## C. Pathways (indexed, promote when gate fits)

- [x] **Logs / feeds / spool (pathway status normalized):** indexed and retained as pathway candidates; promotion remains **gate-controlled** (`docs/next-family-plan-gate.md`).
- [x] **Image-ingestion-md and pathway stubs (status normalized):** indexed and retained as pathway candidates; promotion remains **gate-controlled** (`docs/next-family-plan-gate.md`).

---

## D. Themes (post–cursor-06 scaffold)

- [x] **Adapter phases / integration (backlog-normalized):** required post-08 scaffold tranches are complete; remaining items are optional repo-local enhancements (`uDOS-themes/@dev/next-round.md`) and not blocking family backlog closure.

---

## E. Deferred after `v2.5` (future plan material, not blockers)

Canonical list: **`docs/archive/v2/family-workspace-08-scope.md`** § Deferred features; RFC stubs **`docs/deferred-product-rfc-stubs.md`** (OB-R6).

- [x] **Remote Deer Flow clusters** captured as deferred future-plan material (non-blocking).
- [x] **Graph editing** captured as deferred future-plan material (non-blocking).
- [x] **Memory sync import/export** captured as deferred future-plan material (non-blocking).

---

## F. Next numbered family plan

- [x] **Next plan gate acknowledged:** do not open `v2.6+` until **`docs/next-family-plan-gate.md`** dual trigger is met; when met, add `v2.X-rounds.md` and update `v2-roadmap-status.md`.
- [x] **Roadmap status reconciled post-`v2.5` / post-08:** `v2-roadmap-status.md` current-focus section now reflects closed Cursor 01–08, engineering-backlog mode, and Docker-replacement phase-1 implementation.

---

## G. Spec / narrative alignment (ongoing vigilance)

These are **documented** in Workspace 08 scope; **implementation drift** is the risk — verify when changing binders, Wizard, workspace, or Core feeds/spool.

- [x] **Binder + DeerFlow (baseline):** preview vs controlled execution, artifact persistence, and operator read-path are documented; continue drift checks (`docs/archive/v2/family-workspace-08-scope.md` § Cross-cutting).
- [x] **Binder + spool synchronicity (baseline):** “binder complete” ↔ feed/spool semantics documented in Core (`uDOS-core/docs/feeds-and-spool.md`); deeper automation remains pathway work.
- [x] **`uDOS-docs` v1 vs current (baseline):** post-08 posture favors hub links and avoids duplicating full operator manuals under `uDOS-docs` when another repo owns the binary (`docs/archive/v2/family-workspace-08-scope.md` § v1).

---

## Related

- `docs/archive/v2/workspace-08-exit-evidence.md` § 3 (execution order)
- `@dev/notes/rounds/cursor-08-family-convergence-2026-04-01.md` (gap matrix — closed for 08)
- `@dev/notes/reports/family-readiness-audit-2026-04-01.md` § Final round
- `v2-roadmap-status.md` § Current Focus + Recent Outputs
- `@dev/notes/roadmap/post-08-optional-rounds.md`
- `docs/archive/v2/optional-backlog-rounds-1-7.md` (OB-R1–R7 — **complete** **2026-04-03**)
- `@dev/notes/roadmap/next-plan-readiness.md` (prep for a future `v2.x` — **not** an opened plan)
