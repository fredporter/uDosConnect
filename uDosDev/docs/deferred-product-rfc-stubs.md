# Deferred product RFC stubs (post-`v2.5`)

**Status:** scope-only — **no implementation commitment**  
**Updated:** 2026-04-05 (review: prep cross-links + stance table)  
**Source:** `docs/archive/v2/family-workspace-08-scope.md` § Deferred features after `v2.5` (Workspace 08 row 4)  
**Optional backlog:** OB-R6 — `docs/archive/v2/optional-backlog-rounds-1-7.md`

These are **not** binders or execution tickets. They exist so deferred themes have a **stable link** from the roadmap until product need and `docs/next-family-plan-gate.md` justify a named plan or repo-owned work.

**Preparation notes (design-only, still no product commitment):**

- RFC-DEF-01 — `docs/rfc-def-01-remote-deer-flow-prep.md` (sequence, narrowed open questions)
- RFC-DEF-02 — `docs/rfc-def-02-graph-editing-prep.md` (read-first graph hypothesis + sample shape)
- RFC-DEF-03 — `docs/rfc-def-03-memory-sync-export-prep.md` (operator story, threat model, vocabulary)

### Review snapshot (2026-04-05)

| RFC | Theme | Prep doc stance | Still deferred (product) |
| --- | --- | --- | --- |
| DEF-01 | Remote / multi-node execution | Local default; remote opt-in; Wizard broker; workspace shows locality + pin vocabulary | Cluster product, runner fleet, real adapters |
| DEF-02 | Graph UX | Read-only projection first; workspace primary; Core contracts only if interchange needs it | Collaborative editor, write CRDT, ThinUI edit-first |
| DEF-03 | Portable memory | Explicit export/import; signed pack; audit; Wizard bounded | Vault format, crypto choice, merge implementation |

Opening a **named** family plan still requires `docs/next-family-plan-gate.md` (dual trigger). These rows are **not** that trigger.

---

## RFC-DEF-01 — Remote Deer Flow clusters

**Prep:** `docs/rfc-def-01-remote-deer-flow-prep.md`

- **Problem sketch:** Operators may eventually run Deer Flow (or equivalent) **off-box** or in **multi-node** topologies; `v2.5` only hardens **local controlled** execution.
- **Ownership:** **`uDOS-wizard`** (adapter / broker lane); Core for any contract surfaces if execution leaves the host boundary.
- **Boundaries:** Secrets, network trust, artifact egress, and “preview vs controlled” semantics must stay coherent with workspace consumption (`uDOS-workspace`).
- **Non-goals (until reopened):** shipping a cluster product; mandating Kubernetes; changing local-default posture.
- **Open questions:** identity for remote runners; pin/approval model across networks; cost and quota story. *(Narrowed sub-questions in prep doc.)*

---

## RFC-DEF-02 — Graph editing

**Prep:** `docs/rfc-def-02-graph-editing-prep.md`

- **Problem sketch:** Some workflows may want **structured graph** views (tasks, binders, spatial links) beyond trees and tables.
- **Ownership:** TBD by surface — likely **`uDOS-workspace`** / **`uDOS-grid`** for presentation; Core for identity/contract if graphs become first-class.
- **Boundaries:** Must not contradict binder-native truth or vault/spool semantics.
- **Non-goals (until reopened):** full collaborative real-time graph product; replacing markdown-first lanes.
- **Open questions:** CRDT vs server-authoritative; ThinUI vs browser ownership for editing UX. *(Write path deferred in prep doc.)*

---

## RFC-DEF-03 — Memory sync import/export

**Prep:** `docs/rfc-def-03-memory-sync-export-prep.md`

- **Problem sketch:** Operators may ask for **portable** memory or assistant context across machines or org boundaries.
- **Ownership:** **`uDOS-core`** (vault / memory contracts); **`uDOS-host`** for host-adjacent storage policy; Wizard only as a consumer/exporter if explicitly bounded.
- **Boundaries:** Local vault and family-owned artifacts remain **authoritative** per existing Core/Ubuntu docs; import/export must be **explicit, opt-in, and auditable**.
- **Non-goals (until reopened):** silent cloud sync; third-party memory SaaS as default.
- **Open questions:** encryption envelope; redaction; conflict policy on re-import.

---

## Related

- `docs/next-family-plan-gate.md` — when to name a new `v2.x` (family is **below** the gate after completed **`v2.6`**; deferred items do **not** reopen a plan by themselves)
- `@dev/notes/roadmap/v2-roadmap-status.md` § Current Focus (Deferred); full ledger `@dev/notes/roadmap/archive/v2/v2-roadmap-status.md`
- `@dev/notes/roadmap/archive/v2/v2.5-rounds.md`
- `@dev/notes/rounds/optional-backlog-round-6-2026-04-03.md` (OB-R6 closure)
