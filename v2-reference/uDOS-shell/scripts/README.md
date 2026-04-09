# `scripts/`

This lane holds operational helpers for working on `uDOS-shell`.

## Current Scripts

- `first-run-launch.sh`
  - checks local command prerequisites
  - installs npm dependencies when required
  - builds the TypeScript shell lane
  - launches the Go TUI
- `first-run-launch.command`
  - macOS Finder wrapper that delegates directly to `first-run-launch.sh`
- `run-shell-checks.sh`
  - installs npm dependencies when required
  - builds the TypeScript shell
  - runs the current test suite
- `run-demo.sh`
  - builds Go packages
  - runs full Go test coverage in-repo
  - runs the verbose demo integration test under `tests/demo_test.go`
  - verifies the `cmd/ucode` binary build
- `smoke-wizard-http.sh`
  - curls `GET /` and `GET /mcp/tools` on a **running** Wizard (`UDOS_WIZARD_HOST` / `UDOS_WIZARD_PORT`)
  - see `docs/wizard-shell-operator-runbook.md`

Keep scripts explicit, repo-relative, and small enough to teach.
