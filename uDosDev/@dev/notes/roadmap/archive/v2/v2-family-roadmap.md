# v2 Family Roadmap

Status: active  
Updated: 2026-04-05 (`v2.6` **completed** — release pass `scripts/run-v2-6-release-pass.sh`; prior plan since 2026-04-04 open)

## Purpose

This is the canonical live roadmap for the uDOS v2 repo family.

Use this file as the roadmap entrypoint inside `uDOS-dev/@dev`. Keep stable
process guidance in `docs/`, but keep active sequencing, round notes, and
current references in `@dev/notes/roadmap/`.

**Cursor handoff:** Workspaces **01–09** **closed** (01–08 **2026-04-01**; **09** Classic Modern MVP **2026-04-02**). **Workspace 08** (family convergence) **CLOSED**: **`cursor-08-family-convergence.code-workspace`**; **`docs/archive/v2/workspace-08-exit-evidence.md`**; round `@dev/notes/rounds/cursor-08-family-convergence-2026-04-01.md` **CLOSED**. **Post-08 optional O1–O4** **closed** (**2026-04-02** ledger; **2026-04-03** verify integration on `main` per `v2-roadmap-status.md`). **Optional backlog OB-R1–R7** **complete** (**2026-04-03** — `docs/archive/v2/optional-backlog-rounds-1-7.md`). Authority: `docs/archive/v2/cursor-execution.md`, `docs/archive/v2/cursor-focused-workspaces.md`, `docs/next-family-plan-gate.md`, `docs/archive/v2/family-workspace-08-scope.md`, `docs/family-documentation-layout.md`, `docs/family-operator-organisation-map.md`, `docs/udos-host-platform-posture.md`, `docs/family-first-run-operator-flow.md`, `docs/gui-system-family-contract.md`, `uDOS-themes/docs/display-modes.md`, `uDOS-docs/docs/themes-and-display-modes.md`, `uDOS-docs/docs/publishing-architecture.md`, `post-08-optional-rounds.md`.

## Canonical Roadmap Surfaces

- `v2-family-roadmap.md`
- `v2-roadmap-status.md`
- `post-08-optional-rounds.md` (optional backlog execution sequence O1-O4)
- `docs/archive/v2/optional-backlog-rounds-1-7.md` (optional backlog OB-R1…OB-R7 after O1–O4)
- `docs/github-actions-family-contract.md` (CI vs local SOT)
- `docs/next-family-plan-gate.md` (when to open **`v2.7+`** after completed **`v2.6`**)
- `docs/archive/v2/preparing-for-v2-6.md` (**`v2.6`** runbook — closed; **§ After `v2.6`**)
- `@dev/notes/roadmap/next-plan-readiness.md` (prep checklist before opening a future `v2.x`)
- `docs/dev-inbox-framework.md` + `docs/dev-inbox/` + **`docs/dev-inbox/guidelines/`** (distributable brief templates and submission how-tos; `@dev/inbox/` local-only via **`scripts/bootstrap-dev-inbox.sh`**); **`docs/inbox-ingest/README.md`** (promotion log); repo-root **`AGENTS.md`** (agent hint)
- `docs/thinui-unified-workspace-entry.md` (ThinUI binder shell demo pointer)
- `docs/archive/v2/family-workspace-08-scope.md` (deferred post-`v2.5`, v1 docs posture, cross-cutting themes; Workspace 08)
- `docs/deferred-product-rfc-stubs.md` (RFC-DEF-01…03 for deferred themes; OB-R6)
- `@dev/notes/reports/family-duplication-and-pathway-candidates-2026-04-01.md` (pathway index + duplication stub; Workspace 08)
- `docs/archive/v2/workspace-08-exit-evidence.md` (Workspace 08 exit gate — **closed** **2026-04-01**)
- `@dev/notes/rounds/cursor-08-family-convergence-2026-04-01.md` (Workspace 08 round — **CLOSED**)
- `docs/family-documentation-layout.md` (docs / `@dev` / wiki)
- `docs/family-operator-organisation-map.md` (index: operator journey, host, health, surfaces)
- `docs/gui-system-family-contract.md` (Workspace 05 GUI baseline)
- `docs/udos-host-platform-posture.md` (uDOS-host / server naming; Linux + macOS; Windows scope)
- `docs/family-first-run-operator-flow.md` (Wizard-led install; GUI-first; Sonic DB)
- `uDOS-core/docs/wizard-surface-delegation-boundary.md` (Wizard broker vs host; contract names)
- `uDOS-core/docs/binder-spine-payload.md` (v1 binder spine JSON schema; workspace / ThinUI alignment)
- `v2.0.3-rounds.md`
- `v2.0.3-seed-config-inventory.md`
- `v2.0.3-defaults-vs-examples-rule.md`
- `v2.0.4-rounds.md`
- `v2.0.5-rounds.md`
- `v2.0.6-rounds.md`
- `v2.0.7-rounds.md`
- `v2.0.8-rounds.md`
- `v2.1-rounds.md`
- `v2.2-rounds.md`
- `v2.3-rounds.md`
- `v2.3-unified-spec.md`
- `v2.4-rounds.md`
- `v2.5-rounds.md`
- `v2.6-rounds.md` (**completed** — binder/workspace spine **A–E**; release pass **`scripts/run-v2-6-release-pass.sh`**)

