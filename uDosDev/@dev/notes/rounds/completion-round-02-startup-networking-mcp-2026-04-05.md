# Round: completion-round-02 startup / networking / MCP

- Opened: **2026-04-05**
- **Closed:** **2026-04-05**
- Workspace: `workspaces/completion-round-02-startup-networking-mcp.code-workspace`
- Prerequisite: **completion-round-01** (install / distribution) — **closed** **2026-04-05** (`@dev/notes/rounds/completion-round-01-install-distribution-2026-04-05.md`)

## Status

**CLOSED** — **2026-04-05**. Three-step round complete (`docs/round-closure-three-steps.md`). **Product fix** on **`uDOS-wizard` `main`:** Surface `/app` asset URLs (`/app-assets/`), `/demo/links` human redirect (`Request` query + `/demo/links.html`), legacy `/assets/` rewrite in HTML responses, Vite build `base` + optional `crossorigin` strip. Open **`workspaces/completion-round-03-tui.code-workspace`** per `workspaces/README.md`.

## Round execution

**Started:** **2026-04-05** — workspace open; **Step 1 baseline** run from `~/Code/uDOS-family` (all **pass**).

## Spec and proof

| Ref | Location |
| --- | --- |
| Workspace index | `workspaces/completion-rounds-and-local-stack.md` |
| v2.6 mapping | `docs/completion-rounds-v2-6-alignment.md` |
| Round closure shape | `docs/round-closure-three-steps.md` |
| Wizard MCP lane | `uDOS-wizard` activation / MCP docs; `bash scripts/run-wizard-checks.sh` |

## Sign-off

### Step 1 — Automated verification

**Done** — **2026-04-05**. From `~/Code/uDOS-family`:

```bash
bash uDOS-dev/scripts/run-v2-6-release-pass.sh
bash uDOS-alpine/scripts/run-alpine-checks.sh
bash uDOS-gpthelper/scripts/run-gpthelper-checks.sh
bash uDOS-wizard/scripts/run-wizard-checks.sh
bash uDOS-thinui/scripts/run-thinui-checks.sh
bash uDOS-shell/scripts/run-shell-checks.sh
bash uDOS-plugin-index/scripts/run-plugin-index-checks.sh
```

**Evidence:** v2.6 release pass **`@dev/notes/reports/v2-6-release-pass-2026-04-05-223431.md`**. Wizard: **91** tests OK; sibling scripts pass.

### Step 2 — Integration / terminal proof

**Done** — **2026-04-05**. Local stack: **`python -m wizard.main`** on **127.0.0.1:8787** (FastAPI broker + Surface); **`bash uDOS-host/scripts/serve-command-centre-demo.sh`** on **127.0.0.1:7107** (static command-centre demo). Live HTTP: `/port/status`, `/mcp/tools`, `/host/*`, `/workflow/*`, `/app-assets/assets/*` (200). **`uDOS-wizard`** commits: Surface Vite **`base`**, **`/app-assets`** mount, demo-link redirects, SPA index rewrite for legacy builds.

### Step 3 — Final GUI render (mandatory)

**Done** — **2026-04-05**. Operator browser sign-off: **Surface** **`http://127.0.0.1:8787/app`** and deep routes (e.g. **`/app/workflow`**) render the Svelte operator UI; human demo hub **`http://127.0.0.1:8787/demo`**; optional static lane **`http://127.0.0.1:7107/`** (command-centre demo). Regression anchor remains available: **`bash uDOS-host/scripts/verify-command-centre-http.sh`**.

- [x] Step 1 recorded
- [x] Step 2 recorded
- [x] Step 3 recorded

## Next round

**`completion-round-03-tui.code-workspace`** — `workspaces/README.md`.
