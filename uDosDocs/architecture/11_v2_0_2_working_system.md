# v2.0.2 Working System

## Purpose

Summarize what `v2.0.2` now means in practical terms for the live repo family.

This is the first working-system pass for v2. It does not describe speculative
future integration. It describes the current shared runtime contract spine and
the rebuilt feature lanes that now run across sibling repos.

## Shared Contract Spine

### `uDOS-core`

Owns the machine-readable runtime-service contract artifact at
`contracts/runtime-services.json`.

This is the shared family source for:

- runtime service names
- service ownership
- service lane semantics
- service route expectations

### `uDOS-shell`

Consumes the Core runtime-service artifact and surfaces those contracts through
operator-facing routing previews.

The shell remains a consumer of the shared runtime spine rather than an
independent contract authority.

### `uDOS-wizard`

Consumes the same Core runtime-service artifact and now exposes the first
working shared orchestration surfaces for:

- dispatch
- workflow planning
- callback reporting
- result retrieval

These Wizard routes are the first cross-product remote workflow bridge in the
rebuilt repo family.

The next boundary refinement is now explicit:

- Wizard owns workflow authority and browser operator GUI surfaces
- `uHOME-server` owns always-on execution and Thin GUI or kiosk surfaces

## Rebuilt Product Lanes

### `uHOME-client`

The client lane now derives:

- a control-session brief from live `uHOME-server` runtime and dashboard state
- a remote-control bridge brief from shared Wizard dispatch and workflow-plan
  contracts

This means the client/server lane has moved beyond static contract framing into
an executable interpretation path with a hardened release gate.

### `uDOS-empire`

The sync lane now derives:

- a sync execution brief from live Wizard orchestration and assist state
- a shared remote workflow interpretation path through Wizard dispatch,
  workflow-plan, callback, and result surfaces

This means the empire/wizard lane has also moved beyond static contract framing
into an executable interpretation path with a hardened release gate.

## Release Meaning

`v2.0.2` now means:

- the v2 contract spine is machine-readable and shared
- the first rebuilt product lanes consume one common orchestration path
- live cross-repo gates validate feature briefs rather than only endpoint reachability

It does not yet mean:

- packaged non-sibling contract distribution is complete
- result persistence is finalized beyond in-memory Wizard state
- the full cross-family sync bridge story is complete

## Next Step

`v2.0.3` builds on this working-system pass by hardening cross-repo contracts
and widening sync and orchestration alignment across more family lanes.
