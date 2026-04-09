# Cursor Focused Workspaces

This document defines the ordered Cursor workspaces for finishing the
`uDOS-family` collection to release standard.

Each workspace is intentionally narrow. Open one workspace in Cursor, finish the
spec for that lane, record the round, and only then move to the next.

**Execution sequence and ready-to-start:** `docs/archive/v2/cursor-execution.md`.

Release priority for these workspaces is governed by
`uDOS-dev/docs/release-tier-map.md`.

**Cursor lanes 01–09:** **all closed** (01–08 **2026-04-01**; **09** optional post-08 **2026-04-02**). **Workspace 08** — `workspaces/archive/v2/cursor-08-family-convergence.code-workspace`; exit evidence **`docs/archive/v2/workspace-08-exit-evidence.md`**. **Workspace 09** — `workspaces/archive/v2/cursor-09-classic-modern-mvp.code-workspace`; round `@dev/notes/rounds/cursor-09-classic-modern-mvp-2026-04-02.md` **CLOSED**; canonical pack **`uDOS-docs/docs/classic-modern-mvp-0.1/README.md`**.

**Post-08:** engineering backlog still follows **`CURSOR_HANDOVER_PLAN.md`** (family root) and **`docs/archive/v2/workspace-08-exit-evidence.md`** section 3. **Next optional work:** `@dev/notes/roadmap/post-08-optional-rounds.md` (**O1–O4**).

## Workspace 01

File: `workspaces/archive/v2/cursor-01-runtime-spine.code-workspace`

**Status:** **Closed** — **2026-03-30** (three-step sign-off: `@dev/notes/rounds/cursor-01-runtime-spine-2026-03-30.md`).

Objective:
- centralize the runtime around `uDOS-host`
- define the always-on local/offline-first server shape
- reduce `uDOS-wizard` ownership of uptime-critical behavior
- define vault hosting, beacon/portal networking, and sync ownership

Repos in scope:
- `uDOS-core`
- `uDOS-host`
- `uDOS-wizard`
- `uDOS-grid`
- `uDOS-dev`
- `uDOS-docs`

(`uHOME-server` and the rest of the uHOME stream are **workspace 03** — not this lane.)

Spec outputs:
- runtime ownership map
- network boundary and offline-first contract
- vault hosting and sync contract
- service map for Ubuntu-hosted runtime roles

Exit gate:

- **Spec and tree (always):** `uDOS-host` is documented as the primary runtime host; Wizard narrowed to orchestration and setup; local vs remote sync assigned; runtime paths written and linked; `udos-hostd` materializes `~/.udos/` per `scripts/lib/runtime-layout.sh` (validated by `run-ubuntu-checks.sh`); **real spine daemons (lane 1)** — `udos-hostd`, `udos-web`, `udos-vaultd`, `udos-syncd`, **`udos-commandd`** (**`serve`**), six **aux** HTTP roles — in `runtime_daemon_httpd.py` with Wizard **`/host/*`** on **udos-web** per `wizard-host-surface.v1.json`; **`udos-hostd.sh layout-only`** for CI layout smoke.
- **Linux litmus:** `uDOS-host/docs/linux-first-run-quickstart.md` + `scripts/linux-family-bootstrap.sh`; pathway `@dev/pathways/runtime-spine-workspace-round-closure.md`.
- **LAN continuity:** `uDOS-host/docs/lan-command-centre-persistent.md` (`serve-command-centre-demo-lan.sh`, systemd user unit, `UDOS_BOOTSTRAP_INSTALL_LAN_SERVICE=1`).

**Round closure — three mandatory steps** (see `docs/round-closure-three-steps.md`; **the round is incomplete without all three**):

