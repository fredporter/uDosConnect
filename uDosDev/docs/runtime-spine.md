# Runtime spine (family hub)

Stable reference for **Workspace 01**: who owns the always-on runtime, how it
stays **offline-first**, where **vault and sync** live, and which **Ubuntu
services** implement the spine.

## Primary runtime host

**`uDOS-host`** is the canonical always-on command-centre host for the family.
It owns host uptime, `~/.udos/` layout, vault and sync services, scheduling,
local networking for Beacon/Portal, and operator surfaces (browser + TUI). Proof
statements and boundaries:

- `uDOS-host/README.md` (Family Relation, Ownership)
- `uDOS-host/docs/architecture.md` (Runtime Host Direction, Failure Rule)
- `ubuntu-command-centre-reference.md` (compact family summary)

## Runtime ownership map

| Concern | Owner | Notes |
| --- | --- | --- |
| Cross-repo contracts, event/feed/spool semantics | `uDOS-core` | Canonical policy and JSON contracts |
| Spatial identity and place-bound artefacts | `uDOS-grid` | Consumed by shell, Surface/Wizard, apps; does not host runtime |
| Ubuntu image, systemd posture, host config, repo-store, Git/GitHub on host | `uDOS-host` | Base runtime assembly |
| Browser GUI, publishing, workflow presentation, **broker** to services | `uDOS-wizard` (Surface + Wizard) | **Not** canonical host uptime (see below) |
| Family coordination docs and workspace sequencing | `uDOS-dev` | This hub, `cursor-execution.md` |
| Public hub / narrative alignment | `uDOS-docs` | Links and onboarding; not runtime state |

## Wizard / Surface role (narrowed)

`uDOS-wizard` is **orchestration, presentation, and brokering**: surfaces,
publishing views, delegation to host services, optional remote adapters. It
**does not** own persistent host runtime, sync authority, vault master storage,
or network control plane.

Authoritative wording:

- `uDOS-wizard/README.md` (Ownership, Non-Goals, Family Relation)

**Failure rule:** when Wizard is unavailable, Ubuntu-hosted local runtime must
still operate (shell, browser command-centre, vault, scheduling, sync persistence).
See `uDOS-host/docs/architecture.md` § Failure Rule.

## Network boundary and offline-first contract

- **Local-first:** command router, vault, sync queues, scheduler, and operator
  surfaces target the Ubuntu host and `~/.udos/` without requiring remote
  providers.
- **Optional remote:** publishing bridges, provider-backed assist, MCP adapters
  may degrade when offline; core local operations must not.
- **Extended topology** (layers, Wizard vs host relocation): see
  `uDOS-host/docs/architecture.md` and `uDOS-dev/docs/ubuntu-command-centre-reference.md`.

## Vault, sync, and path assumptions

- **Runtime tree:** `~/.udos/` — not repo trees. See
  `uDOS-host/docs/config-layout.md` and `uDOS-host/docs/architecture.md`.
- **Vault hosting:** master vault and publish paths on the Ubuntu host
  (`udos-vaultd` in the service plan).
- **Sync:** local-first queues and workers on the host (`udos-syncd`); remote
  replication and provider sync are **extensions**, not replacements for local
  persistence.
- **Feeds / spool (semantic logging):** contract reference in `uDOS-core`
  (`uDOS-core/docs/feeds-and-spool.md` and `uDOS-core/contracts/`). The Ubuntu
  host is where durable spool-backed state is expected to land for family runtime
  alignment.

## Local vs remote sync responsibility

| Layer | Responsibility |
| --- | --- |
| **Local durable queues, retry, conflict staging** | Ubuntu host (`udos-syncd`, `~/.udos/sync/`, service state under `~/.udos/state/`) |
| **Remote push/pull, provider APIs, cross-device reconciliation** | Optional adapters (e.g. Wizard bridges, networkd); must not be the only copy of user data |
| **Canonical reconciliation** | Ubuntu host remains source of truth for master vault and sync state when multiple nodes exist (see filesystem contract § Networked Runtime Rule) |

## Ubuntu-hosted service map (target)

Aligned to `uDOS-host/docs/systemd-unit-plan.md` (service graph and ordering):

| Unit (target) | Role (summary) |
| --- | --- |
| `udos-hostd` | Bootstrap, env, path validation |
| `udos-commandd` | Command router / operation registry |
| `udos-vaultd` | Vault API and publish path |
| `udos-syncd` | Sync queue and worker |
| `udos-gitd` | Git/repo-store operations |
| `udos-scheduled` | Background jobs |
| `udos-networkd` | Local network / Beacon / Portal hosting |
| `udos-budgetd` | Runtime-edge policy/budget |
| `udos-web` / `udos-tuid` / `udos-thinui` | Operator surfaces |
| `udos-wizard-adapter` (optional) | Wizard-facing adapter; starts **after** core chain |

## Implementation status (Workspace 01)

What is **implemented in tree** today versus still **stub / deferred**:

