> **Archive (uDos v2/v3)**  
> This is a conceptual uDos v2/v3 project which has been archived for posterity.
>
> **Scheduled extension track:** **4.1.1** (uDos **4.1.0** line; numbers may be reprioritized in [`uDosDev/TASKS.md`](../uDosDev/TASKS.md)).
>
> **When to reintegrate:** after `uDosGo` is locked for **v4.0**, when a Task Forge item for this module is scheduled in `uDosDev` (see [dev-process-v4.md](../uDosDev/docs/dev-process-v4.md)).
>
> **How:** rebuild against the current `uDosGo` contracts and tests; publish as a **submodule under `uDosConnect`** (not merged into `uDosGo`). Extension releases are numbered **4.1.1+** in order of landing.
>
> ---

# uDOS-alpine

## Purpose

Lean Alpine Linux runtime profile and packaging surface for uDOS.

## Ownership

- APK packaging
- lean deployment profiles
- diskless and live boot flows
- remaster and image support
- lightweight Core + TUI + ThinUI runtime profile
- companion-node compatibility with the main Ubuntu runtime

## Non-Goals

- canonical runtime semantics
- provider bridge ownership
- general-purpose host support for every platform
- full browser command-centre ownership
- replacing `uDOS-host` as the primary always-on runtime host

## Spine

- `apkbuild/`
- `distribution/`
- `openrc/`
- `profiles/`
- `docs/`
- `scripts/`
- `tests/`
- `examples/`

## Local Development

Keep deployment profiles explicit, minimal, and packaging-aware.

## Family Relation

`uDOS-alpine` is the lightweight runtime companion to `uDOS-host`.

It should provide:

- `uDOS-core` consumption
- `uDOS-shell` TUI surfaces
- `uDOS-thinui` local GUI surfaces
- network compatibility with the main Ubuntu-hosted command centre

It should stop at ThinUI capability rather than growing into the full browser
command-centre lane.

## Activation

The repo activation path is documented in `docs/activation.md`.

Run the current repo validation entrypoint with:

```bash
scripts/run-alpine-checks.sh
```

Launch the current C64-style ThinUI handoff demo with:

```bash
bash scripts/demo-thinui-launch.sh
```

## Release Policy

Release notes and artifact rules are documented in `docs/release-policy.md`.

## Runtime Profile

See `docs/alpine-runtime-profile.md`.
