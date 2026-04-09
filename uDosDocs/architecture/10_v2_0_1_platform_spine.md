# v2.0.1 Platform Spine

## Purpose

Summarize what `v2.0.1` now means in practical terms for the live repo family.

This is not a future-state wishlist. It describes the starter shared surfaces
that have already been established as the first runnable v2 platform spine.

## Foundation Repos

### `uDOS-core`

Owns the canonical starter contracts for:

- command and runtime framing
- binder workflow shape
- capability resolution
- vault and memory conventions
- release lane semantics

### `uDOS-shell`

Mirrors core ownership through operator-facing routing previews for:

- shell route hints
- owner hints
- lane hints
- adapter hints

### `uDOS-wizard`

Owns the starter orchestration layer for:

- provider routing
- offline fallback routing
- starter orchestration status

### `uDOS-plugin-index`

Owns the starter discovery metadata for:

- plugin trust classes
- compatibility metadata
- certification placeholders
- wrapped source metadata

### `uDOS-themes`

Owns the starter shared presentation bridge for:

- core theme tokens
- shell mappings
- publishing and email-safe mappings

## What `v2.0.1` Does Not Mean

- it is not a complete working product family
- it is not the final runtime contract set
- it does not make archived v1 code authoritative again
- it does not collapse product ownership into the docs repo

## Next Step

`v2.0.2` builds on this spine by turning the starter contracts into working
shared runtime services and product-facing rebuild work.
