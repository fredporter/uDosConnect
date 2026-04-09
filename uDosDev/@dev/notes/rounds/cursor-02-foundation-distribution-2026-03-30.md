# Round: cursor-02 foundation and distribution

- Date: 2026-03-30
- Workspace: `cursor-02-foundation-distribution.code-workspace`

## Status

**CLOSED** — **2026-03-31**. Three-step round complete (`docs/round-closure-three-steps.md`). Open **`cursor-03-uhome-stream.code-workspace`** per `docs/cursor-execution.md`.

## Spec and exit gate

| Criterion | Evidence |
| --- | --- |
| Install locations consistent | `uDOS-dev/docs/foundation-distribution.md`; `CURSOR_HANDOVER_PLAN.md`; `uDOS-host/docs/config-layout.md` |
| Sonic first-entry installer | `sonic-screwdriver/README.md` (preflight + CLI); foundation-distribution topology |
| Repo vs runtime state | foundation-distribution § Path standard; `runtime-layout.sh` |
| Distro / image dependency order | foundation-distribution § Distro and image dependency order |
| Sonic / Ventoy split | `docs/family-split-prep.md`; foundation-distribution § Sonic and Ventoy split |

## Sign-off (steps 1–2)

1. **Automated verification:** `bash uDOS-host/scripts/foundation-distribution-workspace-proof.sh` — green (Sonic `run-sonic-checks.sh`, `run-ubuntu-checks.sh`, `verify-command-centre-http.sh`, `run-core-checks.sh`, `run-plugin-index-checks.sh`, `run-alpine-checks.sh`, `run-docs-checks.sh`, `run-dev-checks.sh` with `SONIC_SCREWDRIVER_ROOT` from the proof script). **Fixtures:** `@dev/fixtures/binder-dev-v2-3-workflow-schedules.md`; Sonic path resolution in `scripts/run-v2-3-workflow-schedule-demo.sh` supports `../sonic-screwdriver` or `../../sonic-family/sonic-screwdriver`.
2. **Integration / terminal proof:** same script chain as step 1 for this lane; optional Ubuntu-only re-run as in pathway.

## Step 3 (final GUI render)

**Done** — **2026-03-31**. Operator opened a real browser to **`http://127.0.0.1:7107/`**
after `serve-command-centre-demo.sh` and **confirmed** the rendered **uDOS command centre**
page (visible **“uDOS command centre”** heading and lane-1 demo copy). Runbook:
`docs/command-centre-browser-preview.md`.

- [x] Browser confirmation recorded (**2026-03-31** / operator localhost sign-off).

## Next lane

`cursor-03-uhome-stream.code-workspace` — `docs/cursor-execution.md`, `docs/cursor-focused-workspaces.md` § Workspace 03.

## Related

- Pathway: `@dev/pathways/foundation-distribution-workspace-round-closure.md`
- Tier map restored: `docs/release-tier-map.md`
