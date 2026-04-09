# ThinUI Feeds and Spool Surfaces

## Purpose

Define the ThinUI-facing local surfaces for browsing feeds, building digests,
and managing spools without moving semantic ownership out of `uDOS-core`.

## Ownership Split

Core owns:

- feed and spool semantics
- event contracts
- lifecycle rules
- retention and reduction policy

ThinUI owns:

- local window and fullscreen rendering
- selection and navigation flows
- bounded preview surfaces
- user-triggered actions emitted back to Core

ThinUI must not own:

- spool storage authority
- feed transformation semantics
- canonical event retention rules

## Primary Surfaces

### Feed Builder

ThinUI should support a compact builder flow for selecting a source, applying a
filter, choosing a transform mode, and selecting an output format.

Suggested controls:

- source selector
- binder or tag selector
- time and type filters
- transform mode selector
- output format and destination selector
- preview action
- create action

### Spool Manager

ThinUI should support a bounded local spool manager showing:

- spool name
- item count
- retained size
- oldest retained item
- checkpoint status
- available actions such as compact, rotate, export, and merge

### Feed Browser

ThinUI should support a feed list with a compact preview panel for:

- feed identity
- recent summaries
- subscription or open actions
- spool handoff actions

### Digest View

ThinUI should support a readable digest surface optimized for:

- grouped summaries
- operational updates
- binder or scope sections
- quick handoff into browser surfaces when richer output is needed

## Interaction Rules

- ThinUI consumes explicit state packets from Core
- ThinUI emits actions and selections back to Core
- ThinUI should render summaries, not raw diagnostic floods
- local preview should stay compact and low-resource
- browser handoff is appropriate for large or richly formatted feed output

## Surface Modes

These surfaces should work in:

- windowed mode
- fullscreen takeover mode
- recovery-safe mode with reduced visual complexity

## Design Direction

The intended visual language is ThinUI plus MDC-style local inspectors:

- single-pane or split-pane layouts
- strong hierarchy
- fast keyboard-safe navigation
- compact list and detail views
- deterministic action placement
