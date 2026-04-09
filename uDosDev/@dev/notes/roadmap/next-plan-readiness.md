# Next family plan readiness (pre-`v2.7+`)

**Updated:** 2026-04-05  
**Gate:** `docs/next-family-plan-gate.md`  
**OB-R5 packet:** `@dev/notes/reports/optional-backlog-round-5-2026-04-03.md`  
**Prior plan runbook:** `docs/preparing-for-v2-6.md` ( **`v2.6`** open → close )

This note is **not** a named version plan. It is a **prep checklist** for the day you intentionally want to **open** a new `v2.x` (e.g. `v2.7` or a themed codename) after the gate in `docs/next-family-plan-gate.md` is satisfied.

## Default (below gate — no active numbered plan)

**`v2.6`** is **completed** (`v2.6-rounds.md`, **`scripts/run-v2-6-release-pass.sh`**). Until **both** gate triggers are true for a **future** plan, stay on:

- repo-local **semver** from baseline **`2.3.0`** (`docs/pr-checklist.md`, `v2-family-roadmap.md`)
- **`v2-family-roadmap.md`** § Engineering backlog (continuous)
- optional **repo PRs** for features that fit without a family round ledger

Automated **below-gate** bundle: **`scripts/verify-engineering-backlog-below-gate.sh`** (gate-doc integrity + GitHub contract roll-forward strict check).

**Closed plan record:** **`v2.6-rounds.md`** — binder/workspace spine rounds **A–E**; closure handoff **`@dev/notes/rounds/v2-6-family-plan-closed-2026-04-05.md`**.

## When you believe the gate has tripped

Complete this packet **before** adding `v2.X-rounds.md`:

1. **Coordinated scope** — List tier-1 repos that **must** move in **lockstep**, the **contract or behaviour** that forces that, and the **round order** (owner per round).
2. **Backlog overflow** — Explain why the engineering backlog **table** cannot hold the work honestly (cross-cutting volume, promotion narrative, or tagging train).
3. **Draft rounds** — Working titles for Round A/B/C (or your shape), exit criteria, and candidate **binder IDs** (`#binder/...`).
4. **Risk / rollback** — What breaks if a round slips; how to roll back or narrow scope.
5. **Evidence** — Links to reports, failing checks, or product drivers that justify **now** vs later.

Then follow **`docs/next-family-plan-gate.md`** § “What opening a plan means” (rounds file, `v2-roadmap-status.md`, baseline, handoff note).

## `v2.6` opening packet (historical — plan closed 2026-04-05)

The packet below was used to **open** **`v2.6`** (sign-off **2026-04-04**). **Closing** evidence: **`@dev/notes/reports/v2-6-release-pass-2026-04-05-111537.md`**; **`@dev/notes/rounds/v2-6-family-plan-closed-2026-04-05.md`**. Use the **five-item template** in § **When you believe the gate has tripped** for a **future** `v2.7+` draft.

### 1. Coordinated scope (lockstep repos + round order) — v2.6

| Field | Content |
| --- | --- |
| **Primary theme** | Binder / workspace spine: aligned binder payload, Core normalization/consumption contracts, ThinUI workspace bridge, `uDOS-workspace` operator state, `uDOS-host` parity checks (`v2.6-rounds.md` **A→E**). |
| **Tier-1 repos that must move in sequence** | `uDOS-core` (A), `uDOS-thinui` (B), `uDOS-workspace` (C), `uDOS-host` (D), `uDOS-dev` (E). `uDOS-wizard` / `uDOS-surface` participate where broker or surfaces consume the same contracts — coordinate in Round A/C as needed. |
| **Contract or behaviour forcing lockstep** | Binder-facing payloads and MDC/document surfaces must not drift between Core schemas, workspace consumption, ThinUI demos, and host static checks; host `run-ubuntu-checks.sh` must stay green when sibling repos change. |
| **Round order** | **A** contract alignment → **B** ThinUI bridge → **C** workspace consumption → **D** host parity → **E** family validation (see `v2.6-rounds.md`). |

### 2. Backlog overflow (why the engineering table is not enough)

The **`v2-family-roadmap.md`** § Engineering backlog row for **ThinUI unified workspace** already defers Core bridge and dependent landings to a **next-plan** wave. **`v2.6`** supplies the **version-round ledger**, explicit **round owners**, and a **promotion narrative** across four tier-1 repos plus dev — i.e. cross-cutting volume and sequencing that ad-hoc PRs cannot represent without losing dependency order. Maintenance-only rows (GitHub roll-forward hygiene, gate script upkeep) **stay** in the backlog table; they are **not** substitutes for **`v2.6` rounds**.

### 3. Draft rounds (exit criteria + binders)

Source of truth: **`v2.6-rounds.md`**. Before opening: replace **illustrative** `#binder/...` IDs with accepted family binders; add measurable exit criteria per round (e.g. Core: new/updated contract artifacts + tests; ThinUI: typecheck + demo; workspace: operator state fields; host: `run-ubuntu-checks.sh` + doc updates; dev: `run-dev-checks.sh` + roadmap evidence).

### 4. Risk / rollback

