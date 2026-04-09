# PR checklist (family)

Use this before opening or merging a PR. Adjust per repo; **uDOS-core** defines the **`green_proof`** pytest marker.

## Branch policy (main line)

- **Integration branch:** **`main`** is the default for all family repos. Avoid long-lived parallel branches (`develop`, `codex/*`, etc.); merge outstanding work into **`main`**, push, then **delete** merged remote branches.
- **Topic branches:** **not** the default. Create one only when there is a clear reason (risky change, long WIP, deliberate review isolation)—not out of habit. Name clearly (`fix/…`, `chore/…`), keep short, **delete after merge**.
- **Branch protection** on GitHub is **optional** per repo; the family habit is **stay on `main`** and avoid unnecessary branches. If GitHub **requires PRs** to update `main`, either **relax that rule** (recommended for solo maintenance) or accept **admin bypass** on direct pushes—both are fine; see **`docs/github-actions-family-contract.md`** § Branch protection and solo maintenance.
- **Cursor / Copilot:** `.cursor/rules/main-and-pr-finalization.mdc` and `.github/instructions/dev-workflow.instructions.md`.

## Dev inbox (family briefs)

- **`@dev/inbox/`** in any repo is **local scratch** (typically **gitignored**). Do not rely on it for reviewable or promotable prose.
- For **distributable** intake policy, templates, and **submission guidelines**, use **`docs/dev-inbox-framework.md`**, **`docs/dev-inbox/`** (`README.md`, `00`–`02` briefs), and **`docs/dev-inbox/guidelines/`**. Run **`bash scripts/bootstrap-dev-inbox.sh`** to install **`@dev/inbox/README.md`** and **`@dev/inbox/guidelines/`** locally; log large promotions in **`docs/inbox-ingest/README.md`**. Draft there or copy templates into a local inbox, then promote outcomes to `docs/`, `@dev/notes/`, `@dev/requests/`, or the owning repo.
- Full lifecycle context: **`docs/family-workflow.md`** (`@dev/inbox/` section).

## Named `v2.x` family plans (gate-controlled)

- Default integration is **repo-local semver** from baseline **`2.3.0`** (patch bumps usual). **Minor or major** bumps need explicit family alignment — see **`@dev/notes/roadmap/v2-family-roadmap.md`** and repo **`docs/activation.md`**.
- A **new numbered family plan** (`v2.6+`, themed rounds file) requires **`docs/next-family-plan-gate.md`** (**both** triggers). Do **not** add **`v2.X-rounds.md`** from a routine PR.
- When **preparing** evidence for a future plan: **`@dev/notes/roadmap/next-plan-readiness.md`** (draft themes + checklist; not itself a plan).

## Green proof (fast gate)

Where `pyproject.toml` registers `green_proof` (currently **uDOS-core** for logs/feeds/spool):

```bash
cd uDOS-core
pip install -e ".[dev]"
bash scripts/run-green-proof.sh
# or: python -m pytest -m green_proof -q --strict-markers
```

- **Pass** = minimal bounded contracts for logs → feeds → spool stay aligned with `docs/feeds-and-spool.md`.
- **Full suite** still required for merge: `python -m pytest` (CI runs the full run when `tests/` exists).

## Wizard / Surface (local API tests)

**`uDOS-wizard`** and **`uDOS-surface`** expose a **`dev`** optional extra (`httpx`, `pytest`) for `tests/test_api_contracts.py` (Starlette `TestClient` needs `httpx`). From the repo root:

```bash
pip install -e ".[dev]"
python -m pytest tests/test_api_contracts.py -q
```

If imports fail, install **`uDOS-core`** editable in the same environment (`pip install -e ../uDOS-core` from a sibling checkout, or your usual family layout).

## CI validate (required)

Repos with `pyproject.toml` + `tests/` use the reusable **Validate** workflow (`uDOS-dev/.github/workflows/validate.yml`): governance script + **`python -m pytest`** (entire suite).

**`uDOS-host` reference:** self-hosted workflows on **`main` only** (local `run-ubuntu-checks.sh` + `verify-command-centre-http.sh`); family **`promote.yml` is not required** in governance. See `uDOS-host/docs/activation.md` § GitHub Actions.

## Runtime spine (when touching Ubuntu / core / grid together)

From `uDOS-host`:

```bash
bash scripts/lane1-runtime-proof-tui.sh
```

## Stable release snapshot (family)

A **stable release** here means **repo-local semver and validation** alongside the **current family plan lane**. **`v2.6`** is **completed** (`v2.6-rounds.md`; release pass **`scripts/run-v2-6-release-pass.sh`**). A **future** **`v2.7+`** uses **`docs/next-family-plan-gate.md`**. Tier-1 scope for “first coherent uDOS” is **`docs/release-tier-map.md`**.

**Before tagging or announcing a stability cut:**

1. **Governance plane:** from **`uDOS-dev`**, `bash scripts/run-dev-checks.sh` (includes below-gate bundle: `verify-engineering-backlog-below-gate.sh`).
2. **Roadmap ledger (optional):** `bash scripts/run-roadmap-status.sh`; promote a snapshot only if you need a dated artifact (`git add -f` for `roadmap-status-*.md` per `.gitignore` comment).
3. **Command-centre host:** `bash scripts/run-ubuntu-checks.sh` in **`uDOS-host`** when host contracts, policy examples, or check scripts changed.
4. **Tier-1 repos you touched:** each repo’s `scripts/run-*-checks.sh` (or CI green); **Core** `green_proof` / full pytest when contracts or feeds/spool move.
5. **GitHub contract drift:** if workflows or `family-repos.sh` changed, `automation/check-github-contract-rollforward.sh` with your usual `ROOT_DIR` / `UDOS_GITHUB_CONTRACT_REPO_ROOTS`.
6. **Versioning:** default **patch** bumps from baseline **`2.3.0`**; **minor/major** only with explicit alignment (**Named `v2.x` family plans** above).

## PR description

- [ ] Behaviour change described; tests or checks updated where needed  
- [ ] `green_proof` passes (uDOS-core) if contracts or feeds/spool paths changed  
- [ ] Full `pytest` passes locally for repos you touched  
- [ ] `run-ubuntu-checks.sh` if `uDOS-host` changed  
- [ ] If using a PR: targets **`main`**; remove remote topic branch after merge  
- [ ] Cross-repo or multi-step work: brief aligned with **`docs/dev-inbox-framework.md`** / **`docs/dev-inbox/`** where helpful (local **`@dev/inbox/`** is not versioned)  

## GitHub (maintainers)

**Branch protection is optional.** Use it only if a repo needs enforced reviews or checks. Either way, prefer **working on `main`** and **not** creating branches unless there is a concrete reason. Document per-repo quirks in `docs/activation.md` or the repo README if needed.
