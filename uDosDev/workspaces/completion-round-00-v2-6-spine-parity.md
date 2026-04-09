# Round 00 — prepare for **v2.6 spine parity** (pre-round)

**Workspace file:** `archive/v2/completion-round-00-v2-6-spine-parity.code-workspace` (edit the JSON to add/remove roots; paths are relative to `workspaces/archive/v2/`).

**Goal:** one Cursor/VS Code window with every repo that owns **binder spine v1** alignment (family `v2.6` rounds A–D) plus **uDOS-dev** / **uDOS-docs** for governance and reader copy — before you branch or PR cross-repo spine changes.

## 1. Checkout layout

**Canonical spine:** [`../../docs/family-workspace-layout.md`](../../docs/family-workspace-layout.md) — **`~/Code/uDosGo/`** (integration) and **`~/Code/uDosConnect/…`** (governance, docs, `v2-reference`, optional nested clones).

Historically this round used a **flat** sibling tree under a family root (for example `~/Code/uDOS-family/`):

- `uDOS-core`, `uDOS-thinui`, `uDOS-workspace`, `uDOS-host`, `uDOS-wizard`, `uDOS-shell`, `uDOS-dev`, `uDOS-docs`

`scripts/run-v2-6-release-pass.sh` assumes **`uDOS-dev`** is the cwd and peers live at `../uDOS-workspace`, `../uDOS-core`, `../uDOS-thinui`, `../uDOS-host` (see script header). Mirror that **relative** layout under **`~/Code/uDosConnect/`** when using the new convention.

## 2. Tooling (before opening the workspace)

| Need | Notes |
| --- | --- |
| **Python 3** | Core binder spine contract tests (`pytest`). |
| **Node + npm** | ThinUI (`npm run validate:binder-spine`, `npm run typecheck`), workspace web check, shell (`npm ci` / `npm run go:run` if you TUI-smoke). |
| **Linux host checks** | `uDOS-host` `run-ubuntu-checks.sh` is part of the full release pass — use a Linux machine or the environment you normally use for host parity. |

## 3. Quick per-repo smoke (optional, before the full pass)

Run from each repo root only if you are debugging; otherwise skip to **§4**.

- **Core:** `PYTHONPATH=. python3 -m pytest tests/test_binder_spine_contract.py -q --tb=line`
- **ThinUI:** `npm run validate:binder-spine` and `npm run typecheck`
- **Workspace:** `bash scripts/run-workspace-checks.sh` (from `uDOS-workspace`)
- **Host:** `bash scripts/run-ubuntu-checks.sh`
- **Shell:** `npm run go:run` (after `npm ci`) for TUI proof

Canonical doc pointers: **`docs/archive/v2/completion-rounds-v2-6-alignment.md`**, **`@dev/notes/roadmap/archive/v2/v2.6-rounds.md`**.

## 4. Full spine verification (recommended gate)

From **`uDOS-dev`**:

```bash
bash scripts/run-v2-6-release-pass.sh
```

On macOS you can double-click **`completion-launchers/Run-v2-6-release-pass.command`** (same script).

## 5. Open the multi-root workspace

1. **File → Open Workspace from File…**
2. Select **`uDOS-dev/workspaces/archive/v2/completion-round-00-v2-6-spine-parity.code-workspace`**
3. Adjust **`folders`** in that JSON if you need extra roots (for example **`uDOS-plugin-index`**, **`uDOS-gpthelper`**) — keep **`..`** (`uDOS-dev`) and the **`uDOS-docs`** entry so governance and public docs stay in the window (paths use extra `../` segments because the file lives under **`archive/v2/`**).

## 6. When you are done

- Commit per repo on **`main`** (or a short-lived branch) per **`docs/pr-checklist.md`**.
- If you changed **`archive/v2/completion-round-00-v2-6-spine-parity.code-workspace`**, commit it in **`uDOS-dev`** with a short note (optional roots, path fixes).

## Related

- `completion-rounds-and-local-stack.md` — proof contract and launchers
- `docs/archive/v2/completion-rounds-v2-6-alignment.md` — family `v2.6` vs inbox MDC pack
- `completion-launchers/README.md`
