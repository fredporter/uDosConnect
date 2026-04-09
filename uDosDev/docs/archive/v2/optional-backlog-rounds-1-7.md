# Optional backlog — dedicated rounds 1–7

Status: **Rounds 1–7** **completed** **2026-04-03**  
Updated: 2026-04-03

This ledger sequences **post-`v2.5` / post-O1–O4** engineering backlog work as **named rounds** without opening a new `v2.x` family plan until `docs/next-family-plan-gate.md` says so.

**Sequence status:** **Rounds 1–7** are **complete** **2026-04-03**. Further coordination uses **`v2-family-roadmap.md`** § Engineering backlog (continuous), repo-local PRs, and the next-plan gate — not additional rows here unless the family defines a new optional sequence.

**Gate rule:** Opening **`v2.6+`** still requires the gate doc. These rounds are **family coordination labels** for optional execution, not a replacement version plan.

**Round 1 note (closed):** `@dev/notes/rounds/optional-backlog-round-1-2026-04-03.md`  
**Round 2 note (closed):** `@dev/notes/rounds/optional-backlog-round-2-2026-04-03.md`  
**Round 3 note (closed):** `@dev/notes/rounds/optional-backlog-round-3-2026-04-03.md`  
**Round 4 note (closed):** `@dev/notes/rounds/optional-backlog-round-4-2026-04-03.md`  
**Round 5 note (closed):** `@dev/notes/rounds/optional-backlog-round-5-2026-04-03.md`  
**Round 6 note (closed):** `@dev/notes/rounds/optional-backlog-round-6-2026-04-03.md`  
**Round 7 note (closed):** `@dev/notes/rounds/optional-backlog-round-7-2026-04-03.md`

## Summary table

| Round | Title | Owner (primary) | Status |
| --- | --- | --- | --- |
| **1** | ThinUI unified workspace — binder data source | `uDOS-thinui` + `uDOS-dev` docs | **completed** **2026-04-03** |
| **2** | GitHub contract roll-forward | `uDOS-host` + `uDOS-dev` | **completed** **2026-04-03** |
| **3** | Docs + wiki hub hygiene | `uDOS-dev` + `uDOS-docs` | **completed** **2026-04-03** |
| **4** | Runtime lane / host checks hardening | `uDOS-host` + `uDOS-dev` | **completed** **2026-04-03** |
| **5** | Next `v2.x` gate packet | `uDOS-dev` | **completed** **2026-04-03** (**defer** new plan) |
| **6** | Deferred product shaping (RFC-only) | family | **completed** **2026-04-03** |
| **7** | Dev workflow + inbox adoption | `uDOS-dev` | **completed** **2026-04-03** |

---

## Round 1 — ThinUI unified workspace: binder data source (**completed** **2026-04-03**)

- **Goal:** Treat binder payload as **injected data**, not only a static import — first step toward Core/host bridge.
- **Delivered:**
  - `BinderWorkspaceSource` + `createBinderSourceFromLocationSearch` / `createFetchBinderSource` / `createBundledDemoBinderSource` in `uDOS-thinui/src/workspace/binder-source.ts` (re-exported from `src/index.ts`).
  - Workspace demo async bootstrap with error surface in `#ws-main`.
  - Query param **`?binder=<url>`**; public static **`demo/public/demo-binder.json`** (`?binder=/demo-binder.json`).
  - **`docs/thinui-unified-workspace-entry.md`** updated.
- **Validation:** `npm run typecheck` + `npm run build:demo` in `uDOS-thinui`.
- **Sign-off (2026-04-03):** ThinUI `npm run typecheck` re-run; OB-R1 scope unchanged.

---

## Round 2 — GitHub contract roll-forward (**completed** **2026-04-03**)

- **Goal:** Reduce `missing-local-repo` / drift in family conformance; align remaining public repos with `docs/github-actions-family-contract.md`.
- **Delivered:**
  - **`UDOS_GITHUB_CONTRACT_REPO_ROOTS`** in `automation/check-github-contract-rollforward.sh` for sibling trees (`sonic-family`, `uHOME-family`, …).
  - **Script-owned** = local `bash scripts/` / `run-*-checks.sh` **or** `uses:` of **`uDOS-dev`** reusable validate / family-policy workflows.
  - **`uHOME-app-android` / `uHOME-app-ios`:** `family-policy-check.yml` added (reusable policy).
  - Baseline report sections **A** (default root) + **B** (extended roots): `@dev/notes/reports/github-contract-rollforward-baseline-2026-04-03.md`
  - **`docs/github-actions-family-contract.md`** updated (tracking aid).
- **Exit:** Round note **CLOSED**; strict check with extended roots **pass** on maintainer machine.

