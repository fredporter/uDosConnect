# Upstream Sync Strategy

## Rule

Clone Deer Flow. Do not maintain a product fork unless upstream disappears or legal / operational conditions force a break.

## Why

A fork creates early divergence pressure:

- harder upstream updates
- blurred ownership
- accidental platform coupling
- unclear bug provenance
- duplicated maintenance burden

An upstream clone plus adapter repo keeps boundaries clear.

## Layout

Recommended local structure:

```text
vendor/
  deer-flow/                 # cloned upstream repo
uDOS-plugin-deerflow/        # this repo
```

Alternative:

```text
external/deer-flow/
plugins/uDOS-plugin-deerflow/
```

## Remote setup

Use:

- `upstream` -> official ByteDance Deer Flow repo
- optional `origin` -> your own mirror if needed for CI caching
- pin through tags or commit SHAs in uDOS config, not by editing Deer Flow internals as your main integration method

## Update cycle

1. fetch upstream
2. inspect release notes / breaking changes
3. update pinned commit in compatibility matrix
4. run adapter tests
5. run translation snapshots
6. run security and trust boundary checks
7. promote pin only after pass

## What belongs in this repo, not upstream

- uDOS workflow translation
- uDOS schema validation
- uDOS trust gating
- uDOS artifact normalization
- uDOS-specific wrappers and launcher scripts
- uDOS docs and conformance tests

## What should be avoided

- random edits to Deer Flow internals
- patching upstream without recording a narrow reason
- depending on unstable internal file paths without a compatibility shim in this repo
- letting runtime outputs become the canonical binder state

## Exception policy

Temporary downstream patches are allowed only when:

- they are recorded in `PATCHES.md`
- they are minimal and reversible
- they are linked to an upstream issue or internal decision
- they do not silently redefine the uDOS adapter boundary
