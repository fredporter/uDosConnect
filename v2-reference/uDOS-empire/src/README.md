# Source

`src/` is the source and contract lane for the Empire WordPress-plugin refactor.

Current source surfaces include:

- `legacy/` for compatibility inventory covering older sync, webhook, and
  container assets still required during migration
- `udos_empire/` for active Empire-owned pack/runtime helpers
- `udos_empire_compat/` for compatibility-only sync, webhook, and automation
  runtime helpers retained during transition
- `wordpress-plugin/` for the first plugin-owned source and contract lane
- WordPress-facing record, workflow, and plugin-owned contract material
- legacy sync and webhook artifacts that still need either migration or removal
- `../examples/` starter envelopes and payloads that can be repointed toward
  WordPress contact and activity flows during the refactor

Boundary rule:

- keep Empire-owned WordPress plugin logic and local CRM processing here
- keep active helper code under `udos_empire/`
- keep only migration or retirement shims under `udos_empire_compat/`
- move host-owned Git, GitHub, scheduling, and runtime operations to
  `uDOS-host`
- treat older Google or HubSpot-specific material as legacy unless it directly
  supports the new WordPress-centred direction
