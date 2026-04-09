# Family Cascading Shakedown

Date: 2026-03-22  
Workspace: `<workspace-root>/uDOS-family`

## Scope

Ran a cascading shakedown across every active family repo discovered under the
workspace:

- `mdc-mac-app`
- `sonic-screwdriver`
- `uDOS-alpine`
- `uDOS-core`
- `uDOS-dev`
- `uDOS-docs`
- `uDOS-gameplay`
- `uDOS-grid`
- `uDOS-plugin-index`
- `uDOS-shell`
- `uDOS-themes`
- `uDOS-thinui`
- `uDOS-host`
- `sonic-ventoy`
- `uDOS-wizard`
- `uHOME-app-android`
- `uHOME-app-ios`
- `uHOME-client`
- `uDOS-empire`
- `uHOME-matter`
- `uHOME-server`

Validation used each repo's published `run-*-checks.sh` entrypoint when
available, plus `swift test` for `mdc-mac-app`.

Final raw command log: `/tmp/udos_family_shakedown_2026-03-22-final.log`

## Repair Applied

### `uHOME-client`

Initial failure:

- `scripts/run-uhome-client-checks.sh` hard-coded `python3`
- on this machine `python3` resolves to Python 3.9.6
- the local Wizard probe path imports `uDOS-wizard`, which uses 3.10+ type
  syntax such as `str | None`
- the newer interpreter available in the environment did not include the shared
  FastAPI stack required for sibling in-process probe runs

Repair:

- updated `uHOME-client/scripts/run-uhome-client-checks.sh`
- the script now:
  - selects a 3.11+ base interpreter when available
  - creates or reuses `uHOME-client/.venv`
  - installs the minimal sibling probe dependencies needed for local server and
    Wizard smoke runs
  - executes the contract checks, smoke scripts, and tests through that repo
    venv

Result:

- `uHOME-client` reran cleanly
- final family matrix reran cleanly

## Final Matrix

All 21 repos passed on the final sweep.

High-signal test counts surfaced during the run:

- `mdc-mac-app`: `swift test` pass, 141 tests passed
- `sonic-screwdriver`: 40 tests passed
- `uDOS-core`: 74 tests passed
- `uHOME-server`: 191 tests passed

All remaining repos passed their published structural, contract, runtime-safe,
or smoke validation scripts.

## Roadmap Status

Canonical roadmap read from:

- `uDOS-dev/@dev/notes/roadmap/v2-roadmap-status.md`
- `uDOS-dev/@dev/notes/roadmap/v2-family-roadmap.md`

Current live state:

- active family version-round: `v2.3`
- active round: `completed`
- blockers: none
- next lane: final promote step and `v2.3` tag cut
- `v2.3` status: promotion-ready

Planned but not yet active public repo still called out in the live roadmap:

- `uHOME-macos-app`

## Incomplete Or Stub Surfaces

These are the most concrete unfinished or placeholder-backed areas found during
the sweep.

### Packaging and build stubs

- `uDOS-alpine/apkbuild/APKBUILD`
  - `build()` and `package()` still emit placeholder messages
- `uDOS-alpine/scripts/build-apk.sh`
  - still prints `Building Alpine package placeholder`
- `uHOME-app-android/build.gradle.kts`
  - root Gradle file remains a placeholder shell

### Placeholder or partial app/test surfaces

- `uHOME-app-ios/Tests/AppTests/README.md`
  - still describes the iOS test target as a placeholder
- `mdc-mac-app/Tests/AppTests/README.md`
  - still describes the desktop test target as a placeholder even though the
    repo now has a substantial real test suite; documentation is stale

### Placeholder output renderers

- `mdc-mac-app/Sources/Core/Projectors/Publish/EPUBPublishRenderer.swift`
  - emits a deterministic `.epub` placeholder payload
- `mdc-mac-app/Sources/Core/Projectors/Publish/PDFPublishRenderer.swift`
  - emits a first-pass placeholder PDF payload

### Explicit future-round or deferred work

- `uDOS-gameplay/src/grid-consumption.json`
  - still marks `grid-core-support` as a future-round tag, not a current merge
    target
- `uHOME-server/docs/architecture/PHASE-6-CHECKLIST.md`
  - Phase 6 remains active and ~95% complete
  - deferred or incomplete items still listed:
    - Terraform templates for cloud deployment
    - environment configuration guide and examples
    - prerequisite checker
    - PyPI publishing automation
    - Docker image publish pipeline
    - metrics export endpoints
    - runbook validation tests

## Notes

- The first family rerun briefly logged a failing `mdc-mac-app` compile, but a
  direct rerun and the final full-family rerun both passed cleanly with the
  current workspace state. No app code change was required there.
- Existing unrelated user edits present in `mdc-mac-app`,
  `sonic-screwdriver`, and `uHOME-server` were left intact.
