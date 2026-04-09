# v2 Roadmap Status

## Baseline

- tranche bootstrap workflow: completed
- current roadmap mode: family plan plus repo-local semver
- validation path: `scripts/run-roadmap-status.sh`
- active family plan: none (next numbered plan: `docs/next-family-plan-gate.md` + `@dev/notes/roadmap/next-plan-readiness.md`)
- prior completed family plan: `v2.6` (binder/workspace spine; governing spec: `@dev/notes/roadmap/v2.6-rounds.md`; prior lane: `v2.5`)
- active repo baseline: `2.3.0`
- post-08 backlog ledger: **closed** in `docs/archive/v2/post-08-backlog-snapshot.md` (**2026-04-02**)

## Version Rounds

| Version | Round | Status | Owner | Active binder | Notes |
| --- | --- | --- | --- | --- | --- |
| `v2.0.1` | Round A: contract lock and repo framing | completed | `family` | `#binder/dev-v2-development-roadmap` | Repo boundaries, activation docs, release policy, and version-round planning are in place. |
| `v2.0.1` | Round B: runnable platform spine | completed | `family` | `#binder/family-v2-0-1-empire-wizard-release-gate` | Shared foundation, product consumption, adapter targeting, local-app integration, live-service smokes, and hardened client/server plus empire/wizard release gates are now in place. |
| `v2.0.1` | Round C: validation and promotion | completed | `uDOS-dev` | `#binder/dev-v2-0-1-foundation-promotion` | Promotion checklist, tagged-repo scope, family release summary, and workspace-state cleanup are now in place. |
| `v2.0.2` | Round A: shared runtime service contracts | completed | `uDOS-core` | `#binder/core-v2-0-2-runtime-services` | Core publishes the shared runtime-services artifact and all current Shell, Wizard, Client, plus Empire consumers now load the same contract source. |
| `v2.0.2` | Round B: product rebuild and shared features | completed | `family` | `#binder/family-v2-0-2-product-rebuild` | Product rebuild work across client/server and empire/wizard lanes is complete for the first working-system pass, including shared Wizard dispatch, workflow-plan, and callback/result reporting paths. |
| `v2.0.2` | Round C: validation and promotion | completed | `uDOS-dev` | `#binder/dev-v2-0-2-release-pass` | Promotion checklist, release scope, family summary, packaged Wizard contract export, and persisted result-store decision are now in place for the first working-system pass. |
| `v2.0.3` | Round A: integration contract hardening | completed | `uDOS-core` | `#binder/core-v2-0-3-integration-contracts` | Config, state, seed, and secret ownership is locked. Family alignment doc is the canonical reference. `uDOS-grid` activated as the spatial identity lane with contracts, seed data, and test coverage. Shell config surface aligned. |
| `v2.0.3` | Round B: sync bridges and product alignment | completed | `family` | `#binder/family-v2-0-3-sync-alignment` | Grid consumed by Shell, Wizard, and Gameplay without ownership transfer. Sync envelope ingest, dispatch routes, client runtime profile refactor, Empire ops containers, and uHOME-matter activation complete. Family config/state language aligned across all active repos. |
| `v2.0.3` | Round C: validation and promotion | completed | `uDOS-dev` | `#binder/dev-v2-0-3-release-pass` | 363 tests passing across 8 repos. Agent-assist instructions created. v2.0.3 tags cut on all 17 repos. Round complete. |
| `v2.0.4` | Round A: Wizard networking boundary lock | completed | `uDOS-wizard` | `#binder/wizard-v2-0-4-network-boundaries` | Accepted 2026-03-16. Shell → Wizard live handoffs complete. Sibling route set, secret-backed bridge lanes, OK agent contract layer, MCP ↔ VS Code design note, Dev fixture scaffolds, household networking policy artifact, and language/runtime spec fully integrated into canonical architecture docs and Core contracts. |
| `v2.0.4` | Round B: secret-backed family bridge rollout | completed | `family` | `#binder/family-v2-0-4-wizard-networking` | Secret-backed networking bridges, uHOME-server fulfillment, uDOS-empire provider/webhook networking, and operator quickstart/bridge test rounds are complete. All exit criteria met and staged follow-up binders opened. |
| `v2.0.4` | Round C: validation and promotion | completed | `uDOS-dev` | `#binder/dev-v2-0-4-release-pass` | All validation and promotion criteria met. Networking release reporting complete. v2.0.4 tagged and promoted. |
| `v2.0.5` | Round A: Core spatial vocabulary lock | completed | `uDOS-core` | `#binder/core-spatial-support-planning` | PlaceRef vocabulary, file/artifact location fields, and minimum spatial conditions defined. Boundaries with Grid and Gameplay documented. |
| `v2.0.5` | Round B: Core spatial contract lift | completed | `uDOS-core` | `#binder/core-v2-0-5-spatial-contract-lift` | PlaceRef contract, documentation, and validation tests published in Core. Sibling repos notified to update usage. No datasets or registries added to Core. |
| `v2.0.5` | Round C: validation and promotion | completed | `uDOS-dev` | `#binder/dev-v2-0-5-release-pass` | Validation complete: PlaceRef contract tests pass in Core, roadmap report generated, and sibling repo coordination requests issued. |
| `v2.0.6` | Round A: Ubuntu and Ventoy family activation | completed | `family` | `#binder/family-v2-0-6-ubuntu-ventoy-activation` | Ubuntu and Ventoy repo activation is complete: scaffolded surfaces, governance alignment, and Round B handoff lane are in place. |
| `v2.0.6` | Round B: Sonic integration and profile wiring | completed | `sonic-screwdriver` | `#binder/sonic-v2-0-6-ubuntu-ventoy-integration` | Sonic now ships init/add/update/theme wiring against Ventoy templates and Ubuntu profile metadata, plus Linux smoke checks, preflight hook, and CI lane coverage. |
| `v2.0.6` | Round C: validation and promotion | completed | `uDOS-dev` | `#binder/dev-v2-0-6-release-pass` | Validation complete: uDOS-host and sonic-ventoy checks passing, sonic-screwdriver 33 tests passed, roadmap report generated. v2.0.6 tagged and ready for promotion. |
| `v2.0.7` | Round A: uHOME-server streaming channel ingestion | completed | `uHOME-server` | `#binder/uhome-server-v2-0-7-streaming-channels` | Channel source adapters, session controller, and local stream gateway complete. 27 channel tests; full uHOME-server suite 189 passed. |
| `v2.0.7` | Round B: validation and promotion | completed | `uDOS-dev` | `#binder/dev-v2-0-7-release-pass` | uHOME-server 189 tests passed. v2.0.7 channel lane validated and staged for promotion. |
| `v2.0.8` | Round A: dev tooling, logging, and loop guard | completed | `uDOS-dev` | `#binder/dev-v2-0-8-tooling-loop-guard` | Structured `@dev` logging schema, loop-detection and circuit-breaker controls, kill-all / kill-by-tag, session checkpoints and resume, scheduler audit trail, and log rotation script all implemented and passing. |
| `v2.0.8` | Round B: vault survival, snap-off, and sandbox protocols | completed | `uDOS-core` | `#binder/core-v2-0-8-vault-survival` | Vault crash-survival contract, `.compost` format, progressive file versioning, sandbox draft/backup/restore protocols, snap-off portable boundary, and reconnect handshake published in Core. 32 new tests; full Core suite 59 passed. |
| `v2.0.8` | Round C: validation and promotion | completed | `uDOS-dev` | `#binder/dev-v2-0-8-release-pass` | 9/9 ops checks pass, 59 Core tests pass, roadmap report generated. v2.0.8 lifecycle closed. Promotion-ready. |
| `v2.1` | Round A: convergence and canonicalization | completed | `family` | `#binder/family-v2-1-convergence-round-a` | Canonical decisions locked (uCODE language/runtime, script system, Ubuntu, Wizard OK, ThinUI state). Boundary alignment matrix published. ThinUI scaffold inventory complete with Round B gaps explicit. |
| `v2.1` | Round B: ThinUI runtime wiring and adapter bridge | completed | `uDOS-thinui` | `#binder/thinui-v2-1-runtime-wiring` | Theme-aware runtime loop landed in ThinUI with `renderThinUiState`, state hydrator, view resolver, C64/minimal-safe theme adapters, boot launch docs, and Alpine/sonic launcher contracts. |
| `v2.1` | Round C: full family operation completion | completed | `family` | `#binder/family-v2-1-operations-completion` | Core/Shell quickstarts, API+MCP docs, container run pattern matrix, uHOME console launch path, Alpine/Sonic Thin GUI docs, and @dev OK ASSIST operations module all published and validated. |
| `v2.1` | Round D: validation, archive decommission gate, and promotion | completed | `uDOS-dev` | `#binder/dev-v2-1-release-and-archive-gate` | Full family validation green, archive dependency audit PASS, archive decisions/rollback order documented, and promotion package prepared. v2.1 is promotion-ready. |
| `v2.2` | Round A: uCODE runtime and script dispatch | completed | `uDOS-core` | `#binder/core-v2-2-ucode-runtime` | Uppercase uCode verb parser, markdown script dispatch contract, and Shell → Core script invocation path are now in place. |
| `v2.2` | Round B: Wizard MCP ↔ VS Code integration | completed | `uDOS-wizard` | `#binder/wizard-v2-2-mcp-vscode` | Wizard MCP transport is live, VS Code can invoke OK tool calls through the local bridge, and Shell now consumes the same managed MCP surface. |
| `v2.2` | Round C: ThinUI first real render and Themes output | completed | `uDOS-thinui` | `#binder/thinui-v2-2-first-render` | ThinUI now emits real C64, NES/Sonic, and teletext frames; Alpine, Ubuntu, and Sonic launcher demos are live; Shell now exposes startup health and family demo entry points. |
| `v2.2` | Round D: validation and promotion | completed | `uDOS-dev` | `#binder/dev-v2-2-release-pass` | Validation matrix is green across Core, Wizard, ThinUI, Themes, Shell, Alpine, Ubuntu, Sonic, and dev; `v2.2` tags are now cut across the active family repos. |
| `v2.3` | Round A: Wizard GUI recovery and OK assistant handling | completed | `uDOS-wizard` | `#binder/wizard-v2-3-gui-stabilization` | Wizard now ships the recovered browser operator surface, visible OK/provider state, workflow and automation lanes, and round-close validation evidence. |
| `v2.3` | Round B: Ubuntu browser-workstation scaffold | completed | `uDOS-host` | `#binder/ubuntu-v2-3-browser-workstation-parity` | Ubuntu now ships a documented browser-workstation target, workstation scaffold manifest, and first-run/setup story aligned to the browser-first local workstation role. |
| `v2.3` | Round C: stronger schedule, automation, and binder control | completed | `uDOS-dev` | `#binder/dev-v2-3-workflow-schedules` | `uDOS-dev` now ships a documented workflow-backed schedule model, runnable Round C demo script, explicit scheduled-versus-manual binder rules, and aligned Shell/Wizard/dev operator docs. |
| `v2.3` | Round D: Sonic live, install, and recovery productization | completed | `sonic-screwdriver` | `#binder/sonic-v2-3-live-install-recovery` | Sonic now publishes explicit live/install/recovery product lanes, clearer Ubuntu/Ventoy/Sonic handoff doctrine, and runnable product evidence on top of the existing deployment substrate. |
| `v2.3` | Round E: archive removal gate, family integration, validation, and promotion | completed | `uDOS-dev` | `#binder/dev-v2-3-release-pass` | Full family validation green, archive removal decisions and rollback notes recorded, promotion package prepared, and `v2.3` is tag-ready across the active family repos. |
| `v2.4` | Round A: workspace shell and binder-facing surfaces | completed | `family` | `#binder/workspace-v2-4-binder-workspace-shell` | `uDOS-workspace` is active as the anchor repo for the workspace lane, with compile-manifest, spatial-consumer surfaces, and live Wizard-backed operator state consumption. |
| `v2.4` | Round B: MDC intake and conversion contract and engine MVP | completed | `uDOS-core` | `#binder/core-v2-4-mdc-conversion-engine` | Core now owns MDC runtime normalization, routing metadata, and the initial markdown-first intake matrix with validation coverage. |
| `v2.4` | Round C: UCI shared controller input and shell-first UX prototype | completed | `family` | `#binder/family-v2-4-uci-controller-surfaces` | Core and Shell now publish the UCI modes, actions, session model, radial keyboard contract, and controller semantic bindings. |
| `v2.4` | Round D: Deer Flow optional execution adapter and Wizard backend lane | completed | `uDOS-wizard` | `#binder/wizard-v2-4-deerflow-execution-adapter` | Wizard and the Deer Flow plugin now support translation, preview execution, result persistence, and workspace consumption for the optional backend lane. |
| `v2.4` | Round E: family integration, validation, and promotion | completed | `uDOS-dev` | `#binder/dev-v2-4-release-pass` | Targeted validations, release-pass evidence, promotion notes, and deferred-set recording are complete for the v2.4 MVP lane. |
| `v2.5` | Round A: execution lane activation | completed | `family` | `#binder/family-v2-5-execution-completion` | `v2.5` opened as the follow-on lane after the v2.4 MVP and locked the remaining local execution scope. |
| `v2.5` | Round B: Deer Flow controlled execution | completed | `uDOS-wizard` | `#binder/wizard-v2-5-deerflow-controlled-execution` | Wizard and Deer Flow now support explicit preview versus controlled execution with persisted artifact results and pin-status reporting. |
| `v2.5` | Round C: MDC and workspace output consumption | completed | `family` | `#binder/family-v2-5-output-consumption` | Core deepened document normalization while Workspace now exposes execution mode and artifact-aware operator state. |
| `v2.5` | Round D: validation and promotion | completed | `uDOS-dev` | `#binder/dev-v2-5-release-pass` | Validation, roadmap reporting, and release-pass evidence for the execution-completion lane are complete. |
| `v2.6` | Round A: contract and binder payload alignment | completed | `uDOS-core` + `family` | `#binder/core-v2-6-binder-contract-alignment` | Binder spine payload v1 schema, Core validation + contract tests, doc; ThinUI demo binder includes `schema_version: "1"`. |
| `v2.6` | Round B: ThinUI workspace bridge | completed | `uDOS-thinui` | `#binder/thinui-v2-6-workspace-bridge` | Spine v1 validation in TS (`binder-spine-v1.ts`), fetch uses v1 when `schema_version` is set, `binderLegacy=1`, bundled + example JSON; `npm run validate:binder-spine`; `docs/thinui-unified-workspace-entry.md`. |
| `v2.6` | Round C: workspace consumption and operator shell | completed | `uDOS-workspace` + `family` | `#binder/workspace-v2-6-binder-consumption` | Spine v1 validation + sample payload, operator snapshot in shell/inspector/topbar, `docs/workspace-binder-spine.md`; Core canonical. |
| `v2.6` | Round D: Ubuntu host parity and validation | completed | `uDOS-host` | `#binder/ubuntu-v2-6-host-parity-checks` | `run-ubuntu-checks.sh` verified; `docs/activation.md` § v2.6 spine parity + `scripts/README.md`; no new env for spine v1. |
| `v2.6` | Round E: family validation and promotion | completed | `uDOS-dev` | `#binder/dev-v2-6-release-pass` | `run-v2-6-release-pass.sh` green; evidence `@dev/notes/reports/v2-6-release-pass-2026-04-05-120137.md` (latest); deferred RFCs unchanged (`docs/deferred-product-rfc-stubs.md`). |

