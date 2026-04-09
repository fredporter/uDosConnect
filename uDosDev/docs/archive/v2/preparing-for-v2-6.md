# Preparing for `v2.6` (maintenance + backlog + gate)

**Purpose:** Historical runbook for **`v2.6`** (binder/workspace spine): maintenance before open, execution, and **closure up to the next-plan gate**.  
**Authority:** `docs/next-family-plan-gate.md`, `@dev/notes/roadmap/v2.6-rounds.md` (rounds **A–E**), `@dev/notes/roadmap/next-plan-readiness.md`.

**Closed 2026-04-05:** **`v2.6`** is **complete** (`v2.6-rounds.md`, **`scripts/run-v2-6-release-pass.sh`**, `@dev/notes/rounds/v2-6-family-plan-closed-2026-04-05.md`). **Next** numbered plan: follow **`docs/next-family-plan-gate.md`** when opening **`v2.7+`**.

## 1. What `v2.6` is (theme)

**Primary theme:** **Binder / workspace spine** — ThinUI ↔ Core ↔ workspace ↔ host — with **`uDOS-dev`** validation and governance in **Round E**. See **`@dev/notes/roadmap/v2.6-rounds.md`** for round owners and illustrative binders.

**Out of scope for the default `v2.6` cut** (unless the gate packet explicitly adds them):

- **Theme B** (shared-runtime / Docker-replacement wave) — track as follow-on or a later plan; see `next-plan-readiness.md` Theme B.
- **Theme C** (deferred product RFCs) — remain **`docs/deferred-product-rfc-stubs.md`** unless product reopens them.

## 2. Maintenance pass (before or parallel to Round A)

Complete so maintenance does not masquerade as version-round risk:

| Step | Action |
| --- | --- |
| **A** | From **`uDOS-dev`:** `bash scripts/run-dev-checks.sh` (includes `verify-engineering-backlog-below-gate.sh`). Fix failures before declaring gate ready. |
| **B** | **GitHub contract roll-forward:** `automation/check-github-contract-rollforward.sh` with your usual `ROOT_DIR` and `UDOS_GITHUB_CONTRACT_REPO_ROOTS` for sonic / uHOME siblings. Address drift or document exceptions in `docs/github-actions-family-contract.md`. |
| **C** | **`uDOS-host`:** `bash scripts/run-ubuntu-checks.sh` — host static contracts and required-file manifest must stay green for Round D. |
| **D** | **Engineering backlog review:** Walk `v2-family-roadmap.md` § Engineering backlog — close stale pointers, confirm standing rows (ThinUI bridge, gate automation) are either **in `v2.6` rounds** or **explicitly maintenance-only**. |
| **E** | **Optional snapshot:** `bash scripts/run-roadmap-status.sh`; promote a report with `git add -f` only if you need a dated artifact (see `pr-checklist.md` / `.gitignore`). |

## 3. Backlog completion (what “complete maintenance + backlog” means here)

- **OB-R1–R7** optional rounds are already **complete** (`docs/archive/v2/optional-backlog-rounds-1-7.md`). No duplicate OB ledger unless the family reopens a sequence.
- **“Complete backlog”** for `v2.6` prep means: **no open contradictions** in the engineering backlog table relative to `v2.6` (e.g. ThinUI follow-on either scheduled in **Round B** or explicitly deferred with a one-line note in `v2-family-roadmap.md`).
- **Post-08 snapshot** (`docs/archive/v2/post-08-backlog-snapshot.md`) stays **closed**; new work flows through **`v2.6` rounds** or continuous maintenance rows.

## 4. Gate packet (sign-off before opening)

Fill and approve the **five-item packet** in **`@dev/notes/roadmap/next-plan-readiness.md`** § **v2.6 opening packet (draft)**. That section is the **canonical draft**; this doc only points to it.

Dual trigger (from `docs/next-family-plan-gate.md`):

1. **Coordinated scope** — multi tier-1 repos, agreed round order (`v2.6-rounds.md` **A→E**).
2. **Backlog overflow** — work too cross-cutting to track only as ad-hoc PRs + the backlog table.

When both are accepted in writing (packet + maintainer sign-off), proceed to **section 5**.

## 5. Opening `v2.6` (promotion checklist)

Execute in order:

1. **`@dev/notes/roadmap/v2.6-rounds.md`** — Promotion checklist (replace illustrative binders, set round statuses, …).
2. **`v2-roadmap-status.md`** — Version table + **Current Focus**: **`active family plan: v2.6`**.
3. **`v2-family-roadmap.md`** — § Current Family Baseline + version index for `v2.6`.
4. **`@dev/notes/rounds/`** or devlog — handoff note (e.g. `v2-6-family-plan-opened-YYYY-MM-DD.md`).

## 6. Related

- `docs/next-family-plan-gate.md`
- `@dev/notes/roadmap/next-plan-readiness.md`
- `@dev/notes/roadmap/v2.6-rounds.md`
- `v2-family-roadmap.md` § Engineering backlog
- `docs/pr-checklist.md` — semver while preparing (`2.3.0` baseline; patch default)
- `docs/archive/v2/optional-backlog-rounds-1-7.md` — completed OB ledger (historical)

## 7. After `v2.6` (below the next-plan gate)

When **`v2.6`** rounds **A–E** and **`scripts/run-v2-6-release-pass.sh`** are complete:

1. **`v2-roadmap-status.md`** — **active family plan:** none; **prior completed:** `v2.6` (see ledger).
2. **`docs/next-family-plan-gate.md`** — default mode: repo-local semver + engineering backlog until **both** gate triggers justify a **`v2.7+`** named plan.
3. **`@dev/notes/roadmap/next-plan-readiness.md`** — use the five-item packet template for a **future** plan; do **not** reuse **`v2.6`** binders without a new rounds file.
4. **Deferred themes** — remote clusters, graph editing, memory sync remain **`docs/deferred-product-rfc-stubs.md`** (RFC-only) unless product reopens them.
5. **Inbox intake** — promoted drops are logged in **`docs/inbox-ingest/README.md`**; local **`@dev/inbox/`** is refreshed with **`scripts/bootstrap-dev-inbox.sh`** (see **`docs/dev-inbox/guidelines/`**).

Opening **`v2.7+`** still requires **`docs/next-family-plan-gate.md`** (dual trigger) plus a new **`v2.7-rounds.md`** (or equivalent) per that doc’s “What opening a plan means.”
