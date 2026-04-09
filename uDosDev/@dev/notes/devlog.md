# Dev log (operator notes)

Append-only style; short dated entries for workspace handoffs and litmus results.

## 2026-04-01 — Cursor Workspace 07 closed; Workspace 08 opened (family convergence)

- **Round 07:** `@dev/notes/rounds/cursor-07-docs-wiki-courses-2026-04-01.md` — **CLOSED**. Exit gate: `uDOS-docs/docs/publishing-architecture.md` § Operator checklist; closure run `node scripts/generate-site-data.mjs` + `bash scripts/run-docs-checks.sh` in **`uDOS-docs`** (pass); GitHub Pages contract **`.github/workflows/pages.yml`** (generate + checks + deploy on `main`).
- **Next:** **`cursor-08-family-convergence.code-workspace`** — **OPEN**. Ledger: `docs/cursor-focused-workspaces.md`, `v2-roadmap-status.md`, `v2-family-roadmap.md`, `CURSOR_HANDOVER_PLAN.md` (family root).

## 2026-04-01 — Cursor Workspace 07 started (docs / wiki / courses session)

- **Cursor lane:** `cursor-07-docs-wiki-courses.code-workspace` — open from **`uDOS-family/`** (folders: `uDOS-docs`, `uDOS-dev`, `uDOS-plugin-deerflow`, `vendor/deer-flow`, `../sonic-family/sonic-screwdriver`, `uDOS-host`, `uDOS-workspace`).
- **Round:** `@dev/notes/rounds/cursor-07-docs-wiki-courses-2026-04-01.md` — **OPEN**; exit gate: operator checklist in `uDOS-docs/docs/publishing-architecture.md` (including Pages deploy) and round note sign-off; lane authority `docs/cursor-focused-workspaces.md` § Workspace 07; sequence `docs/cursor-execution.md` § Step 7.
- **Quick verify:** **`uDOS-docs`** — `bash scripts/run-docs-checks.sh`; regenerate site data when touching hub JSON: `node scripts/generate-site-data.mjs` (repo `README` / publishing docs).
- **Ledger:** `v2-roadmap-status.md` § Current focus — Workspace 07 already **open**; this entry marks an active **dev session** on the exit gate.

## 2026-04-01 — Family audit, roadmap reconciliation, GUI contract + Songscribe stem compose

- **Audit:** `@dev/notes/reports/family-readiness-audit-2026-04-01.md` (supersedes 2026-03-30 for active checklist).
- **Docs:** `docs/github-actions-family-contract.md`, `docs/gui-system-family-contract.md`; `v2-family-roadmap.md` + `v2-roadmap-status.md` § Current focus reconciled with **completed `v2.5`** and **Cursor Workspace 05**; `CURSOR_HANDOVER_PLAN.md` current position; `docs/cursor-execution.md` / `cursor-focused-workspaces.md` audit pointer → 2026-04-01.
- **uDOS-host:** `docs/activation.md` links canonical GitHub contract to sibling `uDOS-dev`.
- **uDOS-groovebox:** `containers/songscribe/docker-compose.stem.yml` (profile `stem`) + README / `songscribe-isolate-audio.md` / `docker-posture.md`; `containers/songscribe/songscribe-api/` gitignored.

## 2026-04-01 — Cursor Workspace 06 closed; Workspace 07 opened (docs lane)

- **Round:** `@dev/notes/rounds/cursor-06-themes-display-modes-2026-04-01.md` — **CLOSED**. Spec gaps closed: `uDOS-themes/docs/theme-token-standard.md`, `step-form-presentation-rules.md`, `adapter-skin-registry-plan.md`, `integration-thinui-workflow-prose-gtx.md`; `uDOS-docs/docs/themes-and-display-modes.md` + `run-docs-checks.sh`.
- **Next:** `@dev/notes/rounds/cursor-07-docs-wiki-courses-2026-04-01.md` **OPEN** — `cursor-07-docs-wiki-courses.code-workspace`. Ledger: `v2-roadmap-status.md`, `v2-family-roadmap.md`, `docs/cursor-focused-workspaces.md`, `CURSOR_HANDOVER_PLAN.md`.

## 2026-04-01 — Cursor Workspace 06 continued (workspace web theme tokens)