## Current Focus

- **Family version-round:** **`v2.6` — completed** **2026-04-05** (Rounds **A–E**). Governing spec: **`@dev/notes/roadmap/v2.6-rounds.md`**. Release pass: **`scripts/run-v2-6-release-pass.sh`**; evidence **`@dev/notes/reports/v2-6-release-pass-2026-04-05-120137.md`** (supersedes earlier `…111537.md` for gate verification). Closure: **`@dev/notes/rounds/v2-6-family-plan-closed-2026-04-05.md`**. **Next** numbered plan: **`docs/next-family-plan-gate.md`** + **`next-plan-readiness.md`**. Prior lane **`v2.5`** (`v2.5-rounds.md`). Opening handoff (historical): **`@dev/notes/rounds/v2-6-family-plan-opened-2026-04-04.md`**.
- **Gate packet / prep:** **`@dev/notes/roadmap/next-plan-readiness.md`** ( **`v2.6`** opening packet = **historical**; use five-item template for **`v2.7+`** ); runbook **`docs/archive/v2/preparing-for-v2-6.md`** § **After `v2.6`**. Plan opened **2026-04-04** after maintenance pass (**`run-dev-checks.sh`**, GitHub roll-forward, **`uDOS-host`** **`run-ubuntu-checks.sh`**).
- **Repo semver baseline:** `2.3.0` with per-repo patch bumps during preparation; minor/major only with family alignment (`docs/pr-checklist.md`).
- **Primary execution:** Cursor numbered lanes **01–09** — **all closed** (01–08 **2026-04-01**; **09** **2026-04-02** — `docs/archive/v2/cursor-execution.md`). **Post-08:** `docs/archive/v2/workspace-08-exit-evidence.md` section 3 + family-root `CURSOR_HANDOVER_PLAN.md`; optional **O1–O4** in `post-08-optional-rounds.md`.
- **Cursor Workspace 09 (Classic Modern MVP):** **closed** **2026-04-02** — `workspaces/archive/v2/cursor-09-classic-modern-mvp.code-workspace`; round `@dev/notes/rounds/cursor-09-classic-modern-mvp-2026-04-02.md` **CLOSED**; canonical pack **`uDOS-docs/docs/classic-modern-mvp-0.1/README.md`**.
- **Post-08 optional:** **O1–O4** **closed** **2026-04-02** — optional sequence complete (`post-08-optional-rounds.md`); further work re-enters via engineering backlog or `docs/next-family-plan-gate.md`.
- **Optional execution sequence (post-08, after 09):** **complete** **2026-04-02** (O4 operational hygiene: wiki hub vs disk, venv lane fixture, vocabulary anchors — `verify-o4-operational-hygiene.sh`).
- **Workspace 05 artefacts (closed 2026-04-01):** `docs/gui-system-family-contract.md` (shared inventory, ownership, Typo, ThinUI vs browser boundary). Round: `@dev/notes/rounds/cursor-05-gui-system-2026-04-01.md`.
- **Workspace 06 artefacts (closed 2026-04-01):** `uDOS-themes/docs/` theme standard, step-form rules, registry + integration plans; `uDOS-docs/docs/themes-and-display-modes.md`. Round: `@dev/notes/rounds/cursor-06-themes-display-modes-2026-04-01.md`.
- **validation path:** `scripts/run-roadmap-status.sh`
- **blockers:** none
- **Cursor Workspace 01 (runtime spine):** **closed** **2026-03-30** — `@dev/notes/rounds/cursor-01-runtime-spine-2026-03-30.md`.
- **Cursor Workspace 02 (foundation / distribution):** **closed** **2026-03-31** — `@dev/notes/rounds/cursor-02-foundation-distribution-2026-03-30.md` (steps 1–3).
- **Completion round 01 (install / distribution):** **closed** **2026-04-05** — `@dev/notes/rounds/completion-round-01-install-distribution-2026-04-05.md` (steps 1–3); workspace **`workspaces/archive/v2/completion-round-01-install-distribution.code-workspace`**; Sonic Tracks **A–D** on **sonic-screwdriver** `main`.
- **Completion round 02 (startup / networking / MCP):** **closed** **2026-04-05** — `@dev/notes/rounds/completion-round-02-startup-networking-mcp-2026-04-05.md` (steps 1–3); workspace **`workspaces/archive/v2/completion-round-02-startup-networking-mcp.code-workspace`**; **`uDOS-wizard`:** Surface `/app` + `/demo/links` fixes on **`main`**. Next **`workspaces/archive/v2/completion-round-03-tui.code-workspace`**.
- **Completion round 03 (TUI):** **closed** **2026-04-06** — `@dev/notes/rounds/completion-round-03-tui-2026-04-05.md` (steps 1–3); workspace **`workspaces/archive/v2/completion-round-03-tui.code-workspace`**. Next was **`workspaces/archive/v2/completion-round-04-gui.code-workspace`**.
- **Completion round 04 (GUI):** **closed** **2026-04-06** — `@dev/notes/rounds/completion-round-04-gui-2026-04-06.md` (steps 1–3); workspace **`workspaces/archive/v2/completion-round-04-gui.code-workspace`** (empire, host, surface, themes, thinui, workspace, wizard, core, gpthelper). **Completion rounds 1–4** complete; follow-on via **`docs/next-family-plan-gate.md`** / engineering backlog.
- **Cursor Workspace 03 (uHOME stream):** **closed** **2026-03-31** — `@dev/notes/rounds/cursor-03-uhome-stream-2026-03-31.md` — Step 3 browser proof recorded (Safari / **127.0.0.1**). Canonical stream doc **`docs/uhome-stream.md`**.
- **Cursor Workspace 04 (Groovebox product):** **closed** **2026-04-01** — `@dev/notes/rounds/cursor-04-groovebox-product-2026-03-31.md` — Step 3 browser sign-off (**127.0.0.1:8766**). Songscribe stem stack: `uDOS-groovebox/containers/songscribe/docker-compose.stem.yml` + `docs/songscribe-isolate-audio.md`.
- **Cursor Workspace 05 (GUI system):** **closed** **2026-04-01** — `@dev/notes/rounds/cursor-05-gui-system-2026-04-01.md`.
- **Cursor Workspace 06 (themes / display modes):** **closed** **2026-04-01** — `@dev/notes/rounds/cursor-06-themes-display-modes-2026-04-01.md`.
- **Cursor Workspace 07 (docs / wiki / courses):** **closed** **2026-04-01** — `@dev/notes/rounds/cursor-07-docs-wiki-courses-2026-04-01.md` (publishing checklist + Pages workflow evidence).
- **Cursor Workspace 08 (family convergence):** **closed** **2026-04-01** — `workspaces/archive/v2/cursor-08-family-convergence.code-workspace`; round `@dev/notes/rounds/cursor-08-family-convergence-2026-04-01.md` **CLOSED**; exit evidence **`docs/archive/v2/workspace-08-exit-evidence.md`**; `docs/archive/v2/cursor-focused-workspaces.md` § Workspace 08 **Closed**.
- **GitHub contract + local SOT:** **`docs/github-actions-family-contract.md`** (canonical); `uDOS-host/docs/activation.md` § GitHub Actions. Roll-forward (sibling repos, workflow trim) stays in `v2-family-roadmap.md` § Engineering backlog.
- **Docker replacement posture (locked):** Docker is transitional compatibility only; family target runtime is shared uDOS-native service/resource capability (aggressive migration). Baseline contract and phase-1 check: `docs/shared-runtime-resource-contract.md`, `@dev/fixtures/shared-runtime-resource.v1.json`, `scripts/run-shared-runtime-resource-check.sh`.
- **Historical semver note:** “Round A repo activation for `uDOS-workspace`” and **distributed execution** follow-up describe **older binder-scoped** threads; they are **not** the same ordering as **Cursor** workspaces. **Cursor Workspaces 01–09** are **complete**; **`v2.6`** is **completed** (`v2.6-rounds.md`); further coordination uses **engineering backlog** until a new **`v2.7+`** plan opens per `docs/next-family-plan-gate.md`.
- **Deferred (future plan material, not blockers):** remote Deer Flow clusters, graph editing, memory sync import/export — see **`docs/deferred-product-rfc-stubs.md`** (RFC-DEF-01…03), `docs/archive/v2/family-workspace-08-scope.md` § Deferred, `v2.5-rounds.md`, audit.
- **Optional backlog rounds 1–7:** **`docs/archive/v2/optional-backlog-rounds-1-7.md`** — **OB-R1–R7** **completed** **2026-04-03**. **OB-R5:** next **`v2.x`** gate — **defer** (packet **`@dev/notes/reports/optional-backlog-round-5-2026-04-03.md`**). **OB-R6:** **`docs/deferred-product-rfc-stubs.md`**. **OB-R7:** dev workflow + inbox — **`docs/pr-checklist.md`**, **`docs/family-workflow.md`**, **`AGENTS.md`**, Copilot **`dev-workflow.instructions.md`**; report **`@dev/notes/reports/optional-backlog-round-7-2026-04-03.md`**; round note **CLOSED**. **Supplement (2026-04-05):** **`docs/dev-inbox/guidelines/`**, **`scripts/bootstrap-dev-inbox.sh`**, **`docs/inbox-ingest/README.md`**. Further work: engineering backlog + gate doc, not additional OB ledger rounds unless reopened.
- **`v2.6` plan (completed):** **`@dev/notes/roadmap/v2.6-rounds.md`** — binder/workspace spine **A–E**; closed **2026-04-05**; release pass script **`scripts/run-v2-6-release-pass.sh`**.
- **Engineering backlog table:** **`v2-family-roadmap.md`** § Engineering backlog — **closure pass** **2026-04-03** (stale “next OB round” pointers cleared; standing gate + maintenance rows retained). **`docs/archive/v2/post-08-backlog-snapshot.md`** header + section **B** updated to match.
- **Engineering backlog rows 1–3 (execution):** Row **1** — **`scripts/verify-next-family-plan-gate-docs.sh`** in **`run-dev-checks.sh`**. Row **2** — **`uDOS-grid`** on **`family-repos.sh`** + **`.github/`** CI/governance pack. Row **3** — **`uDOS-host`** **`scripts/lib/ubuntu-check-required-files.v1.list`** + **`run-ubuntu-checks.sh`** / **`verify-ubuntu-static-contracts.py`** DRY.
- **Below the next-plan gate (2026-04-03):** **`uDOS-surface`** added to **`family-repos.sh`** roll-forward list; **`scripts/verify-engineering-backlog-below-gate.sh`** (gate docs + strict roll-forward) wired **`run-dev-checks.sh`**. **`v2.6` completed 2026-04-05**; opening **`v2.7+`** requires **`docs/next-family-plan-gate.md`** dual trigger + **`next-plan-readiness.md`** packet.

