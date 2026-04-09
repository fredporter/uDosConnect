---
applyTo: "**"
---

# uDOS v2 Dev Workflow Instructions

These instructions give GitHub Copilot full context on the uDOS v2 development
workflow so agent sessions can continue without re-reading governance docs from
scratch.

---

## Main line and pull requests (2026)

- **`main`** is the only long-lived integration branch. Merge outstanding topic
  or legacy branches into **`main`**, then delete merged remote branches.
- **Do not** create branches out of habit. **Default to commits on `main`.**
  Use a **short-lived** branch only for a clear reason (risky change, long WIP,
  deliberate review isolation). **Branch protection on GitHub is optional**—the
  habit is restraint, not tooling. **Solo linear work:** prefer **allow direct
  pushes to `main`** (or admin bypass). Messages like “Changes must be made
  through a pull request” mean **settings** still want a PR—relax the rule or
  bypass; see `docs/github-actions-family-contract.md` § Branch protection and
  solo maintenance.
- When you do use a PR: base on latest **`main`**, green CI, fill
  `.github/pull_request_template.md` when helpful, merge, delete the topic branch.
- Cursor agents: `.cursor/rules/main-and-pr-finalization.mdc` and
  `docs/pr-checklist.md`.

**Dev inbox:** `@dev/inbox/` is **local scratch** (often gitignored). Use
**`docs/dev-inbox-framework.md`** and **`docs/dev-inbox/`** for distributable
brief templates; promote outcomes to `docs/`, `@dev/notes/`, or `@dev/requests/`.

---

## Workspace Folders (17 public repos)

| Folder | Purpose |
| --- | --- |
| `uDOS-core` | runtime contracts and deterministic execution — no upstream public deps |
| `uDOS-shell` | interactive shell and public UX surfaces — depends on `uDOS-core` |
| `uDOS-grid` | canonical spatial identity, layers, seed registries, place-bound artifacts |
| `sonic-screwdriver` | bootstrap, install, update, managed environments |
| `uDOS-plugin-index` | plugin and package metadata registry |
| `uDOS-wizard` | providers, API bridges, MCP, autonomy controls |
| `uDOS-gameplay` | gameplay and simulation patterns |
| `uDOS-empire` | always-on sync, CRM, and publishing extension surfaces |
| `uHOME-matter` | Matter and Home Assistant local automation extension |
| `uDOS-dev` | binder workflow, governance, automation (owns workflow, not runtime) |
| `uDOS-themes` | themes, tokens, shell-facing assets |
| `uDOS-docs` | canonical public docs and onboarding |
| `uDOS-alpine` | APK packaging and lean Alpine profiles |
| `uHOME-client` | lightweight local-network client runtime and contract consumption |
| `uHOME-server` | always-on local-network runtime |
| `uHOME-app-android` | Android application — uHOME UI and kiosk lane |
| `uHOME-app-ios` | iOS application — uHOME UI and kiosk lane |

Private family: `omd-mac-osx-app` — no public repo may depend on it.

---

## Dependency Direction Rules

- `uDOS-core` depends on nothing in the public family
- `uDOS-grid` consumes `uDOS-core` contracts; must not depend on `uDOS-gameplay`
- `uDOS-dev` coordinates, does not own runtime behavior
- Packaging repos (`sonic-screwdriver`, `uDOS-alpine`) do not redefine semantics
- Mobile repos depend on `uDOS-core`, `uHOME-client`, and `uHOME-server` contracts only

---

## Binder Lifecycle (8 stages)

Every non-trivial cross-repo change moves through:

1. **Open** — create or identify a tracked work item; assign a binder ID
2. **Hand off** — place work in `@dev/requests/` or `@dev/submissions/`; define owner, scope, blockers, success criteria
3. **Advance** — do the active local work; keep changes bounded to one objective; sequence by dependency owner first
4. **Review** — confirm boundary ownership, docs, repo requirements, promotable outputs
5. **Commit** — checkpoint local progress; use outcome-driven commit messages
6. **Complete** — binder objective is materially finished; tests, docs, examples updated
7. **Compile** — clean binder output into reviewable, repo-facing changes; remove scratch material
8. **Promote** — land changes on **`main`** (direct push is normal; open a PR if you want review or isolation); release tags cut from **`main`**. Do not maintain parallel long-lived `develop` lines unless a repo explicitly documents an exception.

Binder ID convention: `#binder/<repo-or-stream>-v2-0-x-<objective>`

---

## `@dev` Directory Convention

`uDOS-dev/@dev` is the family control plane. Repo-owned instructions, targeted
upgrade packs, and deep-dive round notes belong in the owning repo's local
`@dev/` tree.

