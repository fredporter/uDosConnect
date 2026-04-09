# uDOS-host Systemd Unit Plan

This document defines the target `systemd` unit layout for the Ubuntu command
centre.

It is a planning contract for the always-on runtime host and should stay aligned
to:

- `uDOS-dev/docs/runtime-spine.md` (family hub)
- `uDOS-dev/docs/ubuntu-command-centre-reference.md` (compact command-centre ref)
- `uDOS-host/docs/architecture.md` (host direction, failure rule, topology)
- `uDOS-host/docs/config-layout.md` (`~/.udos/` layout contract)
- this document (unit graph and process ordering)

## Goals

- boot the base command-centre services reliably on Ubuntu
- keep critical runtime services independent of Wizard availability
- separate mandatory local services from optional adapter services
- give Sonic and first-run setup a stable service target to install and manage

## Unit Naming Rule

Use the `udos-*` prefix for first-party runtime units.

Primary units:

- `udos-hostd.service`
- `udos-commandd.service`
- `udos-vaultd.service`
- `udos-syncd.service`
- `udos-gitd.service`
- `udos-scheduled.service`
- `udos-networkd.service`
- `udos-budgetd.service`
- `udos-web.service`
- `udos-tuid.service`
- `udos-thinui.service`

Optional units:

- `udos-wizard-adapter.service`
- `udos-wordpress.service`

## Core Boot Chain

The minimum always-on chain is:

1. `udos-hostd.service`
2. `udos-commandd.service`
3. `udos-vaultd.service`
4. `udos-syncd.service`
5. `udos-gitd.service`
6. `udos-scheduled.service`
7. `udos-networkd.service`
8. `udos-budgetd.service`
9. `udos-web.service`

Operator surfaces may start after the command-centre core is available:

10. `udos-tuid.service`
11. `udos-thinui.service`

Optional adapters start last:

12. `udos-wizard-adapter.service`
13. `udos-wordpress.service`

## Unit Roles

### `udos-hostd.service`

Purpose:

- validate runtime directories under `~/.udos/`
- load shared environment
- verify prerequisites
- supervise startup order and readiness

WantedBy:

- `multi-user.target`

### `udos-commandd.service`

Purpose:

- canonical operation registry
- local operation execution entrypoint
- shared command-centre action host

After:

- `udos-hostd.service`

Requires:

- `udos-hostd.service`

### `udos-vaultd.service`

Purpose:

- master local vault host
- markdown processing and static publish engine

After:

- `udos-commandd.service`

Requires:

- `udos-commandd.service`

### `udos-syncd.service`

Purpose:

- sync queues
- replication workers
- reconciliation passes

After:

- `udos-commandd.service`
- `udos-vaultd.service`

Requires:

- `udos-commandd.service`

### `udos-scheduled.service`

Purpose:

- schedule registry
- background jobs
- run-now and retry execution

After:

- `udos-commandd.service`

Requires:

- `udos-commandd.service`

### `udos-gitd.service`

Purpose:

- canonical local repo-store supervision
- Git status, fetch, branch, pull, and push execution
- GitHub CLI and MCP adapter handoff under host policy
- scheduled repo reconcile support for other services

After:

- `udos-commandd.service`
- `udos-syncd.service`

Requires:

- `udos-commandd.service`

### `udos-networkd.service`

Purpose:

- Beacon and Portal host endpoints
- LAN discovery and runtime ingress

After:

- `udos-commandd.service`

Requires:

- `udos-commandd.service`

### `udos-budgetd.service`

Purpose:

- budget and policy gate for outbound external operations

After:

- `udos-commandd.service`

Requires:

- `udos-commandd.service`

### `udos-web.service`

Purpose:

- browser command-centre API gateway and frontend host

After:

- `udos-commandd.service`
- `udos-vaultd.service`
- `udos-syncd.service`
- `udos-gitd.service`
- `udos-scheduled.service`
- `udos-networkd.service`
- `udos-budgetd.service`

Requires:

- `udos-commandd.service`

### `udos-tuid.service`

Purpose:

- TUI shell surface with parity to browser operations

After:

- `udos-commandd.service`

Requires:

- `udos-commandd.service`

### `udos-thinui.service`

Purpose:

- fullscreen ThinUI service panels and focused local views

After:

- `udos-commandd.service`

Requires:

- `udos-commandd.service`

### Optional `udos-wizard-adapter.service`

Purpose:

- provider bridges
- assist/model routing
- MCP
- remote publishing adapters

After:

- `udos-networkd.service`
- `udos-budgetd.service`

Wants:

- `udos-networkd.service`
- `udos-budgetd.service`

This service must not be required for the base command-centre boot chain.

### Optional `udos-wordpress.service`

Purpose:

- selected CMS/publishing surface only

After:

- `udos-vaultd.service`
- `udos-web.service`

This service must not replace static publish output under `~/.udos/publish/`.

## Unit File Strategy

Checked-in templates should live under the Ubuntu repo, for example:

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
- `config/systemd/udos-wizard-adapter.service`
- `config/systemd/udos-wordpress.service`

Installed units should be rendered or copied into:

- `/etc/systemd/system/`

The starter checked-in unit templates now point to:

- `${UDOS_INSTALL_ROOT}/scripts/udos-*.sh`

via the shared host env file.

## Environment Loading Rule

All first-party units should load shared environment from a stable host path,
for example:

- `/etc/udos/udos.env`

Optional service-specific env files may extend it:

- `/etc/udos/udos-web.env`
- `/etc/udos/udos-networkd.env`
- `/etc/udos/udos-wizard-adapter.env`

## Readiness Rule

Each first-party service should expose:

- a health endpoint or readiness command
- a log directory under `~/.udos/logs/<service>/`
- a state directory under `~/.udos/state/<service>/` where applicable

`udos-web.service` and `udos-tuid.service` should refuse to advertise ready
until `udos-commandd.service` is reachable.

## Failure Rule

If `udos-wizard-adapter.service` fails:

- the base command centre still boots
- local TUI/browser operations still work
- local vault, sync, and schedules still work
- external adapters and assist degrade only at the adapter edge

If `udos-web.service` fails:

- `udos-tuid.service` must still be a viable admin surface

If `udos-tuid.service` fails:

- `udos-web.service` must still expose the same operation set

## Sonic Integration Rule

Sonic should install or enable the core unit set for the Ubuntu profile.

Sonic should be able to:

- install checked-in unit templates
- write env files under `/etc/udos/`
- enable required units
- leave optional adapter units disabled by default when appropriate
