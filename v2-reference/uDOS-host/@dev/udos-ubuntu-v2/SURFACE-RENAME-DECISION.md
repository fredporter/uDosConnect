# Surface Rename Decision

## Decision

Retire `Wizard` as the browser-GUI product identity and replace it with
`Surface`.

Use:

- `uDOS-surface` for the browser GUI and render-layer repo or package name
- `Surface UI` for the active browser app
- `Surface` as the operator-facing product name

Keep `Wizard` only as a temporary compatibility label during transition.

## Why

The v2.2 Ubuntu split changes the meaning of authority:

- Ubuntu owns network setup and config
- Ubuntu owns beacon node behavior
- Ubuntu owns managed OK execution
- Ubuntu owns managed MCP execution
- Ubuntu owns routing, budgets, retries, caching, scheduling, and audit

`Wizard` implies orchestration or runtime authority. That is now the wrong
mental model for the browser layer.

`Surface` better matches the intended role:

- presentation
- browsing
- render output
- operator visibility
- thin-client submission
- portal and library access

## Naming Rule

Use `Surface` when the concern is:

- browser rendering
- themed presentation
- operator pages
- publishing views
- library browsing
- preview parity
- thin-client submission forms

Do not use `Surface` when the concern is:

- provider routing
- managed MCP lifecycle
- budgets and approvals
- retry and fallback policy
- scheduling
- secret-backed runtime control
- network or beacon authority

Those belong to Ubuntu.

## Transition Posture

Short term:

- keep repo paths and executable names stable where needed
- update user-facing wording first
- treat `Wizard` as a compatibility alias in docs that still describe the GUI

Medium term:

- rename GUI-facing repo, app, and route labels to `Surface`
- leave backend/runtime identities with Ubuntu
- remove `Wizard` from new architectural decisions
