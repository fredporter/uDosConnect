# uDOS-themes Architecture

uDOS-themes holds the cross-surface visual contract for the public family.

## Main Areas

- `src/tokens/` stores the base token layer.
- `src/components/` stores cross-surface component primitive contracts.
- `src/adapters/` stores surface adapters for browser, ThinUI, TUI, workflow,
  publish, and forms.
- `src/themes/` stores theme packs that combine tokens, primitives, and adapter
  targets.
- `src/skins/` stores optional skin overrides layered on top of themes.
- `registry/` stores machine-readable theme, adapter, and skin registries.
- `examples/` shows application patterns.
- `tests/` protects token integrity and packaging assumptions.
- `scripts/run-theme-checks.sh` is the activation validation entrypoint.

## Core Rule

Themes define appearance.
Adapters translate appearance.
Runtimes render appearance.

## Surface Coverage

- browser GUI
- ThinUI
- TUI
- workflow/binder surfaces
- publishing and email-safe output
- GTX-form step flows

## Third-party upstreams

Fork targets, demo URLs, and teletext references: `theme-upstream-index.md`.