- **uDOS-workspace:** `apps/web/src/lib/theme/browserDefaultShell.ts` mirrors `uDOS-themes` `theme-tokens.json` browser-default; `--ws-*` vars on `document.documentElement`; shell and surfaces switched to light editorial styling. `scripts/run-workspace-checks.sh` requires theme files.

## 2026-04-01 — Cursor Workspace 06 continued (ThinUI + Shell bridge docs)

- **ThinUI:** `docs/themes-sibling-bridge.md`, `scripts/print-themes-skin.mjs` (sibling `uDOS-themes` or `UDOS_THEMES_ROOT`); `run-thinui-checks.sh` requires both.
- **Shell:** `docs/tui-themes-parity.md` (TUI ↔ `tui-default` / GTX form-step alignment).
- **Themes:** `docs/display-modes.md` links to ThinUI + Shell notes. Round note updated: `@dev/notes/rounds/cursor-06-themes-display-modes-2026-04-01.md`.

## 2026-04-01 — Cursor Workspace 06 opened (themes / display modes)

- **Cursor lane:** `cursor-06-themes-display-modes.code-workspace` — open from **`uDOS-family/`** (folders: `uDOS-themes`, `uDOS-thinui`, `uDOS-workspace`, `uDOS-shell`, `uDOS-dev`, `uDOS-docs`).
- **Round:** `@dev/notes/rounds/cursor-06-themes-display-modes-2026-04-01.md` — **OPEN**; exit gate per `docs/cursor-focused-workspaces.md` § Workspace 06.
- **uDOS-themes:** `docs/display-modes.md`, `src/load-skin.mjs`, `examples/cross-surface-rendering-matrix.json` primitive map, GTX flow canonical JSON → `gtx-form-prototype.mjs` loader.
- **Ledger:** `v2-roadmap-status.md` § Current focus — Workspace 06 **open**; **next after close** `cursor-07-docs-wiki-courses.code-workspace`.

## 2026-04-01 — Cursor Workspace 05 closed (GUI system)

- **Round:** `@dev/notes/rounds/cursor-05-gui-system-2026-04-01.md` — **CLOSED**; contract + Step 3 handoff note; follow-up visual smoke optional via cursor-06 carry-forward.
- **Superseded by:** Workspace 06 entry above.

## 2026-04-01 — Cursor Workspace 05 opened (GUI system)

- **Cursor lane:** `cursor-05-gui-system.code-workspace` — open from **`uDOS-family/`** (folders: `uDOS-thinui`, `uDOS-workspace`, `uDOS-themes`, `uDOS-wizard`, `uDOS-core`, `uDOS-dev`, `uDOS-docs`).
- **Round:** `@dev/notes/rounds/cursor-05-gui-system-2026-04-01.md` — **OPEN**; exit gate and spec outputs per `docs/cursor-focused-workspaces.md` § Workspace 05.
- **Ledger:** `v2-roadmap-status.md` § Current focus — Workspace 05 **open**; **next after close** `cursor-06-themes-display-modes.code-workspace`.
- **Quick verify:** `uDOS-thinui` — `bash scripts/run-thinui-checks.sh`; `uDOS-workspace` — `bash scripts/run-workspace-checks.sh`; `uDOS-wizard` — `bash scripts/run-wizard-checks.sh`.

## 2026-04-01 — Cursor Workspace 04 closed (Groovebox product)

- **Round:** `@dev/notes/rounds/cursor-04-groovebox-product-2026-03-31.md` — **CLOSED**. Step 3: operator **visual demo** on **`http://127.0.0.1:8766/`** — Compose/Vault/Library/Status shell, Songscribe strip; signed off.
- **Ledger:** `v2-roadmap-status.md` § Current focus — Workspace 04 **closed**; **next** `cursor-05-gui-system.code-workspace`.
- **Docs:** `docs/cursor-focused-workspaces.md` § Workspace 04 **Closed**.
- **uDOS-groovebox:** UI + docs + Songscribe compose default on **`main`** (integration branch; was `develop` before 2026-04-03).

## 2026-04-01 — Workspace 04 close-out prep: Groovebox UI + Songscribe API backlog

