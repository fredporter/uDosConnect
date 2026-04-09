# Dev inbox — canonical templates (tracked)

These files are the **distributable** inbox framework. They replace the idea of versioning `@dev/inbox/` itself.

- `00-family-repo-structure-brief.md` — family repo/tier model
- `01-family-terminology-and-spec-guardrails.md` — language and spec authority
- `02-dev-brief-template.md` — template for new intake briefs
- **`guidelines/`** — how to phrase inbox submissions, agent prompts, and promotion hygiene (`guidelines/README.md`)

Policy and workflow: `../dev-inbox-framework.md`.

**Local inbox refresh:** from repo root, `bash scripts/bootstrap-dev-inbox.sh` installs `@dev/inbox/README.md` and `@dev/inbox/guidelines/` (optional: `--with-briefs` copies `00`–`02` into `@dev/inbox/`).

**Promoted intake index:** `../inbox-ingest/README.md` (inbox → tracked repos).
