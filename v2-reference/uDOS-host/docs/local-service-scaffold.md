# Local Service Scaffold

This document defines the first runnable local scaffold for the Ubuntu
command-centre services.

## Purpose

**Lane 1 (Workspace 01):** **hostd**, **web**, **vaultd**, **syncd**, **commandd**, and the six **aux** roles (**budgetd**, **networkd**, **scheduled**, **tuid**, **thinui**, **wizard-adapter**) are **long-running HTTP listeners** implemented in **`scripts/lib/runtime_daemon_httpd.py`** (each `udos-*.sh` wrapper **exec**s the matching mode). **udos-web** serves the static command-centre plus the full Wizard **`/host/*`** surface (see `contracts/udos-web/wizard-host-surface.v1.json`). **`scripts/lib/service-stub.sh`** remains in-tree for future lane-N stubs; lane-1 aux daemons no longer use it.

Older stubs were starter entrypoints that:

- load the expected service identity
- create the matching state/log directories under `~/.udos/`
- prove the naming and boot plan are coherent

## Host bootstrap (layout)

`scripts/udos-hostd.sh` runs `ud_os_ensure_runtime_layout` then starts the **hostd** HTTP listener (layout manifest at `GET /v1/runtime-layout.json`). It creates:

- `~/.udos/` roots (bin, envs, state, vault, publish, sync, memory, library, logs,
  cache, tmp, repos, …)
- vault subfolders (`vault/inbox`, `vault/projects`, `vault/library`)
- sync queue folders (`sync/queue`, `sync/archive`)
- `publish/static`
- A manifest: `~/.udos/state/hostd/runtime-layout.json`

## Real daemon entry points (lane 1)

- `scripts/udos-hostd.sh` — layout then **hostd** HTTP (`/health.json`, `/v1/runtime-layout.json`); **`layout-only`** first argument materializes `~/.udos/` and exits (used by `run-ubuntu-checks.sh`)
- `scripts/udos-web.sh` — layout (best-effort) then **web** HTTP (static command-centre + Wizard **`/host/*`**: local-state, contract, runtime-summary, orchestration-status, **budget-status**, **providers**, **secrets** GET + POST 403; defaults under `config/host/`, overlays `~/.udos/state/host/`)
- `scripts/udos-vaultd.sh` — **vaultd** HTTP (`/health.json`, `/v1/status` with **`vault_paths`** probes)
- `scripts/udos-syncd.sh` — **syncd** HTTP (`/health.json`, `/v1/status` with **`sync_paths`** probes)
- `scripts/udos-budgetd.sh`, `udos-networkd.sh`, `udos-scheduled.sh`, `udos-tuid.sh`, `udos-thinui.sh`, `udos-wizard-adapter.sh` — **aux** HTTP (`/health.json`, `/v1/status`; product logic deferred)

Automated proof: `scripts/verify-udos-runtime-daemons.sh`.

## commandd HTTP (lane 1)

- `scripts/udos-commandd.sh` with default **`serve`** (no subcommand) **exec**s `runtime_daemon_httpd.py commandd` on **`UDOS_COMMANDD_PORT`** (default **7101**, bind **`UDOS_COMMANDD_BIND`**).
- JSON routes: `GET /health.json`, `GET /v1/policy-summary`, `GET /v1/list-operations?domain=`, `GET /v1/surface-summary?surface=wizard|git`, `GET /v1/wizard-host-surface.json`, `POST /v1/repo-op` with body `{"operation_id":"…","arguments":[]}` (shells the same bash script for each request).

Use **`udos-commandd.sh stub`** for the legacy one-line **commandd-ready** print (exits immediately).

## Non-stub CLI / one-shot (subcommands)

- `scripts/udos-commandd.sh` — `list-operations`, `surface-summary`, `policy-summary`, `repo-op` (also used internally by the HTTP listener)
- `scripts/udos-gitd.sh`

Shared helpers:

- `scripts/lib/service-stub.sh` (optional helper for future non-HTTP stubs)
- `scripts/lib/runtime_daemon_httpd.py` (hostd / web / vaultd / syncd / commandd / six aux modes)
- `scripts/lib/runtime-layout.sh` (sourced by `udos-hostd.sh` and **udos-web.sh** to create `~/.udos/` layout)

## Local Manual Run

Long-running daemons (each blocks the terminal until Ctrl+C):

```bash
bash scripts/udos-hostd.sh              # blocks: layout + hostd HTTP
bash scripts/udos-hostd.sh layout-only  # exits after layout (CI / prep)
bash scripts/udos-commandd.sh
bash scripts/udos-vaultd.sh
bash scripts/udos-syncd.sh
bash scripts/udos-web.sh
```

One-shot **stub** status (prints **commandd-ready** / layout lines and exits): `bash scripts/udos-commandd.sh stub`.

CLI examples (exit after output):

```bash
bash scripts/udos-gitd.sh init-layout
bash scripts/udos-commandd.sh list-operations repo
```

`scripts/udos-gitd.sh` now also supports a bounded local repo-store CLI:

- `init-layout`
- `repo-list`
- `repo-attach <repo-id> <path>`
- `repo-clone <repo-id> <remote-url> [branch]`
- `repo-status <repo-id>`
- `repo-fetch <repo-id>`
- `repo-branch <repo-id> <branch>`
- `repo-pull <repo-id>`
- `repo-push <repo-id>`

## Current Scope

**In place for lane 1:** HTTP listeners for hostd, web (static + `/host/*`), vaultd, syncd, commandd, and minimal aux daemons; `udos-hostd` materializes the full `~/.udos/` tree; `udos-commandd` and `udos-gitd` implement the bounded repo and policy surface in `contracts/udos-commandd/` and `docs/git-repo-store.md`.

**Still deferred:** vault encryption workers, sync execution, schedule/network/budget product semantics, TLS, full GitHub CLI or MCP brokering, and commandd-backed approval flows beyond the current registry + `repo-op` surface.

## Next Layer

The next implementation inputs now live in the checked-in machine-readable
contracts:

- `contracts/udos-commandd/api-envelope.schema.json`
- `contracts/udos-commandd/operation-registry.v1.json`
- `contracts/udos-commandd/minimum-operations.v1.json`

These should be treated as the handover bridge between the Workspace 01 docs
and the first real `udos-commandd` implementation pass.
