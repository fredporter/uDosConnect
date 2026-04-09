# Core Family Boundary

This document explains how `uDOS-core` relates to the rest of the public family.

## Governance Rule

One major responsibility should have one clear public owner.

Core owns semantic hierarchy and deterministic contracts.
`uDOS-dev` owns workflow and governance operations.

## Allowed Dependency Direction

- `uDOS-core` is the semantic root
- public runtime consumers may depend on `uDOS-core`
- packaging and deployment repos may depend on released public contracts
- `uDOS-docs` may explain every public repo without owning implementation

## Forbidden Coupling

- `uDOS-core` must not depend on `uDOS-shell`, `uDOS-wizard`, `uHOME-*`, packaging repos, or OMD repos
- no public repo may depend on OMD repos
- packaging repos do not become owners of runtime semantics
- `uDOS-dev` does not become a runtime or provider implementation repo
- `uDOS-docs` does not become the owner of code behavior

## Short Owner Map

- `uDOS-core`: canonical runtime semantics
- `uDOS-shell`: interactive shell and UX surfaces
- `uDOS-wizard`: broker or compatibility consumer surfaces
- `uDOS-host`: always-on command-centre runtime host
- `uHOME-server`: downstream uHOME services behind the family runtime spine
- `uDOS-gameplay`: interpretation, progression, lens, and skin-aware presentation overlays
- `sonic-screwdriver`: bootstrap, install, recovery, update, managed environments
- `uDOS-alpine`: Alpine runtime profile with Core, TUI, and ThinUI only
- `uDOS-plugin-index`: plugin and package metadata
- `uDOS-dev`: workflow, binders, contributor process, automation

## Promotion Rule

Cross-repo changes land in dependency order:

1. owner repo
2. direct consumers
3. packaging and deployment repos
4. family docs and release surfaces