```
@dev/
  inbox/         local first-pass capture (gitignored in uDOS-dev); templates in docs/dev-inbox/
  requests/      incoming binder handoffs, repo-facing requests
  submissions/   finished or review-ready outputs, candidates for promotion
  triage/        normalized scope and boundary notes
  routing/       brief routing manifests, downstream targeting rules
  promotions/    repo-facing outputs prepared from triaged briefs
  pathways/      contributor learning paths, binder templates, repeatable processes
  notes/
    roadmap/     live roadmap tracking (canonical active surface)
      v2-family-roadmap.md
      v2-roadmap-status.md
      v2.0.3-rounds.md
      v2.0.4-rounds.md
      ...
  logs/          generated run logs
  reports/       generated roadmap reports
```

Repo-local repos may add focused folders such as `@dev/v2-upgrade/` when a
single repo needs a deeper round without turning that material into
family-level governance state.

---

## Roadmap Canonical Surfaces

| File | Role |
| --- | --- |
| `@dev/notes/roadmap/v2-family-roadmap.md` | live family roadmap overview and active round pointer |
| `@dev/notes/roadmap/v2-roadmap-status.md` | version-round ledger with status for every round |
| `@dev/notes/roadmap/v2.0.3-rounds.md` | round detail for active version v2.0.3 |
| `@dev/notes/roadmap/v2.0.4-rounds.md` | staged detail for next version v2.0.4 |
| `docs/development-roadmap.md` | stable public-facing roadmap history |
| `docs/repo-family-map.md` | repo ownership, dependency, and boundary table |
| `docs/family-workflow.md` | binder lifecycle and `@dev` structure reference |
| `docs/roadmap-workflow.md` | how rounds advance, fractional bumps, binder rules |

---

## Round/Promote/Close Cycle

### Advancing a round

1. Update `@dev/notes/roadmap/v2-roadmap-status.md` — change round status to `completed`
2. Update `@dev/notes/roadmap/v2-family-roadmap.md` — advance `active round` pointer
3. Update the relevant `v2.0.x-rounds.md` — mark round accepted, record outputs
4. Close the binder in `@dev/submissions/`
5. Commit `uDOS-dev` with an outcome-driven message

### Opening the next round

1. Find the next `pending` round in the ledger
2. Change its status to `in-progress`
3. Open the binder request in `@dev/requests/`
4. Begin work in the owning repo(s)

### Promotion

1. Run `scripts/run-roadmap-status.sh` to generate a status report (from `uDOS-dev` repo root).
2. Write promotion notes covering what landed in this version
3. Verify all family tests pass before promoting
4. Land on **`main`** (direct commit/push is fine). Use a **PR** when you choose to; delete merged topic branches on the remote if you used one.
5. Cut the release tag from **`main`** after the change is integrated

---

## Round Status Values

- `pending`
- `in-progress`
- `blocked`
- `completed`

Only one round should be `in-progress` at a time unless an explicit cross-repo parallel pass is tracked.

---

## `@dev` Tag Convention

Tags pin work to a binder or round:

- format: `@dev/<descriptive-slug>`
- examples: `@dev/dev-agent-assist`, `@dev/wizard-mcp-vscode`, `@dev/grid-consumption`
- tags appear in: round files, binder requests, commit messages, planning notes

---

## Current active state (canonical)

Do **not** treat this file as the live ledger. Use:

- `@dev/notes/roadmap/v2-roadmap-status.md`
- `@dev/notes/roadmap/v2-family-roadmap.md`

---

## Validation Script

```bash
cd uDOS-dev
bash scripts/run-roadmap-status.sh
```

Runs all family test suites and generates a report in `@dev/reports/`.

---

## Commit Message Convention

Use outcome-driven messages, not activity descriptions:

```
v2.0.3 Round C: <what is now true>

- <change 1>
- <change 2>
```

Avoid: "ran tests", "updated file", "fixed things". Prefer: "test suite green across 8 repos", "Grid spatial contracts locked".

---

## Key Governance Rules (Quick Reference)

- `uDOS-core` owns semantic boundary — all contract definitions start here
- `uDOS-dev` owns workflow — binder process, sync policy, family automation
- `uDOS-grid` owns spatial truth — spatial identity never moves to gameplay or core datasets
- Wizard MCP integration belongs in v2.0.4 after networking boundaries are locked
- No merge to **`main`** without passing required checks for the repos touched (family-wide sweeps when appropriate)
- No public repo depends on `omd-mac-osx-app`
- Packaging repos read contracts; they never define them
