# uHOME v2 Architecture Alignment

**Operational sequencing and repo roles** for day-to-day work: [`uhome-stream.md`](uhome-stream.md).

## Purpose

Translate the `uHOME v2 Master Architecture Specification` brief into an
adopted `uDOS-dev` planning position that matches the current repo family on
2026-03-15.

## Current Reality

The active `uHOME` repos in the workspace today are:

- `uHOME-server`
- `uHOME-client`
- `uDOS-empire`
- `uHOME-matter`
- `uHOME-app-android`
- `uHOME-app-ios`

These six repos are the current `uHOME` family. There is no separate active
macOS app repo in the workspace, so family docs should not present one as a
current or planned public-family fact.

## Adopted Position

The brief is directionally accepted with one staging adjustment:

- keep `uDOS-host` as the primary always-on command-centre runtime owner
- keep `uHOME-server` as the `uHOME` household-service and local-console stream
- keep `uDOS-empire` as the optional remote sync, webhook, and container-style
  workflow extension owner
- keep `uHOME-client` as the lightweight client-runtime and contract surface
- keep `uHOME-matter` as the active local automation and Home Assistant
  extension lane
- treat `uHOME-app-android` and `uHOME-app-ios` as the active platform app
  repos for client, kiosk, and portal presentation aligned to that runtime lane

## Boundary Implications

### `uHOME-server`

`uHOME-server` remains the household infrastructure node for:

- household runtime services
- service routing
- scheduling
- media and game-service host duties
- local `uHOME` vault and library surfaces where needed
- LAN-first streaming or thin-GUI delivery

It should not be reframed as the primary family runtime or as a
cloud-orchestration owner.

### `uHOME-client`

`uHOME-client` remains the live shared runtime surface for:

- local-network interaction flows
- runtime endpoint mapping
- session shaping and adapter logic
- shared client-side contract consumption

It does not own the Android or iOS UI layer. Those platform surfaces now live
in `uHOME-app-android` and `uHOME-app-ios`, including the client, kiosk, and
portal app shells that consume the shared runtime contracts.

### `uDOS-empire`

`uDOS-empire` continues to own optional remote sync, publishing, webhook, and
container-style workflow surfaces. The master spec's statement that cloud
integration is optional through Empire matches the current family boundary and
is adopted as-is.

### `uHOME-matter`

`uHOME-matter` is now the active local automation extension lane for:

- Matter bridge contracts
- Home Assistant integration mapping
- local automation extension examples

It extends `uHOME-server` without replacing the base runtime owner, which keeps
runtime execution, scheduling, and service supervision.

## Recommended Sequence

1. document `uHOME-client` as the umbrella for shared client-runtime contracts
2. document `uHOME-matter` as the active automation extension lane and keep
   `uHOME` runtime execution in `uHOME-server`
3. prepare `uDOS-empire` for the next v2 pass as the remote webhook and
   zapier-like container/job lane
4. keep roadmap and family docs honest about which app repos exist today
5. treat Android and iOS as the active kiosk and portal app lanes rather than
   waiting on a non-existent macOS split

## Result

`uHOME v2` is now tracked in `uDOS-dev` as a staged architecture evolution:
the platform direction is accepted, while the repo family remains grounded in
the current active server, client, extension, and app surfaces.
