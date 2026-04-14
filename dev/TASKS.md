# TASKS.md — A1 Remaining Work Punch List

## Status: in-progress

## Tasks

| ID | Task | Priority | Status | Assignee | ETA |
| --- | --- | --- | --- | --- | --- |
| T001 | Implement `do usxd render` terminal ASCII renderer | P0 | review | @cursor | complete (pending acceptance) |
| T002 | Add explicit `do usxd export --format html|png` parity | P0 | review | @cursor | complete (pending acceptance) |
| T003 | Implement OBF UI renderer for `obf` blocks (A1.2 scope) | P0 | review | @cursor | complete (pending acceptance) |
| T004 | Clarify publish/Jekyll gap and document supported subset | P1 | review | @cursor | complete (pending acceptance) |
| T005 | Harden boundary CI checks (imports + registry validation) | P1 | review | @cursor | complete (pending acceptance) |
| T006 | Add release/version mapping for A1.0→A1.3 ladder | P1 | review | @cursor | complete (pending acceptance) |
| T007 | Add command-level smoke tests for github/pr/wp/collab flows | P2 | review | @cursor | complete (pending acceptance) |

## Task Details

### T001: `do usxd render` terminal ASCII renderer

**Description**: Add a terminal renderer for USXD surfaces (header/content/status + optional grid) using markdown as source, exposed through `usxd-express render` and `do usxd render`.

**Acceptance Criteria**:
- [x] `usxd-express render <file.md>` prints ASCII/teletext-friendly surface in terminal
- [x] `do usxd render <file.md>` delegates correctly
- [x] Works with docs/content markdown containing ` ```usxd` and optional ` ```grid`
- [x] Help/docs updated

**Dependencies**: Existing `usxd-express` parser/render stack (`parse-usxd`, `extract-grid`)

**Related**: A1.2 ladder target (`docs/specs/version-ladder-a1-a2.md`)

**Notes**: Keep A1 local-only and open-box; no cloud dependency.

### T002: `do usxd export --format` parity

**Description**: Extend export command UX to support explicit format selection (`html` now, `png` target).

**Acceptance Criteria**:
- [x] `do usxd export ... --format html` works
- [x] `--format png` either implemented or explicit A1 stub with clear message
- [x] Docs reflect exact support

**Dependencies**: T001 renderer foundation

**Related**: USXD ASCII blocks spec

### T003: OBF UI renderer (A1.2)

**Description**: Parse/render ` ```obf` blocks for `COLUMNS`, `CARD`, `TABS`, `ACCORDION` into terminal and/or HTML-safe output path.

**Acceptance Criteria**:
- [x] Parser for core OBF block primitives
- [x] Terminal render path for at least card/columns
- [x] Publish/build-safe transform path documented

**Dependencies**: None

**Related**: `docs/specs/obf-ui-blocks.md`

### T004: Publish/Jekyll support subset documentation

**Description**: Document exactly what A1 publish supports and what Jekyll features remain out of scope.

**Acceptance Criteria**:
- [x] A1 publish-supported subset listed in public docs
- [x] Jekyll/Liquid incompatibilities called out explicitly
- [x] Guidance provided for portable markdown authoring in A1

**Dependencies**: None

**Related**: `docs/public/publishing-guide.md`

### T005: Boundary CI hardening

**Description**: Strengthen lock/boundary checks in CI to catch registry drift and forbidden cloud imports earlier.

**Acceptance Criteria**:
- [x] Validate lock registry + boundary spec presence
- [x] Validate required lock IDs and format
- [x] Validate whitelist paths in registry exist
- [x] Add stricter cloud SDK import scan in A1 core

**Dependencies**: None

**Related**: `scripts/check-a1-boundary.sh`, `.github/workflows/lock-boundary.yml`

### T006: A1 release/version mapping

**Description**: Define explicit release mapping from locked ladder stages (A1.0→A1.3) to practical semver bumps.

**Acceptance Criteria**:
- [x] Mapping table added for A1.0/A1.1/A1.2/A1.3
- [x] Current package alignment and bump path documented
- [x] Specs index links to the mapping doc

**Dependencies**: None

**Related**: `docs/specs/version-ladder-a1-a2.md`, `docs/specs/version-mapping-a1.md`

### T007: Command-level smoke tests (github/pr/wp/collab)

**Description**: Add lightweight command-surface tests to prevent CLI routing regressions.

**Acceptance Criteria**:
- [x] `github`/`pr` command groups validated via `--help`
- [x] `wp` command path validated for A2 guidance output
- [x] `submit docs/...` route validated to WordPress-stub path

**Dependencies**: None

**Related**: `core/test/commands-smoke.test.mjs`