## Family Tree Check

The current family tree aligns to the active public repo set:

### Public runtime and governance repos

- `uDOS-core`
- `uDOS-shell`
- `uDOS-grid`
- `uDOS-wizard`
- `uDOS-dev`
- `uDOS-docs`
- `uDOS-plugin-index`
- `uDOS-themes`
- `uDOS-thinui`
- `uDOS-workspace`
- `uDOS-alpine`
- `uDOS-host`
- `sonic-ventoy`
- `uDOS-gameplay`
- `sonic-screwdriver`
- `uHOME-server`
- `uHOME-client`
- `uDOS-empire`
- `uHOME-matter`
- `uHOME-app-android`
- `uHOME-app-ios`

Canonical topology reference:

- `uDOS-dev/docs/repo-family-map.md`

## Current Family Baseline

- **completed** family version-rounds: `v2.5`, **`v2.6`** (see `v2-roadmap-status.md`; **`v2.6`** evidence **`scripts/run-v2-6-release-pass.sh`**)
- **active family plan:** none — next numbered plan uses **`docs/next-family-plan-gate.md`** + **`next-plan-readiness.md`** when scoping **`v2.7+`**
- **active repo semver baseline:** `2.3.0` with repo-local patch bumps
- **live status ledger:** `v2-roadmap-status.md`
- **primary execution:** Cursor Workspaces **01–09** **complete** (01–08 **2026-04-01**; **09** **2026-04-02** — `docs/archive/v2/cursor-execution.md`, `docs/archive/v2/workspace-08-exit-evidence.md`). **Post-08 optional O1–O4** **complete** — `post-08-optional-rounds.md`. Further coordination: **engineering backlog** — `v2-roadmap-status.md`, `CURSOR_HANDOVER_PLAN.md`
- **below gate:** repo-local patch bumps from **`2.3.0`**; optional **`v2.6`** reference materials in **`v2.6-rounds.md`** (completed)
- external private apps are tracked in their own repos and docs, not in this
  family roadmap

From this point onward, the family plan and repo release numbers are distinct:

- `v2.5` and **`v2.6`** are **completed**. Further follow-on uses **engineering backlog** and the **next-plan gate** for **`v2.7+`** when both triggers in **`docs/next-family-plan-gate.md`** are true
- each active public repo continues its own semantic version line from `2.3.0`
- patch bumps are the default local increment
- minor or major bumps require explicit family-plan approval

## Version Round Index

### `v2.0.1`

- status: completed
- summary class: platform reset and skeleton rebuild
- historical detail remains in `docs/development-roadmap.md`

### `v2.0.2`

- status: completed
- summary class: shared runtime and first working-system rebuild
- historical detail remains in `docs/development-roadmap.md`

### `v2.0.3`

- status: completed
- summary class: integration contracts, config/state alignment, sync bridges,
  spatial activation, and product alignment
- active detail: `v2.0.3-rounds.md`

### `v2.0.4`

- status: completed
- summary class: Wizard-owned secret-backed networking bridges
- active detail: `v2.0.4-rounds.md`

### `v2.0.5`

- status: completed
- summary class: Core-supported spatial vocabulary and file-location contracts
- active detail: `v2.0.5-rounds.md`