## Recent Outputs

2026-04-06: **Completion round 04 closed** — GUI lane; round note **`@dev/notes/rounds/completion-round-04-gui-2026-04-06.md`** (steps 1–3); workspace **`workspaces/archive/v2/completion-round-04-gui.code-workspace`**; Step 1 green (v2.6 release pass **`@dev/notes/reports/v2-6-release-pass-2026-04-06-230930.md`** + core / empire / surface / themes / thinui / workspace / wizard / gpthelper); Steps 2–3 recorded (demo stack + command-centre / Surface browser sign-off).

2026-04-06: **Completion round 03 closed** — TUI lane; round note **`@dev/notes/rounds/completion-round-03-tui-2026-04-05.md`** (steps 1–3); workspace **`workspaces/archive/v2/completion-round-03-tui.code-workspace`**; Step 3 command-centre browser sign-off + **`verify-command-centre-http.sh`**; next **`workspaces/archive/v2/completion-round-04-gui.code-workspace`**.

2026-04-05: **Completion round 03 opened** — TUI lane; workspace **`workspaces/archive/v2/completion-round-03-tui.code-workspace`**; round note **`@dev/notes/rounds/completion-round-03-tui-2026-04-05.md`**; Step 1 automated baseline green (v2.6 release pass **`@dev/notes/reports/v2-6-release-pass-2026-04-05-235730.md`** + core / grid / shell / thinui / plugin-index / host checks); Steps 2–3 pending.

2026-04-05: **Completion round 02 closed** — startup / networking / MCP; round note **`@dev/notes/rounds/completion-round-02-startup-networking-mcp-2026-04-05.md`** (steps 1–3); **`uDOS-wizard`** Surface **`/app`** + **`/demo/links`** UX pushed to **`origin/main`**; next **`completion-round-03-tui.code-workspace`**.

2026-04-05: **Completion round 01 — closure locked** — round note supplement (release-ready Sonic host path: **`finder-tui-demos.sh`**, **`ensure-host-tui-deps.sh`**, **`sonic udos-resources`**, **`docs/local-artifact-paths.md`**). Status unchanged: **closed** **2026-04-05**; follow-on completion lane was **round 02** (now **closed**); **next** **round 03** (TUI workspace).

2026-04-05: **Completion round 02 — execution started** — Step 1 automated baseline green (v2.6 release pass **`@dev/notes/reports/v2-6-release-pass-2026-04-05-223431.md`** + alpine / gpthelper / wizard / thinui / shell / plugin-index checks); round note **`@dev/notes/rounds/completion-round-02-startup-networking-mcp-2026-04-05.md`**; Steps 2–3 pending.

2026-04-05: **Completion round 02 opened** — startup / networking / MCP lane; workspace **`workspaces/archive/v2/completion-round-02-startup-networking-mcp.code-workspace`**; round note **`@dev/notes/rounds/completion-round-02-startup-networking-mcp-2026-04-05.md`**; **`v2-roadmap-status.md`** Current Focus updated.

2026-04-05: **Completion round 01 closed** — install/distribution completion workspace; round note **`@dev/notes/rounds/completion-round-01-install-distribution-2026-04-05.md`**; **`verify-command-centre-http.sh`** step-3 regression; next **`completion-round-02-startup-networking-mcp.code-workspace`**.

2026-04-05: **`v2.6` release gate re-verified** — **`scripts/run-v2-6-release-pass.sh`** green; evidence **`@dev/notes/reports/v2-6-release-pass-2026-04-05-120137.md`**. Ledger + gate docs updated; deferred themes remain RFC-only (**`docs/deferred-product-rfc-stubs.md`**). Inbox intake: **`docs/dev-inbox/guidelines/`**, **`scripts/bootstrap-dev-inbox.sh`**, **`docs/inbox-ingest/README.md`**.

