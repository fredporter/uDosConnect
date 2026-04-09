# uDOS-shell Architecture

`uDOS-shell` is the operator-facing shell layer for local interaction, previews,
and terminal-first command flows.

## Main Areas

- `src/ucode/` holds command-surface integrations
- `internal/ucode/`, `internal/dispatch/`, and `internal/contracts/` hold the
  Go parse-and-preview runtime
- `internal/app/` and `internal/tui/` hold the Bubble Tea and Lip Gloss shell
- `src/palette/`, `src/panels/`, `src/thingui/`, and `src/tui/` hold operator
  workflow surfaces and alternate presentation layers

## Design Rule

Shell consumes family contracts. It does not invent parallel semantics.

## Runtime Shape

The repo currently has two shell lanes:

- TypeScript compatibility lane:
  - `src/cli.ts`
  - `src/ucode/parser.ts`
  - `src/ucode/preview.ts`
- Go active lane:
  - `cmd/ucode/main.go`
  - `internal/ucode/`
  - `internal/dispatch/`
  - `internal/contracts/`
  - `internal/tui/keymap/`
  - `internal/tui/viewport/`

## Boundary Rule

Shell owns presentation, input, and local inspection.

Canonical semantics stay in Core. Managed network-backed execution stays outside
Shell. Shell may hand requests outward, but it is not the runtime authority.
