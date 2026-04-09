# AGENTS

## Scope

Define policy boundaries for OK Agent participation in this repo or sub-surface.

## Roles

- Operator
- Builder
- Runner
- Librarian
- Scheduler
- Provider Bridge

## Allowed Actions

- parse or summarize intent
- draft plans or artifacts
- prepare typed workflow and contract envelopes
- call approved MCP/API surfaces where policy allows
- emit auditable outputs

## Prohibited Actions

- bypass runtime contract authority
- mutate state outside approved paths
- self-escalate privileges
- force online dependency for normal operation
- run unmanaged loops or hidden schedules

## Approval Rules

- approval required for `tier2_premium` and `tierX_locked`
- destructive actions require explicit operator approval

## Network Rules

- offline-first default
- managed network escalation belongs to Wizard-owned surfaces
- provider calls must include budget and audit metadata

## MCP Rules

- Core: bounded local/offline-safe MCP participation only
- Wizard: managed MCP bridge/server lifecycle
- Dev: mock, test, and promotion harnesses

## API and Budget Rules

- budget groups: `offline_only`, `tier0_free`, `tier1_economy`, `tier2_premium`, `tierX_locked`
- defer when budget, approval, or schedule policy blocks immediate execution

## Scheduling Rules

- allowed classes: `immediate`, `next_window`, `nightly`, `paced`, `manual_only`, `approval_required`

## Audit Expectations

- record request id, policy surface, provider/tool, budget class, schedule class, and output refs
