# `@dev/inbox` (local)

This directory is **gitignored**. It is a **scratch intake queue** for drafts, spikes, and handoff bundles before promotion into tracked docs or owning repos.

## Start here

- **Guidelines** (copy of repo canon): [`guidelines/README.md`](guidelines/README.md)
- **Family policy:** [`../../docs/dev-inbox-framework.md`](../../docs/dev-inbox-framework.md)
- **Templates:** [`../../docs/dev-inbox/`](../../docs/dev-inbox/) — `00-*`, `01-*`, `02-*` briefs

## Restore or refresh this folder

From the **`uDOS-dev`** repo root:

```bash
bash scripts/bootstrap-dev-inbox.sh
```

That reinstalls this `README.md` and the **`guidelines/`** subtree from tracked sources.

## After promotion

1. Move or merge work into the right tracked tree; log cross-repo ingests in **`docs/inbox-ingest/README.md`** when applicable.
2. Delete consumed subfolders here; keep only fresh intake.
3. Run **`bootstrap-dev-inbox.sh`** again so the next round starts with up-to-date guidelines.
