# uDOS v2 Public Repo Requirements

## Required Spine

Every public repo must include:

- `README.md`
- `docs/`
- `tests/`
- `.github/`
- `.github/CODEOWNERS`
- `.github/ISSUE_TEMPLATE/`
- `.github/pull_request_template.md`

Public repos should also expose one of:

- `src/`
- contract-first roots such as `contracts/`, `schemas/`, `runtime/`
- packaging/profile roots when the repo is a deployment owner

## Required Docs

Every public repo must provide:

- `docs/architecture.md`
- `docs/boundary.md`
- `docs/getting-started.md`

Use `docs/examples.md` when examples materially help onboarding or operation.

## Required Git Model

Public repos must support:

- `main` as release-ready
- `develop` as integration
- promotion PRs from `develop` to `main`
- release tags from `main`

## Required Governance Files

Public repos must include:

- `CODEOWNERS`
- binder-backed issue template
- cross-repo boundary issue template
- release-promotion PR template
- shared validation and family-policy workflows

## Hygiene Rules

- no machine-specific root paths in docs or scripts
- managed environments stay under `~/.udos/`
- no repo-local runtime sprawl by default
- no hidden caches or vendored runtimes committed into public repos
