# uDOS v2 Development Roadmap

## Purpose

This document is the stable overview for the uDOS v2 repo family roadmap.

The canonical live roadmap now lives in:

- `@dev/notes/roadmap/v3-roadmap.md` (includes **engineering backlog**: runtime optimisation flags, doc-structure verification, PR checklist)
- `@dev/notes/roadmap/v3-feed.md`
- `@dev/notes/roadmap/v2.0.3-rounds.md`
- `@dev/notes/roadmap/v2.0.4-rounds.md`
- `@dev/notes/roadmap/v2.4-rounds.md`
- `@dev/notes/roadmap/v2.5-rounds.md`

The tranche bootstrap work established governance, activation docs, sweep
automation, release classification, and the `@dev` intake lanes. From this
point onward, implementation is tracked by versioned development rounds rather
than by one-time bootstrap tranches.

`uDOS-dev` owns roadmap sequencing and reporting.
`uDOS-core` remains the semantic source of truth for boundaries, dependencies,
and canonical runtime contracts.

## Operating Position

uDOS v2 is a clean refactor and controlled rebuild across the new repo family.

- archived v1 repos are reference material only
- new repos define fresh v2 ownership boundaries
- useful patterns and schemas may be recovered selectively
- no runtime compatibility shim is carried forward by default
- repo boundaries are part of the architecture, not cleanup work

## Current Family Baseline

The following foundation is already in place:

- public family repos exist with activation docs and validation entrypoints
- `uHOME-app-android` and `uHOME-app-ios` exist as the v2 mobile app repos
- `uHOME-matter` exists as the active local automation extension repo
- `uDOS-dev` binder intake, status reporting, and roadmap workflow are active
- release classification and versioning policy are documented
- archive recovery research has started in `@dev/notes/roadmap/`
- `uHOME-server` remains an active public runtime repo alongside
  `uHOME-client`; it is not retired by this roadmap
- the `uHOME v2` master spec has been accepted as a staged direction; mobile
  repo consolidation is active through `uHOME-app-android` and
  `uHOME-app-ios`, `uHOME-matter` is active as the local automation extension
  lane, and the app-facing client, kiosk, and portal surfaces live in the two
  active platform app repos
- the active `uHOME` family now has a complete repo-level setup spine across
  server, client runtime, matter extension, empire extension, and mobile apps

The completed family lane after `v2.3` is `v2.4`, a workspace-led upgrade
sequence that:

- activates `uDOS-workspace` as a distinct public family repo
- stages MDC as the markdown-first intake and normalization lane
- stages UCI as the shared controller-input contract and shell-first UX lane
- stages Deer Flow as an optional Wizard-selectable execution backend
- keeps repo-local shipping on the `2.3.x` semantic-version line unless a later
  family decision explicitly changes repo baselines

The next active family lane is `v2.5`, which completes the remaining local
execution and output-consumption work:

- controlled Deer Flow execution beyond preview-only flows
- richer Wizard result persistence and artifact reporting
- deeper workspace consumption of execution outputs
- broader markdown-first normalization coverage in Core

This means `v2.0.1` is no longer a pure scaffolding exercise. It is the round
that turns the current scaffold baseline into explicit contracts, starter
runtime artifacts, and reusable cross-repo surfaces.

## Repo Family In Scope

### Core Platform And Orchestration

- `uDOS-core`
- `uDOS-shell`
- `uDOS-wizard`
- `uDOS-plugin-index`
- `uDOS-themes`
- `uDOS-dev`
- `uDOS-docs`
- `uDOS-workspace`

### Product And System Repos

- `uHOME-server`
- `uDOS-empire`
- `uHOME-matter`
- `uHOME-client`
- `uHOME-app-android`
- `uHOME-app-ios`
- `uDOS-gameplay`
- `sonic-screwdriver`
- `uDOS-alpine`

### Archived Reference Repos

Use only as selective source material:

- `uHOME-server-v1-archived`
- `uHOME-android-app-v1-archived`
- `OBSC-android-app-v1-archived`
- `OBSC-mac-app-v1-archived`
- `uDOS-v1-8-archived`
- `uDOS-v1-4-archived`

## Versioned Development Rounds

## Repo Version Rule

Within a family plan, each repo now advances its own three-part semantic
version.

Baseline:

- `2.3.0`

Default progression:

- `2.3.1`
- `2.3.2`

Each repo version change should carry:

- explicit `@dev` tags when useful
- an optional Dev Mode status when the operating posture matters

Collection alignment rule:

- use the current family plan to coordinate cross-repo sequencing
- use repo-local semantic versions for shipped releases
- advance minor or major versions only when the family plan explicitly calls for
  them

Preferred Dev Mode statuses:

- `active`
- `stable`
- `version-locked`
- `queued`
- `blocked`
- `superseded`

