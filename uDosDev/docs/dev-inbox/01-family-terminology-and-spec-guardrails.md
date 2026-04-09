# Family terminology and spec guardrails

Use this when drafting new briefs so language stays aligned with current uDOS
contracts and does not drift into parallel architecture.

## Terminology guardrails

- Prefer **uDOS-host / uDOS-server** as product posture terms; use
  **`uDOS-host`** for implementation repo naming.
- Use **General Knowledge Library** as preferred public term; "Bank" is accepted
  as informal synonym.
- Use **Binder + DeerFlow** language with explicit preview vs controlled modes.
- Use **feeds/spool** for runtime change semantics; do not collapse them into raw
  logs.
- Use **`~/.udos/`** as runtime root and **`<local-project-root>`** in docs for
  machine-local path examples.

## Spec authority order

When writing or reviewing a new brief, resolve conflicts using this order:

1. machine-readable contracts in owning repo
2. owning repo `docs/` architecture and boundary docs
3. family control-plane docs in `uDOS-dev/docs/`
4. `uDOS-dev/@dev` roadmap/backlog ledgers
5. inbox draft text

## Do not drift rules

- Do not propose "new stack" detours as default guidance when in-family route
  exists.
- Do not move runtime state ownership from Ubuntu/Core to docs or ad hoc tools.
- Do not turn `uDOS-docs` into implementation owner for binaries/services.
- Do not add Docker as mandatory dependency for Tier-1 runtime lanes.

## Required references in new briefs

Every cross-repo brief should cite at least:

- one owning-repo contract or architecture doc
- one family control-plane doc in `uDOS-dev/docs/`
- one backlog or roadmap status pointer for execution tracking
