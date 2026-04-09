# uDOS-empire Provider Lane Status

## Purpose

Track which provider lanes are active, scaffolded, or deferred in
`uDOS-empire`.

This adapts the useful operator-status pattern from the archived Empire docs to
the current v2 sibling-repo model.

## Active Direction

### Google workspace lane

Current direction:

- Google Docs mirror sync
- Google Keep projection or mirror import paths
- Google Tasks projection and pull
- channel-specific sync-package slicing for Google-targeted binder routes
- Firestore mirror plus Cloud Run binder supervision for the first Google MVP

Status:

- scaffolded contract lane
- package, handoff, and automation-runtime probe ready
- not yet a full live provider runtime
- first explicit MVP lane named under `@dev/v2-upgrade/uDOS-empire/`

Current MVP focus:

- Firestore mirror for approved binder or vault artifacts
- Cloud Run binder-trigger prototype
- Firebase Auth shared-room support only where collaboration requires it

Ownership guardrails:

- Wizard remains provider-entry and prompt owner
- Firestore remains mirror storage, not canonical truth
- Ubuntu remains the local cache and fallback lane

Primary anchors:

- `src/webhooks/google-sync-template.json`
- `examples/configurable-webhook-server.json`
- `@dev/v2-upgrade/uDOS-empire/runtime/contracts/google-ai-studio-contract.md`
- `@dev/v2-upgrade/uDOS-empire/docs/google-ai-studio-server.md`
- `@dev/v2-upgrade/uDOS-empire/docs/budget-policy.md`

### HubSpot lane

Current direction:

- contact sync using app-owned local contact records
- task sync
- note sync
- webhook-driven updates
- channel-specific sync-package slicing for HubSpot-targeted binder routes

Status:

- active lane
- package, handoff, and automation-runtime gate passing via `scripts/smoke/hubspot_lane_gate.py`
- provider mutation remains approval-gated and secret-backed through Wizard routing

Failure policy and review addendum:

- `docs/hubspot-lane-failure-policy.md`

### Webhook automation lane

Current direction:

- binder-triggered webhook package generation
- queue and handoff path into the local-network ingest surface
- empty-package validation when no webhook-routed records are present

Status:

- scaffolded contract lane
- package, handoff, and automation-runtime probe ready
- not yet a full live event runtime

Primary anchors:

- `src/webhooks/hubspot-sync-template.json`
- `docs/contact-and-crm-model.md`

## Deferred Or Future Lanes

These should appear as explicit scaffold lanes, not as half-live features:

- Outlook or Microsoft ecosystem
- LinkedIn enhancement
- additional CRM providers
- future beacon-to-beacon remote sync handoff

## Operator Rule

Provider lanes must present one of these states clearly:

- `active`
- `scaffolded`
- `deferred`

Do not present a deferred lane as if it were operational.

## Promotion Rule

Before moving a provider from `scaffolded` to `active`:

1. define the contract in `src/webhooks/`
2. add an inspectable example in `examples/`
3. add validation coverage
4. document review and failure policy
5. define where operator status will be surfaced
6. prove that mirrored storage is not being treated as canonical truth
7. record extraction artifacts for routes, schema, auth, and env vars

Current scaffold checks live under:

- `scripts/smoke/integration_preflight.py`
- `scripts/smoke/contract_smoke.py`
- `scripts/smoke/sync_plan.py --local-uhome-automation-runtime`
- `scripts/smoke/hubspot_lane_gate.py --json`