### `v2.0.6`

- status: completed
- summary class: Ubuntu base image and Ventoy boot-platform family activation
- active detail: `v2.0.6-rounds.md`

### `v2.0.7`

- status: completed
- summary class: uHOME-server local streaming channel ingestion lane
- active detail: `v2.0.7-rounds.md`

### `v2.0.8`

- status: completed
- summary class: dev tooling resilience, vault survival, and snap-off/reconnect
- active detail: `v2.0.8-rounds.md`

### `v2.1`

- status: completed (promotion-ready)
- summary class: convergence + full family operations completion + archive decommission readiness
- active detail: `v2.1-rounds.md`

### `v2.2`

- status: completed (tagged and promoted)
- summary class: uCODE runtime implementation, Wizard MCP ↔ VS Code, and ThinUI first visible render
- active detail: `v2.2-rounds.md`

### `v2.3`

- status: completed (promotion-ready)
- summary class: archive-first migration of Wizard GUI, Ubuntu workstation parity, schedule or automation control, and Sonic productization
- active detail: `v2.3-rounds.md`
- governing spec: `v2.3-unified-spec.md`

### `v2.4`

- status: completed
- summary class: workspace-led visual shell activation, MDC intake and conversion, UCI controller input, and optional Deer Flow execution
- active detail: `v2.4-rounds.md`

### `v2.5`

- status: completed
- summary class: execution completion, controlled Deer Flow runs, richer output consumption, and post-MVP hardening
- active detail: `v2.5-rounds.md`

### `v2.6`

- status: **completed** (closed **2026-04-05**)
- summary class: binder / workspace spine (ThinUI ↔ Core ↔ host), coordinated consumption and validation
- detail: `v2.6-rounds.md`, **`scripts/run-v2-6-release-pass.sh`**, `@dev/notes/reports/v2-6-release-pass-2026-04-05-120137.md` (latest), `@dev/notes/rounds/v2-6-family-plan-closed-2026-04-05.md`; opening **`@dev/notes/rounds/v2-6-family-plan-opened-2026-04-04.md`**

## Engineering backlog (continuous)

Work that does not map to a single version round but should stay visible on the
family roadmap:

**Backlog closure (2026-04-03):** optional rounds **OB-R1–OB-R7** in **`docs/archive/v2/optional-backlog-rounds-1-7.md`** are **complete**. Rows below are **not** open round debt: they are **standing doctrine** (gate, contracts), **maintenance** (re-run checks after edits), or **explicitly deferred** optional work (repo-local or next-plan gated). No further OB ledger rounds unless the family opens a new sequence.

**Below the next-plan gate (continuous automation):** **`scripts/verify-engineering-backlog-below-gate.sh`** runs **`verify-next-family-plan-gate-docs.sh`** plus strict **`automation/check-github-contract-rollforward.sh`** (wired **`scripts/run-dev-checks.sh`**). **`v2.6`** spine work is **closed** (`v2.6-rounds.md` **A–E**). A **future** **`v2.7+`** still uses **`docs/next-family-plan-gate.md`** + **`next-plan-readiness.md`** when both triggers are true.

