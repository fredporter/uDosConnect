# uDOS v2 Deferred Queue Contract

Status: v2.0.4 contract baseline
Contract owner: uDOS-core
Queue owner: uDOS-wizard

## Purpose

Define the canonical deferred packet shape used when work cannot execute
immediately due to budget, approval, schedule, or policy constraints.

## Canonical Contract Files

- contracts/deferred-packet-contract.json
- schemas/deferred-packet-contract.schema.json

## Required Fields

- deferred_id
- created_by
- handoff_to
- action_class
- reason
- budget_group
- requested_schedule
- approval_state
- audit_required

## Approval States

- not-required
- pending
- approved
- rejected

## Deferred Triggers

Common reasons include:

- budget exceeded
- approval required and not granted
- schedule mismatch
- provider unavailable
- policy block

## Example

```json
{
  "deferred_id": "def-v2-0001",
  "created_by": "uDOS-core",
  "handoff_to": "uDOS-wizard",
  "action_class": "mcp.call",
  "reason": "approval_required",
  "budget_group": "tier2_premium",
  "requested_schedule": "next_window",
  "approval_state": "pending",
  "audit_required": true
}
```

## Rule

A deferred packet represents a managed handoff request, not hidden execution.
Wizard executes only after policy checks pass.
