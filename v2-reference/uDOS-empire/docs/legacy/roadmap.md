# uDOS-empire Roadmap

## Direction

Empire is moving from a narrow sync-extension posture toward a broader
operations-container repo that still stays modular, inspectable, and safe.

## Phase 1: Foundations

- establish the repo spine for packs, templates, adapters, and schemas
- define domain models for operations concepts
- define pack manifests and dry-run execution expectations
- keep current sync and automation contracts aligned to family runtime surfaces
- add the first Make-pathway docs and starter examples
- add starter operational packs backed by inspectable manifests
- add pack catalog and operator report artifacts for reusable inspection

## Phase 2: Campaign And Audience Layer

- expand contact and company operational records
- add audience segmentation concepts
- add campaign pack structure
- add reporting outputs
- add approval workflow conventions

Current traction inside Phase 2:

- HubSpot lane is now marked active at the contract-plus-runtime-gate level
  through `scripts/smoke/hubspot_lane_gate.py`
- provider mutation remains approval-gated and secret-backed through Wizard

## Phase 3: Guided Make System

- add editable pack builders
- add validation helpers
- add walkthrough examples
- add safer practice and dry-run paths
- promote remixable starter projects

## Phase 4: Extended Adapters

- deepen HubSpot mapping support
- add WordPress or headless publishing adapters
- expand export and reporting options
- support shared library or community pack distribution

## Current Google MVP Round

The next bounded Empire advancement is now explicit:

- MVP lane: `Firestore mirror + Cloud Run binder supervision`
- posture: optional, supervised, disposable
- source of truth: still family-owned canonical contracts, not Firestore
- provider entry: still Wizard
- host and fallback: still Ubuntu

Empire's job in this round is to make the Google lane concrete without
pretending it is already a production provider runtime.

Required outputs for this round:

- one explicit contract note for the MVP lane
- one service-lane note covering route, schema, and extraction expectations
- one policy note covering budget and shutdown behavior
- one operator-facing status surface naming the lane as the current Google MVP

Deferred until after the MVP setup:

- production promotion
- canonical write ownership
- broad multi-lane Google service expansion
- any move that would make Empire the provider-entry point

## Current Family Alignment

Recent family advancement matters here:

- `v2.0.2` shared runtime-service and working-system passes are complete
- `uDOS-core` now supplies shared sync and automation contracts
- `uHOME-server` now exposes ingest, queue, process, and result surfaces
- Empire currently consumes those surfaces for sync and automation scaffolds

That means the next Empire work should build upward from stable family runtime
contracts into richer pack, publishing, messaging, and Make-pathway features.
