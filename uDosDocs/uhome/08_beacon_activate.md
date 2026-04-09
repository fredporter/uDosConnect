# Beacon Activate

`Beacon Activate` is the family term for a Wizard-offered local Wi-Fi portal
that introduces nearby users to curated offline content prepared by a Beacon
host user.

## Core Idea

- Wizard offers the local Wi-Fi connection and access ritual
- `uDOS-host` serves the nearby offline-content and vault-reader surfaces
- the host user decides what information library is compiled and presented
- future beacon-to-beacon connectivity may exist later, but is not required for
  the baseline v2 model

## Shared Module Rule

Beacon Activate does not imply a separate toolchain.

Shared modules can serve multiple contracts. For example, an `md -> html` IO
render module may support both:

- Wizard web publishing
- Beacon Activate local library presentation

The function may be retained while the delivery method changes.

## Boundary

Beacon Activate is not:

- the canonical vault
- a cloud sync product
- the `uDOS-empire` webhook or API lane
- Home Assistant or Matter automation

## Family Ownership

- Wizard = Beacon offering, networking-side handoff, tunnel policy
- `uDOS-host` = local content, TV/tablet-safe reading surfaces
- `uDOS-empire` = remote APIs, webhooks, and online sync
- macOS app = Apple-native sync plus consumption of shared render outputs where
  needed
