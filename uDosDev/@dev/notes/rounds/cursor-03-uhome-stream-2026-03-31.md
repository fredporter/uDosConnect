# Round: cursor-03 uHOME stream

- Date: 2026-03-31
- Workspace: `cursor-03-uhome-stream.code-workspace` (repo root: `uDOS-family/` adjacent to `uHOME-family/` — see workspace JSON `folders`)

## Status

**CLOSED** — **2026-03-31**. Automated checks, stream docs, and **Step 3** real-browser proof are complete (Safari on **127.0.0.1**: `thin/read`, `thin/automation`, `thin/browse`; Tailwind Typography / `prose.css` confirmed).

**Workspace file:** `uDOS-family/cursor-03-uhome-stream.code-workspace`.

## Step 3 — Thin UI browser proof (required to close)

### Start the server

1. **Terminal:** `cd` to your **`uHOME-server`** clone (the repo that contains `pyproject.toml`).
2. **Environment:** `source .venv/bin/activate` (or create the venv first: `bash scripts/run-uhome-server-checks.sh` installs deps and runs tests).
3. **Run:**
   ```bash
   python -m uvicorn uhome_server.app:app --host 127.0.0.1 --port 8000 --reload
   ```
   Pick any port; **`QUICKSTART.md` uses `8000`**. If you use another port (e.g. `7890`), substitute it in every URL below.

### Open in a real browser

Replace **`8000`** with your port:

1. **`http://127.0.0.1:8000/api/runtime/thin/automation`** — automation status (HTML + `prose` block).
2. **`http://127.0.0.1:8000/api/runtime/thin/read`** — default **Typography / prose** reading page (nav links between thin routes).
3. Optional: **`http://127.0.0.1:8000/api/runtime/thin/browse?rel=pathway/README.md`** — renders markdown from `docs/` in the checkout.

### What to verify

- Headings, lists, and links read clearly; dark background looks intentional.
- **`/static/thin/prose.css`** returns **200** (browser Network tab or “View page source” and follow the stylesheet link).

Record completion in this section:

- [x] Operator browser sign-off **2026-03-31** / **127.0.0.1** / Safari (thin read, automation, browse + `prose.css`).

## Lane authority

- Objectives, repos in scope, spec outputs: `docs/cursor-focused-workspaces.md` § Workspace 03
- Sequence: `docs/cursor-execution.md` (step 3)

## Spec outputs (target)

| Output | Where |
| --- | --- |
| uHOME stream roadmap | `uDOS-dev/docs/uhome-stream.md` |
| App / runtime / service boundary | `uhome-stream.md` § Role matrix; `uHOME-server/docs/base-runtime-boundary.md`; `uHOME-matter/docs/server-runtime-handoff.md`; `uHOME-client/README.md` |
| Dependency contract back to runtime spine | `uhome-stream.md` § Sequencing, Wizard/core boundary, Dependency contract; `uHOME-server/docs/architecture.md` |

## Exit gate (Workspace 03)

| Criterion | Evidence |
| --- | --- |
| uHOME clearly sequenced after the runtime spine | `docs/uhome-stream.md` § Sequencing; `uHOME-server/docs/architecture.md` § Networking / Contract edges |
| Mobile, client, server, and matter roles separated cleanly | `docs/uhome-stream.md` § Role matrix |
| Boundary with `uDOS-wizard` and other core repos is clear | `docs/uhome-stream.md` § Wizard and core boundary; `uHOME-server/docs/architecture.md` (LAN baseline without Wizard) |
| uHOME family workable separately from core uDOS completion | `docs/uhome-stream.md` § Working the stream separately; client `family_modes` + `deployment_modes` |

## Verification (automated)

- `uHOME-server` — `bash scripts/run-uhome-server-checks.sh`
- `uHOME-client` — `bash scripts/run-uhome-client-checks.sh`

**Codex `v2.3` merged to `main` (2026-03-31);** remote branch **`codex/v2-3-closeout` deleted** after merge.

## Next lane (after closure)

`cursor-04-groovebox-product.code-workspace` — `docs/cursor-execution.md`.

## Related

- Prior closed round: `@dev/notes/rounds/cursor-02-foundation-distribution-2026-03-30.md`
- Family candidate (not roadmapped): `@dev/notes/candidates/logs-feeds-spool-family-candidate.md`
- Family readiness audit: `@dev/notes/reports/family-readiness-audit-2026-03-30.md`