2026-04-05: **`v2.6` gate alignment (docs)** — **`docs/next-family-plan-gate.md`**, **`next-plan-readiness.md`**, **`preparing-for-v2-6.md`** § **After `v2.6`**, **`v2-family-roadmap.md`** baseline; handoff **`@dev/notes/rounds/v2-6-family-plan-closed-2026-04-05.md`**. Family is **below** the next-plan gate until **`v2.7+`** criteria trip.

2026-04-05: **`v2.6` Round E / plan close** — **`scripts/run-v2-6-release-pass.sh`**; evidence **`@dev/notes/reports/v2-6-release-pass-2026-04-05-111537.md`**. **`v2.6-rounds.md`** **completed**; **`v2-roadmap-status.md`** baseline → prior **`v2.6`**; deferred unchanged (**`docs/deferred-product-rfc-stubs.md`**).

2026-04-03: **`v2.6` Round D (Ubuntu host parity)** — **`uDOS-host`**: `run-ubuntu-checks.sh` pass recorded; **`docs/activation.md`** § **v2.6 family spine parity (host lane)**; **`scripts/README.md`**. **`v2.6-rounds.md`** Round D **completed**; version table updated.

2026-04-03: **`v2.6` Round C (workspace consumption)** — **`uDOS-workspace`**: spine v1 validation (`apps/web/src/lib/spine/binder-spine-v1.ts`), sample spine payload + `binderOperatorSnapshot`, inspector + topbar; **`docs/workspace-binder-spine.md`**; checks require doc. **`v2.6-rounds.md`** Round C **completed**; version table updated.

2026-04-03: **`v2.6` Round B (ThinUI workspace bridge)** — **`uDOS-thinui`**: `src/workspace/binder-spine-v1.ts` (Core-aligned structural validation), `createFetchBinderSource` + `?binderLegacy=1`, bundled `demo-binder.json` + examples spine v1, `npm run validate:binder-spine`, `run-thinui-checks.sh`; **`docs/thinui-unified-workspace-entry.md`**. **`v2.6-rounds.md`** Round B **completed**; version table updated.

2026-04-03: **`v2.6` Round A (binder spine v1)** — **`uDOS-core`**: `schemas/binder-spine-payload.v1.schema.json`, `udos_core.binder_spine`, `docs/binder-spine-payload.md`, `tests/test_binder_spine_contract.py`; **`uDOS-thinui`**: `demo/public/demo-binder.json` sets `schema_version: "1"`. **`v2.6-rounds.md`** Round A **completed**; version table updated.

2026-04-04: **`v2.6` opened (active)** — maintenance pass green; **`v2.6-rounds.md`** **active** + canonical binders; **`v2-roadmap-status.md`** table + Current Focus; **`v2-family-roadmap.md`** baseline; **`@dev/notes/rounds/v2-6-family-plan-opened-2026-04-04.md`**.

2026-04-04: **`v2.6` preparation** — **`docs/archive/v2/preparing-for-v2-6.md`** (maintenance + backlog + gate runbook); **`next-plan-readiness.md`** § **`v2.6` opening packet (draft)**; **`v2.6-rounds.md`** § maintenance before Round A; **`docs/README.md`** / **`docs/next-family-plan-gate.md`** links; **`v2-roadmap-status.md`** Current Focus (**preparation** vs **active**).

2026-04-04: **`docs/pr-checklist.md`** — **Stable release snapshot** section (family semver cut, `run-dev-checks.sh`, optional `run-roadmap-status.sh`, `uDOS-host` checks, GitHub roll-forward, patch-vs-minor discipline; **`v2.7+`** gate per **`docs/next-family-plan-gate.md`** after **`v2.6`**).

2026-04-04: **`v2.6-rounds.md` proposed** — binder/workspace spine rounds **A–E** skeleton (**not** active until gate); **`v2-family-roadmap.md`** version index + engineering row updated.

2026-04-04: **Docs entry points** — **`docs/README.md`** + **`docs/pr-checklist.md`** link **`next-family-plan-gate.md`** / **`next-plan-readiness.md`**; readiness note § **Operator cadence (below gate)**.

2026-04-04: **`next-plan-readiness.md`** — draft **Theme A/B/C** placeholders (workspace spine, shared-runtime tranche, deferred RFCs); **`post-08-backlog-snapshot.md`** cross-link.

2026-04-03: **Below-gate bundle + next plan prep** — **`verify-engineering-backlog-below-gate.sh`** + **`run-dev-checks.sh`**; **`uDOS-surface`** on **`family-repos.sh`**; **`@dev/notes/roadmap/next-plan-readiness.md`**; **`docs/next-family-plan-gate.md`** § preparing a future plan.

2026-04-03: **Engineering backlog row 3 (code)** — **`uDOS-host`**: **`scripts/lib/ubuntu-check-required-files.v1.list`** shared by **`run-ubuntu-checks.sh`** and **`verify-ubuntu-static-contracts.py`**; **`scripts/README.md`**.

2026-04-03: **Engineering backlog rows 1–2 (code)** — **`verify-next-family-plan-gate-docs.sh`** + **`run-dev-checks.sh`** (row **1**); **`uDOS-grid`**: **`family-repos.sh`** + **`.github/workflows`**, templates, **`docs/activation.md`** CI section (row **2**).

2026-04-03: **Engineering backlog closure pass** — **`v2-family-roadmap.md`** § Engineering backlog reconciled post **OB-R1–R7** (GitHub/ThinUI rows no longer point at superseded “next” rounds); **`docs/archive/v2/post-08-backlog-snapshot.md`** updated (OB ledger bullet, deferred RFC pointer).

2026-04-03: **OB-R7 closed (dev workflow + inbox adoption)** — **`docs/pr-checklist.md`** + **`docs/family-workflow.md`** + **`docs/dev-inbox-framework.md`** cross-links; **`.github/instructions/dev-workflow.instructions.md`**; **`AGENTS.md`**; **`@dev/notes/reports/optional-backlog-round-7-2026-04-03.md`**; optional backlog **R1–R7** ledger **complete**.

2026-04-03: **OB-R6 closed (deferred product RFC stubs)** — **`docs/deferred-product-rfc-stubs.md`** (DEF-01…03); links from **`family-workspace-08-scope.md`**, **`@dev/pathways/README.md`**, roadmap Deferred bullet; **`@dev/notes/reports/optional-backlog-round-6-2026-04-03.md`**; round note **CLOSED**.

2026-04-03: **OB-R5 closed (next `v2.x` gate)** — criteria review; **decision: defer** opening `v2.6+`; packet **`@dev/notes/reports/optional-backlog-round-5-2026-04-03.md`**; **`docs/next-family-plan-gate.md`** Related link.

2026-04-03: **OB-R4 closed (runtime / host checks)** — `uDOS-host` `scripts/lib/verify-ubuntu-static-contracts.py` + `run-ubuntu-checks.sh` wiring; `run-ubuntu-checks` pass; roadmap runtime row re-scoped.

2026-04-03: **OB-R3 closed (docs + wiki hub hygiene)** — `verify-o4-operational-hygiene.sh` pass; `active-index.md` + `family-documentation-layout.md` OB-R3 cadence; `@dev/notes/reports/optional-backlog-round-3-2026-04-03.md`.

2026-04-03: **OB-R2 closed (GitHub contract roll-forward)** — extended repo path resolution, reusable-workflow `uses:` treated as script-owned, uHOME app policy workflows, baseline report A+B, contract doc update; strict check **pass** with `UDOS_GITHUB_CONTRACT_REPO_ROOTS` set to sonic + uHOME siblings.

2026-04-03: **OB-R2 started (GitHub contract roll-forward)** — baseline report **`@dev/notes/reports/github-contract-rollforward-baseline-2026-04-03.md`**; strict `check-github-contract-rollforward.sh` **pass** for present siblings; **`@dev/notes/rounds/optional-backlog-round-2-2026-04-03.md`** **OPEN**. OB-R1 **signed off** (ThinUI typecheck re-run).

2026-04-03: **Optional backlog rounds 1–7 ledger + OB-R1 closed** — **`docs/archive/v2/optional-backlog-rounds-1-7.md`** defines OB-R1…OB-R7; **Round 1** lands **`BinderWorkspaceSource`**, `?binder=` fetch path, `demo/public/demo-binder.json`, async workspace bootstrap in **`uDOS-thinui`**; **`docs/thinui-unified-workspace-entry.md`** updated; round **`@dev/notes/rounds/optional-backlog-round-1-2026-04-03.md`** **CLOSED**. **Round 2** next.

2026-04-03: **ThinUI unified workspace scaffold** — `uDOS-thinui`: binder-native shell demo (`demo/workspace.html`, `npm run dev:workspace`), `src/workspace/` types + `demo-binder.json`; family entry doc **`docs/thinui-unified-workspace-entry.md`**. Optional follow-through: core bridge, editor persist, dashboard/Empire lanes (engineering backlog row in `v2-family-roadmap.md`).

2026-04-03: **Dev inbox framework (distributable)** — **`docs/dev-inbox-framework.md`** + **`docs/dev-inbox/`** (`00`/`01`/`02` templates); **`@dev/inbox/`** remains **gitignored** for local intake only. **`docs/family-workflow.md`** § inbox updated.

2026-04-03: **Ventoy repo naming: `sonic-ventoy` only** — family docs, workspaces, automation (`automation/family-repos.sh`), Core dependency matrix, Ubuntu foundation proof + issue template, Sonic screwdriver notes, and archived `@dev` reports updated so **`uDOS-ventoy` is not used**; checkout path remains **`../sonic-family/sonic-ventoy`** (`fredporter/sonic-ventoy`). `scripts/run-family-checks.sh` (family root) invokes **`sonic-ventoy`** checks when present.

