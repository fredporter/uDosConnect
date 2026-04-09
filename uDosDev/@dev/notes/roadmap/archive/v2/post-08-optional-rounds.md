# Post-08 Optional Dev Rounds

Status: complete  
Updated: 2026-04-03

**Order:** **O1–O4** **closed 2026-04-02**; ledger and verify wiring **integrated on `main` 2026-04-03**. Post-08 optional sequence **complete** until a new backlog item reopens this ledger.

This ledger sequences the optional post-08 work without opening a new numbered
family plan. Use this in backlog mode on `main`.

Gate rule remains: only open a new `v2.x` family plan when
`docs/next-family-plan-gate.md` criteria are met.

Follow-on optional execution (after O1–O4): **`docs/archive/v2/optional-backlog-rounds-1-7.md`** (OB-R1…OB-R7).

## Round O1 - Themes optional integration closure

- Owner: `uDOS-themes` (+ `uDOS-wizard`, `uDOS-workspace` consumers)
- Scope:
  - package-level publish preset distribution path
  - direct Wizard surface consumption of workflow GTX map
  - docs and checks alignment in themes/workspace/wizard
- Exit gate:
  - `uDOS-themes/@dev/next-round.md` optional items marked done
  - consumer docs reference the same contract sources
  - checks pass in touched repos
- **Status: closed 2026-04-02** (including Shell CLI demo `demo-gtx-form-tui.mjs`).

## Round O2 - Pathways promotion tranche

- Owner: `uDOS-dev` (+ `uDOS-core`, `uDOS-docs`)
- Scope:
  - promote logs/feeds/spool candidate from pathway to binder-ready execution
  - promote image-ingestion-md candidate into a concrete docs+ingest lane
  - update pathway index and duplication report status lines
- Exit gate:
  - pathway docs include promotion decision and active owner
  - at least one runnable/verified script or checklist per promoted lane
  - `v2-roadmap-status.md` Recent Outputs updated
- **Status: closed 2026-04-02** — both candidates promoted; checklists + `verify-pathway-o2-logs-feeds-spool.sh` / `verify-o2-image-ingestion-lane.sh`; duplication report row 3 + pathways README updated.

## Round O3 - Docker replacement tranche 2 (broader rollout)

- Owner: `uDOS-dev` coordinating family repos
- Scope:
  - extend shared runtime/resource enforcement beyond Groovebox slice
  - migrate additional repos from docker-first assumptions to uDOS runtime lane
  - keep compose overlays compatibility-only with explicit sunset notes
- Exit gate:
  - target repos publish runtime ownership docs and checks
  - no new default docker dependency introduced in active checks
  - backlog row in `v2-family-roadmap.md` updated with tranche status
- **Status: closed 2026-04-02** — `ubuntu-wordpress-publish-stack` in lifecycle matrix; `uDOS-host/docs/docker-compose-compatibility.md` + `verify-docker-compose-compatibility-doc.sh`; `verify-o3-docker-compat-siblings.sh` in `run-dev-checks.sh`; Groovebox + shared-runtime contract docs updated; engineering backlog row refreshed.

## Round O4 - Operational hygiene cadence

- Owner: `uDOS-dev` + repo maintainers
- Scope:
  - wiki-unit to Learning Hub sync whenever new unit ships
  - host-managed venv policy drift checks (`~/.udos/venv/...`)
  - docs vocabulary drift checks (Ubuntu host vs Wizard broker vs Surface UI)
- Exit gate:
  - cadence report note in `@dev/notes/reports/` for the pass
  - no unresolved drift items in active repos touched during pass
- **Status: closed 2026-04-02** — `@dev/notes/reports/operational-hygiene-cadence-o4-2026-04-02.md`; `scripts/verify-o4-operational-hygiene.sh` + `@dev/fixtures/operational-hygiene-venv-lanes.v1.json` in `run-dev-checks.sh`.

## Execution order

Run O1 -> O2 -> O3 -> O4.  
If O2 or O3 expands into coordinated cross-repo contract churn beyond backlog
control, re-evaluate against `docs/next-family-plan-gate.md`.

## Related

- `docs/archive/v2/post-08-backlog-snapshot.md`
- `@dev/notes/roadmap/v3-roadmap.md` § Engineering backlog
- `@dev/notes/roadmap/v3-feed.md` § Current Focus / Recent Outputs
- `docs/next-family-plan-gate.md`