This keeps roadmap progress, dev pegs, and live operating state aligned.

## v2.4: Workspace-Led Upgrade Round

### Goal

Open the next family lane around a new visual operator workspace while keeping
truth ownership in Core, orchestration ownership in Wizard, and repo-local
release cadence on the existing `2.3.x` semver line.

### Round Sequence

- Round A: `uDOS-workspace` repo activation, workspace shell seed, compile
  manifest contract, and spatial-consumer contract lock
- Round B: MDC intake and conversion contract plus Core-owned MVP engine rules
- Round C: UCI event, mapping, and prediction contracts plus shell-first
  command palette and radial-keyboard UX prototype
- Round D: Deer Flow optional execution adapter and Wizard backend-selection
  lane
- Round E: family integration, validation, promotion notes, and explicit
  deferred-set recording

### Public Surface Changes

- `uDOS-workspace` enters the family roadmap as a distinct public repo
- workspace-facing `CompileManifest` mapping becomes the first browser
  workspace schema
- MDC defines normalized output expectations for `.md`, `.json`, and `.sqlite`
- UCI defines the shared mode set and reserved controller semantic actions
- Deer Flow introduces an optional native-versus-adapter backend selection lane

### Stable Constraints

- workspace is an operator-of-truth surface, not the owner of canonical truth
- MDC is contract-plus-MVP conversion behavior in `v2.4`, not a full rich-media
  ingestion platform
- UCI is shell-first and contract-led in `v2.4`, with broader repo rollout
  deferred
- Deer Flow remains optional and experimental in `v2.4`; certification depth,
  remote clusters, graph editing, and memory sync import/export stay deferred

## v2.5: Execution Completion Round

### Goal

Complete the remaining local execution surfaces left intentionally deferred by
`v2.4`, while keeping remote clusters and distributed execution out of scope.

### Round Sequence

- Round A: execution lane activation and follow-on scope lock
- Round B: Deer Flow controlled execution plus Wizard result persistence
- Round C: MDC expansion and workspace output consumption
- Round D: validation and promotion

### Stable Constraints

- local controlled execution is in scope in `v2.5`
- remote clusters, graph editing, and memory sync remain later-plan work

Each version runs through the same three delivery rounds:

### Round A: Contract Lock

- confirm boundaries, docs, schemas, and repo ownership
- capture salvageable v1 patterns without copying stale implementations
- open the binder set for the version

### Round B: Runnable Spine

- land the minimum code, examples, and starter services needed for the version
- wire validation to the new surfaces
- expose reusable contracts to sibling repos

### Round C: Validation And Promotion

- run repo validation and smoke checks
- update `@dev` status, submissions, and promotion notes
- carry only promotable outputs toward release tagging

## v2.0.1: Platform Reset And Skeleton Rebuild

### Goal

Lock the canonical v2 structure and turn the current scaffold baseline into a
real shared platform spine.

### Round A Focus

- confirm public and private repo ownership boundaries
- mark archived v1 repos as reference-only sources for selective recovery
- convert the roadmap workflow from tranche tracking to version-round tracking
- define the first `v2.0.1` contract artifacts in `uDOS-core`

### Round B Focus

#### `uDOS-core`

- define the canonical starter contracts for:
  - command/runtime model
  - binder/workflow engine
  - capability resolution
  - plugin/package contracts
  - MCP abstraction
  - provider abstraction
  - vault/memory conventions
  - release lane semantics
  - conformance expectations
  - starter schemas and templates
- ship a lightweight runnable core surface that exposes those contracts

#### `uDOS-shell`

- stand up a reusable shared shell surface for:
  - common TUI shell
  - command palette
  - layout and panel primitives
  - workflow and task surfaces
  - theme token bridging
  - shell adapter contracts for sibling products

#### `uDOS-wizard`

- frame Wizard as the orchestration layer for:
  - provider setup and routing
  - local and remote tool execution
  - publishing orchestration
  - renderer and service coordination
  - external task execution
  - future assisted workflow and budget controls

#### `uDOS-plugin-index`

- create the registry skeleton:
  - plugin manifest format
  - trust levels
  - compatibility metadata
  - certification placeholders
  - example catalog entries

#### `uDOS-themes`

- stand up shared token and theme surfaces:
  - token structure
  - shell mapping
  - thin GUI and browser mapping direction
  - publishing and email-safe output direction
  - initial bundled themes

#### `uDOS-dev`

- make `@dev` the governed intake lane for briefs and promotions:
  - local-only `@dev/inbox`
  - `@dev/triage`
  - `@dev/routing`
  - `@dev/promotions`
  - routing manifests
  - promotion and status logs

#### `uDOS-docs`

