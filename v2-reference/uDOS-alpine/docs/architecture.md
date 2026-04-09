# uDOS-alpine Architecture

`uDOS-alpine` packages and assembles the lightweight Alpine runtime profile for
the family.

## Main Areas

- `apkbuild/` contains package definitions
- `distribution/` and `profiles/` hold deployable layouts
- `openrc/` defines service startup behavior
- `scripts/run-alpine-checks.sh` is the validation entrypoint

## Runtime Profile Direction

Alpine is the lightweight companion profile:

- Alpine instead of Ubuntu
- Core + TUI + ThinUI only
- local reduced-mode operation
- network compatibility with the main `uDOS-host` host

## Boundary Rule

Alpine should stop at ThinUI capability.

If a feature requires the full browser command centre, broad browser workflow
surfaces, or primary vault-host ownership, it belongs to `uDOS-host`.