2026-04-03: **Post-08 optional O1–O4 integrated on `main`** — `uDOS-dev` ships O2 logs/feeds/spool verify, O3 docker-compat sibling verify, O4 operational hygiene verify + venv fixture + cadence report in `run-dev-checks.sh`; pathway execution checklist and promotion docs; shared-runtime lifecycle matrix and contract phase-2; `active-index` and duplication/pathways index updates. Siblings: Core `feeds-and-spool.md` O2 pointer; Docs image-ingestion lane + verify in `run-docs-checks.sh`; Themes GTX/package sync + Wizard Surface `gtx-step-task-map.json`; Ubuntu compose compatibility doc + check; Groovebox docker-posture O3 alignment; Workspace theme README package path. `bash scripts/run-dev-checks.sh` pass.

2026-04-02: **Post-08 O4 closed (operational hygiene cadence)** — `@dev/notes/reports/operational-hygiene-cadence-o4-2026-04-02.md`; `verify-o4-operational-hygiene.sh` + `operational-hygiene-venv-lanes.v1.json` wired `run-dev-checks.sh` (Learning Hub `wiki_units` vs sibling wiki files, venv defaults on wizard/empire/surface checks, GUI/host/wizard vocabulary anchors). `active-index.md` updated. **Post-08 O1–O4 sequence complete.**

2026-04-02: **Post-08 O3 closed (Docker replacement tranche 2)** — `shared-runtime-service-lifecycle.v1.json`: **`ubuntu-wordpress-publish-stack`**; `uDOS-host/docs/docker-compose-compatibility.md` + `scripts/verify-docker-compose-compatibility-doc.sh` in `run-ubuntu-checks.sh`; WordPress `docker-compose.yml` transitional header; `uDOS-dev/scripts/verify-o3-docker-compat-siblings.sh` in `run-dev-checks.sh`; `shared-runtime-resource-contract.md` phase-2; Groovebox `docker-posture.md` / replacement plan O3 section; `v2-family-roadmap.md` backlog row updated. No new default Docker dependency in checks.

2026-04-02: **Post-08 O1 closed; O2 pathways promotion closed** — `post-08-optional-rounds.md`: O1 themes lane complete; O2 promoted **logs/feeds/spool** (`uDOS-dev` candidate + `o2-logs-feeds-spool-execution-checklist.md` + `scripts/verify-pathway-o2-logs-feeds-spool.sh`, wired `run-dev-checks.sh`) and **image→markdown** (`uDOS-docs` `docs/image-ingestion-markdown-lane.md` + `o2-image-ingestion-md-execution-checklist.md` + `scripts/verify-o2-image-ingestion-lane.sh`, wired `run-docs-checks.sh`). Duplication report row 3 + pathways README + `uDOS-core/docs/feeds-and-spool.md` O2 pointer updated.

2026-04-02: **Post-08 O1 started (themes optional integration)** — `uDOS-themes`: `packages/tailwind-prose-preset` + sync/checks; `sync-gtx-step-task-map-to-wizard.sh`. `uDOS-wizard` Surface: mirrored `gtx-step-task-map.json`, `WorkflowPanel` GTX alignment, `run-wizard-checks.sh` validates map + `npm run build`. `uDOS-workspace` theme README: package path note. `uDOS-themes/@dev/next-round.md` optional prose/workflow items marked done.

2026-04-02: **Workspace 09 closed; numbered `.code-workspace` files in `uDOS-dev`** — round `@dev/notes/rounds/cursor-09-classic-modern-mvp-2026-04-02.md` **CLOSED**; `workspaces/README.md` index for steps 0–9; `post-08-optional-rounds.md` lead points to **O1** next; `docs/gui-system-family-contract.md` workspace path corrected to `workspaces/…`.

2026-04-02: **Classic Modern consumer matrix + Shell/Ubuntu surface push** — **`uDOS-docs`** pack **`classic-modern-mvp-0.1/README.md`** documents **`--cm-*`** → ThinUI **`udos-default`**, Shell, Surface, Ubuntu, Themes, Sonic; **`apply-classic-modern.sh`** smoke text; **`uDOS-themes/docs/README.md`** pointer. **`uDOS-shell`** `main`: surface **`input-mapping.json`** help + test fixes. **`uDOS-host`** `main`: ThinUI **`GET /v1/status`** surface summary + env example. Family repos pushed to **`origin/main`**.

2026-04-02: **Cursor Workspace 09 opened (Classic Modern MVP)** — inbox pack promoted to **`uDOS-docs/docs/classic-modern-mvp-0.1/`** (including `docs/rebrief-instructions.md`); charter canonical/mirror wording in **`uDOS-docs`** + **`sonic-screwdriver`**; round `@dev/notes/rounds/cursor-09-classic-modern-mvp-2026-04-02.md`; **`docs/archive/v2/cursor-execution.md`** § Step 9; **`post-08-optional-rounds.md`** lead paragraph: run **09** before **O1–O4**.

2026-04-02: **Post-08 backlog completion + host-managed Python venv** — `docs/archive/v2/post-08-backlog-snapshot.md` ledger closed (sections A–G); family check/launch scripts default to `~/.udos/venv/{wizard,empire,surface,sonic-screwdriver,uhome-client,uhome-server}` with optional `UDOS_VENV_DIR` override (`uDOS-wizard`, `uDOS-empire`, `uDOS-surface`, `sonic-screwdriver`, `uHOME-client`, `uHOME-server`); backlog normalization commit `uDOS-dev` + related repos pushed to `main`. See `v2-family-roadmap.md` § Engineering backlog.

2026-04-01: **Shared runtime/resource contract phase-1 implemented** — Docker replacement posture now has a machine-readable baseline (`@dev/fixtures/shared-runtime-resource.v1.json`) and enforced family check (`scripts/run-shared-runtime-resource-check.sh`, wired into `scripts/run-dev-checks.sh`). Reference doc: `docs/shared-runtime-resource-contract.md`.

2026-04-01: **Post-08 backlog checklist** — `docs/archive/v2/post-08-backlog-snapshot.md` (single checklist: active requests, engineering backlog, pathways, themes, deferred `v2.5` items, next `v2.x` gate, spec vigilance); linked from `docs/archive/v2/workspace-08-exit-evidence.md` § Related and `docs/README.md`.

2026-04-01: **Learning Hub wiki operator map + Wizard family health** — `uDOS-docs/wiki/family-operator-organisation-map.md` in **`wiki_units`** and Learning Hub cards (regenerated `site/data/*`, hub HTML); **`uDOS-wizard`** `GET /family/health` shells to `uDOS-host` `report-udos-disk-library.sh` and optional `run-ubuntu-checks.sh` (`docs/first-launch-quickstart.md`, `docs/architecture.md`); `uDOS-host/scripts/README.md` lists the disk report script.

2026-04-01: **Public organisation map mirror** — `uDOS-docs/docs/family-operator-organisation-map.md` (reader copy + GitHub links); `uDOS-docs/docs/README.md` + `onboarding.md`; `family-documentation-layout.md` companion row; `featured_references` + `generate-site-data.mjs` in `uDOS-docs`.

2026-04-01: **Family operator organisation map** — `docs/family-operator-organisation-map.md`: single reading-order index (onboarding → first-run → host posture → foundation → GUI contract → exit evidence → compost → feeds/spool → layout → planning ledgers); wired into `docs/README.md`, `family-documentation-layout.md`, `gui-system-family-contract.md`, `runtime-health-and-compost-policy.md`, `udos-host-platform-posture.md`, `family-first-run-operator-flow.md`, `CURSOR_HANDOVER_PLAN.md`, `v2-family-roadmap.md`.

2026-04-01: **Health, disk budget, Wizard dashboard** — `udos-host-platform-posture.md` § **System health, disk budget, and retention** (library vs runtime, Sonic partitions, health checks, compost, feeds/spool); `family-first-run-operator-flow.md` principle **10** + Wizard principle **1** (family health / resource **view**, delegate to host); `foundation-distribution.md` library **retention** pointer.

2026-04-01: **Offline-first LAN library posture** — `docs/udos-host-platform-posture.md` § **Offline-first survival posture**: v1/planned **host** prefetch + local library + **LAN** serve; **Sonic** as plan/prefetch/stage peer; **grid-down too late** rationale; `foundation-distribution.md` **`~/.udos/library/`** paragraph; first-run principles **9** + principle **5** cross-link; `onboarding.md` + `sonic-screwdriver/docs/README.md` pointers.

2026-04-01: **Family first-run operator flow** — `docs/family-first-run-operator-flow.md`: Wizard-led entry, choose roots → requirements → Sonic → Ventoy-style **GUI** master menu → customise install → stay GUI (TUI opt-in) → Sonic for extend/repair/reinstall → organic uDOS stack growth; Sonic DB = **curated global device library** + **user-registered devices** / capabilities / reflash hints; cold-start vs on-Linux table; linked from `onboarding.md`, `foundation-distribution.md`, `udos-host-platform-posture.md`, `sonic-screwdriver/docs/README.md`, `family-documentation-layout.md`, `v2-family-roadmap.md`.

2026-04-01: **uDOS-host platform posture** — `docs/udos-host-platform-posture.md`: product names **uDOS-host** / **uDOS-server** vs **`uDOS-host`** implementation repo; **Linux** tier 1 + **macOS** tier 2; **Windows** narrow (uHOME dual-boot gaming; Sonic “install Linux” story); linked from `family-documentation-layout.md`, `workspace-08-exit-evidence.md` § 1, `uDOS-docs/docs/onboarding.md`, `uDOS-host/README.md`, `v2-family-roadmap.md`.

2026-04-01: **Post-08 wiki hub sync** — `uDOS-docs/site/data/family-source.json`: Ubuntu wiki URLs → **`main`**; **Wiki Units** cards + **`wiki_units`** list extended (Wizard, Shell, ThinUI, Workspace, Grid, Family, Dev control plane); **`uDOS-wizard/wiki/unit-01-wizard-basics.md`**, **`uDOS-dev/wiki/unit-01-dev-basics.md`**; **`repo_groups`** adds **`uDOS-wizard`**, drops **`omit_wiki`** for **`uDOS-dev`**; `node scripts/generate-site-data.mjs` + `run-docs-checks.sh` pass.

