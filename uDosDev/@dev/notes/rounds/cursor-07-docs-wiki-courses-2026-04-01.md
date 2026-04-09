# Round: cursor-07 docs, wiki, and courses

- Date: 2026-04-01
- Workspace: `cursor-07-docs-wiki-courses.code-workspace` (open from **`uDOS-family/`**)

## Status

**CLOSED** **2026-04-01** — exit gate satisfied; evidence below. **Next:** `cursor-08-family-convergence.code-workspace`.

**Workspace file:** `uDOS-family/cursor-07-docs-wiki-courses.code-workspace`.

## Operator start

1. Open **`cursor-07-docs-wiki-courses.code-workspace`**.
2. Read **`docs/cursor-focused-workspaces.md` § Workspace 07** and **`docs/cursor-execution.md`** (step 7).

## Lane authority

- Objectives, repos in scope, spec outputs, exit gate: `docs/cursor-focused-workspaces.md` § Workspace 07

## Prior round

- `@dev/notes/rounds/cursor-06-themes-display-modes-2026-04-01.md` — **CLOSED**.

## Spec outputs (Workspace 07)

| Spec output | Primary artifact | Status |
| --- | --- | --- |
| Docs and wiki publishing architecture | `uDOS-docs/docs/publishing-architecture.md` | Done |
| Course-hook plan and onboarding funnels | `uDOS-docs/docs/course-hooks-and-onboarding.md` | Done |
| Local-hosted vs GitHub-hosted boundary | `uDOS-docs/docs/local-vs-github-docs-boundary.md` | Done |
| Knowledge library + public hub coherence | `uDOS-docs/docs/knowledge/README.md`, `docs/README.md`, `site/data/family-source.json`, `scripts/run-docs-checks.sh`, generated `site/data/*.json` + library HTML | Done |

## Exit gate (operator checklist)

Per `uDOS-docs/docs/publishing-architecture.md` § Operator checklist:

| Check | Evidence |
| --- | --- |
| **1. Entrypoints** | `uDOS-docs/docs/README.md` **Start Here** lists `publishing-architecture.md`, `local-vs-github-docs-boundary.md`, `course-hooks-and-onboarding.md`. `uDOS-docs/docs/onboarding.md` **Learn** links publishing + course-hooks. |
| **2. Ownership** | `uDOS-docs/docs/course-hooks-and-onboarding.md` defines wiki vs `docs/` vs `family-source.json`. |
| **3. End-to-end** | Closure run: `node scripts/generate-site-data.mjs` → `bash scripts/run-docs-checks.sh` (pass) in `uDOS-docs`; `site/index.html` and `site/reference.html` regenerated with manifest pages. |
| **4. Pages** | `uDOS-docs/.github/workflows/pages.yml` — on push to **`main`** (paths `site/**`, `scripts/**`, workflow), runs generate + docs checks + **deploy-pages**; publishing branch stays aligned with committed `site/` + generated JSON. |

## Progress summary

- Publishing trio + hub wiring landed earlier in the round; closure run revalidated the pipeline and recorded Pages automation as the deploy contract.
- Sibling README links: `uDOS-workspace/docs/README.md`, `uDOS-host/docs/README.md` → publishing trio (when checkouts present).
- **sonic-screwdriver** remains an adjacent clone; install-media cross-links when that tree is in the workspace.

## Next lane

`cursor-08-family-convergence.code-workspace` — `docs/cursor-execution.md` § Step 8.