1. **Automated verification:** `bash uDOS-host/scripts/run-ubuntu-checks.sh` **and** `bash uDOS-host/scripts/verify-command-centre-http.sh` pass.
2. **Full workspace cycle (terminal):** `bash uDOS-host/scripts/runtime-spine-round-proof.sh` completes (HTTP verify + `runtime-spine-workspace-tui.sh`), or equivalent.
3. **Final GUI render:** operator **opens a real browser** and **sees** the **uDOS command centre** page (`serve-command-centre-demo.sh` and/or `serve-command-centre-demo-lan.sh`). `curl` and CI substring checks **do not** satisfy this step. Prefer **LAN / second device** when signing off Workspace 01. **Record** in `@dev/notes/rounds/` or `@dev/notes/devlog.md`.

**Next workspace:** `workspaces/archive/v2/cursor-02-foundation-distribution.code-workspace` — **unblocked** after the **2026-03-30** closure above; the spec bullets and steps **1–3** remain the contract for any future re-verification of this lane. See `docs/archive/v2/cursor-execution.md`.

## Workspace 02

File: `workspaces/archive/v2/cursor-02-foundation-distribution.code-workspace`

**Status:** **Closed** — **2026-03-31** (three-step sign-off: `@dev/notes/rounds/cursor-02-foundation-distribution-2026-03-30.md`). Pathway: `@dev/pathways/foundation-distribution-workspace-round-closure.md`.

**Next workspace:** `workspaces/archive/v2/cursor-04-groovebox-product.code-workspace` — **Workspace 03** (`workspaces/archive/v2/cursor-03-uhome-stream.code-workspace`) **closed 2026-03-31** (`@dev/notes/rounds/cursor-03-uhome-stream-2026-03-31.md`). See `docs/archive/v2/cursor-execution.md`.

Objective:
- finalize install, packaging, bootstrap, and distribution decisions
- standardize `~/.udos/` path ownership
- make `sonic-screwdriver` the first install and recovery lane
- define Docker posture and downloaded-library handling
- plan local-language intelligence integration such as `gpt4all`
- prepare `sonic-screwdriver` and `sonic-ventoy` to leave the core-family
  working set as an adjacent Sonic family

Repos in scope:
- `sonic-screwdriver`
- `uDOS-host`
- `sonic-ventoy`
- `uDOS-alpine`
- `uDOS-plugin-index`
- `uDOS-core`
- `uDOS-dev`
- `uDOS-docs`

Spec outputs:
- install and packaging topology
- path standard for envs, vault, memory, logs, library, and sync data
- standalone Sonic versus full uDOS entry contract
- Docker boundary and image ownership notes
- local-model hosting plan

Exit gate:

- install locations are consistent across family docs
- Sonic is the first-step installer and standalone entrypoint
- repo cleanliness versus runtime-state ownership is explicit
- distro and image lanes have a documented dependency order
- Sonic and Ventoy can be split without breaking core uDOS contracts

**Round closure — three mandatory steps** (same contract as Workspace 01; see `docs/round-closure-three-steps.md`; **incomplete without all three**):

1. **Automated verification:** all lane-2 automated checks and CI defined for that milestone pass.
2. **Integration / terminal proof:** documented script chain or integration proof for the milestone passes (may include `uDOS-host` regression such as `run-ubuntu-checks.sh`).
3. **Final GUI render:** operator **visually** confirms a **documented GUI surface** for the milestone. **Until Sonic/Ventoy (or another lane-2 product) defines a different primary operator GUI**, the regression anchor remains the **uDOS command centre** (`uDOS-host/scripts/serve-command-centre-demo.sh` / `serve-command-centre-demo-lan.sh`) so the family-visible HTML does not regress. Runbook: `docs/command-centre-browser-preview.md`. When a new primary GUI exists, update `round-closure-three-steps.md` and this section. **Record** sign-off.

## Workspace 03

File: `workspaces/archive/v2/cursor-03-uhome-stream.code-workspace`

**Status:** **Closed** — **2026-03-31** (three-step sign-off: `@dev/notes/rounds/cursor-03-uhome-stream-2026-03-31.md`). Step 3: operator **Safari** proof on **127.0.0.1** — `/api/runtime/thin/read`, `/api/runtime/thin/automation`, `/api/runtime/thin/browse`; `prose.css` loaded.

