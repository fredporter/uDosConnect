# uHOME v2 Setup

## Purpose

This guide defines the current v2 setup spine for the active `uHOME` family.

`uHOME` can run:

- as a standalone environment
- alongside `uDOS` when shared family services are present

Both modes share the same `@dev` family workflow, and both can be bootstrapped
or configured through `sonic-screwdriver`.

## Active Repos

- `uHOME-server`
- `uHOME-client`
- `uDOS-empire`
- `uHOME-matter`
- `uHOME-app-android`
- `uHOME-app-ios`

## Setup Order

1. `uHOME-server`
   Run `scripts/run-uhome-server-checks.sh` and confirm the always-on runtime is
   healthy.
2. `uHOME-client`
   Run `scripts/run-uhome-client-checks.sh` and confirm the shared client
   runtime profiles are valid.
3. `uHOME-matter`
   Run `scripts/run-uhome-matter-checks.sh` if local Matter or Home Assistant
   integration is part of the target setup.
4. `uHOME-app-android`
   Run `scripts/run-uhome-app-android-checks.sh` and keep Android UI work
   aligned to the shared runtime contracts.
5. `uHOME-app-ios`
   Run `scripts/run-uhome-app-ios-checks.sh` and keep iOS UI work aligned to
   the shared runtime contracts.
6. `uDOS-empire`
   Run `scripts/run-empire-checks.sh` if optional sync and workflow extensions
   are part of the target setup.

## Boundary Summary

- `uHOME-server` owns the always-on runtime
- `uHOME-client` owns shared lightweight client-runtime contracts
- `uHOME-matter` extends the platform with local automation and Matter or Home
  Assistant bridges while `uHOME-server` keeps runtime execution
- `uHOME-app-android` and `uHOME-app-ios` own platform UI and kiosk
  presentation
- `uDOS-empire` extends the platform with optional sync, CRM, webhook, and
  container-style workflow lanes
- `sonic-screwdriver` remains the common bootstrap and setup lane

## Validation Checklist

Run the family setup checks from each repo root:

```bash
uHOME-server/scripts/run-uhome-server-checks.sh
uHOME-client/scripts/run-uhome-client-checks.sh
uDOS-empire/scripts/run-empire-checks.sh
uHOME-matter/scripts/run-uhome-matter-checks.sh
uHOME-app-android/scripts/run-uhome-app-android-checks.sh
uHOME-app-ios/scripts/run-uhome-app-ios-checks.sh
```
