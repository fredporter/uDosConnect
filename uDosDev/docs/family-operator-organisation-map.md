# Family operator organisation map

**Public mirror (short, for library readers):** `uDOS-docs/docs/family-operator-organisation-map.md`
— keep in sync when changing reading order or major links.

**One-page index** for how the family fits together: **host**, **Wizard**,
**Sonic**, **offline/library**, **health and disk**, **GUI surfaces**, and
**process**. Use this when onboarding operators or when explaining “where to
start” without inventing a monorepo “home” repo.

There is **no git repo** for the operator’s chosen checkout root; see
`docs/udos-host-platform-posture.md` and `docs/family-first-run-operator-flow.md`.

## Operator journey (read first)

| Order | Document | What it covers |
| --- | --- | --- |
| 1 | `uDOS-docs/docs/onboarding.md` | Short map: use / learn / build; first-run pointers |
| 2 | `docs/family-first-run-operator-flow.md` | Wizard-led flow, intent profiles, plain language, on-demand vs offline fat, **prepare while connected**, **library vs runtime** |
| 3 | `docs/udos-host-platform-posture.md` | **uDOS-host** / **uDOS-server** vs **`uDOS-host`** repo; Linux + macOS; Windows scope; **LAN library**; **system health, disk, compost, spool**; Wizard as health **dashboard** (delegates to host) |
| 4 | `docs/foundation-distribution.md` | `~/.udos/` layout; Sonic vs host; **`~/.udos/library/`** retention vs runtime headroom |

## Surfaces (who owns which UI)

| Document | What it covers |
| --- | --- |
| `docs/gui-system-family-contract.md` | ThinUI vs browser vs Wizard **surface-ui** vs Ubuntu command-centre demo; Wizard **delegation** and optional **family health** role (cross-ref posture doc) |
| `docs/workspace-08-exit-evidence.md` § 1 | Ownership table: host, Core, Wizard, Shell, docs hub, … |

## Health, compost, runtime hygiene

| Document | What it covers |
| --- | --- |
| `docs/runtime-health-and-compost-policy.md` | `.compost` vs `~/.udos/` cleanup domains |
| `uDOS-core/docs/feeds-and-spool.md` | Feeds/spool contract (no silent bloat vs binders) |

## Documentation discipline and planning

| Document | What it covers |
| --- | --- |
| `docs/family-documentation-layout.md` | `docs/` vs `@dev/` vs `wiki/`; companion table |
| `docs/next-family-plan-gate.md` | When to open a new **`v2.x`** |
| `docs/cursor-execution.md` | Numbered lanes **01–08** (complete); post-08 via exit evidence |
| `docs/cursor-focused-workspaces.md` | Per-lane exit gates (historical) |
| `@dev/notes/roadmap/v2-family-roadmap.md` | Canonical surfaces + engineering backlog |
| `@dev/notes/roadmap/v2-roadmap-status.md` | Live status ledger |

## Active requests and handover

- `@dev/requests/active-index.md` — docs/wiki/host wording backlog
- [`docs/archive/cursor-handover-plan.md`](archive/cursor-handover-plan.md) — archived Cursor sequence and `~/.udos/` path reminder
