# Optional backlog — Round 1 (ThinUI binder data source)

Status: **CLOSED** **2026-04-03**  
Ledger: `docs/optional-backlog-rounds-1-7.md`

## Intent

First tranche of the **ThinUI unified workspace** optional lane: **binder payload is loaded through a pluggable source** (bundled default + HTTP JSON), preparing for a future Core/host bridge without changing shell UX.

## Scope

- [x] `BinderWorkspaceSource` in `uDOS-thinui/src/workspace/binder-source.ts`
- [x] Workspace demo bootstraps asynchronously; errors surfaced in UI
- [x] `?binder=<url>` on `workspace.html` resolves with `parseDemoBinderJson`
- [x] `demo/public/demo-binder.json` for fetch smoke (`?binder=/demo-binder.json`)
- [x] `docs/thinui-unified-workspace-entry.md` updated

## Validation

```bash
cd uDOS-thinui
npm run typecheck
npm run build:demo
# Manual: npm run dev → /workspace.html?binder=/demo-binder.json
```

## Close criteria

All scope items satisfied; ledger Round 1 **completed**.

## Binder tag (optional)

`#binder/optional-backlog-round-1-thinui-binder-source`

## Sign-off (maintenance)

- **2026-04-03:** `uDOS-thinui` `npm run typecheck` — pass (OB-R1 closure re-verified).
