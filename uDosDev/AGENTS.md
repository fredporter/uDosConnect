# Agent notes (uDosDev)

**uDos** expands to **Universal Device Operating Surface**; capital **D** is intentional in new/edited prose. From **dev standard v4**, prefer **uDos** over legacy **uDOS** when touching a file ([docs/dev-process-v4.md](docs/dev-process-v4.md)). Do not use “UDO” / “UDOs” as a family acronym—that wording is for other products.

This repo owns family **workflow** and **governance** docs, not runtime behavior.

## Dev standard (v4)

- **Tasks:** root [`TASKS.md`](TASKS.md) — Task Forge sections (Backlog / In Progress / Blocked / Done).
- **Process:** [`docs/dev-process-v4.md`](docs/dev-process-v4.md), checklist [`docs/dev-checklist-v4.md`](docs/dev-checklist-v4.md).
- **Scratch:** **`@dev/inbox/`** remains the primary gitignored intake; optional **`.local/`** / **`.compost/`** follow the same rules as other family repos (see uDOS-v3 [`docs/dev-process-v4.md`](https://github.com/fredporter/uDOS-v3/blob/main/docs/dev-process-v4.md)).
- **Runnable code** lives in the **integration monorepo** ([**uDOS-v3**](https://github.com/fredporter/uDOS-v3)) — see [repo identity / rename note](https://github.com/fredporter/uDOS-v3/blob/main/docs/repo-identity-and-rename-v4.md).

- **Main line:** prefer **`main`**; short-lived branches only with a clear reason. See **`docs/pr-checklist.md`** and **`.cursor/rules/main-and-pr-finalization.mdc`** (if present).
- **Dev inbox:** **`@dev/inbox/`** is local scratch (gitignored). For brief templates and policy, use **`docs/dev-inbox-framework.md`** and **`docs/dev-inbox/`**; promote work to **`docs/`**, **`@dev/notes/`**, or **`@dev/requests/`**.
- **Lifecycle:** **`docs/family-workflow.md`**. Copilot mirror: **`.github/instructions/dev-workflow.instructions.md`**.
- **Below the `v2.x` gate:** continuous checks **`scripts/verify-engineering-backlog-below-gate.sh`** (also via **`scripts/run-dev-checks.sh`**). Preparing a future numbered plan: **`docs/next-family-plan-gate.md`**, **`@dev/notes/roadmap/next-plan-readiness.md`**.
