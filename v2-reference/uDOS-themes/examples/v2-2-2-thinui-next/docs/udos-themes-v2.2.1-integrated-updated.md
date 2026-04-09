# uDOS-themes v2.2.1 — Integrated Updated Spec

## Status

Draft recommendation for v2.2.1.

## Purpose

uDOS-themes is the dedicated visual system repo for uDOS v2.

It owns:

- theme packs
- design tokens
- adapter bridges
- font packs
- loading sequences
- GUI skin mappings
- runtime-safe theme manifests

It does not own runtime semantics.

Core, thinui, wizard, shell, and gameplay surfaces consume theme contracts from this repo.

## Position in v2.2.1

uDOS-themes remains the canonical theme layer.

The v2.2.1 update expands the repo from browser-first theme assets into a multi-surface theme system that can target:

- browser GUI surfaces
- thinui takeover GUI surfaces
- wizard browser workflow surfaces
- alpine startup and loading surfaces
- sonic-screwdriver utility views
- optional gameplay visual overlays

The rule remains simple:

> runtime repos reference theme identities and adapter contracts; they do not embed theme ownership.

## Surface Split

### Browser default

Default browser theme stack remains Tailwind + Svelte.

This is the neutral modern baseline for:

- docs-facing GUI
- standard browser surfaces
- configuration panels
- user-safe general UI

### Thinui C64 family

Thinui can host a C64-flavoured theme family using a refactored fork of c64css3.

This family should provide:

- low-resource takeover views
- fullscreen launch UI
- retro terminal-adjacent system panels
- Petme default font support
- Alpine startup linkage
- graphical loading sequence patterns

### Wizard Notion family

Wizard keeps its own browser GUI.

Wizard workflow, OK scheduling, and task management can use a refactored fork of svelte-notion-kit.

This family should provide:

- task boards
- scheduling panels
- workflow cards
- OK provider routing views
- mission / roadmap / queue interfaces

### Thinui NES / Sonic family

Thinui can also host an NES-flavoured system family using a refactored fork of NES.css, integrated with sonic-screwdriver utility panels.

This family should provide:

- operations tools
- diagnostics panels
- compact utility cards
- low-resource app-like interfaces
- playful system surfaces without changing core semantics

## Theme Repo Responsibilities

uDOS-themes owns:

- theme source forks and refactors
- theme token normalization
- adapter bridge definitions
- typography packs
- icon and glyph handling rules
- loading pattern packs
- surface capability declarations
- accessibility and low-resource fallbacks
- theme preview examples

uDOS-themes does not own:

- workflow scheduling logic
- binder execution
- assistant orchestration
- core command semantics
- local GUI process lifecycle
- wizard operational state

## Forking Strategy

External theme libraries are not used raw in production.

They must be forked and adapted into uDOS-safe theme packs.

### Required forks

#### 1. c64css3 fork

Target use:

- thinui C64 surface
- Alpine-linked startup views
- boot and loading sequences

Refactor requirements:

- token extraction into uDOS theme variables
- removal of direct app assumptions
- support for thinui component slots
- support for Petme as packaged default font
- palette normalization
- loader-state variants

#### 2. svelte-notion-kit fork

Target use:

- wizard browser GUI
- scheduling and OK workflow surfaces

Refactor requirements:

- convert into wizard-safe component library
- separate content rendering from task orchestration
- normalize cards, blocks, lists, and kanban surfaces to wizard contracts
- bind to uDOS token model
- ensure browser-first performance

#### 3. NES.css fork

Target use:

- thinui utility surfaces
- sonic-screwdriver operational panels

Refactor requirements:

- convert classes into adapter-safe mappings
- reduce decorative bloat for operational density
- define compact utility variants
- normalize typography and spacing to uDOS tokens
- support gamepad/keyboard navigation states where needed

## Theme Family Definitions

### Family A — browser-default

- stack: Svelte + Tailwind
- role: baseline browser UI
- surfaces: docs, shell-adjacent panels, settings, standard app panels

### Family B — thinui-c64

- stack: thinui + c64css3 fork + Petme + Alpine linkage
- role: takeover GUI, boot, kiosk, low-resource system panels
- surfaces: launcher, binder select, sync state, startup, recovery UI

### Family C — wizard-notion

- stack: wizard + svelte-notion-kit fork
- role: workflow management and OK scheduling
- surfaces: boards, cards, queues, agendas, task routing, mission views

### Family D — thinui-nes-sonic

- stack: thinui + NES.css fork + sonic-screwdriver linkage
- role: utility GUI family
- surfaces: tools, diagnostics, control panels, device utilities, compact status widgets

## Font System

uDOS-themes v2.2.1 should promote fonts into first-class theme assets.

### Petme

Petme becomes the default packaged font for uDOS-alpine-linked thinui C64 startup surfaces.

The font pack must define:

- display name
- licensing metadata
- fallback chain
- unicode/glyph support notes
- approved surfaces
- size hints for low-resolution rendering
- SVG/export safety notes if required later

## Loader Pattern System

Loading sequences should be theme assets, not hardcoded runtime effects.

### Loader families to define

- boot-grid
- tape-stripe
- drive-chunk
- binder-pulse
- sync-scan
- OK-wait

Each loader should define:

- animation intent
- low-motion fallback
- frame pattern or state sequence
- text pairing rules
- palette usage
- surface compatibility

## Adapter Model

Theme adapters bridge external/forked visual systems into stable uDOS GUI contracts.

Adapters should exist per surface family, not per app.

### Adapter targets

- browser
- thinui
- wizard
- alpine
- sonic-screwdriver

### Adapter duties

- map tokens
- map component slots
- expose capability flags
- declare unsupported features cleanly
- avoid leaking external CSS naming into runtime contracts

## Theme Contract Rules

1. Themes may change presentation, not semantics.
2. Theme packs must declare their supported surfaces.
3. Theme packs must degrade cleanly under low-resource conditions.
4. Runtime repos must consume manifests, not internal theme structure.
5. External libraries must be forked and normalized before use.
6. Wizard GUI remains browser-owned and separate from thinui.
7. Thinui themes must remain compatible with fullscreen takeover constraints.
8. Fonts and loaders are packaged assets under theme control.

## Recommended Repo Additions

```text
uDOS-themes/
├── docs/
│   ├── v2.2.1-integrated-updated.md
│   ├── theme-families.md
│   ├── adapters.md
│   ├── fonts.md
│   └── loaders.md
├── registry/
│   ├── theme-registry.json
│   ├── adapter-registry.json
│   └── font-registry.json
├── themes/
│   ├── browser-default/
│   ├── thinui-c64/
│   ├── wizard-notion/
│   └── thinui-nes-sonic/
├── adapters/
│   ├── browser/
│   ├── thinui/
│   ├── wizard/
│   ├── alpine/
│   └── sonic/
├── fonts/
│   └── petme/
├── loaders/
│   ├── boot-grid/
│   ├── tape-stripe/
│   ├── binder-pulse/
│   └── sync-scan/
└── forks/
    ├── c64css3/
    ├── svelte-notion-kit/
    └── nes.css/
```

## Release Outcome

uDOS-themes v2.2.1 should establish a stable multi-surface visual contract for:

- default browser UI
- thinui takeover GUI
- wizard browser workflow GUI
- alpine startup visuals
- sonic-screwdriver utility panels

This gives v2 a coherent visual architecture without collapsing runtime ownership into theme repos.
