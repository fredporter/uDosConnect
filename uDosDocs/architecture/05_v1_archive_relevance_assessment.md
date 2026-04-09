# v1 Archive Relevance Assessment

Purpose:

- preserve high-value conceptual work from `uDOS-v1-8-archived`
- avoid wholesale doc migration into v2 family repos
- separate retained functions from obsolete implementation methods

## Planning Rule

Take a planning round before promoting archived docs into active v2 surfaces.

Use this filter:

1. retain the concept if it still matches the v2 family direction
2. rewrite the ownership if the repo split changed
3. keep the archived file as a reference if the old method is too coupled to v1
4. do not promote implementation detail just to save prose

This means the archive remains a design bank, not a second canonical docs tree.

## High-Value Strands To Retain

### 1. Empire as always-on provider lane

Retain:

- provider-heavy workflows should live outside thin clients
- CRM and remote-service sync should be handled by an always-on service lane
- contact enrichment, dedupe, and binder-aware promotion remain useful concepts

Adapt for v2:

- `uDOS-empire` is now a sibling repo, not a Wizard-activated internal module
- Apple-native sync stays in `omd-mac-osx-app`
- shared web publishing and email render contracts should live in the public
  render/theme pipeline and be consumed by app and repo surfaces
- `uDOS-wizard` owns online networking and provider bridge contracts
- `uDOS-empire` owns Google or HubSpot sync jobs, webhook receivers, and API templates

Primary archived sources:

- `uDOS-v1-8-archived/docs/decisions/v1-5-2-EMPIRE-SERVER.md`
- `uDOS-v1-8-archived/modules/empire/docs/ARCHITECTURE.md`
- `uDOS-v1-8-archived/modules/empire/docs/HUBSPOT-SCHEMA.md`

### 2. One workflow manager contract

Retain:

- there must be one canonical workflow lifecycle
- workflow artifacts should remain file-backed and operator-readable
- scheduler and control-plane surfaces must build on the same core contract

Adapt for v2:

- `uDOS-core` remains the owner of workflow semantics
- `uDOS-empire` cron-type webhooks and sync jobs must consume core workflow contracts
- `uDOS-wizard` may expose orchestration or API surfaces, but must not create a second workflow model

Primary archived sources:

- `uDOS-v1-8-archived/docs/reference/specs/WORKFLOW-MANAGER-CONTRACT-v1.5.md`
- `uDOS-v1-8-archived/docs/reference/specs/WORKFLOW-SCHEDULER-v1.5.md`
- `uDOS-v1-8-archived/docs/decisions/v1-5-workflow-manager.md`

### 3. Compile before publish

Retain:

- compile creates the canonical binder artifact
- publish, submit, persist, and execute are downstream outcomes
- web and email are sibling renderers of one canonical artifact

Adapt for v2:

- web publishing and email render contracts should be shared public contracts
  rather than Wizard-only or app-only logic
- `uDOS-empire` may trigger remote sync or CRM side-effects from reviewed artifacts
- public docs should describe render ownership by family repo, not by legacy Wizard or Empire internals

Primary archived sources:

- `uDOS-v1-8-archived/docs/decisions/01-05-06-web-publish.md`
- `uDOS-v1-8-archived/docs/reference/specs/PUBLISH-EMAIL-RENDERER-CONTRACT-v1.5.8.md`
- `uDOS-v1-8-archived/docs/reference/specs/BINDER-COMPILE-v1.5.md`

### 4. Beacon and networking split

Retain:

- Beacon is an access ritual, not a storage or compute node
- networking layers should be separated by responsibility
- local discovery and online transport should not be conflated

Adapt for v2:

- `uHOME-server` owns local Vault Reader and Beacon Activate content surfaces
- `uDOS-wizard` owns online networking, provider bridges, and wider control-plane contracts
- `uDOS-empire` should use Wizard networking contracts for remote APIs rather than inventing parallel transport policy

Primary archived sources:

- `uDOS-v1-8-archived/docs/concepts/features/beacon-portal.md`
- `uDOS-v1-8-archived/docs/concepts/features/wizard-networking.md`

### 5. Education as a coherent pathway

Retain:

- education should be a ladder, not a random tutorial pile
- automation, APIs, triggers, and webhooks deserve a first-class teaching lane
- sibling repos should share one architecture language

Adapt for v2:

- the family now distributes education across `uDOS-docs`, `uHOME-server`, and sibling repos
- `uHOME-server` should teach local automation
- `uDOS-empire` should teach configurable webhook and API server patterns

Primary archived sources:

- `uDOS-v1-8-archived/docs/decisions/uDOS-education-dev-brief.md`
- `uDOS-v1-8-archived/docs/decisions/v1-5-4-REPO-BOUNDARIES.md`

## Promote Carefully, Not Literally

These archived areas contain solid ideas but should be rewritten for v2 before
promotion:

- HubSpot schema and contact normalization
- webhook templates and provider capability matrices
- workflow scheduler runbook examples
- publish renderer contracts
- operator runbooks for managed sync and monitoring

Promotion target pattern:

- concept into `uDOS-docs`
- repo-specific ownership into `uDOS-empire`, `uHOME-server`, `uDOS-wizard`, or the macOS app
- implementation detail only when the current repo actually owns that method

## Archive-Only For Now

Keep these archived as references unless a current repo explicitly needs them:

- v1-specific TUI and Vibe integration material
- monorepo activation flows for internal Empire modules
- old port numbers, package layouts, and internal runtime paths
- old Android/client assumptions that no longer match the family split

## Current v2 Documentation Actions

### Active now

- `uDOS-empire` owns always-on webhook and API sync scaffolds
- `uHOME-server` course material now distinguishes local automation from online webhook automation
- macOS docs keep Apple-native sync while consuming shared public web/email
  render contracts

### Next useful promotions

1. promote a normalized contact and CRM vocabulary into `uDOS-core` or `uDOS-empire` public contracts
2. rewrite legacy Empire operator runbooks as `uDOS-empire` runbooks
3. promote publish-renderer concepts into shared public render and theme contracts
4. extract Beacon Activate wording from archive into active `uHOME-server` and
   family docs

## Decision

Yes, a planning round is the right method for doc relevance assessment.

The rule for this family should be:

- do not migrate docs to build a huge library
- do preserve conceptual, architectural, and creative work that still fits v2
- rewrite ownership and method around the current family structure before promotion

For the next pass, use `architecture/06_v1_archive_asset_migration_matrix.md`
to assess reusable scripts, templates, seed data, courses, and wiki material.
