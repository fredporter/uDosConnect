# Changelog

All notable changes to `uDOS-shell` should be documented in this file.

## Unreleased

- established v2 activation and repo-level validation workflow
- added shell activation guidance and example session coverage
- added `v2.0.2` runtime-service consumption hints to shell routing previews
- switched shell runtime-service consumption to the shared Core contract artifact
- added a `v2.0.3` assessment and phased plan for a Go `uCODE` TUI using Bubble Tea and Lip Gloss
- added a runnable Go Bubble Tea bootstrap TUI with initial parser and preview parity
- added active TUI viewport and terminal-first keybinding contracts with no custom Command-key shortcuts
- refactored the Go TUI toward prompt-first I/O with reusable output blocks and a selector overlay
- aligned the prompt flow with the new Core workflow and automation contracts via machine-readable contract inspection
- added prompt-native workflow and automation commands that render Core-aligned sample envelopes
- added in-memory workflow/job ledgers and selector-driven session inspection in the Go TUI
- added explicit sibling assist surfaces for Core GPT4All local assist and Wizard online assist
- added bounded plain CLI execution with Core GPT4All fallback and version-locked knowledge stamping
- aligned the Go TUI roadmap and bootstrap docs to the active family `v2.0.3` version-round with fractional bump and `@dev` peg references
- added `uDOS-grid` contract and seed inspection commands so the shell can consume canonical spatial truth without owning it
- added the first live Go TUI → Wizard `/assist` HTTP handoff using `UDOS_WIZARD_HOST` and `UDOS_WIZARD_PORT`, with preview fallback when Wizard is unavailable
- expanded the live Wizard handoff to `workflow action` and `automation queue` using Wizard-owned workflow routes
- added prompt-native `#ok route` support so the Go TUI can request and render Wizard `/ok/route` provider-routing decisions
- added selector filter mode (`/` key) so operators can narrow any selector overlay by typing in real time (`@dev/ucode-selector-filter-mode`)
- added focused operator actions in ledger selectors: `a`=advance and `p`=pause on the workflow selector, `r`=show result on the automation job selector (`@dev/ucode-focused-actions`)
- added full cursor-aware input editing: Left/Right arrows, Home/End, Ctrl+A/E/U/W/K, and visual block cursor in the prompt line
- added `tests/demo_test.go` — 22-test integration suite covering parser, dispatch, contracts, selector filter, and full pipeline walk
- added `scripts/run-demo.sh` — build, full test suite, verbose demo test, and binary smoke-check in one command
- updated `examples/basic-ucode-session.md` with keybinding quickstart table and filter/selector operator guide
- closed the initial uCODE TUI build round for `v2.0.3+0.0.x` and carried forward bracketed paste, crop-then-pad helpers, and full pane navigation as next-round items
