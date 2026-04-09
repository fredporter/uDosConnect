# Versioning Policy

## Public Tagged Repos

Use `vMAJOR.MINOR.PATCH` tags on `main`.

Apply:

- `MAJOR` for intentional public contract or behavior breaks
- `MINOR` for additive public capability
- `PATCH` for compatible fixes, doc corrections tied to release, or release-note
  adjustments

## Notes-Only Repos

For `uDOS-docs` and `uDOS-dev`, milestone tags are optional.
Do not force a release tag for every merged change.

## Cross-Repo Rule

When a change spans multiple public repos:

1. release the contract owner first
2. release direct consumers second
3. release packaging or profile surfaces after contract consumers when needed

## Family Plan And Repo Version Rule

The family still coordinates one active plan at a time through the roadmap and
`@dev` status surfaces, but repos no longer share a forced release number.

From the `v2.3` family plan onward:

- each active public repo carries its own semantic version
- the baseline for all active public repos is `2.3.0`
- patch bumps are the default local increment
- minor and major bumps require explicit family-plan approval

Rule:

- read the active family plan from `@dev/notes/roadmap/v2-roadmap-status.md`
- read each repo's release baseline from its local `VERSION` file
- use `vMAJOR.MINOR.PATCH` for public tags
- do not use fractional build notation as the canonical repo version from this
  point onward

Examples:

- family plan: `v2.3`
- repo version: `2.3.0`
- default next repo release: `2.3.1`
- explicit family-approved minor: `2.4.0`

## Changelog Rule

If a repo expects frequent tagged releases, add and maintain `CHANGELOG.md`.
If it does not, the reusable release workflow may fall back to a generated
summary.

Current bootstrap note:

- clean tagged and optional repos should prefer `CHANGELOG.md` as the
  release-notes source once discipline is in place
