# Triage: Apple Mail Contact Intelligence And Archive Hygiene

- title: Apple Mail Contact Intelligence And Archive Hygiene
- date: 2026-03-14
- related binder: `#binder/omd-mac-email-contact-intelligence`
- related repos:
  - `omd-mac-osx-app`
  - `uDOS-dev`
  - `uDOS-empire`
  - `uDOS-docs`
  - `uDOS-core`
- status: `triaged`

## Summary

This is a cross-repo private-origin brief led by `omd-mac-osx-app`.
The source of truth for implementation detail is the private Mac app repo.
`uDOS-dev` owns intake, routing, and promotion tracking.

## Findings

- the brief is primarily an app implementation and decision item, not a public
  core contract yet
- the ingestion lane is Apple-native and should remain private
- structured export semantics may later produce a small public contract surface
- user-facing documentation should summarize behavior and privacy guarantees
  rather than implementation detail

## Risks

- copying the raw brief into multiple repos would create divergence
- public repos could accidentally claim Apple-native ownership if routing is not
  explicit
- sync concerns could sprawl if raw extraction and downstream export are not
  separated

## Next Actions

- route a future sync/export brief to `uDOS-empire`
- generate a user-facing summary only after the app-owned semantics settle
- defer any `uDOS-core` schema work until a reusable public contract is clear
