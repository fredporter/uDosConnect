# Optional backlog Round 5 — next `v2.x` gate packet

Date: 2026-04-03  
Authority: `docs/next-family-plan-gate.md`  
Ledger: `docs/optional-backlog-rounds-1-7.md`

## Question

Should the family **name** a new numbered plan (**`v2.6`** or other **`v2.x`**) now, or stay on **repo-local semver** + **engineering backlog** + **optional backlog rounds**?

## Gate criteria (both required to open a new plan)

1. **Coordinated scope** — same sequencing / contract change across **multiple** tier-1 repos with an agreed **round order** (binder-style), **and**
2. **Backlog overflow** — scope too large to track honestly in the engineering backlog table without a version-round ledger and promotion narrative.

## Assessment (2026-04-03)

| Criterion | Verdict | Notes |
| --- | --- | --- |
| **1. Coordinated scope** | **Not met** | No active programme requires a **family-wide** round train (contrast: `v2.4` workspace/MDC/UCI, `v2.5` execution). OB-R1–R4 are incremental (ThinUI source, GitHub contract tooling, docs hygiene, Ubuntu check extraction). |
| **2. Backlog overflow** | **Not met** | `v2-family-roadmap.md` § Engineering backlog remains the right surface; **`docs/optional-backlog-rounds-1-7.md`** covers optional execution without a new `v2.*-rounds.md`. |

## Decision

**Defer** opening a new **`v2.x`** family plan.

- **Mode:** default from `docs/next-family-plan-gate.md` — baseline **`2.3.0`**, patch bumps, family approval for minor/major per `docs/pr-checklist.md`.
- **Revisit** when **both** gate criteria are satisfied (examples: platform-wide breaking contract wave; multi-repo release train needing tagged alignment and a single promotion story).

## Record

- Round note: `@dev/notes/rounds/optional-backlog-round-5-2026-04-03.md` **CLOSED**
- `v2-roadmap-status.md` **Current Focus** — OB-R5 complete; decision **defer**
- `v2-family-roadmap.md` — Next `v2.x` backlog row updated

## Next optional round

- **OB-R6** — deferred product shaping (RFC-only), per `docs/optional-backlog-rounds-1-7.md`.
