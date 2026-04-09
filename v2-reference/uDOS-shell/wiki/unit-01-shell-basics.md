# Unit 01: Shell Basics

## What This Module Is

`uDOS-shell` is the operator-facing shell layer for local interaction, previews,
and bounded contract-aware command flows.

## What You Should Learn

By the end of this unit you should be able to:

- explain what Shell owns
- launch the local shell
- run the repo checks
- identify where Shell stops and other family services take over

## Practical How-To

1. Run the first local launch.
2. Start the Go TUI.
3. Run the repo checks.

```bash
npm run first-run
npm run go:run
bash scripts/run-shell-checks.sh
```

## Editable Demo

Inside the shell, try:

```text
help
commands
status
routes
```

## Quick Check

You pass this unit if you can answer:

- What does Shell own?
- Which command starts the active TUI?
- Which repo owns canonical semantics?
