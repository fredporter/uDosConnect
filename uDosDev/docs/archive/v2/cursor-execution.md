# Cursor targeted execution

Use this page when running the family completion pass **one focused workspace at
a time** in Cursor.

## Authority

- **Order and rules:** `CURSOR_HANDOVER_PLAN.md` (family repo root; workspace
  **files** in `uDOS-dev/workspaces/`)
- **Lane objectives, repos in scope, exit gates:** `docs/archive/v2/cursor-focused-workspaces.md`
  (this repo)
- **Release tier context:** `docs/release-tier-map.md`

## Workspace files live in `uDOS-dev/workspaces/`

Open a file such as **`workspaces/archive/v2/cursor-02-foundation-distribution.code-workspace`**
from the **`uDOS-dev`** checkout (or **File → Open Workspace** and pick
**`uDOS-dev/workspaces/…`** from your `uDOS-family` tree). Family root
**`CURSOR-WORKSPACES.md`** points here.

## Optional step 0 — overview

Open `workspaces/archive/v2/uDOS-v2-public.code-workspace` **only** for orientation: full family
folder set, light settings. It is **not** a substitute for finishing a numbered
lane. Do not treat the overview workspace as a completion gate.

## Execution sequence (numbered lanes)

Work **strictly in order** for steps **1–8** unless the family explicitly renumbers or renames the
workspace files in git (all under **`workspaces/`**):

| Step | File | Lane |
| --- | --- | --- |
| 1 | `workspaces/archive/v2/cursor-01-runtime-spine.code-workspace` | Runtime spine (Ubuntu host, Wizard orchestration, vault/sync) |
| 2 | `workspaces/archive/v2/cursor-02-foundation-distribution.code-workspace` | Install, Sonic, Ventoy, paths, `~/.udos/` |
| 3 | `workspaces/archive/v2/cursor-03-uhome-stream.code-workspace` | uHOME stream adjacent to core |
| 4 | `workspaces/archive/v2/cursor-04-groovebox-product.code-workspace` | Groovebox product |
| 5 | `workspaces/archive/v2/cursor-05-gui-system.code-workspace` | ThinUI, workspace, Typo, shared GUI |
| 6 | `workspaces/archive/v2/cursor-06-themes-display-modes.code-workspace` | Themes, display modes, shell |
| 7 | `workspaces/archive/v2/cursor-07-docs-wiki-courses.code-workspace` | Docs, wiki, GitHub Pages, courses, `uDOS-docs` hub |
| 8 | `workspaces/archive/v2/cursor-08-family-convergence.code-workspace` | Convergence, duplication, release structure |
| 9 (post-08) | `workspaces/archive/v2/cursor-09-classic-modern-mvp.code-workspace` | Classic Modern + ThinUI + Shell + Sonic TUI charter (`@dev/inbox/classic-modern-mvp/README.md`) |

### Step 9 — Classic Modern MVP (Workspace 09, post-08) — **closed** **2026-04-02**

- **Exit gate and scope:** `docs/archive/v2/cursor-focused-workspaces.md` Workspace 09 (**Closed**)
- **Round note:** `@dev/notes/rounds/cursor-09-classic-modern-mvp-2026-04-02.md` **CLOSED**
- **Canonical promoted pack:** `uDOS-docs/docs/classic-modern-mvp-0.1/README.md` (draft iterations: `@dev/inbox/classic-modern-mvp/`)
- **Experience orchestration:** `uDOS-surface/docs/surface-experience-layer.md`, `uDOS-surface/profiles/` (e.g. `ubuntu-gnome`)
- **Next:** optional post-08 **O1–O4** — `@dev/notes/roadmap/post-08-optional-rounds.md`

### Step 7 — docs, wiki, courses (Workspace 07)

- **Exit gate and scope:** `docs/archive/v2/cursor-focused-workspaces.md` § Workspace 07
- **Round note:** `@dev/notes/rounds/cursor-07-docs-wiki-courses-2026-04-01.md`
- **Publishing and learning metadata:** in `uDOS-docs`, read `docs/publishing-architecture.md`, `docs/local-vs-github-docs-boundary.md`, and `docs/course-hooks-and-onboarding.md` (operator checklist at the end of publishing-architecture)
- **Deer Flow (optional upstream):** `workspaces/archive/v2/cursor-07-docs-wiki-courses.code-workspace` includes `uDOS-plugin-deerflow` and `uDOS-plugin-deerflow/vendor/deer-flow`. Clone upstream with `bash scripts/clone-deerflow.sh "$(pwd)"` from the plugin repo root (`uDOS-plugin-deerflow/docs/README.md`).

