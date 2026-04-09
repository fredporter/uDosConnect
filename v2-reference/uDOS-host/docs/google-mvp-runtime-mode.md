# Ubuntu Google MVP Runtime Mode

## Purpose

Define the operator-facing runtime behavior for Ubuntu's first Google MVP host
profile:

- `always-on local mirror/cache host`

This document explains what remains local, what can degrade safely, and how the
Google-backed lane should appear from the Ubuntu side.

## Default Runtime Posture

Ubuntu should behave as:

- the always-on local workstation and host
- the local cache owner
- the local artifact staging owner
- the degraded-mode recovery lane

Ubuntu is not:

- the provider-entry point
- the remote-service supervisor
- the canonical cloud truth owner

## What Stays Local

Even when the Google MVP lane is enabled, Ubuntu should keep these local:

- workstation shell and operator entry
- cache of mirrored or extracted artifacts
- runtime recovery and replay
- handoff back into repo-owned files and contracts

## Degraded Mode

If Empire's Google-backed lane or a related shared-room service is unavailable,
Ubuntu should:

- continue serving the local workstation
- continue from last-known local cache when possible
- queue or defer mirror-sync work
- show degraded mode rather than hard failure

## Operator Expectations

Degraded mode should be read as:

- local work is still available
- optional Google-backed collaboration or mirror sync is temporarily reduced
- canonical truth has not moved away from local family-owned artifacts

## Family Alignment

- Wizard still owns provider routing and prompt/extraction entry
- Empire still owns Firestore mirror and Cloud Run binder supervision
- Gameplay still owns exported world-state semantics
- Core still owns canonical semantics
