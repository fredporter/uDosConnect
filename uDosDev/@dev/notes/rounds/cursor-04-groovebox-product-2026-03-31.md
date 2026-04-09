# Round: cursor-04 Groovebox product

- Date: 2026-03-31
- Workspace: `cursor-04-groovebox-product.code-workspace` (open from **`uDOS-family/`** so folder paths `uDOS-groovebox`, `uDOS-core`, … resolve)

## Status

**CLOSED** — **2026-04-01**. **Documentation exit gate** and **Step 3** (browser
sign-off on local Groovebox UI) are complete — see **Step 3** below.

**Workspace file:** `uDOS-family/cursor-04-groovebox-product.code-workspace`.

## Operator start

1. Open **`uDOS-family/cursor-04-groovebox-product.code-workspace`** in Cursor (multi-root: groovebox, core, ubuntu, dev, docs).
2. Read lane authority below and **`docs/cursor-focused-workspaces.md` § Workspace 04**.
3. In **`uDOS-groovebox`:** run **`bash scripts/run-groovebox-checks.sh`**, then **`bash scripts/run-groovebox-ui.sh`** for the local operator surface (`docs/getting-started.md`).
4. Optional Songscribe UI lane: **`bash scripts/run-songscribe-ui.sh`** when the container/clone path is in use (`docs/getting-started.md` § containers).

## Finishing shape (recommended for close)

Align with **`docs/cursor-execution.md`** discipline: automated checks, then **human-visible** confirmation of the **Groovebox** browser UI (not only `curl`).

| Step | What |
| --- | --- |
| **1** | **`bash uDOS-groovebox/scripts/run-groovebox-checks.sh`** passes (from repo root or path shown in script). |
| **2** | Any additional integration or docs proof the round adds (Docker/Songscribe optional paths, library layout). |
| **3** | **Browser:** run **`bash scripts/run-groovebox-ui.sh`**, open the served URL in a real browser, confirm the **Groovebox** shell (nav, composer, Songscribe strip). **Record** operator sign-off in this file and/or `@dev/notes/devlog.md`. |

## Lane authority

- Objectives, repos in scope, spec outputs, exit gate: `docs/cursor-focused-workspaces.md` § Workspace 04
- Sequence: `docs/cursor-execution.md` (step 4)

## Spec outputs (delivered)

| Output | Where |
| --- | --- |
| Groovebox product definition | `uDOS-groovebox/docs/product-checklist.md` (§ Product definition); `README.md`, `docs/architecture.md`, `docs/boundary.md` |
| Sound-library storage and browsing plan | `uDOS-groovebox/docs/sound-library.md`; `src/pattern-library.json`, `sample-bank.json`, `synth-presets.json`; `config/workspaces.json` |
| Songscribe processing contract | `uDOS-groovebox/docs/songscribe-contract.md`; `app/songscribe.py`; `containers/songscribe/README.md` |
| Optional Docker usage decision | `uDOS-groovebox/docs/docker-posture.md` |

## Exit gate (Workspace 04)

| Criterion | Evidence |
| --- | --- |
| Groovebox has a product checklist, not just a concept note | `uDOS-groovebox/docs/product-checklist.md`; enforced by `scripts/run-groovebox-checks.sh` (`require_file`). |
| Audio artifacts, metadata, and markdown outputs have stable locations | `uDOS-groovebox/docs/sound-library.md`; `sessions/README.md`. |
| Operational requirements are documented | `uDOS-groovebox/docs/activation.md` § Operational requirements; `docs/product-checklist.md` § Preconditions / smoke. |

### Step 3 — browser sign-off (complete)

- [x] **2026-04-01** — Operator visual demo on **`http://127.0.0.1:8766/`** (default port): **Compose / Vault / Library / Status** nav, stacked cards on Compose, **Vault** tree, **Library** list, header **Songscribe** strip; light single-column shell signed off as good.

## Verification (automated)

- `uDOS-groovebox` — `bash scripts/run-groovebox-checks.sh`

## Next lane (after closure)

`cursor-05-gui-system.code-workspace` — `docs/cursor-execution.md`.

## Carry-forward (2026-04-01 — cursor-04 close-out prep)

- **Groovebox UI:** Single-column, Songscribe-adjacent light shell; hash routes **Compose**, **Vault**, **Library**, **Status** (`uDOS-groovebox/app/static/`).
- **Songscribe stem isolation:** Still fails with **“Error Isolating Audio”** until **[songscribe-api](https://github.com/gabe-serna/songscribe-api)** is running and **`NEXT_PUBLIC_API_BASE_URL`** points at a URL the **browser** can reach; prefer **`http://localhost:3000`** for the Songscribe tab (upstream CORS). See **`uDOS-groovebox/docs/songscribe-isolate-audio.md`**.
- **Roadmap / next rounds:** Family **Engineering backlog** (`v2-family-roadmap.md`) now tracks **integrated Docker** for Songscribe + API (template for additional third-party services). Ledger: `v2-roadmap-status.md` § Recent Outputs **2026-04-01**.

## Related

- Prior closed round: `@dev/notes/rounds/cursor-03-uhome-stream-2026-03-31.md`
- Groovebox onboarding: `uDOS-groovebox/docs/getting-started.md`
- Family execution order: `docs/cursor-execution.md`
