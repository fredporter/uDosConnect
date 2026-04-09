# Family documentation layout

**Workspace 08 / gap matrix row 1.** Defines where prose lives across the family
so `docs/`, `@dev/`, and `wiki/` stay lean and non-duplicative.

## Canonical companions

**Index:** `docs/family-operator-organisation-map.md` — reading order for operator
journey, host posture, surfaces, health, and planning docs below.

Read these together; they are source of truth for boundaries:

| Topic | Document |
| --- | --- |
| Local checkout vs Pages vs `blob` review | `uDOS-docs/docs/local-vs-github-docs-boundary.md` |
| Library build, `family-source.json`, operator checklist | `uDOS-docs/docs/publishing-architecture.md` |
| Wiki vs `docs/` vs learning metadata | `uDOS-docs/docs/course-hooks-and-onboarding.md` |
| `uDOS-dev/@dev` vs repo-local `@dev` | `uDOS-dev/docs/repo-local-dev-workspaces.md` |
| Runtime host vs orchestration vs browser GUI | `uDOS-dev/docs/gui-system-family-contract.md` |
| **uDOS-host** naming, Linux/macOS tiers, Windows scope | `uDOS-dev/docs/udos-host-platform-posture.md` |
| Wizard-led first run, GUI-first, Sonic device DB | `uDOS-dev/docs/family-first-run-operator-flow.md` |
| Single map of organisation docs | `uDOS-dev/docs/family-operator-organisation-map.md` (public short mirror: `uDOS-docs/docs/family-operator-organisation-map.md`) |
| Install topology, `~/.udos/`, library retention | `uDOS-dev/docs/foundation-distribution.md` |
| Compost vs runtime cleanup | `uDOS-dev/docs/runtime-health-and-compost-policy.md` |

## Three surfaces

| Surface | Typical location | Audience | Put here |
| --- | --- | --- | --- |
| **Public `docs/`** | Each repo `docs/`; family hub in `uDOS-docs/docs/` | Operators, integrators, PR reviewers | Stable contracts, activation, runbooks, architecture that must ship with the repo |
| **`@dev/`** | `uDOS-dev/@dev/` (family plane); `<repo>/@dev/` (repo plane) | Maintainers, Cursor lanes, binders | Roadmap, rounds, audits, requests, pathways — not reader onboarding |
| **`wiki/`** | Optional per-repo `wiki/` | Beginners, short how-tos | One practical intro unit per repo when present; linked from `family-source.json` when published |

**Rule:** If text is useful to a **first-time reader** of the library site, prefer
`uDOS-docs` or the **owning repo’s** `docs/` or `wiki/` — not `uDOS-dev/@dev`.

## Ownership split

- **`uDOS-docs`** — cross-repo concepts, publishing, GKL, themes hub pages,
  links into sibling repos. Does **not** replace each repo’s operator manual.
- **Tier-1 implementation repos** (Core, Shell, Wizard, Ubuntu, …) — authoritative
  `docs/` for that binary or service: install, config, health checks, contracts.
- **`uDOS-dev`** — process, Cursor workspaces, governance, **this** layout doc,
  family roadmap status.

## Row 1 implementation backlog (Post-08, per repo)

Execute as small PRs; track completion in the Workspace 08 duplication report or
repo-local `@dev` notes.

1. **Each tier-1 repo:** Add or refresh `docs/README.md` (or top of `README.md`)
   with 3 bullets: what lives in `docs/`, what (if anything) in `wiki/`, pointer
   to `uDOS-dev/docs/family-documentation-layout.md`. **Done:** `uDOS-core`,
   `uDOS-host`, `uDOS-wizard`, `uDOS-workspace`, `uDOS-plugin-index`, `uDOS-shell`,
   `uDOS-thinui`, `uDOS-themes`, `uDOS-grid`, `uDOS-alpine`, `uDOS-gameplay`,
   `uDOS-empire`; `uDOS-docs/docs/README.md`; `sonic-screwdriver/docs/README.md`
   (text pointer to `uDOS-dev`). **Optional later:** `sonic-ventoy`, `uHOME-*`,
   mobile app repos if they add `docs/README.md`.
2. **`uDOS-docs`:** When adding a wiki unit in a sibling repo, update
   `site/data/family-source.json` in the same change set so the library shell
   stays honest.
3. **Ubuntu / host wording (active-index request 2):** **Updated:** `uDOS-host`
   `docs/activation.md` § Host vs browser operator; `docs/architecture.md` boundary;
   `docs/linux-first-run-quickstart.md` opening (spine vs Wizard). `uDOS-wizard`:
   `docs/architecture.md` + `docs/getting-started.md` (dev HTTP server vs spine).
   **Remaining:** optional read-through of `first-run-story.md` only if operators
   report confusion.
4. **OB-R3 cadence (optional backlog, 2026-04-03):** After edits to **`wiki/`** or
   **`family-source.json` / `wiki_units`**, run **`uDOS-dev/scripts/verify-o4-operational-hygiene.sh`**
   locally. Ledger: **`docs/optional-backlog-rounds-1-7.md`** Round 3; report
   **`@dev/notes/reports/optional-backlog-round-3-2026-04-03.md`**.

## Related family requests

- `@dev/requests/active-index.md` — docs consolidation, wiki units, host/surface
  wording; acceptance criteria reference this file.

## Related process

- `docs/next-family-plan-gate.md` — when to name a new `v2.x` after `v2.5`
- `docs/family-workspace-08-scope.md` — deferred post-`v2.5` features, v1/`uDOS-docs` posture, cross-cutting themes
- `@dev/notes/reports/family-duplication-and-pathway-candidates-2026-04-01.md` — pathway candidates + duplication stub (Workspace 08)
