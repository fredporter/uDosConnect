# Doc structure verification — tier-1 repos (2026-03-30)

Pass: confirm each repo exposes a **stable public spine**: root `README.md`,
`docs/` index, learning or onboarding path, and (where applicable) `wiki/` and
`@dev/` rules. **Activation** is the v2 standard entry: `docs/activation.md`.

## Family policy (target)

| Surface | Role |
| --- | --- |
| `README.md` | Purpose, ownership, spine, family relation |
| `docs/README.md` | Stable doc index and “start here” |
| `docs/getting-started.md` | Operator onboarding (where used) |
| `docs/activation.md` | Repo activation path for the family |
| `wiki/README.md` | Beginner / unit lanes (where present) |
| `@dev/README.md` | Forward-only planning; local rules |

## Verification matrix

Checked: file exists at repo root paths below.

| Repo | README | docs/README | docs/getting-started | docs/activation | wiki/README | @dev/README | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `uDOS-core` | yes | yes | yes | yes | yes | yes | OK |
| `uDOS-host` | yes | yes | yes | yes | yes | yes | OK |
| `uDOS-wizard` | yes | yes | yes | yes | yes | yes | OK (`docs/activation.md` added 2026-03-30) |
| `uDOS-grid` | yes | yes | yes | yes | yes | yes | OK |
| `uHOME-server` | yes | yes | yes | yes | — | yes | **No `wiki/`** tree; learning via `docs/`, `courses/` |
| `uDOS-dev` | yes | yes | yes | yes | yes | yes | OK |
| `uDOS-docs` | yes | yes | yes | yes | yes | yes | OK |

Paths resolved from workspace roots (portable):

- `uDOS-*`: `~/Code/uDOS-family/<repo>`
- `uHOME-server`: `~/Code/uHOME-family/uHOME-server`

## Follow-up

1. Re-run this matrix when adding a new **tier-1** public repo.
2. Keep **runtime optimisation** detail in
   `@dev/notes/reports/runtime-loop-optimization-flags-2026-03-30.md`, not here.

## Related

- `docs/pr-checklist.md`
- `@dev/notes/roadmap/v2-family-roadmap.md` § Engineering backlog
