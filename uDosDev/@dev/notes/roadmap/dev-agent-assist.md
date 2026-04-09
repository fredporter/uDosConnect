# @dev/dev-agent-assist

`@dev/dev-agent-assist`
binder: `#binder/dev-v2-0-3-release-pass`
round: `v2.0.3 Round C`
status: `complete`

## Objective

Capture the full uDOS v2 dev workflow as a VS Code Copilot instructions file so
agent sessions can continue without re-reading governance docs from scratch each
time.

## Rationale

- Multiple governance docs exist (`family-workflow.md`, `roadmap-workflow.md`,
  `repo-family-map.md`, round files) but are not automatically loaded
- Agent context resets between sessions — binder workflow, `@dev/` structure,
  and round/promote/close cycle must be re-discovered each time
- A `.instructions.md` file in `.github/instructions/` is picked up
  automatically by VS Code Copilot for any workspace folder in scope

## Deliverable

`.github/instructions/dev-workflow.instructions.md`

Covers:
- full 17-repo family table with ownership and purpose
- dependency direction rules
- binder 8-stage lifecycle
- `@dev/` directory convention and purpose of each subdirectory
- roadmap canonical surfaces (file table)
- round/promote/close cycle (step-by-step)
- round status values
- `@dev/` tag convention
- current active state snapshot (v2.0.3 Round C, 358 tests passing)
- next staged work (v2.0.4 Round A — Wizard networking + MCP)
- validation script path
- commit message convention
- governance quick-reference rules

## Why Now (Not Later)

- Low risk — no networking boundaries, no cross-repo contract changes
- No dependency conflicts with v2.0.4 Wizard networking work
- Immediately useful for Round C validation and all future rounds
- Wizard MCP ↔ VS Code correctly deferred to v2.0.4 after networking lock

## Completion Criteria

- [x] `.github/instructions/dev-workflow.instructions.md` created in `uDOS-dev`
- [x] File uses `applyTo: "**"` frontmatter to activate for all workspace files
- [x] Content draws from `family-workflow.md`, `roadmap-workflow.md`,
      `repo-family-map.md`, `v2-roadmap-status.md`
- [x] Current active state snapshot is accurate (v2.0.3 Round C in-progress)
- [x] Round C advancement reflected in rounds file
- [ ] Committed to `uDOS-dev` as part of Round C outputs
