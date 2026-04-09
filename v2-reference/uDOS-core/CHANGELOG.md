# Changelog

All notable changes to `uDOS-core` should be documented in this file.

## Unreleased

- added **binder spine payload v1** JSON Schema (`schemas/binder-spine-payload.v1.schema.json`), `udos_core.binder_spine` validation helpers, contract tests, and `docs/binder-spine-payload.md` (v2.6 Round A)
- established v2 activation and repo-level validation workflow
- added family contract-enforcement guidance and validation entrypoints
- added the starter `#runtime services` manifest for `v2.0.2` Round A kickoff
- added `contracts/runtime-services.json` as the machine-readable runtime-service artifact
- added the shared `v2.0.4` sync record contract for contacts, activities, binders/projects, and sync metadata
- added the `v2.0.4` OK Agent contract layer (`ok-agent-capability`, `mcp-tool`, `deferred-packet`, `budget-policy`) for Core-owned schema stability with Wizard-managed execution ownership
- added a `v2.0.5` shared ingest and workflow kernel direction for parallel public/private development
