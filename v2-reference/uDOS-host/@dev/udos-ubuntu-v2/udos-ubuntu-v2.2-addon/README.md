# uDOS-host v2.2 add-on scaffold

This add-on package is designed to be merged into the prior `uDOS-host-v2.2` scaffold.

Included:

- full TypeScript ingest + formatter scaffold
- OK routing engine implementation scaffold
- OpenRouter provider + fallback logic
- Beacon network config scripts for `hostapd` and `dnsmasq`
- a natural execution target for a future `Wizard` broker handoff

## Merge targets

- `okd/`
- `network/beacon/`
- `packages/udos-doc-format/`

## Notes

- This is a scaffold, not a production-complete service.
- Deterministic formatting is the first lane.
- Provider-backed OK work is only used when deterministic transforms are insufficient.
- Secrets should be supplied through environment variables or external secret stores.
- If `Wizard` is retained, it should delegate into this scaffold rather than
  reclaiming runtime authority from Ubuntu.
