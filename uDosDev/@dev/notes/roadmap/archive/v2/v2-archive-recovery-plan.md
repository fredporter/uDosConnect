# v2 Archive Recovery Plan

## Purpose

Capture the remaining high-value material from archived v1 repos inside an
in-family mirror so the root archive folders can be removed without losing
contracts, workflows, and client concepts.

## Scope Reviewed And Mirrored

- `uHOME-server-v1-archived`
- `uHOME-android-app-v1-archived`
- `OBSC-android-app-v1-archived`
- `OBSC-mac-app-v1-archived`

Mirror root:

- `uDOS-dev/@dev/archive-imports/v1/`

## Reusable Findings

### `uHOME-server-v1-archived`

High-value carry-forward material:

- explicit server pathway contract and API surface inventory in `README.md`
- local-network runtime ownership split across Home Assistant, runtime,
  library, containers, network, dashboard, and presentation APIs
- household topology examples under `vault/` for homes, rooms, devices, and
  notes
- Home Assistant bridge service docs under `docs/services/home-assistant/`
- operator CLI and install flow examples for launcher and installer work
- backup, readiness, and dashboard expectations recorded in the changelog and
  architecture notes

Recommended v2 use:

- backfill any missing `uHOME-server` docs for runtime/API/CLI surfaces
- recover vault-example patterns for household modeling
- cross-check current `uHOME-server` Phase 6 work against archived backup and
  observability expectations

### `uHOME-android-app-v1-archived`

High-value carry-forward material:

- clean kiosk/server topology split in `uHOME-kiosk.md`
- trusted-server, LAN discovery, controller UX, and session-mode expectations
- launcher, jobs, playback, and household panel definitions for tablet mode

Recommended v2 use:

- turn the kiosk brief into a contract note for `uHOME-app-android`
- keep ownership with `uHOME-server` for jobs, storage, and control endpoints
- treat Android as the thin client and kiosk presentation lane

### `OBSC-android-app-v1-archived`

High-value carry-forward material:

- the clearest client/server split for Empire/Wizard/Android responsibilities
- normalized contact model and source-precedence rules
- Gmail intake, historical archive processing, email-to-task promotion, and
  markdown email publishing requirements
- Google Contacts projection and HubSpot sync boundaries
- milestone ordering for Android shell, Empire services, and uHOME kiosk work

Recommended v2 use:

- recover the service-domain breakdown into `uDOS-empire` planning
- use the contact and email models as input for Mac and Empire binder work
- use the kiosk stream to shape Android feature order after the thin shell

### `OBSC-mac-app-v1-archived`

High-value carry-forward material:

- local-first Apple import, binder contact, email history, and publish
  positioning in the archived README
- recurring automation, runtime indexing, and vault-watcher concepts in
  `Sources/Automation/TaskScheduler.swift`, `Sources/Store/VaultStore.swift`,
  and integration modules
- email rendering, template, and GitHub Pages workflow generation surfaces
- architectural lessons from `PRE_XCODE_AUDIT.md` about duplication,
  façade boundaries, and state drift

Recommended v2 use:

- recover only the durable architectural patterns, not the full v1 app shape
- move Mac-local follow-up work into the private app repo rather than keeping
  it in the family roadmap
- use the audit note to avoid recreating duplicated bridge logic in v2

## Roadmap Implications

### Tranche 7 candidate: Archive Contract Backfill From Mirror

- recover runtime, client, and service contracts from the archived repos
- normalize them into repo-safe v2 docs, briefs, or binders
- avoid direct code migration unless the ownership and runtime fit still hold

### Tranche 8 candidate: Client Surface Convergence

- use recovered archive material to sharpen `uHOME-app-android`
- align client responsibilities against `uHOME-server` and `uDOS-empire`
- move Mac-local workflow follow-up into the private app repo's own docs and
  planning lanes

## Suggested Binder Sequence

1. `#binder/uhome-server-archive-contract-backfill`
2. `#binder/uhome-android-kiosk-alignment`
3. `#binder/uhome-empire-provider-recovery`

## Guardrails

- salvage concepts, contracts, examples, and migration notes into the mirror first
- do not copy archived structure into active repos without an ownership check
- prefer small repo-safe promotions over bulk archive imports
- keep private app repos aligned to public contract owners instead of becoming
  shadow sources of truth