- **uDOS-groovebox:** Operator UI restyle (single-column pages, hash routes); `containers/songscribe/docker-compose.yml` default **`NEXT_PUBLIC_API_BASE_URL=http://127.0.0.1:8000`** for browser-side API calls.
- **Songscribe:** Stem isolation still needs **songscribe-api** + env + CORS; error message is expected until that stack is up. **Roadmap:** `v2-family-roadmap.md` § Engineering backlog — **integrated Docker** for Songscribe + API (and future third-party services) in upcoming rounds.
- **Ledger:** `v2-roadmap-status.md` § Current focus + Recent Outputs; **round** `@dev/notes/rounds/cursor-04-groovebox-product-2026-03-31.md` § Carry-forward. (Superseded same day by Workspace 04 **closure** entry above.)

## 2026-03-31 — Workspace 04 (Groovebox): product docs and exit-gate artifacts

- **uDOS-groovebox:** `docs/product-checklist.md`, `docs/sound-library.md`, `docs/songscribe-contract.md`, `docs/docker-posture.md`; README / `docs/README.md` / `architecture.md` / `activation.md` / `sessions/README.md` cross-links; `run-groovebox-checks.sh` requires new docs.
- **Round:** `@dev/notes/rounds/cursor-04-groovebox-product-2026-03-31.md` — documentation exit gate filled; **Step 3** browser sign-off still open.
- **Focused workspaces:** `docs/cursor-focused-workspaces.md` § Workspace 04 exit bullets point at groovebox paths.

## 2026-03-31 — Cursor Workspace 04 opened (Groovebox product)

- **Cursor lane:** `cursor-04-groovebox-product.code-workspace` — open from **`uDOS-family/`** (folders: `uDOS-groovebox`, `uDOS-core`, `uDOS-host`, `uDOS-dev`, `uDOS-docs`).
- **Round:** `@dev/notes/rounds/cursor-04-groovebox-product-2026-03-31.md` — **OPEN**; exit gate and spec outputs per `docs/cursor-focused-workspaces.md` § Workspace 04.
- **Ledger:** `v2-roadmap-status.md` § Current focus — Workspace 04 **open**; **next after close** `cursor-05-gui-system.code-workspace`.
- **Quick verify:** `uDOS-groovebox` — `bash scripts/run-groovebox-checks.sh`; UI — `bash scripts/run-groovebox-ui.sh` (`docs/getting-started.md`).

## 2026-03-31 — Cursor Workspace 03 closed (uHOME stream; thin UI Step 3)

- **Round:** `@dev/notes/rounds/cursor-03-uhome-stream-2026-03-31.md` — **CLOSED**. Operator **Safari** sign-off on **127.0.0.1**: `thin/read`, `thin/automation`, `thin/browse`; Tailwind **`prose.css`** confirmed.
- **Ledger:** `v2-roadmap-status.md` § Current focus — Workspace 03 **closed**; Workspace 04 **open** (`cursor-04-groovebox-product.code-workspace`).
- **Docs:** `docs/cursor-focused-workspaces.md` § Workspace 03 status; `docs/uhome-stream.md` runbook retained for re-verification.

## 2026-03-31 — Cursor 03 reopened; thin UI browser gate; remote codex deleted

- **Workspace 03** cannot close until **real browser** sign-off on uHOME **thin** routes: `/api/runtime/thin/automation`, `/api/runtime/thin/read` (see `@dev/notes/rounds/cursor-03-uhome-stream-2026-03-31.md` Step 3).
- **Remote:** `git push origin --delete codex/v2-3-closeout` executed on uHOME-server, uHOME-client, uHOME-matter, uHOME-app-android, uHOME-app-ios after `main` was current.
- **Family candidate (not roadmapped):** `@dev/notes/candidates/logs-feeds-spool-family-candidate.md`.

## 2026-03-31 — Codex v2.3 closeout merged to main (uHOME repos)

- **Branches:** `codex/v2-3-closeout` → **`main`** (fast-forward) in `uHOME-server`, `uHOME-client`, `uHOME-matter`, `uHOME-app-android`, `uHOME-app-ios`.
- **Server follow-up:** HDHomeRun discovery uses `_tuner_discovery_hosts` (param → `HDHOMERUN_HOST` → `UHOME_TUNER_DISCOVERY_EXTRA_HOSTS` → `hdhomerun.local`); policy contract paths overridable via `UHOME_NETWORK_POLICY_CONTRACT_PATH` / `SCHEMA_PATH`; `src/uhome_server.egg-info/` gitignored and removed from tracking.
- **Push:** run `git push origin main` in each repo when ready for remote.

