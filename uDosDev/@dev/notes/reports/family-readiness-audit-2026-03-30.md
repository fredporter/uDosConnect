# Family readiness audit

- generated: 2026-03-30
- purpose: snapshot **current vs planned release-shaped work**, backlog, docs
  alignment, and **cross-cutting themes** for targeted Cursor workspace rounds.

**Superseded for day-to-day use** by **`family-readiness-audit-2026-04-01.md`**
(roadmap reconciliation, Workspace 05 open, GitHub + GUI contract docs). This
file remains as a historical snapshot.

## Cross-cutting themes (weave through lanes 01–08)

These threads should be **explicit in each relevant round**, not left to ad hoc
cleanup at the end.

| Theme | Intent | Primary lanes |
| --- | --- | --- |
| **Binder + DeerFlow workflow** | Documented, repeatable compile/execution path: Binder ↔ Wizard Deer Flow ↔ workspace consumption; preview vs controlled execution clear. | 05, 07, 08 |
| **Binder + spool synchronicity** | Feeds/spool semantics stay aligned with binder and workflow surfaces (what lands in spool, when, and how it relates to binder lifecycle). | 01, 05, 07, 08 |
| **Clean as we go** | Each lane leaves repos tidier: scripts, docs, `@dev` notes, no orphan cruft. | all |
| **Compost heap** | **Organic** `.compost` / superseded material: build, compact, rotate; local-only policy respected; no silent migration of runtime state. | 02, 08 |
| **System vitals** | Health checks, monitoring hooks, and optimisation paths for **runtime** (`~/.udos/`), hosts (Ubuntu), and family scripts — documented and runnable. | 01, 02, 08 |

## Family backlog (open)

- [ ] `uDOS-dev/@dev/requests/active-index.md` — docs consolidation; Ubuntu host/surface wording; wiki unit per repo
- [x] `v2-roadmap-status.md` — current-focus reconciled to post-`v2.5` / post-08 execution mode; next family plan still gated by `docs/next-family-plan-gate.md`
- [x] Family Docker posture decision — lock Docker as transitional compatibility and target shared uDOS-native runtime/resource replacement (aggressive migration)
- [x] `docs/release-tier-map.md` — restored at `uDOS-dev/docs/release-tier-map.md` (**2026-03-30**, Workspace 02)
- [ ] Pathways: `logs-feeds-and-spool-candidate.md`: roadmap when ready
- [ ] `uDOS-docs/@dev/pathways/image-ingestion-md-candidate.md`: future round
- [ ] v2.5 deferred (remote Deer Flow clusters, graph editing, memory sync import/export) — tracked, not forgotten

## Docs and v1 narrative

- [ ] **Public `docs/`** vs **`@dev/`** vs **`wiki/`** — consistent per `uDOS-docs` and `uDOS-dev` guidance
- [ ] **v1** — assessment/archive architecture files (e.g. `uDOS-docs/architecture/05_*`) are **history**, not duplicate v2 manuals; **OK** if policy is “no verbose v1 product docs in Tier-1 repos”
- [ ] **Condensed history via log/feed/spool** — Core `feeds-and-spool.md` + contracts; **family-wide migration feed** not yet a single artefact (optional follow-up)

## Tier 1 repos — quick checklist

Use Cursor lanes (`cursor-execution.md`) to drive completion; do not treat this
table as a second ordering system.

| Repo | Aligned structure / install story | Notes |
| --- | --- | --- |
| uDOS-core | [ ] contracts + docs match pathways | feeds/spool stable ref |
| uDOS-ubuntu | [ ] command-centre + vitals + compost story | active request: host/surface |
| uDOS-wizard | [ ] orchestration + Deer Flow docs | deferred features listed |
| uDOS-shell | [ ] Core + health entrypoints | |
| uDOS-dev | [ ] roadmap hygiene; broken links fixed | control plane |
| uDOS-docs | [ ] hub + GKL + seeds | consolidation request |
| uDOS-thinui | [ ] surfaces vs Core ownership | |
| uDOS-themes | [ ] beyond scaffold (`@dev/next-round`) | |
| uDOS-workspace | [ ] binder + execution surfaces | |
| uDOS-grid | [ ] branch/tag vs family | |

## Next actions

1. ~~Run **cursor-01** onward~~ **Done (2026-03-30):** hub `docs/runtime-spine.md`,
   `uDOS-ubuntu` **implements** `~/.udos/` layout via `scripts/lib/runtime-layout.sh`
   + `udos-hostd.sh`; checks green. Round:
   `@dev/notes/rounds/cursor-01-runtime-spine-2026-03-30.md`.
   ~~**cursor-02**~~ **Done (2026-03-31):** `docs/foundation-distribution.md`, foundation proof scripts, browser step 3 on command centre — `@dev/notes/rounds/cursor-02-foundation-distribution-2026-03-30.md`. **Next:** **cursor-03** (`cursor-03-uhome-stream.code-workspace`).
2. ~~Fix **release-tier-map** link or restore file.~~ **Done** — `docs/release-tier-map.md`.
3. Refresh **v2-roadmap-status** “Current focus” after next family plan is named.