- capture the public narrative for:
  - v2 charter
  - repo family overview
  - ownership map
  - contributor workflow
  - binder-led development
  - fresh-refactor positioning

#### Product And App Repos

- `uHOME-server`: keep the active local runtime boundary explicit while
  `uHOME-client` and private apps rebuild around it
- `uDOS-empire`: define fresh v2 docs for contacts, companies, publishing,
  campaigns, monetisation, sync contracts, and zapier-like container or job
  workflows
- `uHOME-matter`: define fresh v2 docs for Matter, Home Assistant, and local
  automation extension boundaries separate from the server runtime
- `uHOME-client`: define the lightweight client runtime, LAN contract
  boundaries, and relationship to the server runtime
- `uHOME-app-android`: own Android UI, kiosk, playback, and platform-specific
  presentation on top of the client runtime
- `uHOME-app-ios`: own iOS UI, kiosk, playback, and platform-specific
  presentation on top of the client runtime
- `uDOS-gameplay`: define gameplay as a lens on platform data, not a second
  runtime
- `sonic-screwdriver`: align install, bootstrap, rescue, and deployment
  boundaries
- `uDOS-alpine`: position Alpine as the lean deployment and rescue target
- `uHOME-app-ios` and `uHOME-app-android`: keep app boundaries, sync roles,
  and links to Core, Shell, Wizard, Empire, and uHOME explicit

### Round C Exit Criteria

- `uDOS-core` exposes the starter contract spine in code and docs
- Shell and Wizard reflect the new core contract framing
- roadmap status is tracked as `v2.0.1` rounds rather than tranche steps
- repo owners have a clear binder queue for `v2.0.2`

## v2.0.2: Shared Runtime, Product Rebuild, And First Real Features

### Goal

Move from starter scaffolds to a usable shared runtime with the first real v2
product features.

## uHOME v2 Staging Rule

Across upcoming version rounds, treat the `uHOME v2` platform expansion as a
sequenced split:

1. `uHOME-server` remains the runtime owner
2. `uHOME-client` remains the active shared client-runtime lane
3. `uHOME-app-android` and `uHOME-app-ios` own the v2 client, kiosk, and
   portal app lanes
4. `uHOME-matter` remains the active local automation extension lane
5. `uDOS-empire` remains the optional sync and cloud-extension lane

### Round A Focus

- lock the first working runtime and orchestration contracts
- prioritize `uDOS-core`, `uDOS-shell`, `uDOS-wizard`, `uHOME-server`, and
  `uDOS-empire`

### Round B Focus

- `uDOS-core`: working binder engine, command routing, schema validation,
  capability loading, plugin install resolution, vault layout, release-lane
  wiring, and conformance tests
- `uDOS-shell`: command execution, binder browsing, package browsing, task and
  status panels, theme support, and product adapter hooks
- `uDOS-wizard`: provider config, local and remote execution routing,
  publishing orchestration, connector preparation, and service status surfaces
- `uDOS-plugin-index`: manifest validation, trust classes, discovery metadata,
  and wrapped repo path scaffolding
- `uDOS-themes`: stable theme packs for shell, browser, publishing, and
  email-safe output
- `uDOS-empire`: contact and company schemas, sync pipeline skeletons,
  campaign metadata, outbound comms direction, and import/export contracts
- `uHOME-matter`: Matter bridge contracts, Home Assistant adapter surfaces, and
  local automation extension flows
- `uHOME-client`: client runtime, LAN interaction, session and control routing
- `uHOME-app-android`: Android UI, kiosk, playback, and mobile presentation
- `uHOME-app-ios`: iOS UI, kiosk, playback, and mobile presentation
- `uHOME-server`: align the always-on runtime with the new core and client
  contracts instead of carrying transitional drift
- `uDOS-gameplay`: state structures, spatial and grid consumption, renderer
  contracts, and optional gameplay views
- `sonic-screwdriver`: installer packs, bootstrap logic, rescue routes,
  deployment profiles, and verification flows
- `uDOS-alpine`: deployment references, runtime profiles, and low-resource
  package strategy
- app repos: implementation planning and first app-facing integration layers

### Round C Exit Criteria

- core runtime actually executes shared flows
- shell and wizard are usable against those contracts
- product repos hold the first real v2 code, not docs alone
- `uDOS-dev` promotion flow can compile status cleanly for the version

## v2.0.3: Integration Pass, Sync Bridges, And Product Alignment

### Goal

Turn the repo family into a connected system with the first end-to-end v2
workflows across core, shell, wizard, apps, and sibling products.

### Round A Focus

- harden cross-repo contracts before widening integrations
- prioritize live sync and orchestration paths over new surface area
- lock the shared config and state split for `.env`, user variables, seed
  stores, and Wizard secret storage before broad networking work

### Round B Focus

