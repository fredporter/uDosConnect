# uDOS v2 MCP Schema

Status: v2.0.4 contract baseline
Contract owner: uDOS-core
Managed runtime owner: uDOS-wizard

## Purpose

Document the canonical MCP contract schema used across Core, Wizard, and Dev.

## Canonical Contract Files

- contracts/mcp-tool-contract.json
- schemas/mcp-tool-contract.schema.json

## Required MCP Tool Fields

The MCP tool contract requires:

- tool_id
- tool_owner
- transport
- tool_class
- network_required
- input_schema
- output_schema
- budget_group
- approval_required
- schedule_classes
- audit_required

## Schedule Classes

Allowed schedule classes for managed MCP use:

- immediate
- next_window
- nightly
- paced
- manual_only
- approval_required

## Ownership Split

- Core: schema ownership and typed contract validation
- Wizard: managed bridge lifecycle, auth binding, routing, and scheduling
- Dev: fixtures, contract tests, and promotion checks

## Event Surface Relationship

The logs, feeds, and spool event surface is a bounded tool family built on this
existing MCP contract.

Those tools should reuse the same contract metadata, policy, and scheduling
rules defined here. They do not define a separate MCP standard.

## Example

```json
{
  "tool_id": "wizard.mcp.render_markdown",
  "tool_owner": "uDOS-wizard",
  "transport": "mcp",
  "tool_class": "content_transform",
  "network_required": true,
  "input_schema": "schemas/render_markdown.input.json",
  "output_schema": "schemas/render_markdown.output.json",
  "budget_group": "tier1_economy",
  "approval_required": false,
  "schedule_classes": ["immediate", "next_window", "paced"],
  "audit_required": true
}
```

## Rule

MCP schema defines interoperability and policy metadata only. It does not grant
execution authority.
