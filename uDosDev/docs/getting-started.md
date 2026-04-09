# uDosDev — getting started

1. Optional historical context: [archive/cursor-handover-plan.md](archive/cursor-handover-plan.md) (archived Cursor lane narrative).
2. Read [cursor-execution.md](cursor-execution.md) and [cursor-focused-workspaces.md](cursor-focused-workspaces.md).
3. Open the next numbered `cursor-*.code-workspace` in Cursor (start at `cursor-01` unless a lane is already complete).
4. Drop raw incoming material into a local-only `@dev/inbox/`, process it into its canonical public home, and keep only forward-looking planning in tracked `@dev/`.
5. Review `docs/activation.md`.
6. Document contributor flows in `docs/`.
7. Keep automation helpers in `automation/` and `scripts/`.
8. Treat education and maintenance as first-class outputs.
9. Use `docs/development-roadmap.md`, `docs/roadmap-workflow.md`, `docs/post-08-backlog-snapshot.md`, `@dev/notes/roadmap/v2-family-roadmap.md` (§ Engineering backlog), `scripts/run-roadmap-status.sh`, and `scripts/run-dev-checks.sh` to track active roadmap progress.
10. When working on **ThinUI** and **uDOS-themes** together, run `bash scripts/install-thinui-themes-lane.sh` from **`uDosDev/`** (initializes `uDOS-themes/vendor/forks` submodules and `npm install` in **uDOS-thinui** when those sibling repos exist).
