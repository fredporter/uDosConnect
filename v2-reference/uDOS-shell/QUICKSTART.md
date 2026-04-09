# uDOS-shell Quickstart

This is the shortest path to launch the shell and validate the active TUI lanes.

## Prerequisites

- Node.js 20+
- npm
- Go 1.22+

## 1. One-Command First Run

From repo root:

```bash
npm run first-run
```

macOS Finder launcher:

```bash
open ./scripts/first-run-launch.command
```

This command:

- checks for `node`, `npm`, and `go`
- installs npm dependencies when needed
- builds the TypeScript shell lane
- launches the Go TUI

## 2. Build And Test

```bash
npm run build
npm test
```

## 3. Launch The Go TUI Lane

```bash
npm run go:run
```

## 4. Run Full Repo Checks

```bash
bash scripts/run-shell-checks.sh
```

## 5. Run Demo Flow

```bash
bash scripts/run-demo.sh
```

Inside the TUI, start with:

```text
help
commands
wizard
test
status
routes
```

## 6. MCP/Core Consumption Path

If the sibling core repo is present, inspect the MCP contract before wiring shell integrations:

```bash
cat ../uDOS-core/contracts/mcp-tool-contract.json | head -40
```

## 7. Continue With Docs

- docs/README.md
- docs/getting-started.md
- docs/activation.md
- docs/tui-keybindings.md
- docs/mcp-consumption.md
