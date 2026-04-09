# 2026-03-30 Empire And Ubuntu Restructure

## Status

Accepted family direction for the current refactor pass.

## Decision

`uDOS-empire` is repurposed from a broad remote-ops container into a
WordPress plugin that runs on the local `uDOS-host` host.

`uDOS-host` is extended to own the coordinated local repo store and the
host-side Git or GitHub execution surface for the family.

## Why

The March 2026 Empire WordPress brief pack makes WordPress the correct local
CRM, admin, consent, and email host for Empire.

Ubuntu already owns the always-on runtime host, scheduling, sync posture, and
local service assembly. Git repository storage plus GitHub push or pull
execution fits that host boundary better than Empire or Wizard ownership.

This removes three unstable overlaps:

- Empire no longer needs to present itself as both a general outbound workbench
  and a WordPress CRM plugin.
- Wizard no longer needs to drift into canonical Git or GitHub ownership just
  because it can broker MCP or assist flows.
- Ubuntu can expose one stable local repo surface for family automation,
  scheduled sync, and operator review.

## Ownership Split

### `uDOS-empire` owns

- WordPress plugin runtime and admin UX
- WordPress-backed CRM record processing
- contact import, dedupe, enhancement, and tagging
- binder or workspace links on contact records
- WordPress-centred email and contact activity logging
- intake from other family components into WordPress contact records

### `uDOS-host` owns

- canonical local checkout or mirror storage for family repos
- host-side Git actions such as status, fetch, branch, pull, and push
- GitHub CLI and MCP adapter access as host-managed execution tools
- scheduled repo sync or reconcile jobs
- credentials, remotes, and policy gates for outbound GitHub operations

### `uDOS-wizard` owns

- optional assist, orchestration, and presentation on top of Ubuntu host
  actions
- no canonical ownership of repo storage, remotes, or GitHub execution policy

### `uDOS-core` owns

- generic reusable contract shapes only if repo-action envelopes need to become
  family-level semantics

## Immediate Refactor Rule

For this refactor pass:

- replace Empire README and architecture messaging so WordPress plugin
  ownership is the public default
- mark the older Empire "operations container" framing as superseded
- add Ubuntu docs and contracts for repo-store and GitHub host surfaces
- keep cross-repo coordination here in `uDOS-dev/@dev`, not in repo-local docs