---

## Round 3 — Docs + wiki hub hygiene (**completed** **2026-04-03**)

- **Goal:** Keep Learning Hub / `family-source.json` / `wiki_units` aligned when wiki units ship (`@dev/requests/active-index.md`).
- **Delivered:**
  - **`scripts/verify-o4-operational-hygiene.sh`** — pass (2026-04-03).
  - **`@dev/requests/active-index.md`** — OB-R3 pointer for requests **1–2** + hub edit discipline.
  - **`docs/family-documentation-layout.md`** — backlog item **4** (OB-R3 cadence).
  - Report: **`@dev/notes/reports/optional-backlog-round-3-2026-04-03.md`**
- **Exit:** Round note **CLOSED**; continuous hygiene remains on contributors when shipping wiki/hub changes.

---

## Round 4 — Runtime lane / host checks hardening (**completed** **2026-04-03**)

- **Goal:** Optional extraction and clarity in Ubuntu/dev check scripts; `udos-commandd` contract validation path (`v2-family-roadmap.md` engineering backlog).
- **Delivered:**
  - **`uDOS-host/scripts/lib/verify-ubuntu-static-contracts.py`** — static checks extracted from **`run-ubuntu-checks.sh`** (udos-commandd + web + policy examples).
  - **`run-ubuntu-checks.sh`** invokes the module; **`scripts/README.md`** updated.
  - Report: **`@dev/notes/reports/optional-backlog-round-4-2026-04-03.md`**
- **Scope:** No new default Docker dependency; shared-runtime contract unchanged.
- **Exit:** Backlog row re-scoped; further manifest/DRY refactors **deferred** repo-local optional in **`uDOS-host`**.

---

## Round 5 — Next `v2.x` gate packet (**completed** **2026-04-03**)

- **Goal:** One decision-ready brief: whether to open `v2.6` (or themed plan), candidate binders, and multi-repo scope.
- **Scope:** `docs/next-family-plan-gate.md` criteria applied; output in `docs/` or `@dev/notes/roadmap/`.
- **Decision:** **Defer** opening a new **`v2.x`** — coordinated-scope and backlog-overflow criteria **not** met; remain on repo semver + engineering backlog + optional rounds.
- **Delivered:** `@dev/notes/reports/optional-backlog-round-5-2026-04-03.md`; `docs/next-family-plan-gate.md` Related link; `v2-roadmap-status.md` + `v2-family-roadmap.md` updated.
- **Exit:** Explicit **defer** recorded; round note **CLOSED**.

---

## Round 6 — Deferred product shaping (RFC-only) (**completed** **2026-04-03**)

- **Goal:** Scope-only documents for items in `docs/archive/v2/family-workspace-08-scope.md` § Deferred (e.g. remote Deer Flow clusters, graph editing, memory sync) — **no implementation commitment**.
- **Delivered:** **`docs/deferred-product-rfc-stubs.md`** (RFC-DEF-01…03); links from **`family-workspace-08-scope.md`**, **`@dev/pathways/README.md`**, **`v2-roadmap-status.md`** Deferred bullet.
- **Report:** **`@dev/notes/reports/optional-backlog-round-6-2026-04-03.md`**
- **Exit:** RFC stubs linked from roadmap deferred bullet or pathway index — **met**. Round note **CLOSED**.

---

## Round 7 — Dev workflow + inbox adoption (**completed** **2026-04-03**)

- **Goal:** Contributors use **`docs/dev-inbox-framework.md`** + **`docs/dev-inbox/`** for briefs; `@dev/inbox/` stays local scratch.
- **Delivered:** **`docs/pr-checklist.md`** (dev inbox section + PR checkbox); **`docs/family-workflow.md`** (cross-links, Open-stage template); **`docs/dev-inbox-framework.md`** Related → **`pr-checklist.md`**; **`.github/instructions/dev-workflow.instructions.md`**; **`AGENTS.md`** (repo root).
- **Report:** **`@dev/notes/reports/optional-backlog-round-7-2026-04-03.md`**
- **Exit:** Checklist in round note; **`@dev/inbox/`** not versioned — **met**. Round note **CLOSED**.
- **Supplement (2026-04-05, not a new OB round):** **`docs/dev-inbox/guidelines/`** (how to submit), **`scripts/bootstrap-dev-inbox.sh`**, **`docs/inbox-ingest/README.md`** (promotion index) — extends OB-R7 without reopening the ledger.

## Related

- `v2-family-roadmap.md` — engineering backlog
- `v2-roadmap-status.md` — Current Focus
- `docs/thinui-unified-workspace-entry.md` — ThinUI workspace pointer
- `post-08-optional-rounds.md` — historical O1–O4 (complete)
