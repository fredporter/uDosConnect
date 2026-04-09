# Dev process — family governance (v4)

**Status:** locked (2026-04)  
**Repo:** **uDosDev** (`~/Code/uDosConnect/uDosDev/`) — workflow, governance, scripts; **not** canonical runtime.

## Version

Root **`package.json`** **version** `4.0.0` tracks the **governance / dev-standard** line. It does not replace product or monorepo version labels in other repositories.

### Naming in prose (v4 onwards)

Prefer **uDos** in **new and edited** docs and scripts comments; the capital **D** is intentional. Legacy **uDOS** in older text can stay until touched — **no** mass rename across the family. Do **not** use “UDO” / “UDOs” as a family acronym (reserved by other products).

## Structure (aligned with family standard)

| Zone | Role |
| --- | --- |
| **`@dev/inbox/`** | Gitignored scratch (see **AGENTS.md**). |
| **`.local/`** | Optional extra untracked scratch (gitignored). |
| **`.compost/`** | Optional untracked decay pile for replaced material. |
| **`TASKS.md`** | Single active task surface (Backlog → In Progress → Blocked → Done). |
| **`docs/`** | Canonical governance and workflow. |

Flow: **inbox / .local → TASKS.md → docs/ and scripts/**.

## Companion docs

- **Checklist:** [dev-checklist-v4.md](dev-checklist-v4.md)
- **Family workflow:** [family-workflow.md](family-workflow.md)
- **Integration monorepo identity / rename options:** [uDOS-v3: repo-identity-and-rename-v4.md](https://github.com/fredporter/uDOS-v3/blob/main/docs/repo-identity-and-rename-v4.md)
- **Local disk spine:** [`../../docs/family-workspace-layout.md`](../../docs/family-workspace-layout.md) (`~/Code/uDosGo` + `~/Code/uDosConnect/…`)

Canonical Task Forge prose may live in operator-local `~/Code/Dev-tasks.md`; this repo encodes **locked behaviour** for the family.