| Risk | Mitigation |
| --- | --- |
| Round A slips | B/C may proceed on **frozen** contract snapshot from A branch; document SHA or tag. |
| ThinUI bridge incomplete | Narrow C to read-only consumption; defer write-back to a follow-up round or patch. |
| Host check failures | Stop D until `uDOS-host` green; do not tag family promotion. |
| Scope creep (Docker wave, DEF RFCs) | Keep **Theme B/C** out of default `v2.6` unless gate packet is explicitly revised. |

### 5. Evidence (why now)

- **OB-R1** delivered `BinderWorkspaceSource` and `?binder=` path; **v2.6** is the coordinated **contract + consumption** follow-on, not a duplicate OB round.
- **Shared-runtime / host** phase-1 checks and **`uDOS-host`** rename (`uDOS-host`) stabilized the command-centre baseline for Round D.
- **Operator need:** single narrative for binder-native workspace across ThinUI, workspace, and Core — matches **`docs/thinui-unified-workspace-entry.md`** direction.

### Sign-off (activation — 2026-04-04) — historical

Maintenance pass completed (`docs/preparing-for-v2-6.md` § 2): **`run-dev-checks.sh`**, **`check-github-contract-rollforward.sh`** (with `ROOT_DIR` + `UDOS_GITHUB_CONTRACT_REPO_ROOTS`), **`uDOS-host`** **`run-ubuntu-checks.sh`**. Gate packet **1–5** accepted; **`v2.6`** opened per **`v2.6-rounds.md`** promotion checklist and **`@dev/notes/rounds/v2-6-family-plan-opened-2026-04-04.md`**.

### Sign-off (closure — 2026-04-05)

Rounds **A–E** completed; **`scripts/run-v2-6-release-pass.sh`** green; roadmap baseline set to **prior completed** **`v2.6`**; **`docs/next-family-plan-gate.md`** restored to **below-gate** posture for **`v2.7+`**.

## Draft candidate themes (not opened — fill when triaging)

These are **starter sketches** only. Replace with your real scope when (and only when) both gate triggers are true. **Do not** add `v2.X-rounds.md` from this section alone.

### Theme A — Binder workspace spine (ThinUI ↔ Core ↔ host) — **delivered as `v2.6`**

**`v2.6`** (2026-04-04 → 2026-04-05) closed this theme for the **spine v1** slice. Further coordinated binder/workspace work either ships as **backlog + PRs** or becomes a **new** gate-approved plan (e.g. **`v2.7`**) with fresh binders.

| Field | Placeholder for a **future** plan (not `v2.6`) |
| --- | --- |
| **Why coordinated** | Only if a new cross-repo contract or behaviour **again** forces lockstep landings. |
| **Tier-1 repos (candidate)** | Depends on scope; see gate packet. |
| **Example binder IDs** | New IDs in a new `v2.*-rounds.md` — do not recycle **`v2.6`** binders. |
| **Overflow argument** | Must satisfy **`docs/next-family-plan-gate.md`** § Open a new plan when. |

### Theme B — Shared runtime / Docker-replacement tranche

| Field | Draft placeholder |
| --- | --- |
| **Why coordinated** | Lifecycle matrix and host checks touch **`uDOS-host`**, **`uDOS-groovebox`**, **`uDOS-dev`** fixtures, and sibling docs together. |
| **Tier-1 repos (candidate)** | `uDOS-host`, `uDOS-groovebox`, `uDOS-dev` |
| **Example binder IDs** | `#binder/family-v2-x-shared-runtime-phase-N` (illustrative) |
| **Overflow argument (draft)** | Further phase work beyond current **`shared-runtime-resource`** / O3 checks may need a promotion story **if** you plan a tagged alignment wave. |

### Theme C — Deferred product RFCs (only if reopening as product)

| Field | Draft placeholder |
| --- | --- |
| **Source** | `docs/deferred-product-rfc-stubs.md` (DEF-01…03) |
| **Gate bar** | Usually **higher** than A/B: needs explicit product pull and security posture, not “family hygiene.” |

Pick **one** primary theme per plan; merge or sequence others only if the gate packet proves they cannot ship as backlog + PRs.

## Operator cadence (below gate)

- Before substantive **`uDOS-dev`** governance or automation edits: **`bash scripts/run-dev-checks.sh`** (includes **`scripts/verify-engineering-backlog-below-gate.sh`**).
- After large family moves or version-round chatter: **`bash scripts/run-roadmap-status.sh`** and reconcile **`v2-roadmap-status.md`** / **`v2-family-roadmap.md`** as needed.
- Re-read **`docs/next-family-plan-gate.md`** when you think coordinated scope **and** backlog overflow may both be true; only then start filling the five-item packet above for real.

## Related

- `docs/preparing-for-v2-6.md` — **`v2.6`** maintenance through close; **§ After `v2.6`**
- `v2.6-rounds.md` — **completed** rounds **A–E**
- `docs/next-family-plan-gate.md` — when to name **`v2.7+`**
- `v2-family-roadmap.md` — engineering backlog + version index
- `v2-roadmap-status.md` — live ledger
- `docs/deferred-product-rfc-stubs.md` — deferred themes stay RFC-only until product need
- `docs/post-08-backlog-snapshot.md` — post-08 checklist (closed sections)
- `docs/README.md` — family dev docs index (links here + gate doc)
- `docs/pr-checklist.md` — semver + named-plan reminder
