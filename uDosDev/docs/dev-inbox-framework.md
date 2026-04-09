# `@dev/inbox` — local intake, distributable framework

## Policy

- **`uDOS-dev/@dev/inbox/` is gitignored.** Treat it as a **local intake queue**: drafts, spikes, agent handoffs, and copies of briefs you are working. Nothing there is assumed to ship with the repo.
- **Ingest into the real workflow:** promote accepted content into tracked homes (`docs/`, `@dev/notes/`, `@dev/requests/`, `@dev/pathways/`, or the owning repo). Agents and humans should **read inbox, implement or document in canonical places, then discard or archive locally**.
- **Do not commit the inbox** under normal family practice. There is no need to push scratch to `.git`.

## What *is* distributable

The **instructions and templates** for how to use the inbox live under version control:

| Path | Role |
|------|------|
| `docs/dev-inbox-framework.md` | This file — workflow and policy |
| `docs/dev-inbox/00-family-repo-structure-brief.md` | Base briefing — repo/tier model |
| `docs/dev-inbox/01-family-terminology-and-spec-guardrails.md` | Terminology and authority order |
| `docs/dev-inbox/02-dev-brief-template.md` | Template for new briefs |
| `docs/dev-inbox/guidelines/` | Submission and agent-instruction guidelines (install into local inbox via `scripts/bootstrap-dev-inbox.sh`) |
| `docs/dev-inbox/local-inbox-README.md` | Source for `@dev/inbox/README.md` (installed by the bootstrap script) |
| `docs/dev-inbox/README.md` | Short index of the template set |

Copy or mirror those files into a **local** `@dev/inbox/` if you want the same layout Cursor/agents expect; **`bash scripts/bootstrap-dev-inbox.sh`** refreshes `@dev/inbox/README.md` and `guidelines/` from the tracked copies. Keep long-lived or team-visible prose in `docs/` (or downstream repos).

## Workflow (short)

1. Draft using `docs/dev-inbox/02-dev-brief-template.md` (and guardrails `01`, structure `00` as needed).
2. Execute or spec in canonical locations; run validation from the brief.
3. Promote outcomes per the template’s “Promotion target” checklist.
4. Leave `@dev/inbox/` as disposable intake, or clear it after promotion.

## Related

- Promoted intake log: `docs/inbox-ingest/README.md`
- Tracked pointers for specific workstreams (example): `docs/thinui-unified-workspace-entry.md`
- Family workflow: `docs/family-workflow.md`
- PR and branch habits: `docs/pr-checklist.md`
