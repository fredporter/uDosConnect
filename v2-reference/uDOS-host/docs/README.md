# Ubuntu Docs

`/docs` is the stable reference lane for `uDOS-host`.

Use it for:

- runtime-host architecture and ownership
- setup and activation
- system layout and service scaffolds
- repo-store and Git or GitHub host contracts
- examples and operator-facing how-tos

Use `/wiki` for beginner-friendly learning material and quick practical guides.

## Start Here

- `getting-started.md`
- `architecture.md`
- `boundary.md`
- `activation.md`
- `git-repo-store.md`
- `examples.md`

## Reference Docs

- `config-layout.md`
- `git-repo-store.md`
- `local-service-scaffold.md`
- `systemd-unit-plan.md`
- `first-run-story.md`
- `google-mvp-runtime-mode.md`

## Family library and publishing (sibling checkout)

When this repo sits next to `uDOS-docs` in a family folder, runtime **docs**
here stay canonical for Ubuntu; the **library site** (hubs, manifest, featured
links) is authored in **`uDOS-docs`**:

- [`uDOS-docs/docs/publishing-architecture.md`](../../uDOS-docs/docs/publishing-architecture.md)
- [`uDOS-docs/docs/local-vs-github-docs-boundary.md`](../../uDOS-docs/docs/local-vs-github-docs-boundary.md)
- [`uDOS-docs/docs/course-hooks-and-onboarding.md`](../../uDOS-docs/docs/course-hooks-and-onboarding.md)
- [`uDOS-dev/docs/family-documentation-layout.md`](../../uDOS-dev/docs/family-documentation-layout.md) — `docs/` vs `@dev/` vs `wiki/` across the family

Wiki units under `wiki/` are listed from `uDOS-docs` `site/data/family-source.json` when promoted to the learning hub.

## Rule

Keep stable reference here. Move planning to `@dev/`, and keep historical
scratch material local-only.
