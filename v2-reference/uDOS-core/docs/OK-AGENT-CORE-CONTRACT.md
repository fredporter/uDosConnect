# uDOS v2 OK Agent Core Contract

Status: v2.0.4 contract baseline
Owner: uDOS-core

## Purpose

Define the Core-owned runtime contract for OK Agent participation while keeping
command and workflow execution deterministic and policy-bound.

## Ownership

Core owns:

- contract and schema shape for OK Agent capability metadata
- deterministic validation and execution gating
- local policy interpretation and evidence expectations
- deferred packet shape for policy-blocked handoff to Wizard

Core does not own:

- managed network provider routing
- managed MCP bridge lifecycle
- live budget and scheduling operations

## Canonical Artifacts

- contracts/ok-agent-capability-contract.json
- schemas/ok-agent-capability-contract.schema.json
- contracts/mcp-tool-contract.json
- schemas/mcp-tool-contract.schema.json
- contracts/deferred-packet-contract.json
- schemas/deferred-packet-contract.schema.json
- contracts/budget-policy-contract.json
- schemas/budget-policy-contract.schema.json

## Required Capability Fields

The OK Agent capability contract requires:

- agent_id
- role
- capabilities
- autonomy_class
- budget_group
- network_required
- audit_required

## Contract Rule

Models, providers, and MCP transports are capability participants. They do not
replace deterministic runtime authority in Core.

## Related Docs

- v2.0.4-ok-agent-core-contracts.md
- MCP-SCHEMA.md
- DEFERRED-QUEUE-CONTRACT.md
- AUTONOMY-CLASSES.md
