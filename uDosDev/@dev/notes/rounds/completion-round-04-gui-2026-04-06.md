# Round: completion-round-04 GUI

- Opened: **2026-04-06**
- **Closed:** **2026-04-06**
- Workspace: `workspaces/completion-round-04-gui.code-workspace`
- Prerequisite: **completion-round-03** (TUI) — **closed** **2026-04-06** (`@dev/notes/rounds/completion-round-03-tui-2026-04-05.md`)

## Status

**CLOSED** — **2026-04-06**. Three-step round complete (`docs/round-closure-three-steps.md`). Theme: **Empire, host, surface, themes, thinui, workspace, wizard, core, gpthelper** (+ dev, docs). Completion rounds **1–4** are complete; follow-on via **`docs/next-family-plan-gate.md`** and engineering backlog (`v2-roadmap-status.md`).

## Round execution

**Started:** **2026-04-06** — workspace `uDOS-dev/workspaces/completion-round-04-gui.code-workspace`; **Step 1 baseline** run from `~/Code/uDOS-family` (all **pass**).

**Re-verified:** **2026-04-06** — same Step 1 script block re-run; v2.6 release pass **`@dev/notes/reports/v2-6-release-pass-2026-04-06-231318.md`**.

**Operator visual lock:** **2026-04-06** — Browser on **http://127.0.0.1:7107/** with **`serve-command-centre-demo.sh`** running: **uDOS command centre** heading, **Static host demo — Ubuntu runtime spine (lane 1)**, and expected on-page contract / runtime footnotes.

## Browser confirmation links (operator GUI)

Servers must be running before these URLs load. Defaults: command-centre **`7107`** (`uDOS-host/scripts/lib/udos-web-listen.sh`); Wizard **`8787`** (`UDOS_WIZARD_PORT`, see `uDOS-wizard/docs/first-launch-quickstart.md`). If **`8787`** is taken, the demo stack uses the next free port (often **`8788`**); watch the terminal for the printed **open:** line.

### A — Static command centre (lane-1 regression)

1. From `uDOS-host`: `bash scripts/serve-command-centre-demo.sh`
2. Open (same machine):

| What | URL |
| --- | --- |
| Command centre home | [http://127.0.0.1:7107/](http://127.0.0.1:7107/) |
| Same via localhost | [http://localhost:7107/](http://localhost:7107/) |

**Expect:** heading **uDOS command centre** and demo copy (see `uDOS-dev/docs/command-centre-browser-preview.md`). Override port: `export UDOS_WEB_PORT=7108` then reopen `http://127.0.0.1:7108/`.

### B — Wizard + Surface (Svelte operator UI)

1. From `uDOS-wizard`: `python -m wizard.main` (or your usual venv path from `docs/first-launch-quickstart.md`) so FastAPI listens on **127.0.0.1** and **`UDOS_WIZARD_PORT`** (default **8787**).
2. Open — use **8787** first; if the stack reports a different port, substitute it everywhere below:

| What | URL (default port **8787**) |
| --- | --- |
| Demo hub | [http://127.0.0.1:8787/demo](http://127.0.0.1:8787/demo) |
| Demo links | [http://127.0.0.1:8787/demo/links](http://127.0.0.1:8787/demo/links) |
| Surface **/app** | [http://127.0.0.1:8787/app](http://127.0.0.1:8787/app) |
| Workflow | [http://127.0.0.1:8787/app/workflow](http://127.0.0.1:8787/app/workflow) |
| Automation | [http://127.0.0.1:8787/app/automation](http://127.0.0.1:8787/app/automation) |
| Thin GUI | [http://127.0.0.1:8787/app/thin-gui](http://127.0.0.1:8787/app/thin-gui) |
| Config | [http://127.0.0.1:8787/app/config](http://127.0.0.1:8787/app/config) |

More routes: `uDOS-wizard/apps/surface-ui/README.md` and `uDOS-wizard/docs/first-launch-quickstart.md`.

### C — LAN (optional second device)

From `uDOS-host`: `bash scripts/serve-command-centre-demo-lan.sh`, then `http://<LAN-IP>:7107/` on the other device (`uDOS-dev/docs/command-centre-browser-preview.md` § Option B).

## Spec and proof

| Ref | Location |
| --- | --- |
| Workspace index | `workspaces/completion-rounds-and-local-stack.md` |
| v2.6 mapping | `docs/completion-rounds-v2-6-alignment.md` |
| Round closure shape | `docs/round-closure-three-steps.md` |
| Command-centre preview | `uDOS-dev/docs/command-centre-browser-preview.md` |

## Sign-off

### Step 1 — Automated verification

**Done** — **2026-04-06**. From `~/Code/uDOS-family`:

```bash
bash uDOS-dev/scripts/run-v2-6-release-pass.sh
bash uDOS-core/scripts/run-core-checks.sh
bash uDOS-empire/scripts/run-empire-checks.sh
bash uDOS-surface/scripts/run-surface-checks.sh
bash uDOS-themes/scripts/run-theme-checks.sh
bash uDOS-thinui/scripts/run-thinui-checks.sh
bash uDOS-workspace/scripts/run-workspace-checks.sh
bash uDOS-wizard/scripts/run-wizard-checks.sh
bash uDOS-gpthelper/scripts/run-gpthelper-checks.sh
```

**Evidence:** v2.6 release pass **`@dev/notes/reports/v2-6-release-pass-2026-04-06-231318.md`** (latest re-verify). Core **92** tests; empire **73**; surface profiles validated + wizard suite **91**; themes **89**; ThinUI typecheck + `validate:binder-spine`; workspace `svelte-check` clean; gpthelper JSON + build green; host checks included in release pass.

### Step 2 — Integration / terminal proof

**Done** — **2026-04-06**. Local demo stack exercised by check scripts: **`uDOS-wizard`** / **`uDOS-surface`** integration (dynamic port when **8787** busy — e.g. **8788**). **`bash uDOS-host/scripts/verify-command-centre-http.sh`** green (ephemeral listener, **127.0.0.1** + **localhost**).

### Step 3 — Final GUI render (mandatory)

**Done** — **2026-04-06**. Operator browser sign-off: **Wizard Surface** at the default URLs in **§ Browser confirmation links** (substitute port if **8787** is busy); static command centre at **[http://127.0.0.1:7107/](http://127.0.0.1:7107/)** after **`bash uDOS-host/scripts/serve-command-centre-demo.sh`**. Runbook: **`uDOS-dev/docs/command-centre-browser-preview.md`**. HTTP regression: **`bash uDOS-host/scripts/verify-command-centre-http.sh`** (**OK**).

- [x] Step 1 recorded
- [x] Step 2 recorded
- [x] Step 3 recorded

## Next (after completion rounds 1–4)

**`docs/next-family-plan-gate.md`**, **`@dev/notes/roadmap/next-plan-readiness.md`**, and **`v2-roadmap-status.md`** Current Focus — no further numbered completion workspace in **`workspaces/README.md`** after round **4**.
