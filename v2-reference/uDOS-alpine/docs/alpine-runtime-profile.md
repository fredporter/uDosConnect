# Alpine Runtime Profile

`uDOS-alpine` is the lightweight runtime companion to `uDOS-host`.

It should be treated as:

- uDOS-host light
- Alpine Linux instead of Ubuntu
- core + TUI + ThinUI only
- network-compatible with the full Ubuntu command centre

## Product Position

`uDOS-alpine` is not just a packaging lane.

It is the minimal operational runtime profile for:

- lower-resource devices
- appliance-like deployments
- portable or diskless boots
- kiosk or service-panel usage
- fallback nodes that still need to participate in the uDOS runtime network

## Capability Boundary

`uDOS-alpine` must stop at ThinUI capability.

That means it should include:

- `uDOS-core` contracts and local runtime consumption
- `uDOS-shell` TUI and command surfaces
- `uDOS-thinui` fullscreen and service-panel GUI surfaces
- `uDOS-themes` support where needed for ThinUI output
- local service startup and runtime hooks via Alpine/OpenRC

That means it should not become:

- the full browser command centre
- the full Ubuntu-hosted runtime replacement
- the primary host for broad browser workflow/publishing surfaces
- the owner of rich browser workspace features beyond ThinUI scope

## Network Role

`uDOS-alpine` must still work with the rest of the family.

When a main `uDOS-host` server is present on the network, Alpine should be
able to:

- discover or target the Ubuntu runtime host
- authenticate or pair through family runtime contracts
- read from and sync with the master local vault where permitted
- submit jobs, updates, or sync payloads to the Ubuntu command centre
- consume Beacon/Portal/network services exposed by the Ubuntu host

When no Ubuntu server is present, Alpine should still support:

- local shell commands
- local ThinUI service surfaces
- local cached/offline operation within its profile limits
- deferred sync or publish queues for later reconciliation

## Ownership Split

`uDOS-alpine` owns:

- Alpine runtime profile assembly
- OpenRC service wiring
- lightweight boot and launch flows
- ThinUI-first local interaction posture
- package and image outputs for the Alpine runtime profile

`uDOS-alpine` does not own:

- canonical runtime semantics
- provider bridges
- the full browser command centre
- the master network vault
- primary scheduling authority for the full family runtime

## Family Relation

`uDOS-host` remains the primary always-on command centre.

`uDOS-alpine` is the lightweight companion node/profile that can:

- operate locally in reduced mode
- join the wider runtime network
- hand off to the Ubuntu host when the full command centre is available

## Planning Rule

Future Alpine work should stay inside this boundary:

- if a feature requires a full browser command centre, it belongs to
  `uDOS-host`
- if a feature can be expressed as TUI or ThinUI plus network compatibility, it
  may belong in `uDOS-alpine`
