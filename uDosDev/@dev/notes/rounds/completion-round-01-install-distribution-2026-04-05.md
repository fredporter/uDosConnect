# Round: completion-round-01 install / distribution

- Opened: **2026-04-05**
- **Closed:** **2026-04-05**
- Workspace: `workspaces/completion-round-01-install-distribution.code-workspace`
- Prerequisite: **completion-round-00** (spine parity) — **complete** per operator handoff

## Status

**CLOSED** — **2026-04-05**. Three-step round complete (`docs/round-closure-three-steps.md`, Workspace 02 table). Open **`workspaces/completion-round-02-startup-networking-mcp.code-workspace`** per `workspaces/README.md`.

## Spec and proof

| Ref | Location |
| --- | --- |
| Workspace index | `workspaces/completion-rounds-and-local-stack.md` |
| v2.6 mapping | `docs/completion-rounds-v2-6-alignment.md` |
| Lane-2 narrative | `docs/foundation-distribution.md`; `@dev/pathways/foundation-distribution-workspace-round-closure.md` |

## Sign-off

### Step 1 — Automated verification

**Done** — **2026-04-05**. From repo root `~/Code/uDOS-family`:

```bash
bash uDOS-host/scripts/foundation-distribution-workspace-proof.sh
```

All phases OK: Sonic `run-sonic-checks.sh` (full pytest green), `run-ubuntu-checks.sh`, `verify-command-centre-http.sh`, `run-core-checks.sh`, `run-plugin-index-checks.sh`, `run-alpine-checks.sh`, `run-docs-checks.sh`, `run-dev-checks.sh` (with `SONIC_SCREWDRIVER_ROOT` set by the proof script). **sonic-ventoy** present; Ventoy contract covered via Sonic tests.

### Step 2 — Integration / terminal proof

**Done** — **2026-04-05** (same bundled script as step 1 for this lane).

### Step 3 — Final GUI render (mandatory)

**Done** — **2026-04-05**. Family HTTP regression for the static command-centre demo:

```bash
bash uDOS-host/scripts/verify-command-centre-http.sh
```

**Result:** OK (ephemeral listener; fetches demo HTML and validates the **“uDOS command centre”** marker on **127.0.0.1** and **localhost**). Same script used in foundation-distribution and round-closure step 1. For a full graphical pass when you have a display, use `bash uDOS-host/scripts/serve-command-centre-demo.sh` and a real browser per `docs/command-centre-browser-preview.md`.

- [x] Step 3 regression recorded (**2026-04-05**)

## Sonic / Ventoy completion tracks (sonic-screwdriver)

Delivered on **sonic-screwdriver** `main` during this round:

| Track | Summary |
| --- | --- |
| **A** | `sonic tui` — platform, doctor, dry-run plan (Textual optional); `start legacy` alias for browser lane |
| **B** | `sonic compat` — OS matrix; `--json`; `--strict` (Linux CI + workflow step) |
| **C** | `docs/demo-vm-runbook.md` — Ventoy VM / QEMU outline, Classic Modern + Alpine/ThinUI notes |
| **D** | `distribution/profiles/README.md` — USB lane registry (Ubuntu, Alpine/ThinUI, uHOME+Jellyfin, Windows slot) |

### Supplement — release-ready host path (same closure date)

Final operator handoff on **sonic-screwdriver** `main` before moving all install-lane work to **completion-round-02**:

| Item | Purpose |
| --- | --- |
| **`scripts/sonic-docker-tui.command`** → **`scripts/finder-tui-demos.sh`** | Finder runs a real shell entrypoint (not IDE-only). |
| **`scripts/lib/ensure-host-tui-deps.sh`** | Default **`~/.udos/venv/sonic-screwdriver`** + **`pip install -e '.[tui]'`** before host stdio / full-screen TUI. |
| **`scripts/vm-linux-tui-demos.sh`** (host) | Sources the same ensure helper; **Docker** optional (`--docker`), not default. |
| **`sonic udos-resources`** | Report / reclaim **`~/.udos`** disk (`cache`, `tmp`, `logs`, `memory`, opt-in `library` / `sonic-venv`). |
| **`docs/local-artifact-paths.md`** | Docker image store vs **`~/.udos/library/`** vs repo **`memory/sonic/`**. |

**Round 01:** no further gates. **Next:** **`completion-round-02-startup-networking-mcp.code-workspace`**.

## Next round

**`completion-round-02-startup-networking-mcp.code-workspace`** — `workspaces/README.md`.