| Area | Status |
| --- | --- |
| `~/.udos/` **canonical layout** (roots, vault subdirs, sync queue dirs, repos, manifest) | **`udos-hostd`** runs `scripts/lib/runtime-layout.sh` (idempotent); writes `state/hostd/runtime-layout.json`. Verified by `scripts/run-ubuntu-checks.sh`. |
| **commandd + gitd** (operation registry, policy-gated `repo.*` / `github.*`, repo-store CLI) | **Implemented** in `scripts/udos-commandd.sh` and `scripts/udos-gitd.sh` with checked-in JSON contracts. |
| **systemd** unit templates | Checked in under `config/systemd/`; `ExecStart` points at install-root scripts. |
| **hostd / web / vaultd / syncd** long-running daemons | **Real HTTP listeners** (`scripts/lib/runtime_daemon_httpd.py`): **web** serves the command-centre static tree plus **full Wizard `/host/*` contract surface** on disk: local-state file, contract, runtime-summary, orchestration-status, **`GET /host/budget-status`** / **`GET /host/providers`** (merge `config/host/*.lane1.json` + optional `~/.udos/state/host/*.json`), **`GET /host/secrets`** (empty list; **`POST` → 403**). **Vaultd/syncd** expose **`/v1/status`** with path/queue probes. Verified by `scripts/verify-udos-runtime-daemons.sh`. Vault encryption, sync worker execution, and TLS remain later lanes. |
| **commandd** HTTP | Default **`udos-commandd.sh`** **exec**s **`runtime_daemon_httpd.py commandd`**: `GET /v1/*`, `POST /v1/repo-op` (shells existing bash **commandd**). **`stub`** = one-shot status print. |
| **budgetd / networkd / scheduled / tuid / thinui / wizard-adapter** | **Minimal HTTP** (`runtime_daemon_httpd.py` aux modes): **`GET /health.json`**, **`GET /v1/status`** (role + `UDOS_*_PORT` hint). Product behaviour (budget gates, Beacon, jobs, UIs) deferred. |
| **Wizard** broker vs host | **Contract + code posture**: `wizard-host-surface.v1.json` owner `uDOS-host`; **`/host/*`** implemented on **udos-web** with file-backed config; **commandd** HTTP for registry/policy/repo-op. |

Workspace **01** round **closed** — **2026-03-30** — three-step sign-off in **`@dev/notes/rounds/cursor-01-runtime-spine-2026-03-30.md`**. The table above is the in-tree implementation map; deeper product semantics (vault crypto, sync workers, TLS, budget enforcement daemons) roll forward in later lanes. New rounds on this lane still follow **`docs/round-closure-three-steps.md`**.

### Round closure — three steps (mandatory)

See **`docs/round-closure-three-steps.md`**. **Cursor-01** recorded **closed** **2026-03-30** in **`@dev/notes/rounds/cursor-01-runtime-spine-2026-03-30.md`**. In general: **(1)** automated checks + `verify-command-centre-http.sh`, **(2)** `runtime-spine-round-proof.sh` (HTTP + TUI), **(3)** **real browser**, **visible** command-centre page — a round stays **open** without step 3.

### Lane closure proof (commands)

| Proof | Command | Expect |
| --- | --- | --- |
| **Step 1 — Ubuntu + HTTP automated** | `bash uDOS-host/scripts/run-ubuntu-checks.sh` **and** `bash uDOS-host/scripts/verify-command-centre-http.sh` | All pass |
| **Step 2 — one-shot automated round** | `bash uDOS-host/scripts/runtime-spine-round-proof.sh` | **[1/3][2/3]** pass; script prints **[3/3]** instructions (not automated) |
| **Step 3 — final GUI render** | `bash uDOS-host/scripts/serve-command-centre-demo.sh` or `serve-command-centre-demo-lan.sh`, then **open URL in browser** | Operator **sees** “uDOS command centre”; record sign-off |
| **Terminal — Core + Grid + Ubuntu (subset)** | `bash uDOS-host/scripts/lane1-runtime-proof-tui.sh` | Pytest + grid + `run-ubuntu-checks.sh` (does not replace step 3) |
| **Runtime daemons** | Inside `run-ubuntu-checks.sh`: `verify-udos-runtime-daemons.sh` | Ephemeral ports; **`/host/*`**, commandd smoke |
| **Workspace TUI alone** | `bash uDOS-host/scripts/runtime-spine-workspace-tui.sh` | Full repo cycle (part of step 2 when combined with HTTP verify) |

Full pathway: `@dev/pathways/runtime-spine-workspace-round-closure.md` in `uDOS-dev`.

**Linux install from public `uDOS-host` only:** `uDOS-host/docs/linux-first-run-quickstart.md` and `scripts/linux-family-bootstrap.sh` (automated sibling clones + `runtime-spine-round-proof.sh`).

**Keep the demo on the LAN between rounds:** `uDOS-host/docs/lan-command-centre-persistent.md` (foreground LAN script, optional systemd user service, bootstrap `UDOS_BOOTSTRAP_INSTALL_LAN_SERVICE=1`).

## Related links

- `cursor-execution.md` — lane order
- `cursor-focused-workspaces.md` — Workspace 01 exit gate
- `uDOS-host/docs/boundary.md` — what Ubuntu does / does not own
- `runtime-health-and-compost-policy.md` — vitals and `.compost` discipline
