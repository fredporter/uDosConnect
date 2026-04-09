# Alpine Release Policy

## Purpose

Define when `uDOS-alpine` releases remain notes-only versus when they may
attach Alpine packaging outputs.

## Default Policy

Alpine releases are tagged from `main` using semantic version tags.

Default behavior:

- create GitHub release notes from `CHANGELOG.md`
- do not attach APK or image artifacts by default

## Artifact Attachment Rule

Artifacts may be attached only when all of the following are true:

1. the APK or image output is produced by a documented build path
2. the release artifact is a stable public deliverable
3. the artifact type is described in repo docs
4. the repo validation path covers the relevant packaging surfaces

## Current State

Current Alpine releases are treated as notes-first.

Rationale:

- the repo owns packaging and profile definitions, but not yet a stable public
  artifact publication lane
- release automation should not fabricate placeholder APK or image outputs
