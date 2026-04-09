# Round: cursor-01 runtime spine — **closure criteria (amended)**

- Date: 2026-03-30 (updated same day: real daemons + physical proof gate)
- Workspace: `cursor-01-runtime-spine.code-workspace`

## Status

**CLOSED** — **2026-03-30**. Three-step round complete (`docs/round-closure-three-steps.md`). You may open **`cursor-02-foundation-distribution.code-workspace`** per `docs/cursor-execution.md`.

### Sign-off (steps 1–3)

1. **Automated verification:** `run-ubuntu-checks.sh` **and** `verify-command-centre-http.sh` green.
2. **Terminal round:** `runtime-spine-round-proof.sh` completed **[1/3][2/3]** (HTTP verify + full workspace TUI).
3. **Final GUI render:** operator **opened a real browser** and **confirmed** the uDOS command-centre page (`serve-command-centre-demo.sh` / `serve-command-centre-demo-lan.sh` as applicable); **curl-only does not count** for this step.

**Real HTTP daemons:** In tree (`runtime_daemon_httpd.py`); **`verify-udos-runtime-daemons.sh`** passes via **`run-ubuntu-checks.sh`**.

---

## Exit gate (Workspace 01) — spec + automation

| Criterion | Evidence |
| --- | --- |
| `uDOS-host` documented as primary runtime host | `uDOS-host/README.md`, `docs/architecture.md`; `uDOS-dev/docs/runtime-spine.md` |
| Wizard narrowed to orchestration / broker | `uDOS-wizard/README.md`; Core contracts `wizard-host-surface.v1.json` (owner `uDOS-host`) |
| Local vs remote sync responsibilities assigned | `runtime-spine.md`; `runtime-layout.sh` materializes `sync/queue`, `sync/archive` |
| Runtime path assumptions written and linked | `runtime-spine.md`; `uDOS-host/docs/config-layout.md`; `scripts/lib/runtime-layout.sh` |
| Lane-1 HTTP daemons | `udos-hostd.sh`, `udos-web.sh`, `udos-vaultd.sh`, `udos-syncd.sh`, `udos-commandd.sh` (serve), six `udos-*` aux wrappers → `runtime_daemon_httpd.py`; `scripts/verify-udos-runtime-daemons.sh` |

## Implementation (lane 1)

| Deliverable | Where |
| --- | --- |
| **Canonical `~/.udos/` layout** | `scripts/lib/runtime-layout.sh`; `scripts/udos-hostd.sh` (then long-lived hostd HTTP) |
| **Checks** | `scripts/run-ubuntu-checks.sh` (layout + commandd/gitd + **verify-udos-runtime-daemons.sh**) |
| **commandd + gitd** | `scripts/udos-commandd.sh`, `scripts/udos-gitd.sh` + JSON contracts |
| **Aux minimal HTTP** | **budgetd / networkd / scheduled / tuid / thinui / wizard-adapter** → `runtime_daemon_httpd.py` aux modes (`/health.json`, `/v1/status`); **`service-stub.sh`** kept for future non-HTTP stubs only |
| **LAN + systemd user demo** | `serve-command-centre-demo-lan.sh` → **`udos-web.sh`**; `install-command-centre-demo-lan-user-service.sh` → **`udos-web.sh`** |
| **Steps 1–2 (automated + TUI)** | `run-ubuntu-checks.sh`, `verify-command-centre-http.sh`, `runtime-spine-round-proof.sh`, `lane1-runtime-proof-tui.sh`, `runtime-spine-workspace-tui.sh` |
| **Step 3 (final GUI render)** | `serve-command-centre-demo.sh` / `serve-command-centre-demo-lan.sh` + **browser** + sign-off |

**Still open (later lanes):** vault/sync **workers**, TLS/auth, aux **product** behaviour (budget gates, Beacon, jobs, UIs), deeper commandd approval flows.

## Spec outputs

| Output | Where |
| --- | --- |
| Runtime ownership map | `docs/runtime-spine.md` |
| Network / offline-first | `docs/runtime-spine.md`; `uDOS-host/docs/architecture.md` |
| Vault + sync contract | `docs/runtime-spine.md`; layout + compost filesystem contract |
| Ubuntu service map | `docs/runtime-spine.md`; `uDOS-host/docs/systemd-unit-plan.md` |

## Next lane

Open `cursor-02-foundation-distribution.code-workspace` per `docs/cursor-execution.md` (Workspace 01 closed above).