**Sequence:** see `docs/archive/v2/cursor-execution.md` — this workspace is **closed**; **Workspaces 01–08** are **closed** **2026-04-01**; post-08 execution: **`docs/archive/v2/workspace-08-exit-evidence.md`** § 3.

Objective:
- run `uHOME` as its own stream only after runtime and distro foundations settle
- keep `uHOME` dependent on the primary Ubuntu runtime instead of redefining it
- prepare the full `uHOME` stream to sit outside the active core-family working
  set

Repos in scope:
- `uHOME-server`
- `uHOME-client`
- `uHOME-matter`
- `uHOME-app-android`
- `uHOME-app-ios`
- `sonic-screwdriver` (install / Ventoy / dual-boot; sibling `sonic-family` checkout)
- `uDOS-dev`
- `uDOS-docs`

Spec outputs:
- `uHOME` stream roadmap
- app/runtime/service boundary
- dependency contract back to the runtime spine

Exit gate:
- `uHOME` is clearly sequenced after the runtime spine
- mobile, client, server, and matter roles are separated cleanly
- boundary with `uDOS-wizard` and other core repos is clear
- the `uHOME` family can be worked separately from core uDOS completion

## Workspace 04

File: `workspaces/archive/v2/cursor-04-groovebox-product.code-workspace`

**Status:** **Closed** — **2026-04-01** (`@dev/notes/rounds/cursor-04-groovebox-product-2026-03-31.md`). Step 3: operator visual sign-off on Groovebox UI **127.0.0.1:8766** (Compose / Vault / Library / Status, Songscribe header strip).

**Sequence:** see `docs/archive/v2/cursor-execution.md` — this workspace is **closed**; **Workspace 08** **closed** **2026-04-01**; post-08: **`docs/archive/v2/workspace-08-exit-evidence.md`** § 3.

Objective:
- turn `uDOS-groovebox` into a working releaseable product
- define a local browsable sound library
- support audio/music to markdown-text project capture
- finish Songscribe processing and operational flow

Repos in scope:
- `uDOS-groovebox`
- `uDOS-core`
- `uDOS-host`
- `uDOS-dev`
- `uDOS-docs`

Spec outputs:
- groovebox product definition
- sound-library storage and browsing plan
- Songscribe processing contract
- optional Docker usage decision

Exit gate:
- groovebox has a product checklist, not just a concept note — `uDOS-groovebox/docs/product-checklist.md`
- audio artifacts, metadata, and markdown outputs have stable locations — `uDOS-groovebox/docs/sound-library.md`
- operational requirements are documented — `uDOS-groovebox/docs/activation.md` § Operational requirements

## Workspace 05

File: `workspaces/archive/v2/cursor-05-gui-system.code-workspace`

**Status:** **Closed** — **2026-04-01** (`@dev/notes/rounds/cursor-05-gui-system-2026-04-01.md`).

**Next workspace:** `workspaces/archive/v2/cursor-06-themes-display-modes.code-workspace` — **Closed** **2026-04-01**; **07** and **08** **closed** **2026-04-01**; **post-08:** `docs/archive/v2/workspace-08-exit-evidence.md` § 3. See `docs/archive/v2/cursor-execution.md`.

Objective:
- standardize ThinUI and browser GUI lanes
- make Typo the shared quick-code-editor and prose viewer surface
- unify reusable Svelte components across family GUIs

Repos in scope:
- `uDOS-thinui`
- `uDOS-workspace`
- `uDOS-themes`
- `uDOS-wizard`
- `uDOS-core`
- `uDOS-host`
- `uDOS-dev`
- `uDOS-docs`

Spec outputs (canonical family doc):
- **`docs/gui-system-family-contract.md`** — shared GUI inventory, ownership and reuse, Typo contract, ThinUI vs browser boundary

