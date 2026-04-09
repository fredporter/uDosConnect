# Docker Compose compatibility (Ubuntu repo)

Status: **reference**  
Owner: **`uDOS-host`** (publish/demo material under `@dev/`)

## Role

Tier-1 **host runtime** remains **`udos-*` daemons**, **`udos-commandd`**, and the
shared lifecycle contract in **`uDOS-dev/docs/shared-runtime-resource-contract.md`**.

**Docker Compose** in this repository is **transitional compatibility only** for
third-party stacks that are not yet on the uDOS-native runtime lane.

## Registered stack (Post-08 O3)

| Path | Purpose | Profile |
| --- | --- | --- |
| `@dev/udos-ubuntu-v2/publish/wordpress/docker/docker-compose.yml` | WordPress + MariaDB publish/demo | `docker-fallback` |

This stack is listed as **`ubuntu-wordpress-publish-stack`** under
**`optional_compat_services`** in
**`uDOS-dev/@dev/fixtures/shared-runtime-service-lifecycle.v1.json`**.

## Rules

- Do **not** treat Compose as a prerequisite for command-centre, wizard bridge, or
  green-proof host checks.
- Prefer **`scripts/run-ubuntu-checks.sh`** and **`verify-udos-runtime-daemons.sh`**
  for validation; they do **not** invoke Docker by default.
- When adding new Compose files, document them here and extend the lifecycle
  matrix in **`uDOS-dev`** (or open a family plan if scope crosses
  **`docs/next-family-plan-gate.md`**).

## Sunset

Remove or replace this stack when a host-native or adapter-backed publish path
covers the same operator story and the matrix entry is deleted or moved to
**`external-compat`** with an explicit migration note.

## Related

- `docs/activation.md`
- `uDOS-dev/docs/shared-runtime-resource-contract.md`
- `uDOS-groovebox/docs/docker-posture.md` (product-side Songscribe compatibility)
