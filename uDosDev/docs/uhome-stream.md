# uHOME stream (family lane)

Canonical **sequencing and boundaries** for the uHOME product family relative
to the uDOS runtime spine. Cursor workspace **03** closed **2026-03-31**; this
doc remains the stream reference for operators deciding where a change belongs.

**Related:** planning history in [`uhome-v2-architecture-alignment.md`](uhome-v2-architecture-alignment.md); lane objectives in [`cursor-focused-workspaces.md`](cursor-focused-workspaces.md) § Workspace 03.

## Cursor workspace 03 — thin UI runbook (reference)

**Round closed 2026-03-31** (`@dev/notes/rounds/cursor-03-uhome-stream-2026-03-31.md`). Keep this section as the **operator runbook** for re-checking thin HTML.

**Run:** from `uHOME-server` repo, `source .venv/bin/activate`, then  
`python -m uvicorn uhome_server.app:app --host 127.0.0.1 --port 8000`  
(`QUICKSTART.md` uses **`8000`**; use any port and substitute below).

- `http://127.0.0.1:8000/api/runtime/thin/automation` — status HTML + Tailwind Typography block
- `http://127.0.0.1:8000/api/runtime/thin/read` — default **prose** reading page (markdown → HTML)
- `http://127.0.0.1:8000/api/runtime/thin/browse?rel=pathway/README.md` — sample file under `docs/` in the checkout

Stylesheet: `/static/thin/prose.css` (built from `@tailwindcss/typography`; rebuild via `uHOME-server/thin-prose-build/`).

## Sequencing after the runtime spine

- **Primary Ubuntu / `~/.udos/` runtime** is owned by **`uDOS-host`** and the
  family **runtime spine** ([`runtime-spine.md`](runtime-spine.md)). uHOME does
  not redefine that host layout.
- **uHOME** ships as a **downstream household stream**: Linux uHOME host runs
  **`uHOME-server`** (API, kiosk, media, scheduling) on a normal LAN; install
  and recovery paths are **`sonic-screwdriver`** (Ventoy/USB/dual-boot), not
  Wizard-first flows.
- **`uDOS-wizard`** remains optional **orchestration** on the command-centre
  story. The **regular-LAN uHOME baseline** does not require a Wizard checkout;
  network policy contracts ship inside `uHOME-server`. Optional alignment with
  uDOS-host command-centre networking is explicitly **future** scope (see
  `uHOME-server` `docs/architecture.md`).

## Role matrix (repos)

| Role | Repo | Owns |
| --- | --- | --- |
| Household server runtime | `uHOME-server` | Local API, kiosk/thin UI, media, scheduling, LAN services, policy contracts under `src/uhome_server/contracts/` |
| Shared client runtime | `uHOME-client` | Runtime profile map, session offers, contract consumption for apps; not server semantics |
| HA / Matter extension | `uHOME-matter` | Bridge and clone contracts, adapter catalogs; extends server without owning base runtime |
| Mobile / platform UI | `uHOME-app-android`, `uHOME-app-ios` | App shells and presentation; consume `uHOME-client` contracts |
| Bootstrap / imaging | `sonic-screwdriver` | USB, Ventoy, dual-boot, recovery; first-step install partner for uHOME on metal |
| Coordination + docs | `uDOS-dev`, `uDOS-docs` | Roadmap, stream notes, cross-family docs |

**Optional adjacent (not required on the uHOME LAN baseline):** `uDOS-core`
for shared artifact shapes; `uDOS-empire` for remote sync/webhook/container
workflows (`uhome-v2-architecture-alignment.md`).

## Wizard and core boundary

- **`uDOS-wizard`:** Broker/orchestration for operator workflows; **not** the
  uHOME media/console runtime. uHOME may integrate later for command-centre
  scenarios; default product stands alone on documented contracts.
- **`uDOS-core`:** Optional compatibility for shared JSON/sync semantics; uHOME
  remains a **standalone product**, not a subordinate service (`uHOME-server`
  `docs/architecture.md` § Contract edges).

## Dependency contract (back to spine)

- **Materialised layout** and long-lived host daemons follow **`runtime-spine.md`**
  and `uDOS-host` scripts when uHOME sits on a full uDOS workstation.
- **uHOME-server** `docs/base-runtime-boundary.md` states what the server owns
  vs `sonic-screwdriver`, `uHOME-matter`, and client/app repos.
- **uHOME-matter** `docs/server-runtime-handoff.md` states extension vs runtime
  ownership.
- **uHOME-client** `src/runtime-profile-map.json` declares supported
  **`family_modes`**: `standalone-uhome` (household-only) and `integrated-udos`
  (full family checkout / command-centre adjacent).

## Working the stream separately

The uHOME repos listed in the role matrix can be developed and validated on
their own check scripts and tests (`run-uhome-server-checks.sh`,
`run-uhome-client-checks.sh`, matter/app CI) without blocking on unrelated
core uDOS completion, provided contract edges above stay honest.
