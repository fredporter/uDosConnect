# uDOS-host Config Layout

This document defines the intended checked-in config structure for the Ubuntu
command-centre host.

Family-wide install path standard and Sonic-first topology: `uDOS-dev/docs/foundation-distribution.md`.

It separates:

- repo-owned templates and defaults
- host-installed config files
- runtime-owned state under `~/.udos/`

## 1. Checked-In Repo Config

The repo should own non-secret templates and defaults under `uDOS-host/config/`.

Target layout:

- `config/packages.list`
- `config/systemd/`
- `config/env/`
- `config/network/`
- `config/runtime/`
- `config/policy/`
- `config/web/`
- `config/thinui/`
- `config/tui/`
- `config/publish/`
- `config/docker/`
- `contracts/`

## 2. Proposed Config Tree

### `config/packages.list`

Purpose:

- base package assumptions for the Ubuntu host image/profile

### `config/systemd/`

Purpose:

- checked-in unit templates for the command-centre services

Expected contents:

- `udos-hostd.service`
- `udos-commandd.service`
- `udos-vaultd.service`
- `udos-syncd.service`
- `udos-scheduled.service`
- `udos-networkd.service`
- `udos-budgetd.service`
- `udos-web.service`
- `udos-tuid.service`
- `udos-thinui.service`
- optional adapter units

### `config/env/`

Purpose:

- non-secret environment templates

Expected contents:

- `udos.env.example`
- `udos-web.env.example`
- `udos-networkd.env.example`
- `udos-wizard-adapter.env.example`

These should be templates only, not real secrets.

### `config/network/`

Purpose:

- network posture defaults for the Ubuntu command centre

Expected contents:

- LAN listen defaults
- Beacon/Portal exposure rules
- local-only versus LAN-facing defaults
- discovery and pairing templates

### `config/runtime/`

Purpose:

- runtime service defaults shared by the command-centre services

Expected contents:

- runtime root locations
- state/log/cache path defaults
- service port defaults
- health/readiness config

### `config/policy/`

Purpose:

- checked-in non-secret safety defaults for host-managed outbound operations

Expected contents:

- Git or GitHub approval defaults
- audit posture defaults
- action gating templates for push and remote mutations

### `config/web/`

Purpose:

- browser command-centre host defaults

Expected contents:

- frontend host config
- API gateway config
- static asset host defaults

### `config/thinui/`

Purpose:

- ThinUI launch and panel defaults

### `config/tui/`

Purpose:

- TUI shell defaults
- terminal/UI feature flags
- command palette defaults

### `config/publish/`

Purpose:

- static vault publishing defaults
- optional CMS bridge templates

Expected contents:

- static publish target templates
- wiki/GitHub Pages style publish settings
- optional WordPress bridge templates

### `config/docker/`

Purpose:

- optional Docker compose or service templates for isolated supporting services

Expected contents:

- WordPress template
- local model-serving template
- optional worker or queue sidecar templates

Docker templates are supporting surfaces only and must not replace first-party
runtime ownership.

### `contracts/`

Purpose:

- machine-readable runtime and command-centre contracts
- schema and registry files that implementation code should consume directly
- handover-safe alignment between prose docs and executable scaffolding

## 3. Host-Installed Config Layout

Rendered or installed host config should live under:

- `/etc/udos/`

Suggested layout:

- `/etc/udos/udos.env`
- `/etc/udos/udos-web.env`
- `/etc/udos/udos-networkd.env`
- `/etc/udos/udos-wizard-adapter.env`
- `/etc/udos/runtime.yaml`
- `/etc/udos/network.yaml`
- `/etc/udos/publish.yaml`

## 4. Secrets Rule

Secrets must not be checked into the repo.

Secrets should live in host-installed config or secure local stores, for
example:

- `/etc/udos/*.env`
- a secret manager
- encrypted local service state where required

## 5. Runtime State Rule

Do not put mutable runtime data in `config/`.

Mutable runtime data belongs under `~/.udos/`, especially:

- `~/.udos/state/` (e.g. `state/web/local-state.json` for **`/host/local-state`**, `state/host/*.json` optional overlays for **`/host/budget-status`** and **`/host/providers`** on **udos-web**)
- `~/.udos/vault/`
- `~/.udos/publish/`
- `~/.udos/sync/`
- `~/.udos/logs/`

## 6. Initial Scaffolding

The first concrete config files now exist as starter templates:

- `config/systemd/udos-hostd.service`
- `config/systemd/udos-commandd.service`
- `config/systemd/udos-vaultd.service`
- `config/systemd/udos-syncd.service`
- `config/systemd/udos-scheduled.service`
- `config/systemd/udos-networkd.service`
- `config/systemd/udos-budgetd.service`
- `config/systemd/udos-web.service`
- `config/systemd/udos-tuid.service`
- `config/systemd/udos-thinui.service`
- `config/env/udos.env.example`
- `config/env/udos-web.env.example`
- `config/env/udos-networkd.env.example`
- `config/env/udos-wizard-adapter.env.example`
- `config/runtime/runtime.yaml.example`
- `config/runtime/git-repos.yaml.example`
- `config/policy/github-action-policy.json.example`
- `config/network/network.yaml.example`
- `config/publish/publish.yaml.example`
- `contracts/udos-commandd/api-envelope.schema.json`
- `contracts/udos-commandd/operation-registry.v1.json`
- `contracts/udos-commandd/minimum-operations.v1.json`
