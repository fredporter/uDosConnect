# Inbox ingest index (`@dev/inbox` → tracked docs)

The **`@dev/inbox/`** tree in **`uDOS-dev`** is **gitignored** by design (`docs/dev-inbox-framework.md`). Accepted intake is **promoted** here and in sibling repos.

## 2026-04-05 promotion

| Intake | Permanent location |
| --- | --- |
| **Classic Modern MVP** pack | **`uDOS-docs`** `docs/classic-modern-mvp-0.1/` (merged; canonical `docs/sonic-tui-charter.md` retained) |
| **Agent Digital v2.1** pack | **`uDOS-gpthelper`** `docs/source-packs/agent-digital-v2_1-pack/` |
| **ThinUI unified workspace v2** notes | **`uDOS-thinui`** `docs/inbox-ingest/unified-workspace-v2/` |
| **gpthelper + host export** snapshot | **`2026-04-05-gpthelper-export-snapshot/`** (this repo) — reference bundle; live code remains **`uDOS-gpthelper`**, **`uDOS-host/services/gpt-export-helper/`** |
| Root briefs **`00`–`02`** | Already matched **`docs/dev-inbox/`**; no file copy required |
| **Submission guidelines + local inbox bootstrap** | **`docs/dev-inbox/guidelines/`**, **`docs/dev-inbox/local-inbox-README.md`**, **`scripts/bootstrap-dev-inbox.sh`** (installs **`@dev/inbox/guidelines/`** and **`@dev/inbox/README.md`**; optional **`--with-briefs`**) |

## Workflow

1. Draft in **`@dev/inbox/`** locally. Use **`docs/dev-inbox/guidelines/`** (or run **`bash scripts/bootstrap-dev-inbox.sh`** so **`@dev/inbox/guidelines/`** is present) for recommended ways to instruct a submission.
2. Promote into **`docs/`**, **`@dev/notes/`**, or the **owning repo** (as above).
3. Clear **`@dev/inbox/`** subfolders after promotion; run **`bash scripts/bootstrap-dev-inbox.sh`** to restore **`README.md`** and **`guidelines/`** for the next round.
