# Themes Next Round

## Target Round

Follow-on work after **cursor-06** closure (ongoing engineering, not a blocking lane):

## Completed in cursor-06 (baseline)

- Display modes, token standard, step-form rules, registry plan, integration plan docs
- Skin loader, primitive map, GTX JSON + forms adapter, Node adapter smokes
- Workspace web token load + sync script; ThinUI bridge + Shell TUI parity note
- Reader hub: `uDOS-docs/docs/themes-and-display-modes.md`

## Optional follow-up (phases C–E)

- **ThinUI hydration:** **phase-C tranche 1 done** — ThinUI resolver now accepts
  thinui-safe skin ids (`skin:<id>` and mirrored ids such as `sonic-boot`,
  `alpine-safe`) and maps them to base thinui theme ids without changing runtime
  loop ownership. Keep deeper token/loader metadata hydration optional.
- **Tailwind Prose preset:** **phase-E tranche 2 done (O1)** — same contract
  syncs to `packages/tailwind-prose-preset` for `file:` npm consumption
  (`scripts/sync-publish-prose-preset-to-package.sh`) in addition to the
  workspace mirror.
- **Wizard / workflow:** **phase-D tranche 2 done (O1)** — GTX map syncs to
  `uDOS-wizard/apps/surface-ui/src/lib/contracts/gtx-step-task-map.json`;
  Workflow surface resolves `step_id` → task metadata from the mirrored map.
- **Shell CLI demo:** **done** — `scripts/demo-gtx-form-tui.mjs` prints `renderTuiFormStep` output for **`examples/gtx-form-flow.json`** (validated in `run-theme-checks.sh`).

## Exit Evidence (cursor-06)

Satisfied per `@dev/notes/rounds/cursor-06-themes-display-modes-2026-04-01.md`.

## Family index (Workspace 08)

Post-06 adapter work is listed under **Post-08 engineering hooks** in
**`uDOS-dev`** `@dev/notes/reports/family-duplication-and-pathway-candidates-2026-04-01.md`.