## 2026-03-31 — Workspace 03 closed (uHOME stream)

- **Canonical doc:** `docs/uhome-stream.md` — sequencing vs runtime spine, role matrix, Wizard/core boundary, standalone vs integrated `family_modes`.
- **uHOME-client:** `runtime-profile-map.json` — `family_modes` and each profile’s `deployment_modes` include **`integrated-udos`** and **`standalone-uhome`** (matches `run-uhome-client-checks.sh`).
- **uHOME-server:** `docs/architecture.md` — pointer to `uhome-stream.md` under Contract edges.
- **Verification:** `run-uhome-server-checks.sh` (205 tests); `run-uhome-client-checks.sh` green.
- **Round:** `@dev/notes/rounds/cursor-03-uhome-stream-2026-03-31.md` — **CLOSED**. Handoff: Workspace 04 (`cursor-04-groovebox-product.code-workspace`) — see newer devlog entry.

## 2026-03-31 — Workspace 03 opened (uHOME stream)

- **Cursor lane:** `cursor-03-uhome-stream.code-workspace` — open from **`uDOS-family/`** (folders: `uHOME-server`, `uHOME-client`, `uHOME-matter`, mobile apps, `sonic-screwdriver`, `uDOS-dev`, `uDOS-docs`).
- **Round:** `@dev/notes/rounds/cursor-03-uhome-stream-2026-03-31.md` — **OPEN**; exit gate and spec outputs per `docs/cursor-focused-workspaces.md` § Workspace 03.
- **Status ledger:** `v2-roadmap-status.md` § Current focus updated.

## 2026-03-31 — Roadmap: GitHub contract + local SOT anchored on uDOS-host

- **Engineering backlog:** `v2-family-roadmap.md` — new track **GitHub contract + local source of truth (uDOS-host anchor)** (define GitHub vs local truth, roll pattern to siblings).
- **Status ledger:** `v2-roadmap-status.md` § Current focus + Recent outputs.
- **Ubuntu doc:** `uDOS-host/docs/activation.md` § GitHub contract vs local source of truth.

## 2026-03-31 — Workspace 02 closed (cursor-02 three-step sign-off)

- **Step 3:** real browser on **`http://127.0.0.1:7107/`** — **uDOS command centre** heading and lane-1 demo page confirmed (`serve-command-centre-demo.sh`). Runbook: `docs/command-centre-browser-preview.md`.
- **Record:** `@dev/notes/rounds/cursor-02-foundation-distribution-2026-03-30.md` — **CLOSED**.
- **Next Cursor workspace:** `cursor-03-uhome-stream.code-workspace` (`docs/cursor-focused-workspaces.md` § Workspace 03).

## 2026-03-30 — Workspace 01 (runtime spine): real daemons landed; proof harness + pathway

