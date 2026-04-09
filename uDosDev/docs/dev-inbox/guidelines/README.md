# Inbox submission guidelines (tracked)

These files are the **canonical** instructions for dropping work into the local **`@dev/inbox/`** queue. They ship with the repo; your machine’s inbox folder is gitignored.

| File | Purpose |
|------|---------|
| [`how-to-submit-to-inbox.md`](how-to-submit-to-inbox.md) | What to put in an inbox submission, how to phrase asks, and promotion hygiene |
| [`copy-paste-prompts.md`](copy-paste-prompts.md) | Short prompts you can hand to an agent or paste into a ticket |

**Refresh your local inbox** after a promotion round or on a new clone:

```bash
bash scripts/bootstrap-dev-inbox.sh
```

That copies this `guidelines/` tree into **`@dev/inbox/guidelines/`** and installs **`@dev/inbox/README.md`** from [`../local-inbox-README.md`](../local-inbox-README.md).

Parent index: [`../README.md`](../README.md) · Policy: [`../../dev-inbox-framework.md`](../../dev-inbox-framework.md).
