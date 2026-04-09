# uDOS-docs Activation

## Purpose

This document marks the first active implementation tranche for `uDOS-docs`.

The activation goal is to make the docs repo publishable, teachable, and
repeatably checkable as the family documentation owner without broadening its
ownership beyond:

- family-level architecture and boundary explanations
- onboarding and learning pathways
- public reference maps and walkthroughs
- documentation quality checks for this repo's own surfaces

## Activated Surfaces

- `architecture/`, `wizard/`, `alpine/`, and `uhome/` as the family topic lanes
- `docs/` as the repo entrypoint and governance lane
- `architecture/07_family_learning_path.md` as the family ladder and pathway
  reference
- `scripts/run-docs-checks.sh` as the repo validation entrypoint
- `tests/` as the documentation validation lane
- `examples/basic-docs-update.md` as the smallest author workflow

## Current Validation Contract

Run:

```bash
scripts/run-docs-checks.sh
```

This command:

- verifies the required repo entry surfaces exist
- checks that core documentation roots contain markdown files
- rejects private local-root path leakage in tracked repo docs and scripts

## Boundaries

This activation does not move ownership into `uDOS-docs` for:

- canonical runtime semantics
- implementation behavior that belongs in code repos
- provider and control-plane logic
- private OMD documentation
