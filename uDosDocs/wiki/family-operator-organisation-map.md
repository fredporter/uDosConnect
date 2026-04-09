# Family operator organisation map

A one-page map of **who does what** when you operate the uDOS family: which repos sit on the host, which surfaces talk to you, and where public learning lives.

For a longer reader-friendly index (host, Wizard, Sonic, first-run, health doc links into `uDOS-dev`), see [`docs/family-operator-organisation-map.md`](https://github.com/fredporter/uDOS-docs/blob/main/docs/family-operator-organisation-map.md).

## Three layers

| Layer | Role | Typical repos |
| --- | --- | --- |
| **Host runtime** | Always-on services, local execution, networking, vault/sync posture on the machine you treat as command centre. | `uDOS-host`, `uDOS-core` |
| **Operator surfaces** | How you drive the system: TUI, thin fullscreen UI, browser workspace, orchestration broker. | `uDOS-shell`, `uDOS-thinui`, `uDOS-workspace`, `uDOS-wizard`, `uDOS-surface` |
| **Shared contracts and look** | Deterministic semantics, schemas, and cross-surface visuals. | `uDOS-core`, `uDOS-themes` |
| **Library and coordination** | Public explanation, onboarding, policy, and cross-repo hygiene. | `uDOS-docs`, `uDOS-dev` |

Use **`uDOS-core`** for *what the family agrees is true* (contracts). Use **`uDOS-host`** for *what actually runs on the Ubuntu host*. Use **`uDOS-wizard`** for *orchestration and dev-time operator HTTP*; use **`uDOS-surface`** for the browser-facing layer that retains the broker-facing story.

## Repo groups (canonical names)

These names match **`site/data/family-source.json`** `repo_groups` so metadata, the public library, and this map stay aligned.

### Runtime spine

Command-centre host, contracts, shell, themes, and operator-facing runtime surfaces.

- **uDOS-core** — Contracts, schemas, offline-first boundaries.
- **uDOS-host** — Always-on host runtime (services, execution, networking).
- **uDOS-shell** — Operator shell language and TUI path.
- **uDOS-thinui** — Thin fullscreen surfaces and low-resource UI.
- **uDOS-themes** — Theme packs, tokens, adapters, skins.
- **uDOS-workspace** — Binder-driven browser workspace shell.

### Surface and library

Browser-facing navigation and public knowledge.

- **uDOS-surface** — Surface UI and broker-facing browser layer.
- **uDOS-wizard** — Orchestration, MCP, workflows, operator HTTP surfaces.
- **uDOS-docs** — Public library, architecture, onboarding, learning paths.
- **uDOS-dev** — Family coordination, release policy, cross-repo docs layout.

### Optional modules

Extensions once the spine is clear (examples: empire, gameplay, grid, plugin index). See `family-source.json` for the full list.

### uHOME stream

Household media, kiosk thin UI, LAN server, Matter — coordinated at family level via **`uDOS-dev`** (see `docs/uhome-stream.md` there).

## Where to go next

- **First read:** [Onboarding](https://github.com/fredporter/uDOS-docs/blob/main/docs/onboarding.md), [Family learning path](https://github.com/fredporter/uDOS-docs/blob/main/architecture/07_family_learning_path.md).
- **Per-repo intros:** Wiki units on the [Learning Hub](https://fredporter.github.io/uDOS-docs/site/learning.html) (Surface, Core, Ubuntu, Wizard, Shell, and the rest).
- **Family basics unit:** [Unit 01: Family Basics](https://github.com/fredporter/uDOS-docs/blob/main/wiki/unit-01-family-basics.md).

## Quick check

You can use this map if you can answer:

- Which repo owns **host execution** vs **browser orchestration**?
- Where do **stable contracts** live vs **operator UX**?
- Which repo is the **public library spine** vs **internal coordination**?
