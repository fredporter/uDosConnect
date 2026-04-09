# v1 Code Helper Reuse Audit

Purpose:

- assess archived v1 helper modules for selective reuse in the v2 family
- preserve strong helper logic without dragging forward v1 monorepo coupling
- identify concrete v2 landing zones for rewritten helpers

## Assessment Rule

Use three buckets:

- `rewrite-worthy helper logic`
- `pattern only`
- `archive only`

For code, prefer rewriting the smallest stable logic unit rather than moving
whole modules. Keep v2 helpers narrow, repo-owned, and contract-first.

## Main Finding

The strongest reusable code in the archive is helper logic, not whole runtime
modules. The parts worth carrying forward are:

- record normalization rules
- contact dedupe keys and fuzzy-match helpers
- small validation and enrichment hooks
- thin client and preflight patterns for provider-facing services

The parts that should not be revived directly are:

- monorepo-relative path loading
- private local secret-file conventions as the default family method
- old SQLite schema ownership
- broad route or proxy surfaces without a current v2 owner

## Landing Zones

- `uDOS-empire`
  For provider payload normalization, contact matching, provider mapping, sync
  preflight, and operator-facing helper scripts.
- `uDOS-wizard`
  For thin provider or MCP bridge helpers, route-level transport wrappers, and
  network-facing guardrails.
- `uDOS-core`
  Only if a helper becomes truly cross-family and semantics-level rather than
  provider-specific.

## Targeted Module Assessment

### `modules/empire/services/normalization_service.py`

Bucket:

- `rewrite-worthy helper logic`

Keep:

- field alias extraction for `name`, `organization`, `role`, `email`, and
  `phone`
- stable record-id hashing from normalized identity fields
- line-oriented payload normalization as a simple ingest shape

Do not keep directly:

- imports tied to old `empire.services.*`
- direct SQLite persistence inside the normalization module
- v1 record shape as a family-wide canonical schema

Promote toward:

- `uDOS-empire/src/` as a small provider payload normalization helper
- input adapters behind Google, HubSpot, and generic webhook contracts

Reason:

- the logic is portable and still matches the current `uDOS-empire` role
- the implementation should become provider-neutral and contract-scoped

### `modules/empire/services/dedupe_service.py`

Bucket:

- `rewrite-worthy helper logic`

Keep:

- email-first dedupe key strategy
- `name + organization` fallback keying
- lightweight fuzzy comparison helpers

Do not keep directly:

- tight coupling to the v1 `NormalizedRecord` dataclass

Promote toward:

- `uDOS-empire/src/` as contact merge and mirror-sync helper logic

Reason:

- dedupe is still core to Apple-contact-originated CRM sync and Google or
  HubSpot projection

### `modules/empire/services/email_validator.py`

Bucket:

- `rewrite-worthy helper logic`

Keep:

- low-cost format validation
- role-based mailbox detection
- bot-like sender filtering

Do not keep directly:

- treating the helper as sufficient for all production email trust decisions

Promote toward:

- `uDOS-empire/src/` as a narrow validation helper used by contact ingest and
  webhook payload cleanup

Reason:

- this is a small, clear helper with little architecture baggage

### `modules/empire/services/enrichment_service.py`

Bucket:

- `rewrite-worthy helper logic`

Keep:

- simple hook registration pattern for post-normalization record cleanup

Do not keep directly:

- global mutable hook state as the long-term runtime pattern

Promote toward:

- `uDOS-empire/src/` as explicit transform pipelines or provider mapping
  stages

Reason:

- the concept is useful, but v2 should favor explicit, testable transform
  chains over implicit global hook registration

### `modules/empire/services/secret_store.py`

Bucket:

- `pattern only`

Keep:

- the distinction between operator-managed secret material and repo-tracked
  config
- the idea of a small helper API for `set` and `get`

Do not keep directly:

- local Fernet key generation in repo-adjacent config as the default family
  method
- secret files as the primary cross-repo secret contract

Promote toward:

- `uDOS-empire/scripts/` for local development helpers only, if needed
- otherwise prefer environment-based loading or an approved external secret
  store

Reason:

- the need is real, but the method is too tied to private v1 deployment habits

### `modules/empire/services/storage.py`

Bucket:

- `pattern only`

Keep:

- separation between records, tasks, documents, import jobs, sync jobs, and
  mapping metadata
- the idea of explicit job tables or job-state records for always-on sync work

Do not keep directly:

- the full SQLite schema
- schema migration through helper-side `ALTER TABLE` drift
- old repo ownership of contacts, documents, and tasks as one local database

Promote toward:

- `uDOS-empire` docs and future runtime design as a data-shape reference only

Reason:

- the table partitioning is conceptually useful, but v2 ownership is now
  distributed across the macOS app, `uDOS-empire`, and shared family
  contracts

### `wizard/mcp/gateway.py`

Bucket:

- `pattern only`

Keep:

- thin HTTP wrapper around Wizard APIs
- explicit health check before use
- loopback-aware auto-start idea for local development only

Do not keep directly:

- imports from old runtime config modules
- large endpoint inventory as a scaffold for current v2
- subprocess launch assumptions tied to the old daemon layout

Promote toward:

- `uDOS-wizard` as small, current-contract transport helpers where needed

Reason:

- the thin-client pattern is good, but the old file is mostly integration glue
  to a runtime that no longer exists in the same form

### `wizard/tools/secret_store_cli.py`

Bucket:

- `pattern only`

Keep:

- operator-oriented CLI shape for bootstrapping local secrets

Do not keep directly:

- key-file conventions and output paths
- wizard-private storage assumptions as family defaults

Promote toward:

- repo-local tooling only if a current operator workflow requires it

Reason:

- useful as a CLI pattern, not as a migration target

### `wizard/tools/web_proxy.py`

Bucket:

- `pattern only`

Keep:

- URL validation and blocked-host rules
- content-size and timeout guardrails
- fetch-result structuring

Do not keep directly:

- broad fetch-and-convert service as active v2 scope without an owner
- cache-path assumptions from the archived Wizard runtime

Promote toward:

- future `uDOS-wizard` helper work only if Beacon Activate, assist, or another
  current feature explicitly needs bounded remote fetching

Reason:

- some security checks are reusable, but the module is not yet justified as a
  live v2 service

## Adjacent Archived Helpers

These are lower confidence reuse candidates and should stay secondary until a
current v2 feature asks for them:

- `email_process.py`
- `email_receive.py`
- `ingestion_service.py`
- `overview_service.py`
- `wizard/mcp/mcp_server.py`
- most files under `wizard/tools/`

These are more likely to be:

- `rewrite for v2` only after a specific owner asks for them, or
- `archive only` if they mainly preserve old runtime breadth

## Recommended Rewrite Order

1. `uDOS-empire` normalization helper
2. `uDOS-empire` dedupe and validation helper set
3. `uDOS-empire` explicit transform or enrichment pipeline
4. `uDOS-wizard` thin transport helper patterns only when current routes need them

## Practical Rule For v2

Do not ask:

- "Which archived module should we port?"

Ask:

- "Which helper logic is still correct, and which repo owns its rewritten form?"

That keeps v2 modular, shared where useful, and free from accidental v1
runtime restoration.
