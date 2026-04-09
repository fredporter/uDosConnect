# uDosDocs

## Purpose

Canonical public documentation for the uDos and uHOME families.

## Ownership

- family-level architecture docs
- onboarding and learning paths
- public reference and explanatory material

## Non-Goals

- canonical runtime code ownership
- provider bridge implementation
- closed product–specific documentation that belongs in a private repo

## Spine

- `docs/`
- `architecture/`
- `wizard/`
- `alpine/`
- `uhome/`
- `tests/`
- `scripts/`
- `config/`
- `examples/`
- `seed/` — public read-mostly starter trees (Typo welcome copy, example binders,
  vault scaffolds); see `seed/README.md`
- `docs/knowledge/` — General Knowledge Library articles (survival-guide,
  depth/research/exemplars); see `docs/general-knowledge-library.md`

## Local Development

Prefer plain-language, source-first documentation that teaches the system.

Useful entry docs:

- `docs/README.md`
- `docs/onboarding.md`
- `docs/getting-started.md`
- `docs/general-knowledge-library.md`
- `docs/binders-and-publishing.md`
- `docs/vision.md`
- `docs/modes-and-boundaries.md`
- `docs/v2/classic-modern-mvp-0.1/README.md` — Classic Modern + ThinUI + Sonic TUI charter (three-layer UX alignment)
- `architecture/10_v2_0_1_platform_spine.md`
- `architecture/07_family_learning_path.md`

## Family Relation

This repo explains the family but should not become the owner of implementation details that belong elsewhere.

## Activation

The repo activation path is documented in `docs/activation.md`.

Run the current repo validation entrypoint with:

```bash
scripts/run-docs-checks.sh
```
