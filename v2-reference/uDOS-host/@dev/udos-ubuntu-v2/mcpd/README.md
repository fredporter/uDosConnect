# MCPD

Managed MCP execution lives on Ubuntu.

## Final Split

Core owns:

- local MCP client wrappers
- schema readers
- offline-safe capability lookup
- serialization
- validation and permissions

Ubuntu owns:

- managed bridge and server lifecycle
- registry and manifests
- auth binding
- budget binding
- schedules
- deferred execution
- fallback and retry
- remote tool audit

## Managed Tool Categories

- `local_managed`
- `remote_managed`
- `provider_backed`
- `system_bridge`
- `content_transform`
- `research_enrich`
- `automation_guarded`

## Manifest Minimum

Each managed tool manifest should declare:

- `owner`
- `tool_id`
- `transport_class`
- `network_requirement`
- `auth_source`
- `input_schema`
- `output_schema`
- `budget_group`
- `approval_requirement`
- `schedule_classes`
- `cache_eligibility`
- `audit_requirement`
- `fallback_strategy`

## Rule

Wizard may render tool state and operator controls, but Ubuntu remains the only
managed MCP runtime authority in this package.
