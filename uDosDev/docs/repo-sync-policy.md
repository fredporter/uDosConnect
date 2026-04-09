# uDOS v2 Repo Sync Policy

## Purpose

This document defines how local work syncs to GitHub during v2 development.

## Public Family Sync Policy

Public repos:

- `uDOS-core`
- `uDOS-shell`
- `sonic-screwdriver`
- `uDOS-plugin-index`
- `uDOS-wizard`
- `uDOS-gameplay`
- `uDOS-empire`
- `uHOME-matter`
- `uDOS-dev`
- `uDOS-themes`
- `uDOS-docs`
- `uDOS-alpine`
- `uHOME-client`
- `uHOME-server`
- `uHOME-app-android`
- `uHOME-app-ios`

### Branch policy

- **`main`** is the **only** long-lived integration branch; treat it as
  release-ready. Avoid parallel long-lived lines (`develop`, personal
  integration branches) unless a repo explicitly documents an exception.
- **Short-lived topic branches** branch from **`main`** only when there is a
  clear reason (risky change, long WIP, deliberate review isolation).
- Release tags follow `vMAJOR.MINOR.PATCH` from **`main`**.

### Push policy

- **Solo, linear work:** commit on **`main`** and **`git push origin main`** is
  the **default**—no PR required for routine integration.
- Non-trivial work should still link to a binder or tracked work item when the
  family uses binders; that does not imply a GitHub PR.
- **Pull requests** are **optional**: use them when you want isolation or a
  review artifact; do not treat “PR required” GitHub rules as mandatory—relax
  branch protection on `main` if it only creates friction (see
  **`docs/github-actions-family-contract.md`** § Branch protection and solo
  maintenance).

### Cross-repo sync policy

- push contract-owner repos first
- push downstream consumers second
- push packaging/deployment repos after contract consumers
- record cross-repo status in `uDOS-dev/@dev`

### Rollback policy

- revert or hotfix from the affected repo first
- document rollback in the binder or release note
- if the breakage is cross-repo, update the shared binder in `uDOS-dev`

## External Private App Rule

External private apps are outside the public family sync policy and should keep
their own branch, release, and promotion rules in their own repos.

### Shared hygiene

Private repos should still use:

- CODEOWNERS
- issue and PR templates
- validation workflows where practical
- boundary-safe public contract references

## Automation Expectations

### Public repos

- **`validate.yml`** and similar: family convention is triggers on **`main`**
  (**push** and, if configured, **pull_request**). Older repos may still list
  `develop`; converge them toward **`main`** when touching workflows.
- **`family-policy-check.yml`** verifies governance files and docs where wired.
- **`promote.yml`**: not required for public repos per governance; optional
  promotion automation only where a repo documents it.
- **`release.yml`** (or tag workflows): typically on version tags from **`main`**.

## Local Working Rule

Local work happens in:

- the affected repo
- `uDOS-dev/@dev`

Use repo trees for promotable outputs.
Use `uDOS-dev/@dev` for coordination state, binder notes, brief intake,
triage, routing manifests, and cross-repo planning.

Cross-repo briefs should enter through a local-only `uDOS-dev/@dev/inbox/`,
then move through processing into `triage/`, `routing/`, `promotions/`, or the
target repo's canonical public docs before the inbox copy is composted.
