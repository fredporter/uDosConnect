> **Archive (uDos v2/v3)**  
> This is a conceptual uDos v2/v3 project which has been archived for posterity.
>
> **Scheduled extension track:** **4.1.11** (uDos **4.1.0** line; numbers may be reprioritized in [`uDosDev/TASKS.md`](../uDosDev/TASKS.md)).
>
> **When to reintegrate:** after `uDosGo` is locked for **v4.0**, when a Task Forge item for this module is scheduled in `uDosDev` (see [dev-process-v4.md](../uDosDev/docs/dev-process-v4.md)).
>
> **How:** rebuild against the current `uDosGo` contracts and tests; publish as a **submodule under `uDosConnect`** (not merged into `uDosGo`). Extension releases are numbered **4.1.1+** in order of landing.
>
> ---

# uDOS-shell

## Purpose

Public interactive shell and operator-facing UI patterns for uDOS.

## Ownership

- uCODE interactive shell
- command palette
- workspace panels
- ThinGUI and browser handoff
- reusable shell interaction patterns

## Non-Goals

- canonical runtime semantics
- provider and network ownership
- API budgeting and autonomy policy

## Spine

- `src/ucode/`
- `src/palette/`
- `src/panels/`
- `src/thingui/`
- `src/tui/`
- `docs/`
- `tests/`
- `scripts/`
- `config/`
- `examples/`

## Local Development

Keep package installs explicit and avoid embedding runtime caches into the repo.
Use `scripts/run-shell-checks.sh` as the default local validation entrypoint.
The current shell has two active lanes:

- `npm run dev` for the legacy TypeScript starter preview
- `npm run go:run` for the new Go Bubble Tea bootstrap TUI
- `npm run first-run` for one-command local install-and-launch bootstrap

## Activation References

- `docs/README.md`
- `docs/activation.md`
- `QUICKSTART.md`
- `docs/mcp-consumption.md`
- `docs/tui-keybindings.md`
- `docs/tui-viewport-contract.md`
- `examples/basic-ucode-session.md`
- `scripts/run-shell-checks.sh`

## Family Relation

Shell presents Core semantics to operators and can hand bounded work outward to
the wider family when needed.

Current startup/demo surfaces:

- `npm run first-run`
- `help`
- `commands`
- `wizard`
- `test`
- `status`
- `routes`
- `doctor`
- `health startup`
- `setup story`
- `demo list`
- `demo ux` (visual ASCII UX fixtures; see `demo/screens/`, `bash scripts/demo-ux-walk.sh`)
- `demo run thinui-c64`
- `demo run thinui-nes-sonic`
- `demo run thinui-teletext`
