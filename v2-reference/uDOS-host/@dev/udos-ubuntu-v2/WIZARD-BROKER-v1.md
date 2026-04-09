# Wizard Broker v1

## Purpose

`Wizard` is repurposed as a family delegation broker.

It is no longer the browser GUI identity and it is no longer a managed runtime
authority.

Its job is:

- accept a request
- determine what capability is needed
- find which family service can handle it
- dispatch when allowed
- return help when no valid handler exists

## Core Rule

`request -> Wizard broker -> resolve handler -> handoff or help`

Wizard is a broker, not an executor.

## Ownership

Wizard broker owns:

- request classification
- capability lookup
- family service discovery
- delegation planning
- handoff envelope generation
- broker-side status tracking
- help and fallback guidance when no handler is valid

Wizard broker does not own:

- provider routing
- budget enforcement
- retry or fallback execution
- scheduling
- network config
- beacon runtime ownership
- managed MCP lifecycle ownership
- secret-backed execution
- canonical vault or library authority

Those remain with Ubuntu, Core, Surface, or other destination services.

## Service Split

### Ubuntu Owns

- always-on runtime execution
- local OK execution
- managed MCP execution
- provider routing
- budgets
- cache
- retries
- scheduling
- audit
- network and beacon config

### Surface Owns

- browser GUI
- preview and publishing presentation
- library and portal rendering
- thin-client task submission views

### Core Owns

- schemas
- validation
- permissions
- offline-safe tool boundaries
- deterministic local contracts

### Wizard Owns

- delegation brokering only

## Broker Decision Flow

1. accept request
2. parse intent
3. map intent to capability
4. query service registry
5. resolve best handler
6. either dispatch or return guidance
7. track and return broker result

## Dispatch Outcomes

Wizard may return:

- `delegated`
- `multiple_candidates`
- `blocked_by_policy`
- `unsupported`
- `help`

## Example Requests

- "format this doc"
  - Wizard resolves Ubuntu OK formatting as the handler

- "show binder X in the browser"
  - Wizard resolves Surface or Ubuntu library delivery

- "which service owns managed MCP for this tool?"
  - Wizard resolves Ubuntu

- "do this offline only"
  - Wizard filters handlers by offline-safe or local capability

- "nothing can handle this right now"
  - Wizard returns help, requirements, or a next step

## Delegation Envelope

Suggested broker handoff shape:

```json
{
  "request_id": "req_001",
  "broker": "wizard",
  "intent": "format_doc",
  "capability": "ok.transformation",
  "destination_service": "uDOS-host",
  "destination_surface": "okd",
  "dispatch_mode": "direct",
  "constraints": {
    "offline_only": false,
    "approval_required": false
  },
  "payload_ref": "client://capture/123",
  "status_callback": "/wizard/delegations/req_001",
  "created_at": "2026-03-29T00:00:00Z"
}
```

## Broker Registry

Wizard should read from a family service registry that records:

- service id
- owner
- capability ids
- transport class
- offline availability
- auth requirements
- policy notes
- preferred dispatch mode
- health or readiness signal

## MCP Passing Rule

Wizard may pass or relay MCP requests only as a broker.

It may:

- identify which service owns a tool
- package the request for the destination
- return the destination or relay status

It may not:

- become the managed MCP lifecycle owner
- execute remote MCP policy itself
- take over Ubuntu-managed scheduling or budget logic

## Acceptance Criteria

This broker model is satisfied when:

- Wizard can resolve a request to a family service
- Wizard can return a delegation envelope without owning execution
- Wizard can return a useful help response when no service fits
- Ubuntu remains the runtime authority for OK and managed MCP
- Surface remains the browser GUI identity
- Core remains the deterministic local contract authority

## Naming Consequence

This keeps both names relevant:

- `Surface` remains the browser-facing product
- `Wizard` remains the family delegation broker

That removes the name collision between browser GUI and runtime authority.
