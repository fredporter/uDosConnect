# Active Request Index

This is the compact family-level request index.

**Workspace 08 (2026-04-01):** **08-doc scope** for requests **1–2** is **closed** in the gap matrix (`@dev/notes/rounds/cursor-08-family-convergence-2026-04-01.md` row **1**, audit § Final round). **Post-08:** **`family-source.json`** hub sync **tranche 1** done for tier-1 + Wizard + Dev (request **3** progress). **2026-04-02:** `docs/post-08-backlog-snapshot.md` ledger (sections A–G) marked complete; remaining work is **operational** (wiki hub sync when units ship) per this index.

**Optional backlog OB-R3 (2026-04-03):** **`docs/optional-backlog-rounds-1-7.md`** Round 3 — hygiene pass for requests **1–2**: `bash scripts/verify-o4-operational-hygiene.sh` **pass**; report `@dev/notes/reports/optional-backlog-round-3-2026-04-03.md`. When you add wiki units or hub cards, run O4 in the same change window and update `uDOS-docs/site/data/family-source.json` per **`uDOS-docs/docs/publishing-architecture.md`**.

## Current Active Family Requests (post-08 operational tails)

### 1. Docs consolidation and public library cleanup

- **Owner:** `uDOS-dev` coordinating with family repos  
- **Outcome:** lean `docs/` / `@dev/` / `wiki/` structure across the family  
- **Canonical boundary:** `uDOS-docs/docs/local-vs-github-docs-boundary.md`  
- **Implementation (started):** `uDOS-dev/docs/family-documentation-layout.md` — three-surface rules, ownership split, per-repo backlog bullets  
- **Acceptance (family):** tier-1 repos do not duplicate full manuals that belong in another repo; hub cards in `uDOS-docs` `site/data/family-source.json` stay in sync with real `wiki/` units when added  
- **Workspace 08:** tracked in `@dev/notes/rounds/cursor-08-family-convergence-2026-04-01.md` gap matrix row 1 / 7 / 8  
- **Post-08 normalization:** this is now an **operational maintenance lane**, not a one-off backlog closure item.

### 2. Wiki rollout and educational unit coverage

- **Owner:** each family repo  
- **Outcome:** one practical intro **wiki** unit per repo (where the repo ships a `wiki/` tree)  
- **Acceptance:** unit listed from `uDOS-docs` learning hub / `family-source.json` when published  
- **Progress (2026-04-01):** learning page **Wiki Units** + top-level **`wiki_units`** in `site/data/family-source.json` now cover **tier-1 spine** repos (Core, Ubuntu, Shell, ThinUI, Themes, Workspace, Grid), **`uDOS-docs`** Family Basics, **`uDOS-wizard`** (new **unit-01** + repo card), **`uDOS-dev`** (new **unit-01**), and optional/product repos already shipping `wiki/unit-01-*` (`uDOS-groovebox`, `uDOS-alpine`, `uDOS-gameplay`, `uDOS-empire`, `uDOS-plugin-index`); Ubuntu blob/tree links use **`main`**.  
- **Workspace 08:** Post-08 execution per repo; index stays until units exist or request is moved repo-local  
- **Post-08 normalization:** keep as **continuous acceptance hygiene** (when units are added, refresh `uDOS-docs` hub data in the same change window). **O4 (2026-04-02):** automated drift guard — `uDOS-dev/scripts/verify-o4-operational-hygiene.sh` (wiki index vs on-disk files for present siblings, venv lane strings, vocabulary anchors); report `@dev/notes/reports/operational-hygiene-cadence-o4-2026-04-02.md`.

## Rule

If a request becomes repo-owned, move it into that repo and remove it from this
index.

## Recently completed in family lane

### Ubuntu host and surface or broker split cleanup

- **Status:** baseline complete in post-08 pass; keep wording vigilance when editing first-run or activation docs
- **Outcome achieved:** stable **runtime host** vs **orchestration** vs **browser operator** vocabulary across family guidance
- **Evidence lane:** `docs/gui-system-family-contract.md`, `uDOS-core/docs/wizard-surface-delegation-boundary.md`, `uDOS-host/docs/activation.md`, `uDOS-wizard/docs/architecture.md`, Workspace 08 round review