| Track | Reference | Status (2026-04-03 closure pass) |
| --- | --- | --- |
| **Next `v2.x` family plan** | **`docs/next-family-plan-gate.md`**; **`@dev/notes/roadmap/next-plan-readiness.md`**; **`v2.6-rounds.md`** (completed); **`@dev/notes/reports/optional-backlog-round-5-2026-04-03.md`** (OB-R5); **`scripts/verify-next-family-plan-gate-docs.sh`**; **`scripts/verify-engineering-backlog-below-gate.sh`** ( **`run-dev-checks.sh`**) | **`v2.6` completed 2026-04-05** — release pass **`scripts/run-v2-6-release-pass.sh`**; closure **`@dev/notes/rounds/v2-6-family-plan-closed-2026-04-05.md`**. **Next** named plan (e.g. **`v2.7`**) uses the same gate + packet pattern. **Row execution:** below-gate bundle remains in **`run-dev-checks.sh`**. |
| **GitHub contract + local source of truth (uDOS-host anchor)** | **`docs/github-actions-family-contract.md`** (canonical); `uDOS-host/docs/activation.md` § GitHub Actions; `uDOS-host/.github/workflows/`; `uDOS-dev/automation/check-repo-governance.sh`; `uDOS-dev/automation/check-github-contract-rollforward.sh` (**`UDOS_GITHUB_CONTRACT_REPO_ROOTS`**); `automation/family-repos.sh` **public list**; **`scripts/verify-engineering-backlog-below-gate.sh`**; `docs/pr-checklist.md`; **`docs/archive/v2/optional-backlog-rounds-1-7.md`** OB-R2; `@dev/notes/reports/github-contract-rollforward-baseline-2026-04-03.md` | **OB-R2 complete (2026-04-03):** sibling path env + reusable `uses:` detection; uHOME app **`family-policy-check.yml`**; aligned matrix with extended roots when siblings are present. **OB-R3 complete (2026-04-03):** docs/wiki hub hygiene cadence. **Row execution (2026-04-03):** **`uDOS-grid`** + **`uDOS-surface`** on **`family-repos.sh`** public list (Surface was already CI-aligned; roll-forward now tracks it). **`uDOS-grid`** ships full **`.github/`** governance pack. **Below-gate bundle:** **`verify-engineering-backlog-below-gate.sh`** in **`run-dev-checks.sh`**. **Maintenance:** re-run **`automation/check-github-contract-rollforward.sh`** after workflow or repo-set changes. |
| **Runtime script optimisation** | `@dev/notes/reports/runtime-loop-optimization-flags-2026-03-30.md`; `docs/shared-runtime-resource-contract.md`; `@dev/fixtures/shared-runtime-resource.v1.json`; `@dev/fixtures/shared-runtime-service-lifecycle.v1.json`; `uDOS-host/scripts/udos_commandd.py`; `uDOS-host/scripts/lib/verify-ubuntu-static-contracts.py`; **`uDOS-host/scripts/lib/ubuntu-check-required-files.v1.list`**; **`docs/archive/v2/optional-backlog-rounds-1-7.md`** OB-R4 | **Done:** `runtime-layout` batch `mkdir` via `xargs`; **done:** `run-contract-enforcement.sh` DRY targets; **done (phase-1):** shared runtime/resource check + lifecycle matrix enforced in `run-dev-checks.sh`; **done:** baseline Python `udos-commandd` wrapper integrated and validated in `run-ubuntu-checks.sh`. **OB-R4 (2026-04-03):** static contract block extracted to **`verify-ubuntu-static-contracts.py`**. **Row execution (2026-04-03):** single **`ubuntu-check-required-files.v1.list`** drives **`run-ubuntu-checks.sh`** `require_file` loop and **`verify-ubuntu-static-contracts.py`** existence pass (`scripts/README.md` updated). |
| **Repo documentation structure** | `docs/doc-structure-verification-2026-03-30.md` | **Done:** tier-1 matrix; `uDOS-wizard` `docs/activation.md` |
| **Wizard → delegation pointer** | `uDOS-wizard` README, `docs/wizard-broker.md`, `docs/architecture.md` | **Done:** copy aligned to broker-only role |
| **PR hygiene** | `docs/pr-checklist.md` | **Done:** green proof + checklist; **updated:** ubuntu CI anchor note |
| **Docker replacement via shared family runtime/resource lane** | `docs/shared-runtime-resource-contract.md`; `docs/foundation-distribution.md` § Docker and family runtime decision; `@dev/notes/reports/runtime-loop-optimization-flags-2026-03-30.md`; `uDOS-groovebox/docs/docker-posture.md`; `uDOS-groovebox/docs/songscribe-docker-replacement-plan.md`; `uDOS-host/docs/docker-compose-compatibility.md`; `@dev/fixtures/shared-runtime-service-lifecycle.v1.json`; `scripts/verify-o3-docker-compat-siblings.sh` | **Decision locked:** Docker is transitional compatibility. **O3 tranche (2026-04-02):** lifecycle matrix adds **`ubuntu-wordpress-publish-stack`**; Ubuntu publishes Compose ownership doc + **`verify-docker-compose-compatibility-doc.sh`** (no Docker in CI); dev checks verify sibling Groovebox/Ubuntu docs when present; Groovebox docs cross-link registry. Further multi-repo execution work stays **next-plan gated** (`docs/next-family-plan-gate.md`). |
| **Ubuntu + Empire strict completion lane** | `docs/ubuntu-empire-strict-completion-contract.md`; `docs/ubuntu-empire-strict-operations-runbook.md`; `@dev/notes/reports/ubuntu-empire-strict-readiness-2026-04-01.md`; `uDOS-host/scripts/run-ubuntu-strict-completion-gate.sh`; `uDOS-empire/scripts/run-empire-strict-completion-gate.sh` | **Done (2026-04-01):** strict local-lab completion contract executed end-to-end with readiness evidence; Ubuntu strict host gate and Empire strict application gate now first-class command surfaces. |
| **Post-08 backlog and request reconciliation** | `docs/archive/v2/post-08-backlog-snapshot.md`; `@dev/requests/active-index.md`; `docs/archive/v2/cursor-execution.md`; `docs/archive/v2/cursor-focused-workspaces.md`; **`docs/archive/v2/optional-backlog-rounds-1-7.md`** OB-R3 | **Done (2026-04-01):** host/broker wording baseline moved to completed lane, post-08 checklist reconciled, and cross-cutting themes (Binder+DeerFlow, Binder+spool, clean/compost/vitals) aligned in execution docs. **Ledger closed (2026-04-02):** snapshot sections A–G all checked; operational tails (wiki hub sync) documented in `active-index.md`. **OB-R3 (2026-04-03):** O4 verify + layout cadence + round report for docs/wiki hygiene. |
| **Host-managed Python venv paths (`~/.udos/venv/...`)** | `uDOS-wizard`, `uDOS-empire`, `uDOS-surface`, `sonic-screwdriver`, `uHOME-client`, `uHOME-server`; override `UDOS_VENV_DIR`; `@dev/fixtures/operational-hygiene-venv-lanes.v1.json`; `scripts/verify-o4-operational-hygiene.sh` | **Done (2026-04-02):** host venv defaults in check scripts. **O4 (2026-04-02):** drift fixture + automated verify in `run-dev-checks.sh`; optional `UDOS_SONIC_SCREWDRIVER_ROOT` for Sonic lane when not sibling to `uDOS-dev`. |
| **ThinUI unified workspace (binder shell)** | `docs/thinui-unified-workspace-entry.md`; `docs/archive/v2/optional-backlog-rounds-1-7.md` OB-R1; `uDOS-thinui` `demo/workspace.html`, `src/workspace/`, `npm run dev:workspace` | **OB-R1 complete (2026-04-03):** `BinderWorkspaceSource`, `?binder=` fetch, `demo/public/demo-binder.json`; typecheck re-verified. **`v2.6` Rounds A–C complete (2026-04-05):** Core spine v1, ThinUI bridge, workspace consumption (`v2.6-rounds.md`). Editor persist / dashboard/Empire lanes remain optional or **next-plan** gated. |
| **Dev inbox intake (local vs distributable)** | `docs/dev-inbox-framework.md`; `docs/dev-inbox/`; **`docs/dev-inbox/guidelines/`**; **`scripts/bootstrap-dev-inbox.sh`**; **`docs/inbox-ingest/README.md`**; `docs/pr-checklist.md`; `docs/family-workflow.md`; **`AGENTS.md`**; `.github/instructions/dev-workflow.instructions.md` | **Done (2026-04-03):** templates and policy tracked; `@dev/inbox/` gitignored. **OB-R7 (2026-04-03):** PR checklist + workflow cross-links, framework Related, Copilot instructions, **`AGENTS.md`**; report **`@dev/notes/reports/optional-backlog-round-7-2026-04-03.md`**. **2026-04-05:** submission guidelines + local inbox bootstrap; promotion log for inbox → tracked repos. |
| **Deferred product themes (Workspace 08 row 4)** | `docs/deferred-product-rfc-stubs.md`; `docs/archive/v2/family-workspace-08-scope.md` § Deferred | **OB-R6 complete (2026-04-03):** RFC-DEF-01 (remote Deer Flow clusters), DEF-02 (graph editing), DEF-03 (memory sync import/export); scope-only; **`@dev/notes/reports/optional-backlog-round-6-2026-04-03.md`**. |

## Rule

When roadmap detail becomes operational, move it here into `@dev/notes/roadmap/`
and keep `docs/` as the stable explanatory layer.
