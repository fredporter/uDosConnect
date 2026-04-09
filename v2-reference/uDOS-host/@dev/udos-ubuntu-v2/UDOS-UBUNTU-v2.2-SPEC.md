# uDOS-host v2.2

## Network Server + Local WordPress + OK + MCP Specification

## 1. Purpose

uDOS-host is the always-on server node for uDOS.

It provides:

- the local network access point
- the local web server
- the managed OK engine
- the managed MCP control plane
- the canonical vault ingest / normalize / compost pipeline
- the local publish portal and markdown library server

It serves nearby devices over the local network even when those devices cannot
run heavy local tooling.

## 2. Server Doctrine

### 2.1 Ubuntu Is The Node

Ubuntu is the canonical runtime home for:

- networked OK work
- managed MCP
- provider routing
- budgets
- caching
- retries
- deferred execution
- scheduling
- audit

Wizard is the GUI and render layer only. It may present settings, routes,
status, library views, and operator controls, but it does not own network
application, provider routing, runtime scheduling, or managed bridge policy.

If `Wizard` is retained as a family service identity, it should be repurposed
into a delegation broker only. Execution authority remains with Ubuntu and
other destination services.

### 2.2 WordPress Is The Local Publishing Shell

WordPress is not runtime authority.

WordPress is:

- localhost web server shell
- vault content publisher
- local portal and admin UI
- small-user library and browser surface
- permission gate for public and private content
- local API or UI facade where helpful

### 2.3 Markdown Remains Canonical

Vault content stays canonical as `md` and `mdc`.

File workflows remain the system of record. Generated visual assets should stay
portable, inspectable, and markdown-linked rather than hidden inside a CMS.

## 3. Docker + Localhost WordPress

The Ubuntu server should host a Dockerized WordPress stack for local serving.

Recommended stack:

- `wordpress`
- `mariadb`
- optional `nginx` or `caddy` reverse proxy
- optional `redis` cache
- optional `meilisearch` later
- optional SMTP relay later

Primary roles:

- serve published vault content
- provide a local portal and login surface
- expose a small authenticated UI for admin, library, and network views
- optionally expose headless APIs for local device apps

## 4. Vault Publishing Through WordPress

Canonical flow:

`vault md/mdc -> compile/normalize in uDOS-host -> publish package -> WordPress ingest/runtime adapter -> local site/library/page delivery`

### Publish Modes

Each artifact can be routed as:

- `public_local`
- `permission_local`
- `private_local`
- `binder_portal`
- `workspace_preview`

### WordPress Responsibilities

- content routing
- page and view rendering
- portal auth
- menu and library browsing
- search UI
- permissioned access to selected content
- small audience delivery

### WordPress Non-Responsibilities

- canonical sync engine
- provider routing
- MCP scheduling
- queue control
- network rule application
- canonical contacts or task merge logic

## 5. Beacon Rewrite

Beacon is no longer a Wizard-owned network concept.

Beacon becomes an Ubuntu server network mode.

### 5.1 Beacon Definition

A Beacon node is a uDOS-host server that can expose a local Wi-Fi or LAN
access surface and serve:

- its local WordPress portal
- selected markdown library content
- local OK endpoints
- local device-facing APIs
- optional binders and workspace views
- operator status and control pages

### 5.2 Beacon Modes

Recommended node modes:

- `public`
- `crypt`
- `private`
- `tomb`
- `home`

Mode guidance:

- `public`: open or lightly accessible local portal node for `public_local`
  content and optional browse-only views.
- `crypt`: password-protected local Wi-Fi or portal surface for
  `permission_local` content and selected authenticated OK functions.
- `private`: restricted internal server mode for full local library and admin
  surfaces.
- `tomb`: discovery-obscured specialty mode with tightly controlled exposure.
- `home`: trusted household or team mode with full OK, WordPress, and library
  integration.

### 5.3 Beacon Content Surfaces

A beacon node may serve:

- WordPress site shell
- markdown library browser
- binder pages
- local dashboards
- task boards
- research notes
- wiki-style topic pages
- API docs
- local device service forms
- OK submission and results UI

### 5.4 Beacon Security Rule

Network exposure level must not change Core or Ubuntu authority boundaries.

Public or semi-public surfaces may browse content, but:

- MCP policy remains server-owned
- provider keys remain server-side
- budgets remain server-side
- queue execution remains server-side
- content permissions remain policy-bound

## 6. Network Setup And Config Ownership

All network setup and config is Ubuntu-owned.

Ubuntu should own:

- SSID and node mode config
- local DHCP, DNS, and reverse proxy rules where applicable
- captive landing page logic if used
- TLS on local portal if configured
- local service discovery
- auth and session handling for local portal and services
- health and failover policy
- route exposure rules for OK, MCP, WordPress, and library

Wizard may render these settings, but Ubuntu applies them.

## 7. Local OK Serving To Devices

Devices on the local network should be able to delegate OK tasks to Ubuntu.

Examples:

- iPhone sends a document to format
- Android app sends a research topic
- browser submits a URL to ingest
- tablet requests a binder summary
- Mac client asks for HTML to MD cleanup

### 7.1 Local Endpoints

Recommended surfaces:

```text
POST /ok/run
POST /ok/format
POST /ok/research
POST /ok/ingest/link
POST /ok/ingest/topic
POST /ok/ingest/file
GET  /ok/status/{id}
GET  /library
GET  /binders/{id}
```

### 7.2 Device Role

Devices are thin clients:

- capture
- submit
- receive result
- optionally browse status and history

They do not need Python or provider credentials.

## 8. Robust Local Network With Fallback Management