- **Cursor lane:** `cursor-01-runtime-spine.code-workspace` — closure pathway `@dev/pathways/runtime-spine-workspace-round-closure.md`.
- **Real HTTP daemons (lane 1):** `uDOS-host/scripts/lib/runtime_daemon_httpd.py` behind host/web/vault/sync/**commandd** + six **aux** wrappers. Automated check: `verify-udos-runtime-daemons.sh` (`run-ubuntu-checks.sh`). LAN / demo scripts use **`udos-web.sh`** (static GUI + full contract **`/host/*`**). **`udos-hostd.sh layout-only`** = layout smoke without blocking on the hostd listener.
- **Proof scripts (uDOS-host):** `verify-command-centre-http.sh`, `verify-udos-runtime-daemons.sh`, `runtime-spine-workspace-tui.sh`, `runtime-spine-round-proof.sh`.
- **Linux first-time litmus:** `uDOS-host/docs/linux-first-run-quickstart.md` + `scripts/linux-family-bootstrap.sh` (clone siblings + full round proof). Re-runs **self-upgrade** `uDOS-host` + pull siblings, **self-heal** corrupt/missing clones, **pip -U** bootstrap tools; optional `UDOS_BOOTSTRAP_RESET_HARD=1` / `UDOS_APT_UPGRADE=1`.
- **LAN continuity:** `uDOS-host/docs/lan-command-centre-persistent.md` — `serve-command-centre-demo-lan.sh`, `install-command-centre-demo-lan-user-service.sh`, bootstrap `UDOS_BOOTSTRAP_INSTALL_LAN_SERVICE=1`.
- **Three-step closure:** physical operator proof (step 3) and full sign-off — **next** devlog entry (same day) and `@dev/notes/rounds/cursor-01-runtime-spine-2026-03-30.md`.
- **Next Cursor workspace:** `cursor-02-foundation-distribution.code-workspace` — `docs/cursor-execution.md`, `docs/cursor-focused-workspaces.md` § Workspace 02 (unblocked after closure entry).

## 2026-03-30 — Workspace 01 closed (cursor-01 three-step sign-off)

- **Record:** `@dev/notes/rounds/cursor-01-runtime-spine-2026-03-30.md` — steps **1–3** recorded **closed**.
- **Next Cursor workspace:** `cursor-02-foundation-distribution.code-workspace`.

## 2026-03-30 — Workspace 02 (foundation / distribution): spec + automated gates

- **Spec:** `uDOS-dev/docs/foundation-distribution.md` — install topology, `~/.udos/` standard, Sonic vs Ubuntu entry, Docker boundary, local-model plan, Ventoy split, dependency order.
- **Release tiers:** `uDOS-dev/docs/release-tier-map.md` restored (fixes broken links from `START_HERE.md`, `repo-family-map.md`, audit).
- **Proof scripts (`uDOS-host`):** `foundation-distribution-workspace-proof.sh`, `foundation-distribution-round-proof.sh` — Sonic + Ubuntu + command-centre HTTP + core + plugin-index + alpine + docs + dev (see continuation entry for dev/docs wiring).
- **Pathway:** `@dev/pathways/foundation-distribution-workspace-round-closure.md`.
- **Round:** `@dev/notes/rounds/cursor-02-foundation-distribution-2026-03-30.md` — steps **1–2** recorded; **step 3 (browser)** pending per `docs/round-closure-three-steps.md`.
- **Next:** operator completes step 3, updates round note to **CLOSED**, then `cursor-03-uhome-stream.code-workspace`.

## 2026-03-30 — Workspace 02 continuation: full workspace checks + portable dev docs

- **Proof script** now runs **`uDOS-docs`** and **`uDOS-dev`** (`run-docs-checks.sh`, `run-dev-checks.sh`); exports **`SONIC_SCREWDRIVER_ROOT`** to the same Sonic checkout used for pytest.
- **Binder fixture:** `@dev/fixtures/binder-dev-v2-3-workflow-schedules.md` (v2.3 Round C archive) so `run-v2-3-workflow-schedule-demo.sh` / `run-dev-checks` resolve the fixture path.
- **`run-v2-3-workflow-schedule-demo.sh`:** resolves Sonic via `SONIC_SCREWDRIVER_ROOT`, `../sonic-screwdriver`, or `../../sonic-family/sonic-screwdriver`.
- **Portable paths:** removed machine-specific `/Users/...` from `docs/getting-started.md`, `docs/family-split-prep.md`, `docs/doc-structure-verification-2026-03-30.md` so `run-dev-checks` local-root grep passes.

## 2026-03-30 — Command-centre browser preview runbook

- **Doc:** `uDOS-dev/docs/command-centre-browser-preview.md` — step-by-step URLs (default **`http://127.0.0.1:7107/`**), port overrides, LAN, SSH port-forward, what to look for on the page, and record-keeping pointers.
- **Linked from:** `docs/round-closure-three-steps.md`, foundation pathway, runtime-spine pathway, `docs/foundation-distribution.md`, round `cursor-02-foundation-distribution-2026-03-30.md`.
- **`serve-command-centre-demo-lan.sh`:** prints open hints (this host + LAN pattern) before starting `udos-web.sh`.

## 2026-03-30 — Workspace 02 continuation: onboarding cross-links

- **`uDOS-host/docs/linux-first-run-quickstart.md`:** points to `foundation-distribution.md`, foundation proof script, and foundation pathway when moving past Workspace 01.
- **Family `START_HERE.md`:** adjacent roots use `~/Code/...` instead of a fixed `/Users/...` path.
- **`sonic-screwdriver/README.md`:** new **uDOS family install contract** section (foundation doc + proof script paths).
- **`uDOS-docs/docs/README.md`:** Start Here link to `uDOS-dev/docs/foundation-distribution.md` for family checkouts.
