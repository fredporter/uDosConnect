# Family duplication and pathway candidates

- **Generated:** 2026-04-01  
- **Workspace 08:** spec output 2 **Done** **2026-04-01**; **gap matrix rows 3, 5–6, 9, duplication ledger, manual dedup policy**

## Purpose

Central index for **candidate pathways** called out in the family readiness
audit—especially **logs / feeds / spool** and **image → markdown ingestion**—and
a stub for **duplication / bloat** themes that the full convergence pass will
expand. This file **does not** open binders; it records **Post-08** placement
and stable references so work does not sprawl unnamed.

## Pathway candidates (row 3)

| Candidate | Path | Status | Owner hint | Stable / related refs |
| --- | --- | --- | --- | --- |
| **Logs, feeds, spool** (family model) | `uDOS-dev/@dev/pathways/logs-feeds-and-spool-candidate.md` | **O2 promoted** **2026-04-02** | `uDOS-dev` coordinates; **`uDOS-core`** contract owner | **`uDOS-core/docs/feeds-and-spool.md`**; execution **`o2-logs-feeds-spool-execution-checklist.md`**; **`scripts/verify-pathway-o2-logs-feeds-spool.sh`** |
| **Image ingestion → markdown** | `uDOS-docs/@dev/pathways/image-ingestion-md-candidate.md` | **O2 promoted** **2026-04-02** | **`uDOS-docs`** lane; Core intake when scheduled | **`docs/image-ingestion-markdown-lane.md`**; **`o2-image-ingestion-md-execution-checklist.md`**; **`scripts/verify-o2-image-ingestion-lane.sh`** |

**Rule:** Promote a row to a **binder-backed round** only when scope and owners
clearly justify it (see **`docs/next-family-plan-gate.md`** for multi-repo
coordination). Until then, keep evolving the candidate files and contracts—no
duplicate “source of truth” prose in `uDOS-docs` for feeds/spool; link **Core**.

## Row 9 — family migration feed (feeds/spool)

An optional **family-wide migration feed** artefact (audit item) remains
**Post-08**: not required for Workspace 08 exit. When designed, it should align
with **`uDOS-core/docs/feeds-and-spool.md`** and the logs/feeds/spool pathway
candidate—not a parallel vocabulary.

## Tier-1 snapshot (matrix section C)

Detailed per-repo rows remain in **`@dev/notes/rounds/cursor-08-family-convergence-2026-04-01.md`**
§ C. **Duplication lens:** prefer one canonical manual per concern (repo `docs/`
or hub link); use **`docs/family-workspace-08-scope.md`** for v1 vs current split.

## Post-08 engineering hooks (rows 5–6)

| Hook | Owner | Reference | Notes |
| --- | --- | --- | --- |
| **Unified `udos-commandd` Python CLI** | `uDOS-ubuntu` | `@dev/notes/reports/runtime-loop-optimization-flags-2026-03-30.md` | Schedule next time Ubuntu/daemon scripts are refactored; not a Workspace 08 implementation gate |
| **Themes adapter beyond cursor-06 scaffold** | `uDOS-themes` | `uDOS-themes/@dev/next-round.md` | Phases C–E: ThinUI hydration, Tailwind Prose preset, Wizard/GTX id alignment, optional Shell demo |

## Manual deduplication policy (gap matrix row 1 — 08-doc)

**Rule:** Each operational concern has **one** canonical long-form manual in the
**owning repo’s** `docs/`. `uDOS-docs` **links**; it does not re-host full copies.
When adding prose, use **`docs/family-documentation-layout.md`** and **`docs/family-workspace-08-scope.md`** § v1.

**Ongoing (Post-08):** each new **wiki** unit must be registered in
`uDOS-docs/site/data/family-source.json` when promoted to the learning hub
(`@dev/requests/active-index.md` request 3). **2026-04-01:** tier-1 + Wizard +
Dev units listed under learning **Wiki Units** and the top-level **`wiki_units`**
array; run `uDOS-docs/scripts/generate-site-data.mjs` after edits.

## Duplication and bloat (ledger)

Workspace **08** treats the rows below as **closed for documentation**; reopen or extend on a **future dated** audit if drift appears.

| Theme | Note | Evidence / mitigation |
| --- | --- | --- |
| **Tier-1 manuals vs hub** | Avoid full v2 manuals duplicated under `uDOS-docs` when a repo owns the topic | `docs/family-documentation-layout.md` + § Manual deduplication policy above |
| **v1 architecture under `uDOS-docs`** | Historical / archive tone; link to current tier-1 docs | **`docs/family-workspace-08-scope.md`** § v1 |
| **Pathway vs contract drift** | Candidate pathways must not contradict Core contracts | This index + Core `feeds-and-spool.md` |

## Related

- `docs/family-workspace-08-scope.md` — deferred, v1 posture, cross-cutting themes
- `@dev/notes/rounds/cursor-08-family-convergence-2026-04-01.md` — gap matrix
- `@dev/pathways/README.md` — pathway lane index
- `@dev/notes/reports/family-readiness-audit-2026-04-01.md`
