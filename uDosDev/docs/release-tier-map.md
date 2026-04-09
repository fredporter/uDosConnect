# Release tier map

This file is the **stable public index** for how repos are prioritized during
v2 family completion. Cursor lane order is still governed by
`docs/cursor-execution.md` and `docs/cursor-focused-workspaces.md`; this map
answers “what must ship first” in product terms.

## Tier 1 — required for first coherent uDOS release

These repos define contracts, the always-on runtime, operator shell, primary
documentation, and governance automation.

| Repo | Role |
| --- | --- |
| `uDOS-core` | Semantic contracts and deterministic execution |
| `uDOS-shell` | Interactive shell and CLI-facing UX |
| `uDOS-host` | Always-on command-centre runtime host |
| `uDOS-wizard` | Orchestration, providers, MCP, autonomy |
| `uDOS-grid` | Spatial identity and registries |
| `uDOS-plugin-index` | Plugin and package metadata registry |
| `uDOS-themes` | Presentation tokens and shell-facing assets |
| `uDOS-thinui` | Thin UI surfaces aligned to Core |
| `uDOS-workspace` | Binder-first browser workspace |
| `uDOS-docs` | Public docs and onboarding hub |
| `uDOS-dev` | Family control plane, pathways, and automation |

## Tier 2 — product or extension modules

Ship when ready; must not block Tier 1 completion.

| Repo | Role |
| --- | --- |
| `uDOS-groovebox` | Music / Songscribe product lane |
| `uDOS-gameplay` | Gameplay and simulation patterns |
| `uDOS-empire` | Sync / CRM / publishing extensions |
| `uDOS-alpine` | Lean Core + TUI/ThinUI profile (optional host) |

## Tier 3 — adjacent families and delayed streams

Consumed through **stable contracts**; not in the core working-set completion
gate. Install and handoff are specified in `docs/foundation-distribution.md` and
`docs/family-split-prep.md`.

| Repo / stream | Role |
| --- | --- |
| `sonic-screwdriver` | First-entry install, deployment, recovery |
| `sonic-ventoy` | Boot-media assets consumed via Sonic |
| `uHOME-*` | uHOME product stream after runtime spine |

## Related

- `docs/repo-family-map.md` — dependency and ownership table
- `docs/cursor-focused-workspaces.md` — numbered Cursor lanes
- `@dev/notes/roadmap/v2-family-roadmap.md` — live sequencing and round index
