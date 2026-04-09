# Operational hygiene cadence (Post-08 O4)

- **Generated:** 2026-04-02  
- **Round:** `@dev/notes/roadmap/post-08-optional-rounds.md` **O4**  
- **Result:** **PASS** (no unresolved drift in checked paths)

## Scope exercised

1. **Learning Hub ↔ wiki files** — For each `wiki_units` entry in `uDOS-docs/site/data/family-source.json` whose GitHub URL matches `…/blob/main/…`, if the target repo exists under the family root, the referenced path must exist on disk (stale hub links fail the verify).
2. **Host-managed venv policy** — `uDOS-dev/@dev/fixtures/operational-hygiene-venv-lanes.v1.json` lists check scripts that must retain `~/.udos/venv/<lane>` defaults and `UDOS_VENV_DIR` override hooks when those repos are present. Optional: set **`UDOS_SONIC_SCREWDRIVER_ROOT`** to a checkout of `sonic-screwdriver` to include that lane.
3. **Docs vocabulary anchors** — `docs/gui-system-family-contract.md` retains ThinUI / Wizard / browser wording; when siblings exist, Core `wizard-surface-delegation-boundary.md`, Ubuntu `docs/activation.md`, and Wizard `docs/architecture.md` retain expected host / broker / delegation terms.

## Automation

- **`uDOS-dev/scripts/verify-o4-operational-hygiene.sh`** (wired **`run-dev-checks.sh`**).
- Environment: **`UDOS_FAMILY_ROOT`**, **`UDOS_DOCS_ROOT`** override default `uDOS-dev/..` layout.

## Operator habit

When adding a **new wiki unit** and listing it in **`family-source.json`**, land the markdown in the owning repo and run **`bash uDOS-docs/scripts/generate-site-data.mjs --check`** plus **`bash uDOS-dev/scripts/run-dev-checks.sh`** in the same change window.

## Related

- `@dev/requests/active-index.md` (wiki hub sync request)
- `v2-family-roadmap.md` engineering backlog (host venv row)
