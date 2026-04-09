# uDOS-grid Security And Gameplay Link

## Purpose

Define the boundary between canonical spatial truth in `uDOS-grid` and
interactive interpretation in `uDOS-gameplay`.

## Ownership Boundary

`uDOS-grid` owns:

- canonical place identity
- place-gated artifact lookup
- deterministic spatial condition evaluation
- permission and gate rule evaluation inputs

`uDOS-gameplay` owns:

- visual interpretation
- traversal presentation and feedback loops
- optional interaction UX for gated actions

Gameplay may present place differently, but it must not replace canonical
Grid persistence truth.

## Permission Classes

Spatially gated actions should map to explicit permission classes.

- public_read: no gate beyond canonical place validity
- proximity_read: actor must satisfy place and proximity policy
- handshake_unlock: actor must satisfy proximity and handshake requirements
- owner_mutation: only owner or policy-approved role may mutate place-bound state
- operator_override: explicit operator lane, auditable and revocable

## Validation Pipeline

Every gated action should evaluate in the same order:

1. resolve place reference against Grid canonical records
2. verify actor role against required role set
3. verify proximity and optional handshake constraints
4. verify artifact gate policy and required flags
5. emit decision and audit payload

Only after this pipeline passes may downstream systems execute the requested
action.

## Security Direction

Spatially gated actions should validate against Grid-owned truth first.

Examples:

- proximity checks
- place-bound binder discovery
- crypt or vault unlock conditions
- beacon or portal gating

Grid validates canonical place and gate policy truth.
Wizard, Gameplay, or app surfaces may handle UX, networking, or transport.

## Audit Expectations

Every gated decision should emit at least:

- request_id
- place_ref
- actor_id or role
- permission_class
- validation_result
- gate_reason or deny_reason
- written_outputs

This keeps gameplay-visible outcomes traceable back to Grid-owned validation.

## Failure Handling

If validation fails:

- reject the gated action
- return explicit deny reason
- avoid partial state mutation
- keep retry and escalation behavior in Wizard or app layers

## Anti-Patterns

Avoid the following:

- gameplay system writing canonical place identity
- unlock behavior that bypasses Grid validation
- hidden state changes not tied to auditable gate decisions
- transport layer becoming policy owner

## Rule

Gameplay may reinterpret place visually, but must not redefine persistence
truth owned by Grid.
