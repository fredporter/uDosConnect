# Containers

`src/containers/` is a transition-era catalog for older Empire job
definitions.

Current contents are legacy scaffolds from the earlier remote-ops framing:

- `container-job-catalog.json` as the top-level registry
- `google-workspace-sync-container.json` for Google mirror jobs
- `hubspot-sync-container.json` for HubSpot sync jobs
- `binder-release-webhook-container.json` for binder-triggered webhook jobs

Boundary rule:

- do not expand this folder as the primary public direction of Empire
- keep only transition definitions that still help migrate toward the
  WordPress-plugin role
- keep local ingest, runtime hosting, and Git or GitHub host execution in
  `uDOS-host`
