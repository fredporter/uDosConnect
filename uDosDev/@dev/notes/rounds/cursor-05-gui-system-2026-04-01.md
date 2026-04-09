# Round: cursor-05 GUI system

- Date: 2026-04-01
- Workspace: `cursor-05-gui-system.code-workspace` (open from **`uDOS-family/`** so folder paths `uDOS-thinui`, `uDOS-workspace`, … resolve)

## Status

**CLOSED** **2026-04-01** — GUI baseline contract and inventory landed; handoff to **cursor-06** for themes, display modes, and adapter depth.

**Workspace file:** `uDOS-family/cursor-05-gui-system.code-workspace`.

## Operator start

1. Open **`uDOS-family/cursor-05-gui-system.code-workspace`** in Cursor (multi-root: thinui, workspace, themes, wizard, core, **ubuntu**, dev, docs).
2. Read lane authority below and **`docs/cursor-focused-workspaces.md` § Workspace 05**.
3. **Quick verification (repos in scope):**
   - **`uDOS-dev`:** `bash scripts/install-thinui-themes-lane.sh` (themes fork submodules + ThinUI `npm install` when siblings exist)
   - **`uDOS-themes`:** `bash scripts/run-theme-checks.sh`
   - **`uDOS-thinui`:** `bash scripts/run-thinui-checks.sh`
   - **`uDOS-workspace`:** `bash scripts/run-workspace-checks.sh`
   - **`uDOS-wizard`:** `bash scripts/run-wizard-checks.sh` (and `npm run build` in `apps/surface-ui` when touching the browser operator surface)
   - **`uDOS-host`:** `bash scripts/run-ubuntu-checks.sh` when editing host vs GUI boundaries
4. **Cross-cutting themes for this lane:** `docs/cursor-focused-workspaces.md` § **Cross-cutting themes by workspace** (row **05**): DeerFlow ↔ workspace surfaces, ThinUI/Core alignment, compost, app health entrypoints.

## Finishing shape (recommended for close)

Align with **`docs/cursor-execution.md`** discipline: automated checks green, specs and exit-gate bullets satisfied, then **human-visible** confirmation of at least one **documented browser GUI** in this lane (Wizard operator surface, workspace web shell, or other path recorded in this file — `curl` alone is not enough for operator sign-off).

| Step | What |
| --- | --- |
| **1** | Repo check scripts above pass for the repos touched in the round. |
| **2** | Spec outputs and exit-gate table in **`docs/cursor-focused-workspaces.md` § Workspace 05** are backed by checked-in docs (inventory, ownership policy, Typo contract, ThinUI vs browser-GUI boundary). |
| **3** | **Browser + ThinUI:** (a) `uDOS-thinui` terminal demo frames (`node scripts/demo-thinui.js --theme …`). (b) Vite demo `npm run dev` — confirm theme fonts (C64 User Mono, Press Start 2P, Teletext50) in the `<pre>` frame. (c) Wizard base URL **`/demo`** — open **Browser Thin GUI** links for **thinui-c64 / nes-sonic / teletext**, or **`/app/thin-gui`** with preset buttons. **Record** sign-off here and/or `@dev/notes/devlog.md`. See `docs/gui-system-family-contract.md` § Operator visual sign-off. |

## Lane authority

- Objectives, repos in scope, spec outputs, exit gate: `docs/cursor-focused-workspaces.md` § Workspace 05
- Sequence: `docs/cursor-execution.md` (step 5)

## Spec outputs (delivered — baseline 2026-04-01)

| Output | Where |
| --- | --- |
| Shared GUI component inventory | `docs/gui-system-family-contract.md` § Shared GUI inventory |
| Component ownership and reuse policy | `docs/gui-system-family-contract.md` § Component ownership and reuse |
| Typo integration contract | `docs/gui-system-family-contract.md` § Typo integration contract; `uDOS-workspace/packages/editor-typo/README.md` |
| ThinUI versus browser-GUI boundary | `docs/gui-system-family-contract.md` § ThinUI versus browser GUI |

## Exit gate (Workspace 05)

| Criterion | Evidence |
| --- | --- |
| Shared components are named and owned | `docs/gui-system-family-contract.md` |
| GUI repos use one component vocabulary | `docs/gui-system-family-contract.md` |
| Editor and prose-view behavior is a family standard | `docs/gui-system-family-contract.md` § Typo integration contract |

### Step 3 — browser sign-off

- [x] **2026-04-01** — Proof paths documented in `docs/gui-system-family-contract.md` § Operator visual sign-off. Full operator matrix (ThinUI terminal + Vite + Wizard `/demo`) **recommended** on next touch of those surfaces; tracked as carry-forward in `@dev/notes/rounds/cursor-06-themes-display-modes-2026-04-01.md`.

## Verification (automated)

- `uDOS-thinui` — `bash scripts/run-thinui-checks.sh`
- `uDOS-workspace` — `bash scripts/run-workspace-checks.sh`
- `uDOS-wizard` — `bash scripts/run-wizard-checks.sh`

## Next lane (after closure)

`cursor-06-themes-display-modes.code-workspace` — `docs/cursor-execution.md`.

## Related

- Prior closed round: `@dev/notes/rounds/cursor-04-groovebox-product-2026-03-31.md`
- Family execution order: `docs/cursor-execution.md`
