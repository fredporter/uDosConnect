# Ubuntu Handover For Cursor

Date: 2026-03-30
Repo: `uDOS-host`

## Current State

Ubuntu is now the active host boundary for the family repo-store and Git or
GitHub execution lane.

Completed in this round:

- `scripts/udos-gitd.sh` is no longer a pure stub
- repo-store layout, registry path, and starter repo manifest are defined
- docs and checks now validate the repo-store scaffold
- `scripts/udos-commandd.sh` can now inspect the checked-in contract surfaces
- `scripts/udos-commandd.sh` can now bridge `repo.*` operations into `udos-gitd`
- outbound `repo.push` and `github.*` actions are now policy-gated by checked-in defaults
- the Git host surface is machine-readable and aligned with the runtime docs

## Files To Start From

- `scripts/udos-gitd.sh`
- `scripts/udos-commandd.sh`
- `contracts/udos-commandd/git-host-surface.v1.json`
- `contracts/udos-commandd/operation-registry.v1.json`
- `config/policy/github-action-policy.json.example`
- `config/runtime/git-repos.yaml.example`
- `docs/git-repo-store.md`
- `scripts/run-ubuntu-checks.sh`

## What Is Real Now

- local repo-store root assumptions under `~/.udos/repos`
- registry file under `~/.udos/state/gitd/repo-registry.tsv`
- bounded repo admin commands for init, attach, clone, status, fetch, branch,
  pull, and push
- commandd inspection commands for repo-domain operation listing and surface
  summaries
- commandd repo bridge for `repo.list`, `repo.status`, `repo.fetch`,
  `repo.branch`, `repo.pull`, `repo.push`, and `repo.clone_or_attach`
- checked-in policy gating for `repo.push`, `github.issue.read`,
  `github.pr.comment`, and `github.pr.create`
- command audit logging under `~/.udos/logs/commandd/operation-audit.log`
- validation coverage for the new scaffold

## What Is Still Missing

- no long-running HTTP daemon for `udos-gitd`
- no real `gh` or MCP broker adapter implementation
- no persisted structured repo registry beyond TSV
- no HTTP envelope layer yet for commandd operation invocation
- no approval state persistence beyond environment-variable gates

## Recommended Next Steps

1. replace shell-level commandd bridging with an envelope-aware local API or dispatcher
2. implement real `gh` or MCP adapters behind the policy-gated `github.*`
   operations
3. replace TSV registry storage with a versioned JSON registry once commandd
   starts owning request envelopes
4. move audit logging to a more structured per-operation format
5. add persistent approval state rather than environment-variable gates

## Quick Verification

```bash
bash scripts/run-ubuntu-checks.sh
bash scripts/udos-gitd.sh init-layout
bash scripts/udos-commandd.sh list-operations repo
bash scripts/udos-commandd.sh surface-summary git
bash scripts/udos-commandd.sh policy-summary
bash scripts/udos-commandd.sh repo-op repo.list
```
