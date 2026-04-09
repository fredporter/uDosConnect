# Family Maintenance Sweeps

## Purpose

This document defines the recurring family sweeps that keep public repos
consistent, lean, and easy to ingest.

## Sweep Types

### Conformance Sweep

Checks:

- required governance files
- required docs entrypoints
- repo cleanliness
- expected branch and protection posture

Run:

```bash
scripts/run-family-conformance-sweep.sh
```

### Public Structure Sweep

Checks:

- expected top-level roots by repo type
- missing `docs`, `@dev`, or `wiki` lanes
- extra transitional roots that should be retired

Run:

```bash
scripts/run-public-structure-sweep.sh
```

### Reference Consistency Sweep

Checks:

- stale repo names
- retired paths
- rename drift across active public docs

Run:

```bash
scripts/run-reference-consistency-sweep.sh
```

## Output Rule

Sweeps should write reports into local `@dev` report lanes, not expand public
docs with repeated snapshots.

## Current Consolidation Rule

- keep one canonical public doc per concept
- keep one compact public sweep reference rather than one doc per sweep
- move forward-looking cleanup rounds into `@dev`
- compost bulk historical sweep notes once their rules are absorbed here