2026-04-01: **Workspace 08 closed** — `docs/archive/v2/workspace-08-exit-evidence.md` (exit gate); round `@dev/notes/rounds/cursor-08-family-convergence-2026-04-01.md` **CLOSED**; `docs/archive/v2/cursor-focused-workspaces.md` + `CURSOR_HANDOVER_PLAN.md` post-08; row 1 manual-dedup policy in duplication report; spec outputs **Done**.

2026-04-01: **Gap-closure matrix closed (ledger pass)** — round note § matrix **Progress** → terminal for Workspace 08; duplication report header + bloat ledger marked **Done**; `family-readiness-audit-2026-04-01.md` tier-1 table **08-doc snapshots** checked; `active-index.md` splits **08-doc** (requests 1–2) vs **Post-08** (wiki + `family-source.json`).

2026-04-01: **Gap matrix rows 4–8 + D** — `docs/archive/v2/family-workspace-08-scope.md` (deferred post-`v2.5`, v1 `uDOS-docs`, cross-cutting themes); duplication report § Post-08 hooks (`udos-commandd`, themes); matrix + audit updated.

2026-04-01: **Gap matrix row 3 — pathway candidates** — `@dev/notes/reports/family-duplication-and-pathway-candidates-2026-04-01.md` (logs/feeds/spool + `uDOS-docs` image-ingestion-md + dup stub + row 9 migration feed); `@dev/pathways/README.md` candidate section; spec output 2 **Done** (see newer Recent Outputs).

2026-04-01: **Gap matrix row 2 — next `v2.x` gate** — `docs/next-family-plan-gate.md`; `v2-family-roadmap.md` baseline + engineering backlog row; `v2-roadmap-status.md` link; Workspace 08 round matrix + spec output 3 started.

2026-04-01: **Gap matrix row 1 — continued** — tier-1 `docs/README.md` pointers: Shell, ThinUI, Themes, Grid, Alpine, Gameplay, Empire; Sonic `docs/README.md` text pointer; Ubuntu + Wizard host/spine vocabulary (`activation`, `architecture`, `linux-first-run-quickstart`, `getting-started`); `family-documentation-layout.md` backlog updated.

2026-04-01: **Gap matrix row 1 — implementation started** — `uDOS-dev/docs/family-documentation-layout.md` (docs / `@dev` / wiki rules + Post-08 per-repo backlog); linked from `uDOS-docs/docs/README.md`, `publishing-architecture.md`, `repo-local-dev-workspaces.md`; `active-index.md` request 1 points at layout doc.

2026-04-01: **Workspace 08 gap matrix started** — `@dev/notes/rounds/cursor-08-family-convergence-2026-04-01.md` § Gap-closure matrix (backlog A–D, tier-1 snapshot, cross-cutting one-liners, v2.5+ defer paragraph); `@dev/requests/active-index.md` acceptance bullets + Workspace 08 pointers.

2026-04-01: **Workspace 08 final-round scaffold** — `@dev/notes/rounds/cursor-08-family-convergence-2026-04-01.md` (gap matrix + exit gate), `docs/archive/v2/cursor-execution.md` § Step 8, `@dev/notes/reports/family-readiness-audit-2026-04-01.md` § Final round; v2.3 schedule binder fixture moved to `@dev/fixtures/binder-dev-v2-3-workflow-schedules.md`; `scripts/run-roadmap-status.sh` **Current Focus** extraction fixed.

2026-04-01: **Cursor Workspace 07 closed; convergence lane 08 started** — Docs/wiki/Pages lane complete: exit gate table in `@dev/notes/rounds/cursor-07-docs-wiki-courses-2026-04-01.md`; `uDOS-docs` `generate-site-data.mjs` + `run-docs-checks.sh` pass; **Publish Pages** workflow `.github/workflows/pages.yml` documents deploy on `main`. **Same day:** Workspace **08** **closed** — `docs/archive/v2/workspace-08-exit-evidence.md` (see newer Recent Outputs above). Ledgers: `docs/archive/v2/cursor-focused-workspaces.md`, `CURSOR_HANDOVER_PLAN.md`, `v2-family-roadmap.md`, devlog.

2026-04-01: **Cursor Workspace 06 closed; Workspace 07 opened** — Themes lane complete: `theme-token-standard.md`, `step-form-presentation-rules.md`, `adapter-skin-registry-plan.md`, `integration-thinui-workflow-prose-gtx.md`; `uDOS-docs/docs/themes-and-display-modes.md`; round `@dev/notes/rounds/cursor-06-themes-display-modes-2026-04-01.md` **CLOSED**. **Active:** `@dev/notes/rounds/cursor-07-docs-wiki-courses-2026-04-01.md`, `cursor-07-docs-wiki-courses.code-workspace`. Ledger + `cursor-focused-workspaces.md` + `v2-family-roadmap.md` + `CURSOR_HANDOVER_PLAN.md` updated.

2026-04-01: **Cursor Workspace 06 opened; Workspace 05 closed** — `@dev/notes/rounds/cursor-06-themes-display-modes-2026-04-01.md` **OPEN**; `@dev/notes/rounds/cursor-05-gui-system-2026-04-01.md` **CLOSED**. **`uDOS-themes`:** `docs/display-modes.md`, `src/load-skin.mjs`, `examples/cross-surface-rendering-matrix.json` `primitive_surface_map`, GTX flow JSON as single source for `gtx-form-prototype.mjs`. `docs/archive/v2/cursor-focused-workspaces.md`, `v2-family-roadmap.md`, `CURSOR_HANDOVER_PLAN.md` handoff → **06**.

2026-04-01: **Family audit + roadmap reconciliation** — `@dev/notes/reports/family-readiness-audit-2026-04-01.md` supersedes 2026-03-30 audit for active checklist; **`docs/github-actions-family-contract.md`** and **`docs/gui-system-family-contract.md`** added; `v2-family-roadmap.md` handoff + baseline refreshed; **Current focus** aligned with completed `v2.5` and **final convergence lane 08** (later **closed** — `docs/archive/v2/workspace-08-exit-evidence.md`); `CURSOR_HANDOVER_PLAN.md` + `docs/archive/v2/cursor-execution.md` readiness pointer updated. **`uDOS-groovebox`:** optional **`containers/songscribe/docker-compose.stem.yml`** (profile `stem`) for **songscribe-api** + UI stack.

2026-04-01: **Cursor Workspace 05 opened (GUI system)** — `@dev/notes/rounds/cursor-05-gui-system-2026-04-01.md` **OPEN**; `docs/archive/v2/cursor-focused-workspaces.md` § Workspace 05 **OPEN**; open **`uDOS-family/cursor-05-gui-system.code-workspace`**.

2026-04-01: **Cursor Workspace 04 closed (Groovebox product)** — `@dev/notes/rounds/cursor-04-groovebox-product-2026-03-31.md` **CLOSED**; Step 3 operator visual sign-off on Groovebox UI (**127.0.0.1:8766**). `docs/archive/v2/cursor-focused-workspaces.md` § Workspace 04 **Closed**. **Next workspace:** `cursor-05-gui-system.code-workspace`.

2026-04-01: **Workspace 04 — close-out prep (Groovebox + Songscribe)** — Operator shell in `uDOS-groovebox` moved to a light, single-column layout (hash routes: Compose, Vault, Library, Status). **Songscribe “Error Isolating Audio”** documented as an **operational gap**: frontend calls **songscribe-api**; without that service + correct `NEXT_PUBLIC_API_BASE_URL` (and `http://localhost:3000` for CORS), isolation fails. **Roadmap:** `v2-family-roadmap.md` § Engineering backlog — **integrated Docker** for Songscribe + stem API (+ pattern for more third-party apps) targeted in **next few rounds**. `containers/songscribe/docker-compose.yml` default API base moved to **`http://127.0.0.1:8000`** for browser-side fetches.

2026-03-31: **Workspace 04 (Groovebox) — product documentation** — `uDOS-groovebox` ships `docs/product-checklist.md`, `sound-library.md`, `songscribe-contract.md`, `docker-posture.md`; round `@dev/notes/rounds/cursor-04-groovebox-product-2026-03-31.md` exit-gate table filled; **Step 3** UI browser sign-off pending.

2026-03-31: **Cursor Workspace 04 opened (Groovebox product)** — `@dev/notes/rounds/cursor-04-groovebox-product-2026-03-31.md` **OPEN**; `docs/archive/v2/cursor-focused-workspaces.md` § Workspace 04; open **`uDOS-family/cursor-04-groovebox-product.code-workspace`**.

2026-03-31: **Cursor Workspace 03 closed (uHOME stream, final)** — `@dev/notes/rounds/cursor-03-uhome-stream-2026-03-31.md` **CLOSED** with Safari Step 3 on uHOME **thin** routes (`/api/runtime/thin/read`, `thin/automation`, `thin/browse`); `docs/archive/v2/cursor-focused-workspaces.md` § Workspace 03 **Closed**; handoff to Workspace 04 same day.

2026-03-31: **Roadmap — GitHub contract and local SOT:** `v2-family-roadmap.md` § Engineering backlog now tracks **configuring the GitHub contract** (Actions on `main`, governance + Core enforcement, optional `promote.yml`) with **`uDOS-host` as the integration anchor** and **local checkout + `~/.udos/`** as operator source of truth; see `uDOS-host/docs/activation.md` § GitHub Actions and `v2-roadmap-status.md` § Current focus.

2026-03-31: **`uDOS-host` GitHub Actions refresh** — self-contained **`main`** workflows (`validate.yml`, slim `family-policy-check.yml`); removed **`promote.yml`**; governance in `uDOS-dev` no longer requires **`promote.yml`** for public repos (`automation/check-repo-governance.sh`).

