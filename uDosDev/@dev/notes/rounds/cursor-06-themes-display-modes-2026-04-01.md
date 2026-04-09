# Round: cursor-06 themes and display modes

- Date: 2026-04-01
- Workspace: `cursor-06-themes-display-modes.code-workspace` (open from **`uDOS-family/`** so folder paths `uDOS-themes`, `uDOS-thinui`, … resolve)

## Status

**CLOSED** **2026-04-01** — exit gate satisfied; specs and implementation evidence below. **Next:** `cursor-07-docs-wiki-courses.code-workspace`.

**Workspace file:** `uDOS-family/cursor-06-themes-display-modes.code-workspace`.

## Operator start

1. Open **`uDOS-family/cursor-06-themes-display-modes.code-workspace`** in Cursor (multi-root: themes, thinui, workspace, shell, docs, dev).
2. Read lane authority below and **`docs/cursor-focused-workspaces.md` § Workspace 06**.
3. **Quick verification (repos in scope):**
   - **`uDOS-themes`:** `bash scripts/run-theme-checks.sh`
   - **`uDOS-thinui`:** `bash scripts/run-thinui-checks.sh` (when wiring consumers)
   - **`uDOS-workspace`:** `bash scripts/run-workspace-checks.sh` (when wiring consumers)
   - **`uDOS-shell`:** run repo check script if present when touching TUI parity
   - **`uDOS-docs`:** `bash scripts/run-docs-checks.sh` when touching docs hub
4. **Cross-cutting themes for this lane:** `docs/cursor-focused-workspaces.md` § **Cross-cutting themes by workspace** (row **06**): clean as we go.

## Finishing shape (recommended for close)

| Step | What |
| --- | --- |
| **1** | Repo check scripts green for touched repos. |
| **2** | Spec outputs in **`docs/cursor-focused-workspaces.md` § Workspace 06** backed by checked-in docs and data (`uDOS-themes` display modes, primitive map, skin loader, adapter modules). |
| **3** | Exit evidence: working ThinUI renderer pack (existing lane + registry), publish prose preset, GTX-form prototype from canonical JSON, cross-surface primitive mapping table. |

## Lane authority

- Objectives, repos in scope, spec outputs, exit gate: `docs/cursor-focused-workspaces.md` § Workspace 06
- Sequence: `docs/cursor-execution.md` (step 6)
- GUI baseline: `docs/gui-system-family-contract.md`

## Spec outputs (delivered)

| Output | Where |
| --- | --- |
| Display-mode inventory | `uDOS-themes/docs/display-modes.md` |
| Theme / token standard | `uDOS-themes/docs/theme-token-standard.md` |
| Step-form and presentation-flow rules | `uDOS-themes/docs/step-form-presentation-rules.md` |
| Adapter and skin registry plan | `uDOS-themes/docs/adapter-skin-registry-plan.md` |
| ThinUI + workflow + Prose + GTX integration plan | `uDOS-themes/docs/integration-thinui-workflow-prose-gtx.md` |
| Cross-surface primitive ↔ adapter map | `uDOS-themes/examples/cross-surface-rendering-matrix.json` § `primitive_surface_map` |
| Skin loader (registry → skin + base theme) | `uDOS-themes/src/load-skin.mjs` |
| GTX-form canonical flow | `uDOS-themes/examples/gtx-form-flow.json` (loaded by `src/adapters/forms/gtx-form-prototype.mjs`) |
| ThinUI ↔ themes boundary + skin diagnostic | `uDOS-thinui/docs/themes-sibling-bridge.md`, `uDOS-thinui/scripts/print-themes-skin.mjs` |
| Shell TUI parity with themes adapters | `uDOS-shell/docs/tui-themes-parity.md` |
| Workspace web consumes browser-default tokens | `uDOS-workspace/apps/web/src/lib/theme/` (`theme-tokens.json`, `browserDefaultShell.ts`) + `uDOS-themes/scripts/sync-theme-tokens-to-workspace.sh` |
| Reader hub (uDOS-docs) | `uDOS-docs/docs/themes-and-display-modes.md` |

## Exit gate (Workspace 06)

| Criterion | Evidence |
| --- | --- |
| Theme and mode vocabulary is consistent | `display-modes.md`, `theme-token-standard.md`, registries + `theme-tokens.json` |
| Forms and story flows are deliberate design | `step-form-presentation-rules.md`, GTX JSON + forms adapter |
| GUI and TUI interaction posture aligned | `tui-themes-parity.md`, `integration-…-gtx.md`, ThinUI bridge doc |
| `uDOS-themes` past scaffold-only adapters | Node adapter modules + smoke, `load-skin.mjs`, integration plan phases C–E for follow-on |

## Carry-forward (Workspace 05 Step 3)

Optional: operator visual smoke per **`docs/gui-system-family-contract.md` § Operator visual sign-off** when convenient (ThinUI terminal + Vite + Wizard `/demo`).

## Next lane (after closure)

`cursor-07-docs-wiki-courses.code-workspace` — `docs/cursor-execution.md`.

## Related

- Prior round: `@dev/notes/rounds/cursor-05-gui-system-2026-04-01.md`
- Themes follow-up: `uDOS-themes/@dev/next-round.md`, `uDOS-themes/docs/workspace-06-next-round.md`
- Family execution order: `docs/cursor-execution.md`
