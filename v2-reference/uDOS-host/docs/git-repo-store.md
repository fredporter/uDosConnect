# uDOS-host Git Repo Store

This document defines the first-pass host contract for family repository
storage and Git or GitHub execution on `uDOS-host`.

## Purpose

`uDOS-host` is the coordinated central local repo store for the family.

That means Ubuntu owns:

- canonical local checkouts or mirrors for active family repos
- host-side Git execution for status, fetch, branch, pull, and push
- GitHub CLI and MCP access as host-managed adapter tools
- scheduled repo refresh or reconcile jobs
- policy and credential gates for outbound GitHub actions

## Local Store Rule

The repo store should use one bounded local root, for example:

`~/.udos/repos/<repo-name>`

The exact path can still be finalized, but the rule is stable:

- one host-owned root
- one canonical working checkout per active repo unless a separate mirror is
  explicitly required
- no hidden duplication of ownership across Empire, Wizard, or ad hoc folders

The current scaffold now assumes:

- repo root: `~/.udos/repos`
- registry file: `~/.udos/state/gitd/repo-registry.tsv`
- starter config example: `config/runtime/git-repos.yaml.example`

## Action Surface

Ubuntu should expose repo actions through host-owned operations such as:

- `repo.status`
- `repo.fetch`
- `repo.branch`
- `repo.pull`
- `repo.push`
- `repo.clone_or_attach`
- `github.pr.create`
- `github.pr.comment`
- `github.issue.read`

`gh` and GitHub MCP are adapter tools behind this surface. They are not the
family semantic boundary by themselves.

The first runnable local shell surface is:

- `bash scripts/udos-gitd.sh init-layout`
- `bash scripts/udos-gitd.sh repo-list`
- `bash scripts/udos-gitd.sh repo-attach <repo-id> <path>`
- `bash scripts/udos-gitd.sh repo-status <repo-id>`
- `bash scripts/udos-gitd.sh repo-fetch <repo-id>`
- `bash scripts/udos-gitd.sh repo-branch <repo-id> <branch>`
- `bash scripts/udos-gitd.sh repo-pull <repo-id>`
- `bash scripts/udos-gitd.sh repo-push <repo-id>`

This is intentionally a local host-admin surface first, not a public HTTP API.

## Security Rule

All outbound repo and GitHub actions should remain subject to:

- host-side credentials
- remote policy gates
- budget or approval policy where needed
- audit-friendly logging

## Cross-Repo Rule

- Empire consumes this host surface when plugin workflows need repo awareness.
- Wizard may orchestrate or present these actions.
- Core may later publish reusable action-envelope shapes if they become
  family-wide semantics.