2026-03-31: **Workspace 03 reopened** — operator requires **visual proof** of uHOME **thin** browser surfaces before close; round `@dev/notes/rounds/cursor-03-uhome-stream-2026-03-31.md` **OPEN** with Step 3 checklist (`/api/runtime/thin/automation`, `/api/runtime/thin/read`). Remote **`codex/v2-3-closeout`** branches **deleted** after merge to **`main`**.

2026-03-31: **Workspace 03 closed (uHOME stream)** — superseded by reopening above pending thin-UI browser sign-off.

2026-03-31: **Workspace 03 opened (uHOME stream)** — round `@dev/notes/rounds/cursor-03-uhome-stream-2026-03-31.md` **OPEN**; open **`uDOS-family/cursor-03-uhome-stream.code-workspace`** per `docs/archive/v2/cursor-focused-workspaces.md` § Workspace 03.

2026-03-31: **Workspace 02 closed** — step 3 browser sign-off on **uDOS command centre** at `http://127.0.0.1:7107/`; round `@dev/notes/rounds/cursor-02-foundation-distribution-2026-03-30.md` **CLOSED**. Next Cursor workspace **`cursor-03-uhome-stream.code-workspace`**.

2026-03-30: **Workspace 02 start:** `docs/foundation-distribution.md`, restored `docs/release-tier-map.md`, `uDOS-host/scripts/foundation-distribution-{workspace-proof,round-proof}.sh`, pathway `@dev/pathways/foundation-distribution-workspace-round-closure.md`, round `@dev/notes/rounds/cursor-02-foundation-distribution-2026-03-30.md` (steps 1–2 green; step 3 browser pending).

2026-03-30: **Workspace 01 closeout prep:** `uDOS-host` ships **`linux-family-bootstrap.sh`** and **`docs/linux-first-run-quickstart.md`** for first-time Linux install from the public `uDOS-host` repo (clone siblings + `runtime-spine-round-proof.sh`). Roadmap/devlog updated; next Cursor workspace **`cursor-02-foundation-distribution`**. Pathway: `@dev/pathways/runtime-spine-workspace-round-closure.md`, devlog: `@dev/notes/devlog.md`.

2026-03-30: Recorded **runtime optimisation backlog** and **tier-1 doc structure verification** under the family roadmap (`v2-family-roadmap.md` § Engineering backlog; `docs/doc-structure-verification-2026-03-30.md`). PR checklist (`docs/pr-checklist.md`) linked for green-proof gating.

2026-03-29: `v2.5` opened as the active family plan immediately after `v2.4` MVP closeout. Scope now shifts from optional preview-stage execution into controlled Deer Flow execution, richer Wizard artifact reporting, broader workspace output consumption, and the remaining local markdown-first normalization hardening.

2026-03-29: `v2.4` completed as the workspace-led MVP family plan. `uDOS-workspace`, Core MDC, Shell UCI, Wizard backend selection, Deer Flow preview execution, and the v2.4 release-pass evidence are now in place as the baseline for the follow-on execution lane.

2026-03-29: `v2.5` completed. Controlled Deer Flow execution, Wizard artifact-aware result persistence, workspace output consumption, Core MDC document-expansion work, and the v2.5 release-pass are now recorded. Distributed execution features remain later-plan work rather than open local leftovers.

2026-03-21: v2.3 Round E completed. Full release-pass validation is green across Core, Shell, Wizard, ThinUI, Themes, Alpine, Ubuntu, Ventoy, Sonic, and dev. Archive removal/freeze decisions and rollback-safe notes are now recorded in `@dev/operations/checklists/v2.3-archive-removal-gate.md`, promotion notes are staged in `@dev/submissions/v2-3-promotion-notes.md`, and the roadmap report is generated. `v2.3` is now promotion-ready and tag-ready across the active family repos.

2026-03-21: v2.3 Round D completed. `sonic-screwdriver` now documents explicit live, install, and recovery product lanes in `docs/LIVE_INSTALL_RECOVERY_PRODUCT.md`, publishes a dedicated Ubuntu/Ventoy/Sonic handoff reference in `docs/UBUNTU_VENTOY_SONIC_HANDOFF.md`, and ships a runnable product demo in `scripts/demo-live-install-recovery.sh`. Validation remained green (`bash scripts/run-sonic-checks.sh`: 38 tests passed; `bash scripts/demo-live-install-recovery.sh`: pass). Advancing to v2.3 Round E with `#binder/dev-v2-3-release-pass`.

2026-03-21: v2.3 Round C completed. `uDOS-dev` now publishes the active workflow-backed schedule model in `docs/workflow-schedule-operations.md`, ships `scripts/run-v2-3-workflow-schedule-demo.sh`, and aligns Shell and Wizard docs to the same bounded schedule-versus-manual binder lifecycle. Validation remained green (`bash scripts/run-v2-3-workflow-schedule-demo.sh`: pass; `bash scripts/run-dev-checks.sh`: pass; `uDOS-shell` `bash scripts/run-shell-checks.sh`: pass; `uDOS-wizard` `bash scripts/run-wizard-checks.sh`: 63 tests passed). Advancing to v2.3 Round D with `#binder/sonic-v2-3-live-install-recovery`.

2026-03-21: v2.3 Round B completed. `uDOS-host` now documents the browser-first local workstation target in `docs/browser-workstation-parity.md`, ships a checked-in browser-workstation scaffold manifest in `examples/browser-workstation-scaffold.json`, and aligns first-run/setup flow to the browser workstation direction. Validation remained green (`bash scripts/run-ubuntu-checks.sh`: pass; `bash scripts/demo-browser-workstation.sh`: pass; `bash scripts/demo-first-run-setup.sh`: pass). Advancing to v2.3 Round C with `#binder/dev-v2-3-workflow-schedules`.

2026-03-21: v2.3 Round A completed. `uDOS-wizard` now ships a recovered browser operator surface through `/app`, with workflow, automation, publishing, Thin GUI, and config lanes backed by active Wizard routes and OK-provider state. Wizard validation remained green (`bash scripts/run-wizard-checks.sh`: 63 tests passed; `npm run build` in `apps/wizard-ui`: pass). Advancing to v2.3 Round B with `#binder/ubuntu-v2-3-browser-workstation-parity`.

2026-03-22: `v2.3` family closeout completed. Repo-owned requests, submissions, briefs, and repo-specific triage now live in each repo's local `@dev/`, `uDOS-dev/@dev` is reduced to family coordination, and active public repos now carry independent `2.3.0` semantic-version baselines. See `@dev/submissions/submission-dev-v2-3-round-closeout.md`.

2026-03-21: previous version rounds closed out and `v2.3` rollout preparation recorded in `@dev/submissions/submission-dev-v2-3-rollout-preparation.md`. `v2.2` is treated as fully closed for active-family purposes, and `v2.3` is now the active binder-backed execution lane rather than a staged draft.

2026-03-21: `v2.3` unified platform spec integrated into the live roadmap at `@dev/notes/roadmap/v2.3-unified-spec.md`. Existing archive-first rounds were extended rather than replaced, so Wizard recovery, Ubuntu workstation parity, schedule and automation control, Sonic productization, and the final release gate now also carry the broader `v2.3` platform requirements for publishing, themes, modules, vault truth, education, and strict Core/Wizard/Dev separation.

2026-03-21: `v2.3` was reprioritized as an archive-migration-first lane so the old archives can be removed after delivery. Execution order is now: Wizard GUI recovery with OK assistant handling, Ubuntu browser-workstation scaffold, stronger schedule/automation/binder control, Sonic live-install-recovery productization, then the archive removal and release gate.

2026-03-21: `v2.2` tag history aligned across the active family repos. Annotated `v2.2` tags are now published for `uDOS-core`, `uDOS-wizard`, `uDOS-thinui`, `uDOS-themes`, `uDOS-shell`, `uDOS-alpine`, `uDOS-host`, `sonic-screwdriver`, and `uDOS-dev`. `v2.3` is now the active family lane, opening with `#binder/wizard-v2-3-gui-stabilization`.

2026-03-21: v2.2 Round D completed. Validation is green across Core (74), Wizard (63), Sonic (35), ThinUI, Themes, Shell, Alpine, Ubuntu, and dev. Promotion notes are prepared in `@dev/submissions/v2-2-promotion-notes.md`, and the roadmap report was regenerated for the release pass.

2026-03-21: v2.2 Round C completed. ThinUI now emits real adapter-backed frames for `thinui-c64`, `thinui-nes-sonic`, and `thinui-teletext`, including a teletext block-graphic demo surface. Alpine, Ubuntu, and Sonic now ship executable launcher/first-run demos, and Shell now exposes `health startup`, `setup story`, `demo list`, and `demo run <id>` as the family TUI entry lane. Round D binder opened as `#binder/dev-v2-2-release-pass`.

2026-03-21: v2.2 Round B completed. Wizard now exposes a working MCP bridge with JSON-RPC tool discovery and invocation, a local VS Code extension stub can route editor context through `ok.route`, and Shell now consumes the same managed MCP path in-session. Round C binder opened as `#binder/thinui-v2-2-first-render`.

2026-03-21: v2.2 Round B editor-context increment landed in `uDOS-wizard`. The VS Code MCP stub now includes `uDOS Wizard MCP: Route Active Selection`, which routes the current selection or active file through `ok.route` and includes `project_id`, `source_file`, and `source_language` in the MCP payload. Validation: `node --check mcp/vscode-extension/extension.js` passed and Wizard `bash scripts/run-wizard-checks.sh` remained green at 63 tests.

2026-03-21: v2.2 Round B shell/editor increment landed across `uDOS-wizard` and `uDOS-shell`. Wizard now ships a runnable VS Code extension stub in `mcp/vscode-extension/` that speaks the local JSON-RPC MCP bridge (`initialize`, `tools/list`, `tools/call`). Shell now exposes first-class `mcp init`, `mcp tools`, and `mcp call <tool>` commands against Wizard, plus read-only `dev ops` commands that surface the canonical `@dev/operations` docs in-session. Validation: `uDOS-shell` `go test ./...` passed; Wizard `bash scripts/run-wizard-checks.sh` passed with 63 tests.