### Step 8 — family convergence (Workspace 08) — **closed** **2026-04-01**

- **Exit evidence:** `docs/archive/v2/workspace-08-exit-evidence.md` (satisfied; `docs/archive/v2/cursor-focused-workspaces.md` § Workspace 08 **Closed**)
- **Round note:** `@dev/notes/rounds/cursor-08-family-convergence-2026-04-01.md` **CLOSED**
- **Gap ledger:** `@dev/notes/reports/family-readiness-audit-2026-04-01.md` § Final round (Workspace 08)
- **Deliverables (done):** `docs/family-documentation-layout.md` + `docs/archive/v2/family-workspace-08-scope.md`, `@dev/notes/reports/family-duplication-and-pathway-candidates-2026-04-01.md`, `docs/next-family-plan-gate.md`; post-08 order in exit evidence section 3. **Workspace 09** (Classic Modern) **closed 2026-04-02** — `docs/archive/v2/cursor-focused-workspaces.md` Workspace 09.

## Git branch expectation

Family coordination assumes **`main`** as the default integration branch.
**Prefer committing on `main`**; create a short-lived branch only for a clear
reason—not by habit. See `docs/pr-checklist.md` § Branch policy and
`.cursor/rules/main-and-pr-finalization.mdc`.

## Per-lane discipline

- Open **one** numbered `.code-workspace` at a time.
- Exit only when the **exit gate** in `cursor-focused-workspaces.md` for that
  lane is satisfied and `uDOS-dev` / repo `@dev` notes are updated (see
  `CURSOR_HANDOVER_PLAN.md`).

**Workspaces 01 and 02 — three-step round closure:** every round ends with **(1)** automated verification, **(2)** terminal or integration proof, **(3)** **final GUI render** (real browser, human eyes). Steps 1–2 alone do **not** close the round. See `docs/round-closure-three-steps.md`.

## Cross-cutting themes (carry through the rounds)

Bring these forward **in each relevant lane** so they are specified, tested, and
documented—not deferred to a vague “later cleanup.”

| Theme | What to nail |
| --- | --- |
| **Binder + DeerFlow workflow** | Binder ↔ Wizard Deer Flow ↔ workspace handoff: preview vs controlled execution, artifact persistence, and where operators look for results. |
| **Binder + spool synchronicity** | How binder lifecycle and feed/spool semantics line up (Core + runtime + any UI surfaces); no silent drift between “binder done” and “spool updated.” |
| **Clean as we go** | Each lane ends with tidier trees: scripts, docs, `@dev` notes; no opportunistic scope creep. |
| **Compost heap** | `.compost` and superseded local material: **build, compact, rotate** per policy; organic archive only, not runtime state. |
| **System vitals** | Health checks and optimisation paths for `~/.udos/`, Ubuntu hosts, and family scripts — documented, runnable, and linked from onboarding or ops docs. |

**Lane hints:** see `cursor-focused-workspaces.md` section **Cross-cutting themes
by workspace**. Audit checklist: `@dev/notes/reports/family-readiness-audit-2026-04-01.md`.

## Ready state

Preparation is aligned when:

- Overview and focused workspaces use consistent exclude patterns (see workspace
  JSON).
- This document and family-root `CURSOR_HANDOVER_PLAN.md` agree on sequence **01 → 09** (01–08 **2026-04-01**; Step 9 **2026-04-02**).

**Historical sequence:** Steps **1–8** used `workspaces/archive/v2/cursor-01-runtime-spine.code-workspace` through `workspaces/archive/v2/cursor-08-family-convergence.code-workspace` — **closed**. **Step 9** `workspaces/archive/v2/cursor-09-classic-modern-mvp.code-workspace` — **closed** **2026-04-02**. **Post-08** work follows **`docs/archive/v2/workspace-08-exit-evidence.md`** section 3 and **`CURSOR_HANDOVER_PLAN.md`**; optional **O1–O4** in **`post-08-optional-rounds.md`**.

## Post-08 optional rounds

Use `@dev/notes/roadmap/post-08-optional-rounds.md` for optional backlog
execution in backlog mode (O1-O4) without opening a numbered `v2.x` plan.