- `uDOS-core`: stable command and workflow runtime, plugin behavior,
  provider/MCP execution paths, release routing, improved conformance, and the
  shared env plus local-state contract
- `uDOS-shell`: mature adapters, multi-repo surfaces, workflow and publish
  views, plugin-index integration, local tool visibility, and family config
  inspection surfaces
- `uDOS-wizard`: provider and transport orchestration, publishing and
  deployment routing, task dispatch, service coordination, health flows, secret
  storage, and config inspection plus mutation surfaces
- `uDOS-plugin-index`: installable example plugins, trust and compatibility
  policy, deprecation, and promotion logic
- `uDOS-themes`: first cross-family theme bridge for shell, browser,
  publishing, and email-safe output
- `uDOS-empire`: active contact, company, campaign, publishing, and early
  mail/contact intelligence flows plus shared sync and webhook secret
  consumption
- `uHOME-client` and `uHOME-server`: connected remote-control, session,
  browser, appliance-facing surfaces, and aligned service-local config plus
  seed-data consumption
- `uDOS-gameplay`: visual overlays and optional immersion layers without
  violating core runtime ownership
- `sonic-screwdriver` and `uDOS-alpine`: aligned install and deployment
  pathways
- app repos: first serious desktop and mobile companion workflows

### v2.0.3 Family Config And Secret Lane

The current integration pass also needs a dedicated family lane for local
configuration and state alignment. Keep the detailed split centralized in the
family alignment doc rather than repeating it in each roadmap note.

Working tags:

- `@dev/family-env-contract`
- `@dev/family-user-vars`
- `@dev/family-seed-store`
- `@dev/wizard-secret-store`

Canonical reference:

- `docs/v2.0.3-family-config-state-alignment.md`

### Round C Exit Criteria

- the repo family behaves like one connected platform
- first sync and orchestration bridges work across repo boundaries
- dev workflow, docs, and release discipline operate as part of runtime
  delivery instead of after-the-fact cleanup

## Recovery Rule From Archived v1

Recover from v1 only by category.

Recover:

- patterns
- schemas
- useful contracts
- install and package ideas
- workflow shapes
- selected product logic worth preserving

Rewrite fresh:

- runtime code
- shell code
- orchestration boundaries
- product ownership boundaries
- sync logic
- app integrations
- new UI and surface code

Retire:

- duplicate shell work
- mixed-boundary logic
- experimental fragments without clear ownership
- v1 coupling that breaks the v2 repo-family model

## Recommended Immediate Priority Order

1. `uDOS-core`
2. `uDOS-shell`
3. `uDOS-wizard`
4. `uDOS-dev`
5. `uDOS-docs`
6. `uDOS-plugin-index`
7. `uDOS-themes`
8. `uHOME-server`
9. `uDOS-empire`
10. `uHOME-matter`
11. `sonic-screwdriver`
12. `uHOME-client`
13. `uDOS-alpine`
14. `uHOME-app-ios`
15. `uHOME-app-android`
16. `uDOS-gameplay`

## v2.0.4: Networked Runtime Bridges And Secret-Backed Integration

### Goal

Build the first family-wide networking layer on top of the `v2.0.3` config,
state, and secret split without moving transport ownership out of Wizard.

### Round A Focus

- lock Wizard-owned networking boundaries for remote provider, bridge, and
  sibling runtime calls
- confirm which secret-backed network lanes are family-wide versus repo-local
- keep Core focused on neutral contracts, not transport execution
- use `docs/v2.0.3-family-config-state-alignment.md` as the prerequisite
  boundary instead of redefining config and secret ownership here

### Round B Focus

- `uDOS-wizard`: secret-backed networking bridges, remote provider transport,
  and family-visible operator controls
- `uHOME-server`: durable local-network fulfillment behind Wizard-owned bridge
  contracts
- `uDOS-empire`: online provider, webhook, and CRM networking that consumes
  Wizard-mediated secret and bridge patterns where useful
- `uDOS-shell` and app repos: inspection and handoff surfaces, not networking
  ownership

Working tags:

- `@dev/family-wizard-networking`
- `@dev/wizard-network-bridges`

### Round C Exit Criteria

- Wizard owns the family networking layer clearly
- secret-backed bridge patterns are reusable across sibling repos
- networking does not leak into Core semantics or Shell UI ownership

## Entry Criteria For New Round Work

Open a new binder when:

- the owning repo is clear
- the boundary is already documented or can be clarified cheaply
- the output is promotable
- the validation path is known or can be added as part of the work

Do not open implementation work when the boundary still spans multiple repos
without an owner.

## Exit Criteria Per Round

- binder request exists
- validation path exists
- outputs are committed in the owning repo
- `develop` carries the integration state
- `main` receives only reviewed promotion outputs