Exit gate:
- shared components are named and owned — evidence: **`docs/gui-system-family-contract.md`**
- GUI repos use one component vocabulary — same
- editor and prose-view behavior is treated as a family standard — Typo section in same doc; **Step 3** browser sign-off recorded in round note **2026-04-01** (carry-forward optional)

## Workspace 06

File: `workspaces/archive/v2/cursor-06-themes-display-modes.code-workspace`

**Status:** **Closed** — **2026-04-01** (`@dev/notes/rounds/cursor-06-themes-display-modes-2026-04-01.md`).

**Then:** `workspaces/archive/v2/cursor-08-family-convergence.code-workspace` — **Closed** **2026-04-01**; post-08: `docs/archive/v2/workspace-08-exit-evidence.md` § 3.

Objective:
- finalize themes and display modes after GUI surfaces prove stable
- align web, presentation, wizard-form, binder, and TUI storytelling patterns
- make step-by-step forms the default interaction style
- formalize `uDOS-themes` as the cross-surface adapter and skin system

Repos in scope:
- `uDOS-themes`
- `uDOS-thinui`
- `uDOS-workspace`
- `uDOS-shell`
- `uDOS-docs`
- `uDOS-dev`

Spec outputs:
- theme/token standard
- display-mode inventory
- step-form and presentation-flow interaction rules
- TUI parity notes for full-viewport guided flows
- adapter and skin registry plan
- ThinUI, workflow, Tailwind Prose, and GTX-form integration plan

Exit gate:
- theme and mode vocabulary is consistent
- forms and story flows are documented as deliberate design, not incidental UI
- GUI and TUI interaction posture is aligned
- `uDOS-themes` is ready to move from scaffold to real adapter implementation

## Workspace 07

File: `workspaces/archive/v2/cursor-07-docs-wiki-courses.code-workspace`

**Status:** **Closed** — **2026-04-01** (`@dev/notes/rounds/cursor-07-docs-wiki-courses-2026-04-01.md`). Exit gate: `uDOS-docs/docs/publishing-architecture.md` § Operator checklist; local generate + `run-docs-checks.sh` pass; GitHub Pages workflow `.github/workflows/pages.yml` (regenerates and deploys on `main`).

**Then:** `workspaces/archive/v2/cursor-08-family-convergence.code-workspace` — **Closed** **2026-04-01**; post-08: `docs/archive/v2/workspace-08-exit-evidence.md` § 3.

Objective:
- do a dedicated documentation, wiki, and educational hook round
- align GitHub Pages style publishing with local hosted views
- consolidate docs, wiki pages, and course pathways
- align General Knowledge Library / bank (`uDOS-docs/docs/knowledge/`) with site
  and seeds as needed

Repos in scope:
- `uDOS-docs`
- `uDOS-dev`
- `sonic-screwdriver`
- `uDOS-host`
- `uDOS-workspace`

Spec outputs:
- docs and wiki publishing architecture
- course-hook plan and onboarding funnels
- local-hosted versus GitHub-hosted documentation boundary
- knowledge library and public hub links coherent for readers and bundles

Exit gate:
- docs entrypoints are coherent
- wiki and course lanes have explicit ownership
- publishing flow is documented end to end

## Workspace 08

File: `workspaces/archive/v2/cursor-08-family-convergence.code-workspace`

**Status:** **Closed** — **2026-04-01** (follows closure of Workspace 07:
`@dev/notes/rounds/cursor-07-docs-wiki-courses-2026-04-01.md`).

**Round note:** `@dev/notes/rounds/cursor-08-family-convergence-2026-04-01.md` **CLOSED**.

**Exit evidence:** **`docs/archive/v2/workspace-08-exit-evidence.md`**.

Objective:
- identify leftovers, overlaps, and duplicated responsibilities
- recommend the best unified family structure moving forward
- trim bloat before release completion

