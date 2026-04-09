# Family Onboarding

## Purpose

This is the short onboarding map for the family.

**Reader map (same folder):** [`family-operator-organisation-map.md`](family-operator-organisation-map.md)
— how host, Wizard, Sonic, and docs fit together without opening **`uDOS-dev`**
first. Maintainers: canonical tables live in
[`uDOS-dev/docs/family-operator-organisation-map.md`](../../uDOS-dev/docs/family-operator-organisation-map.md).

The goal is not to reproduce the old monorepo mission flow verbatim. The goal
is to help a new user understand where to start and which repo owns which part
of the experience.

## Start Here

1. Read the family overview in `README.md`.
2. Read `architecture/07_family_learning_path.md`.
3. Pick one entry path:
   - use
   - learn
   - build

## Use

Use this path if you want to run current products.

- **uDOS-host** (implemented in the **`uDOS-host`** repo) for the command
  centre, local runtime, `~/.udos/` layout, vault, sync, scheduling, and host
  networking — see `uDOS-dev/docs/udos-host-platform-posture.md` for **Linux /
  macOS** tiers and **Windows** scope (dual-boot / uHOME gaming; bare Windows is
  not a host target)
- `uDOS-alpine` for the lightweight Core + TUI + ThinUI companion runtime profile
- `sonic-screwdriver` for install, deployment, recovery, and setup
- `uHOME-server` for the later `uHOME` service stream and ThinUI/local console
  surfaces built on the wider runtime spine
- `uDOS-surface` for browser presentation and surface UI
- `uDOS-wizard` for broker and adapter-facing family routing
- Apple-native apps for selective local user-touch advancement and private sync

## Learn

Use this path if you want the architecture and course ladder.

- `uDOS-docs` for family explanations
- Library site metadata, Pages flow, and wiki/course ownership:
  `docs/publishing-architecture.md`, `docs/course-hooks-and-onboarding.md`
- `uHOME-server/courses/` for local-network and Beacon Activate teaching
- `uDOS-empire` docs for webhook/API automation patterns

## Build

Use this path if you want to work with real contracts and examples.

- `uDOS-core` for canonical semantics
- `uDOS-shell` for operator-facing routing and preview surfaces
- `uDOS-host` for the command-centre host shape
- `uDOS-surface` for browser presentation
- `uDOS-wizard` for broker and adapter-facing family routing
- `uDOS-plugin-index` for plugin trust and compatibility metadata
- `uDOS-themes` for shell and publishing token bridges
- `uDOS-empire` for webhook, sync, CRM, and mapping contracts
- `uHOME-server` for household services and ThinUI/local console surfaces

## First-time operator flow (target story)

The family’s **intended** beginner path is **Wizard-first**, **click-first** for
most people, then Sonic for USB/Ventoy-style menus, **organic** growth of the
local stack, and **Sonic** as the place to **extend / repair / reinstall**. Full
step map, **intent-based profiles** (e.g. uHOME-only vs minimal document work),
and Sonic **global + user device** data model:

- `uDOS-dev/docs/family-first-run-operator-flow.md`

**Maintainers / full doc map:** `uDOS-dev/docs/family-operator-organisation-map.md`
lists host posture, foundation paths, GUI contract, health/compost, and planning
docs in **reading order**.

**Operator-friendly wording:** Wizard should **not** assume everyone knows
“TUI” or “GUI” — it asks what you want to **do** and how you like to work
(browser vs terminal). **Dependencies** (e.g. terminal UI stacks such as Shell’s
**Bubble Tea** graph) install **on demand** when you actually need that path, not
on every install. **Exception:** if you explicitly choose a **full local
offline** install up front, the family may pre-stage a **fat bundle** for that
profile. **Survival posture:** while you still have connectivity, a **library
host** can **prefetch** into local storage and serve the **LAN** — when the grid
is down it is too late to download what you need; see
`uDOS-dev/docs/udos-host-platform-posture.md` § **Offline-first survival posture**.

Cold USB / bare metal may still use **Sonic** before Linux exists; after Linux,
**Wizard** is the recommended entry (see that doc).

## First Practical Rule

Start with the smallest owned surface you can understand.

Do not start by reading the whole archive or trying to absorb the entire family
at once.

## Next Docs

- `uDOS-dev/docs/family-first-run-operator-flow.md` (Wizard-led install story)
- `docs/getting-started.md`
- `architecture/10_v2_0_1_platform_spine.md`
- `architecture/07_family_learning_path.md`
- `docs/binders-and-publishing.md`
