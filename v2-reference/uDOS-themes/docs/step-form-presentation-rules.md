# Step-form and presentation-flow rules

Deliberate interaction design for guided setup, wizards, and narrative surfaces across browser, ThinUI, TUI, and workflow views.

## Default posture

1. **Step-by-step forms** are the **preferred** pattern for multi-field setup (installers, runtime naming, mode selection). Do not scatter one-off modals when a flow has three or more decisions with ordering.
2. **One primary action** per step (continue / submit step); secondary actions (back, cancel) stay visible but subordinate.
3. **Progress** is always communicated when more than one step exists (numeric `current/total` or explicit label).

## Canonical data

- **GTX step model:** `examples/gtx-form-flow.json` — step `id`, `type` (`input-field`, `choice-grid`, …), `prompt`, optional `choices` / `placeholder`.
- **Prototype API:** `src/adapters/forms/index.mjs` — `createGtxFormPrototype()`, `renderBrowserFormStep`, `renderThinUiFormStep`, `renderTuiFormStep`, `submitForm`.
- **CLI demo:** `scripts/demo-gtx-form-tui.mjs` — prints `renderTuiFormStep` output for the canonical JSON (`node scripts/demo-gtx-form-tui.mjs` from repo root).

## Surface behaviour

| Surface | Adapter | Rendering expectation |
| --- | --- | --- |
| Browser | `forms-gtx-step` | Section with step count, prompt, inputs or choice grid (`prose`-friendly markup). |
| ThinUI | `thinui-default` + forms helpers | ASCII/terminal lines with numbered choices. |
| TUI / Shell | `tui-default` + forms helpers | Full-width text layout; parity with ThinUI step copy where possible. |
| Workflow | `workflow-default` | Same step ids can appear as lane tasks or checklist rows tied to binder state. |

## Presentation flows

- **Presentation** = read-mostly narrative (docs preview, publish preview). Use **`publish-tailwind-prose`** adapter output shape: title, lede, sections with HTML safe for `prose` classes.
- **Story flows** that mix prose and input should **end** on an input step or explicit confirmation, not an ambiguous “done” with no state capture.

## Anti-patterns

- Duplicate step ids in one flow.
- Skipping progress on flows longer than two screens without operator context.
- Forking GTX JSON shape in app repos — extend `examples/gtx-form-flow.json` and map in adapters here.

## Related

- `docs/display-modes.md`
- `uDOS-shell/docs/tui-themes-parity.md` (in `uDOS-shell`)
- `docs/integration-thinui-workflow-prose-gtx.md`
