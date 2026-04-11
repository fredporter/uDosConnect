> **Archive (uDos v2/v3)**  
> This is a conceptual uDos v2/v3 project which has been archived for posterity.
>
> **Scheduled extension track:** **4.1.8** (uDos **4.1.0** line; numbers may be reprioritized in [`uDosDev/TASKS.md`](../uDosDev/TASKS.md)).
>
> **When to reintegrate:** after `uDosGo` is locked for **v4.0**, when a Task item for this module is scheduled in `uDosDev` (see [dev-process-v4.md](../uDosDev/docs/dev-process-v4.md)).
>
> **How:** rebuild against the current `uDosGo` contracts and tests; publish as a **submodule under `uDosConnect`** (not merged into `uDosGo`). Extension releases are numbered **4.1.1+** in order of landing.
>
> ---

# uDOS-host

**Product names:** this repo implements **uDOS-host** (local runtime host,
`~/.udos/` materialisation, command-centre posture). When we mean an always-on /
LAN deployment, we may say **uDOS-server** as the same stack, different profile.
See **`uDOS-dev/docs/udos-host-platform-posture.md`** for OS support (Linux tier
1, macOS tier 2, Windows scope).

## Naming — do not conflate this repo with “GNOME design”

- **This git repo** (folder name **`uDOS-host`**) is the **runtime host implementation**: images, scripts, hooks, command-centre posture, disk layout — not a design-system home.
- **Ubuntu** here means the **distro baseline** we build on, not “this repository equals Ubuntu Desktop as a product.”
- **Classic Modern** and **de-modernised GNOME** posture are **specified** in **`uDOS-docs/docs/classic-modern-mvp-0.1/`** (host profile, tokens, brief). **`uDOS-themes`** and **`uDOS-thinui`** own tokens and primary surface; **this repo** applies host-side steps (tweaks, launch paths, scripts) that **follow** that pack. If you are doing **visual / token** work, start in the Classic Modern pack + themes + ThinUI — not only here.

## Purpose

Canonical **Ubuntu 22.04 LTS** base image definition and reference host lane for
uDOS deployments — the **primary implementation** of **uDOS-host** in git today.

## Ownership

- reproducible base image definition and build flow
- sonic-screwdriver install hook compatibility
- Proton suite integration lane
- uDOS boot and desktop identity assets
- browser command-centre hosting and setup story
- always-on runtime host posture
- local network, vault, sync, and scheduled-operation host posture
- central local repo-store posture for family repos
- host-side Git and GitHub execution surfaces
- shared API, budgeting, security, and policy enforcement at the runtime edge
- local and remote-aware AI or model hosting gateways for the family runtime

## Non-Goals

- runtime semantics ownership
- replacing uDOS-core contracts
- full distro fork ownership

## Spine

- `build/`
- `config/`
- `proton/`
- `theming/`
- `boot/`
- `sonic-hooks/`
- `docs/`
- `scripts/`
- `tests/`
- `examples/`

## Local Development

Keep image generation deterministic, scriptable, and portable for Sonic-driven deploy.

## Family Relation

This repository (**uDOS-host** implementation; legacy name **uDOS-host**) is the target always-on runtime host for the family.

It should host the official base command centre:

- browser GUI
- TUI shell
- local and remote-aware networking services
- API access and budget enforcement
- security and shared policy gates
- vault and sync services
- Git or GitHub repo operations
- scheduled operations

It is installed and recovered through `sonic-screwdriver`, grounded in
`uDOS-core` contracts, and should consume `uDOS-shell`, `uDOS-thinui`,
`uDOS-themes`, and selected Wizard services without delegating base runtime
uptime to Wizard.

## Activation

The v2 repo activation path is documented in docs/activation.md.

Runtime planning references:

- `docs/systemd-unit-plan.md`
- `docs/config-layout.md`
- `docs/git-repo-store.md`

Run the local validation entrypoint with:

scripts/run-ubuntu-checks.sh

**Linux first install from the public repo (clone uDOS-host only, then one script):** see `docs/linux-first-run-quickstart.md` and `scripts/linux-family-bootstrap.sh`.

Run the current first-run demo story with:

```bash
bash scripts/demo-first-run-setup.sh
```

Run the current browser command-centre parity demo with:

```bash
bash scripts/demo-browser-workstation.sh
```
