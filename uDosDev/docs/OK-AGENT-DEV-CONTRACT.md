# uDOS v2 OK Agent Dev Contract

Status: v2.0.4 contributor lane contract
Owner: uDOS-dev

## Purpose

Define Dev-owned contributor workflows for OK Agent development, fixtures,
policy checks, and promotion readiness.

## Ownership

Dev owns:

- contributor templates for OK policy and manifests
- fixture validation and promotion checklist workflows
- simulation and regression support for policy and routing behavior
- binder-driven promotion packaging for Core and Wizard changes

Dev does not own:

- release runtime authority
- managed provider routing ownership
- managed MCP bridge lifecycle ownership

## Canonical Scaffolds

Path: @dev/pathways/templates/

- ok-agent-policy-template.md
- ok-provider-manifest-template.json
- mcp-tool-manifest-template.json
- deferred-packet-template.json
- budget-policy-template.json
- ok-promotion-checklist.md

## Validation Helper

- scripts/run-ok-agent-fixture-check.sh

## Rule

Dev workflows can accelerate experimentation, but promotion to release lanes
must preserve Core and Wizard ownership boundaries.

## Related Docs

- v2.0.4-ok-agent-dev-lane.md
