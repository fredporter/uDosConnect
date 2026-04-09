# How to submit to `@dev/inbox`

The inbox is **local scratch**: drafts, bundles, and agent handoffs that are **not** committed. Good submissions make promotion into tracked `docs/`, `@dev/notes/`, or owning repos fast and unambiguous.

## What belongs in the inbox

- **One coherent chunk of work** per top-level folder (or a single brief at the root). Avoid dumping unrelated PDFs and code in one pile.
- **Explicit ownership**: name the target repo or family lane (`uDOS-core`, post-08 gate, ThinUI, etc.).
- **Enough context to execute without chat history**: assume the reader has only this folder plus family defaults.

## What to include

1. **Intent in one paragraph** — outcome, not only activity (“land X in docs under …”, not “think about docs”).
2. **Constraints** — timebox, compatibility, “do not touch Y”, paths that are authoritative vs draft.
3. **Canonical references** — links or paths to contracts, roadmap lines, or existing briefs (`docs/dev-inbox/01-…`, `02-…`).
4. **Acceptance criteria** — bullet list; include “promote to … and delete inbox” when ready.
5. **Artifacts** — files the agent should create or merge; name expected filenames.

## How to instruct humans

- Use the dev brief template: `docs/dev-inbox/02-dev-brief-template.md` (copy into the inbox or draft beside it).
- Put **questions and decisions** in the brief, not only narrative.
- If the work spans repos, say which repo is **primary** and what is **follow-up**.

## How to instruct agents (recommended shape)

Give a single message that contains:

1. **Role and scope** — “You are working in repo X; stay within family boundaries in `docs/boundary.md`.”
2. **Inputs** — “Read `@dev/inbox/<folder>/…` and …”
3. **Tasks** — numbered steps; each step has a clear done condition.
4. **Out of scope** — one short list.
5. **Done when** — match your acceptance criteria; add “run checks from `docs/pr-checklist.md` if touching tracked files.”

Avoid vague asks (“clean this up”, “make it better”). Prefer measurable outcomes.

## Folder layout (suggested)

```
@dev/inbox/
  README.md                 # installed by bootstrap-dev-inbox.sh
  guidelines/               # copy of docs/dev-inbox/guidelines/
  <your-drop>/              # one folder per submission
    README.md               # intent + acceptance (required for multi-file drops)
    …
```

Single-file drops can live at the inbox root only if they are self-explanatory and short.

## After the work lands

1. **Promote** content to the tracked location named in the brief or ingest index.
2. **Log** large promotions in `docs/inbox-ingest/README.md` when crossing repos.
3. **Clear** the consumed folder from `@dev/inbox/`; run `bash scripts/bootstrap-dev-inbox.sh` to restore guidelines for the next round.

## Related

- Policy: `docs/dev-inbox-framework.md`
- Templates: `docs/dev-inbox/00-*`, `01-*`, `02-*`
- Ingest log: `docs/inbox-ingest/README.md`
