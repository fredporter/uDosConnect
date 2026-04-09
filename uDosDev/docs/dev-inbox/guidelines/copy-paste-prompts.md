# Copy-paste prompts for inbox work

Use these as **starting points**. Replace angle-bracket placeholders. Point agents at **`@dev/inbox/<your-folder>/`** when the materials live there.

## Generic inbox execution

```
You are helping with uDOS family work in this workspace. Local intake may live under
uDOS-dev/@dev/inbox/<folder>/ (gitignored). Read that folder first.

Goals:
1. <outcome in one sentence>
2. <second outcome if any>

Constraints:
- Stay within family boundaries (uDOS-dev docs/boundary.md, architecture.md).
- Do not commit @dev/inbox/; promote results to tracked paths: <e.g. uDOS-dev/docs/… or owning repo>.
- Match existing naming and doc style in the target repo.

Tasks:
1. <step with done condition>
2. <step with done condition>

Out of scope: <list>

Done when: <acceptance bullets>. If you change tracked files, note checks from uDOS-dev docs/pr-checklist.md.
```

## Inbox ingest (operator)

```
Ingest everything under uDOS-dev/@dev/inbox/ into durable tracked locations per
docs/dev-inbox/guidelines/how-to-submit-to-inbox.md and docs/inbox-ingest/README.md.
Copy or merge into the owning repos as appropriate, update inbox-ingest index when needed,
then clean @dev/inbox/ for the next round and run bash scripts/bootstrap-dev-inbox.sh
so guidelines/README are restored locally.
```

## New brief from template

```
Draft a new dev brief using uDOS-dev/docs/dev-inbox/02-dev-brief-template.md for:
<title>. Target repo(s): <repos>. Save the filled brief under @dev/inbox/<slug>/
as README.md or brief.md and list promotion targets.
```
