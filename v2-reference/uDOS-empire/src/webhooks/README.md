# Webhooks

`src/webhooks/` is now a legacy-transition contract lane inside
`uDOS-empire`.

These files capture older webhook and provider-template work that may still be
useful during migration, especially where a remote intake or callback path
still needs to land in the local WordPress CRM model.

This lane currently contains:

- inbound webhook receiver templates
- outbound API call templates
- older Google or HubSpot-oriented transition scaffolds
- mapping templates for normalizing remote payloads into local reviewable
  records

Boundary rule:

- do not treat this folder as the public default identity of Empire
- only keep webhook or provider artifacts here when they still support the
  WordPress-plugin direction
- move host-owned Git, GitHub, runtime, and scheduling operations to
  `uDOS-host`

Migration rule:

- prefer WordPress-backed intake, notes, and CRM workflows
- retire provider-specific templates that do not support that local-first model