To serve OK reliably to local devices, Ubuntu needs a proper fallback ladder.

### 8.1 Execution Ladder

```text
deterministic TS
-> local/offline helper
-> cache
-> local model
-> OpenRouter free
-> OpenRouter economy
-> premium provider
-> defer
```

This preserves the routing philosophy:

- offline first
- cheapest capable provider
- budget aware
- deterministic escalation
- fail-safe operation

### 8.2 Response Safety

Provider failures must not break runtime behavior. Fallback and defer paths are
part of the Ubuntu-owned runtime contract.

### 8.3 Local Degraded Mode

If remote APIs are unavailable:

- return deterministic formatting if possible
- mark semantic enrichments as skipped
- preserve a usable `md` or `mdc` result
- queue optional enhancements for later

### 8.4 Service Health Checks

Ubuntu should monitor:

- LAN availability
- Wi-Fi node state
- reverse proxy health
- WordPress availability
- DB availability
- OK worker queue health
- MCP registry and bridge health
- provider connectivity
- cache health
- storage pressure

### 8.5 Local Service Discovery

Preferred access patterns:

- `http://udos.local`
- `http://beacon.local`
- direct local IP fallback
- optional QR or bootstrap page for mobile onboarding

## 9. OK Handling On Ubuntu

### 9.1 Request Classes

Keep the existing request class model, now Ubuntu-owned for managed execution:

- `summarize`
- `draft`
- `classify`
- `analysis`
- `research`
- `code`
- `multimodal`
- `transformation`

### 9.2 Provider Registry

Keep the same provider manifest approach, but move ownership from Wizard repo
concepts into Ubuntu server services:

- OpenRouter
- OpenAI
- Anthropic
- Mistral
- Gemini

### 9.3 Routing Rules

Ubuntu should:

- classify request
- assess complexity
- check cache
- choose lowest-cost capable route
- enforce budget
- run fallback
- defer when blocked
- audit every call

### 9.4 Caching

Cache keys should include:

- request hash
- provider
- model
- input parameters

### 9.5 Scheduling

Ubuntu owns schedule classes for managed work:

- `immediate`
- `next_window`
- `nightly`
- `paced`
- `manual_only`
- `approval_required`

## 10. MCP On Ubuntu

### 10.1 Final Split

Core owns:

- local MCP client wrappers
- tool schema readers
- offline-safe capability lookup
- request serialization
- validation and permissions

Ubuntu owns:

- managed MCP bridge and server lifecycle
- registry and manifests
- auth binding
- budget binding
- scheduling
- deferred execution
- fallback and retry
- remote tool audit

### 10.2 Managed MCP Categories

Ubuntu should classify managed tools as:

- `local_managed`
- `remote_managed`
- `provider_backed`
- `system_bridge`
- `content_transform`
- `research_enrich`
- `automation_guarded`

### 10.3 Tool Manifest Requirements

Each managed MCP tool should declare:

- owner
- tool id
- transport class
- network requirement
- auth source
- input and output schemas
- budget group
- approval requirement
- schedule classes
- cache eligibility
- audit requirement
- fallback strategy

## 11. Markdown Library Serving

The Ubuntu server should expose a local markdown library service backed by
canonical `md` and `mdc` artifacts.

Views:

- browse by binder
- browse by tag and topic
- wiki graph and related pages
- search
- recent ingest
- inbox review
- compost review
- public and private split views
- horizontal reading mode
- optional Marp-derived slide view

WordPress may render these views directly or via adapter or plugin endpoints.

## 12. Permission Model

For small and occasional user bases, permissions stay simple.

### Access Tiers

- anonymous local browse
- authenticated local user
- trusted operator
- admin or operator

### Content Tiers

- `public_local`
- `permission_local`
- `private_local`

### Service Tiers

- browse only
- submit OK jobs
- view own results
- use research tools
- admin and network config
- operator and MCP tools

## 13. Suggested Folder Structure

```text
udos-ubuntu/
  network/
    beacon/
    wifi/
    dns/
    proxy/
    auth/
    health/
  publish/
    wordpress/
      docker/
      plugins/
      themes/
      adapters/
  library/
    browse/
    search/
    permissions/
    render/
  ingest/
  normalize/
  media/
  dedupe/
  split/
  wiki/
  compost/
  okd/
    routing/
    providers/
    cache/
    schedules/
    audit/
    workers/
  mcpd/
    registry/
    bridge/
    sessions/
    auth/
    budgets/
    schedules/
    cache/
    audit/
    schemas/
  vault/
    canonical/
    derived/
    indexes/
```

## 14. Acceptance Criteria

This architecture is satisfied when:

- Ubuntu can host Dockerized localhost WordPress
- WordPress can serve vault-derived content locally
- content can be public or permission-based
- beacon is redefined as an Ubuntu network node mode
- Ubuntu owns network setup and config
- local devices can submit OK tasks without local runtimes
- OK routing remains offline-first and fallback-safe
- managed MCP is Ubuntu-owned, not Wizard-owned
- Core retains deterministic local contracts and offline-safe tool boundaries
- the markdown library is locally browsable and permission-aware
- degraded operation still returns useful local results when remote services fail
- any retained `Wizard` role is broker-only and does not reclaim Ubuntu-owned
  runtime authority

## Short-Form Decision

uDOS-host is the always-on local network server for uDOS. It hosts Dockerized
localhost WordPress as the vault publishing shell, serves the markdown library
to nearby devices, owns beacon and network configuration, and provides the
managed OK and MCP execution fabric with offline-first routing, cache,
fallback, and permission-aware local access.