Repos in scope:
- `uDOS-dev`
- `uDOS-core`
- `uDOS-docs`
- `sonic-screwdriver`
- `uDOS-host`
- `uDOS-wizard`
- `uDOS-workspace`
- `uDOS-plugin-index`

Spec outputs:
- family architecture review
- duplication and bloat report
- recommended steady-state repo and resource structure

Exit gate (satisfied **2026-04-01**):

- overlapping ownership is called out explicitly — **`docs/archive/v2/workspace-08-exit-evidence.md`** § 1
- proposed convergence structure is documented — same file § 2
- post-handover execution order is clear — same file § 3

## Workspace 09 (post-08 — Classic Modern MVP)

File: `workspaces/archive/v2/cursor-09-classic-modern-mvp.code-workspace`

**Status:** **Closed** **2026-04-02** — round `@dev/notes/rounds/cursor-09-classic-modern-mvp-2026-04-02.md` **CLOSED** (does not supersede exit evidence section 3 backlog).

**Canonical pack:** `uDOS-docs/docs/classic-modern-mvp-0.1/README.md` — **Inbox (draft):** `@dev/inbox/classic-modern-mvp/README.md`

**Objective:**

- align **Classic Modern** tokens and UX rules across **Ubuntu host**, **ThinUI**, **uDOS Shell**, and **sonic-screwdriver**
- keep **experience orchestration** (surface profiles, ThinUI hosting contracts) aligned via **`uDOS-surface`** (`docs/surface-experience-layer.md`, `profiles/`)
- keep **Sonic** as a **TUI-only** utility (install / repair / doctor); browser product surfaces belong under uDOS / ThinUI
- promote accepted inbox content into `uDOS-docs` and repo-local docs when ready

**Repos in workspace:**

- `uDOS-dev` (control plane + inbox)
- `uDOS-docs` (canonical promoted pack: `docs/classic-modern-mvp-0.1/`)
- `uDOS-themes`, `uDOS-thinui`, **`uDOS-surface`**, `uDOS-host`, `uDOS-shell`
- `sonic-screwdriver`

**Exit gate:** satisfied **2026-04-02** — `@dev/notes/rounds/cursor-09-classic-modern-mvp-2026-04-02.md` **CLOSED** (not part of historical 01–08 release train).

**Workspace file location:** all `.code-workspace` files live under **`uDOS-dev/workspaces/`** — see **`workspaces/README.md`**.

## Cross-cutting themes by workspace

These complement each workspace’s main objective. Record them in round notes and
exit evidence when a lane touches them.

| Workspace | Binder + DeerFlow | Binder + spool | Clean as we go | Compost / archive | Vitals / health |
| --- | --- | --- | --- | --- | --- |
| **01** runtime spine | — | sync + spool boundary on host | yes | runtime `.compost` policy | Ubuntu + `~/.udos/` checks |
| **02** foundation / distro | — | seed paths for spool bundles | yes | installer + local compost | bootstrap + env health |
| **03** uHOME stream | — | HA / uHOME vs spool (if any) | yes | — | service health |
| **04** groovebox | — | optional audio feed patterns | yes | — | product checks |
| **05** GUI system | **DeerFlow ↔ workspace** surfaces | ThinUI/Core surface alignment | yes | — | app health entrypoints |
| **06** themes | — | — | yes | — | — |
| **07** docs / wiki / Pages | document DeerFlow + binder story | document feeds/spool + GKL | **yes** | docs `.compost` | publish + link health checks |
| **08** convergence | unify **Binder + DeerFlow** story across repos | **synchronicity** review Core↔Wizard↔runtime | **yes** | **family compost** compaction | **family vitals** matrix |
| **09** Classic Modern / Sonic TUI | document binder handoff to ThinUI where relevant | — | yes | — | TUI + host token checks; **uDOS-surface** profile alignment with ThinUI hosting |

Family readiness checklist: `@dev/notes/reports/family-readiness-audit-2026-04-01.md`.