2026-03-21: v2.2 Round B implementation traction landed in `uDOS-wizard`: live MCP tool registry with callable `ok.route` and `ok.providers.list` tools, direct invoke endpoint (`POST /mcp/tools/{tool}/invoke`), JSON-RPC shim (`POST /mcp` for `initialize`, `tools/list`, `tools/call`), activation doc, and starter HTTP JSON-RPC client profile for VS Code-capable clients (`mcp/vscode-http-client-profile.json`). Wizard validation path: `bash scripts/run-wizard-checks.sh` with project `.venv` (Python 3.13) passed: 63 tests.

2026-03-21: v2.2 Round A completed. `uDOS-core` now ships uppercase uCODE verb parsing, offline-safe dispatch for the locked verb set, markdown script execution via `RUN` / `SCRIPT RUN`, and a published script execution contract. `uDOS-shell` now invokes `.md` scripts through Core. Advancing to v2.2 Round B with `#binder/wizard-v2-2-mcp-vscode`.

2026-03-21: family consolidation and publish pass completed. v2.1 closeout work committed and pushed across active family repos; `uDOS-host` and `sonic-ventoy` are now published on `origin/develop`; one external private-app backup publish was preserved on a separate branch because its upstream `main` advanced independently.

2026-03-21: v2.2 Round A implementation traction landed in `uDOS-core`: uppercase uCODE verb parsing, offline-safe dispatch for `SET`, `STATUS`, `WORKFLOW RUN`, `DRAW BLOCK`, and `DRAW PAT TEXT`, plus markdown script execution via `RUN` / `SCRIPT RUN`. `uDOS-shell` now hands `RUN <script.md>` / `SCRIPT RUN <script.md>` through to Core via the local execution lane. Validation: Core `74 passed`; Shell `go test ./...` and `npm test` passing.

2026-03-21: v2.2 Round A opened. Consolidated the roadmap into a single active lane: `v2.2` is now active, `#binder/core-v2-2-ucode-runtime` is the only in-progress binder-backed round, and the next handoff is Round B after Core ships the initial uCODE runtime and script dispatch contract.

2026-03-21: v2.2 staged: four rounds planned (uCODE runtime, Wizard MCP ↔ VS Code, ThinUI first render, validation). v2.1 commit script prepared. v2-family-roadmap.md stale statuses fixed.

2026-03-21: v2.1 Round D completed. Final release gate accepted: 9/9 family operations checks pass, archive dependency audit PASS with no active runtime dependencies, archive decisions and rollback-safe decommission order documented, and promotion package prepared. v2.1 is now promotion-ready.

2026-03-21: v2.1 Round C completed. Full family operation completion accepted: Core/Shell quickstarts and API+MCP docs published, container run patterns matrix documented, uHOME console launch path validated, Alpine/Sonic Thin GUI docs added, OK ASSIST operations module active. 9/9 ops checks pass and operations audit PASS (28 checks). Advancing to v2.1 Round D: validation, archive decommission gate, and promotion.

2026-03-21: v2.1 Round B completed. ThinUI runtime wiring and adapter bridge delivered: `renderThinUiState` runtime bridge, state hydrator and view resolver, `uDOS-themes` resolver hooks (`resolveThinUiTheme`), first `thinui-c64` boot-render path, and Alpine/sonic launcher contracts. Ops checks remain 9/9 passing. Advancing to v2.1 Round C: full family operation completion.

2026-03-21: v2.0.8 Round C completed. All three v2.0.8 rounds closed. 9/9 ops checks pass, uDOS-core 59 tests pass, roadmap report generated. v2.0.8 is promotion-ready. Advancing to v2.1 Round A: convergence and canonicalization.

2026-03-21: v2.0.8 Round B completed. Vault survival contract published in uDOS-core: crash-safe/discard-safe boundary, `.compost` format (header/state/footer + integrity checksum), progressive delta versioning protocol, sandbox draft-before-write and backup-before-mutate guards, snap-off portable boundary, reconnect handshake, and mid-round crash restore worked example. 32 new tests; full Core suite 59 passed. Advancing to v2.0.8 Round C: validation and promotion.

2026-03-21: v2.0.8 Round A completed. Dev tooling and loop guard hardening complete: `run-dev-log-rotate.sh` (per-pattern JSONL rotation), kill-switch and log-rotate dry-run smoke passes added to `run-dev-checks.sh`, resilience runbook updated. All 9 ops checks pass. Advancing to v2.0.8 Round B: vault survival, snap-off, and sandbox protocols.

2026-03-21: v2.0.7 Round B completed. uHOME-server streaming channel lane validated: 189 tests passing (27 channel tests). Channel source adapters (channel.rewind.mtv, channel.rewind.cartoons), session controller, local stream gateway, and REST surface all confirmed. v2.0.7 staged for promotion. Advancing to v2.0.8 Round A: dev tooling, logging, and loop guard.

2026-03-20: v2.0.8 staged in the roadmap ledger. Scope: `@dev` structured logging and scheduler audit trail, loop-detection and circuit-breaker controls for orchestrators, kill-all/kill-by-tag emergency stops, session checkpoint and resume, vault crash-survival contract, `.compost` restore primitive, progressive file versioning, sandbox draft/backup/restore protocols, and uDOS snap-off/reinstall/reconnect sequence.

2026-03-20: v2.1 staged in the roadmap ledger. Scope now includes convergence, ThinUI wiring, full family operations completion (Core/Shell launch, API/MCP/plugin/container/modular, uHOME console, Alpine Thin GUI, sonic-screwdriver Thin GUI, `@dev` OK ASSIST MCP module), and archive decommission gate prior to promotion.

2026-03-17: v2.0.7 Round A opened. uHOME-server streaming channel ingestion lane started: channel source adapters for channel.rewind.mtv and channel.rewind.cartoons, session controller (join/create/sync/resume/move), local stream gateway, REST routes, and 24 tests. Full uHOME-server suite: 174 passed.

2026-03-17: v2.0.6 Round C completed. Validation passing across all repos: uDOS-host and sonic-ventoy baseline checks passing, sonic-screwdriver 33 tests passed, roadmap report generated. Promotion notes and handoff artifacts prepared.

2026-03-17: v2.0.6 Round B completed. Sonic integration and profile wiring landed with init/add/update/theme command wiring, template/profile consumption service lane, Linux integration smoke script, first-run preflight hook, and CI coverage.

2026-03-17: v2.0.6 Round A opened. uDOS-host and sonic-ventoy are initialized as public family repos, inbox briefs are promoted into triage and binder tracking, and roadmap/governance alignment is active.

2026-03-16: v2.0.5 Round C completed. Validation and promotion checks complete for the first Core-supported spatial round.

2026-03-16: v2.0.5 Round B completed. PlaceRef contract, documentation, and validation tests published in Core. Sibling repos notified to update usage. Now advancing to Round C: validation and promotion.

2026-03-16: v2.0.4 Round C completed. All validation and promotion criteria met. v2.0.4 tagged and promoted. Now advancing to v2.0.5 Round A: Core spatial vocabulary lock.

2026-03-16: v2.0.4 Round B completed. All bridge rollout objectives met, staged follow-up binders opened, and ready for validation and promotion.

- `#binder/wizard-v2-0-4-network-boundaries`
- `#binder/dev-v2-0-4-language-runtime-spec` (language/runtime spec integration — arch docs 14/15, Core contracts ucode-verb + script-document)
- grid spatial specs integrated: `uDOS-grid/docs/seed-layer-data.md` and `spatial-runtime.md` expanded; 5-domain seed registry landed
- uHOME v2 master spec integrated: `uHOME-server/docs/architecture.md` expanded with kiosk, Jellyfin, networking modes, extension model
- 6 inbox briefs promoted to triage (grid spatial brief v2, grid spatial runtime contract, grid spatial security and gameplay link, uHOME v2 master spec, uHOME v2 empire, uDOS seed layer data)
- `#binder/dev-v2-0-4-wizard-core-grid-spec-routing`
- `#binder/dev-v2-0-4-wizard-quickstart-test-round`
- `#binder/dev-v2-0-4-uhome-bridge-test-round`
- `#binder/dev-v2-0-3-release-pass`
- `#binder/family-v2-0-3-grid-consumption`
- `#binder/dev-v2-development-roadmap`
- `#binder/dev-v2-0-1-foundation-promotion`
- `#binder/core-v2-0-2-runtime-services`
- `#binder/family-v2-0-2-product-rebuild`
- `#binder/family-v2-0-1-empire-wizard-release-gate`
- `#binder/family-v2-0-1-client-server-release-gate`
- `#binder/family-v2-0-1-live-service-smoke`
- `#binder/family-v2-0-1-local-app-integration`
- `#binder/family-v2-0-1-adapter-target-integration`
- `#binder/family-v2-0-1-product-runnable-consumption`
- `#binder/family-v2-0-1-product-contract-alignment`
- `#binder/family-v2-0-1-registry-theme-foundation`
- `#binder/dev-roadmap-workflow`
- `#binder/dev-brief-routing-promotion`
- `#binder/dev-archive-recovery-roadmap`
- `#binder/release-surfaces-bootstrap`
- `#binder/tranche-4-repo-activation-complete`
- `#binder/themes-activation`
- `#binder/uhome-empire-activation`
- `#binder/gameplay-activation`
- `#binder/uhome-client-activation`
- `#binder/plugin-index-activation`
- `#binder/alpine-activation`
- `#binder/docs-activation`
- `#binder/sonic-activation`
- `#binder/uhome-server-activation`
- `#binder/wizard-activation`
- `#binder/core-contract-enforcement`
- `#binder/shell-activation`
- `#binder/dev-public-reference-consistency`
- `#binder/dev-public-structure-normalization`
- `#binder/family-v2-0-6-ubuntu-ventoy-activation`
