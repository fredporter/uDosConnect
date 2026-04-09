# `uDOS-dev/@dev`

This workspace owns family-level development coordination.

Keep these items here:

- family roadmap and release coordination
- cross-repo requests and completed summaries
- shared pathway candidates and templates
- minimal triage and current coordination notes

`@dev/inbox/` is a local processing queue, not a tracked storage lane. Drop new
specs, decisions, scaffolds, and raw source material there locally, process
them into their canonical doc home, then compost them or move them into a
local-only processed folder.

Do not use this workspace as the default storage location for repo-specific
round history. Repo-owned planning belongs in the owning repo's local
workspace, and historical raw intake should stay out of public git.

Do not keep public logs, promotion ledgers, routing manifests, or bulk
operations runbooks here once their useful rules have been promoted into
canonical docs or pathways.

See:

- `notes/devlog.md` — short dated handoffs (e.g. Cursor workspace transitions)
- `docs/repo-local-dev-workspaces.md`
- `docs/family-workflow.md`
- `docs/versioning-policy.md`
