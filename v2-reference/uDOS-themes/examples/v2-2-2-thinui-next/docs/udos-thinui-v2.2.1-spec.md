# uDOS-thinui v2.2.1 — Repo and Runtime Specification

## Status

Draft recommendation for v2.2.1.

## Purpose

uDOS-thinui is the dedicated low-resource GUI runtime for uDOS v2.

It provides the single-window, fullscreen, low-overhead, app-like takeover GUI surface for local uDOS operation.

Thinui exists between:

- the TUI / CLI world
- basic system startup and recovery views
- lightweight local GUI panels
- optional kiosk-like operational modes

It is not a general browser app and it is not wizard.

## Position

### Core owns

- system semantics
- binder state
- command execution
- workflow truth
- local runtime state
- lifecycle authority

### Thinui owns

- takeover window rendering
- fullscreen UI runtime
- low-resource local view transitions
- launcher, selector, status, and recovery screens
- theme-hosted GUI composition for local operation

### Themes own

- appearance
- tokens
- skins
- fonts
- loaders
- adapter mappings

### Wizard owns

- browser GUI
- OK scheduling
- provider workflows
- task management
- assisted orchestration views

## Thinui Must Be

- single-window
- fullscreen-capable
- low-resource
- keyboard-safe
- gamepad-mappable where appropriate
- CLI-adjacent
- crash-contained
- restartable without semantic drift

## Thinui Must Not Be

- a second runtime
- an alternate command engine
- an owner of workflow logic
- a theme repo
- a browser-first planner app
- wizard's GUI

## Primary Use Cases

Thinui should cover the local operational GUI cases where a full browser stack is unnecessary, too heavy, or too distracting.

### Main targets

- startup launcher
- binder chooser
- vault / location selector
- sync status surface
- operation progress display
- recovery / safe mode GUI
- kiosk-style utility panels
- lightweight system dashboards
- graphical handoff into browser surfaces when needed

## Surface Modes

### 1. Windowed mode

For desktop use where thinui is a compact local app window.

### 2. Fullscreen takeover mode

For focused operation, kiosk flows, launcher use, and immersive app-like use.

### 3. Recovery-safe mode

For low-dependency startup, degraded rendering, and local troubleshooting.

## Contract with Core

Thinui must consume explicit state packets from core.

Core remains the source of truth.

Thinui renders those packets and emits user interaction events.

### Core → Thinui

- shell/session state
- binder selection data
- progress state
- warnings and recovery flags
- allowed actions
- current view identity
- theme and surface preference

### Thinui → Core

- user selection
- input events
- launch requests
- cancel / back requests
- layout capability report
- view exit / handoff events

## Core Contract Shapes

### ThinUiStatePacket

```ts
export type ThinUiStatePacket = {
  view: string;
  mode: "windowed" | "fullscreen" | "recovery";
  themeId: string;
  loaderId?: string;
  title?: string;
  subtitle?: string;
  status?: "idle" | "running" | "warning" | "error" | "complete";
  progress?: {
    current?: number;
    total?: number;
    label?: string;
  };
  actions: Array<{
    id: string;
    label: string;
    kind?: "primary" | "secondary" | "danger" | "nav";
    disabled?: boolean;
  }>;
  panels?: Array<{
    id: string;
    kind: string;
    title?: string;
    body?: string;
    items?: Array<{ id: string; label: string; value?: string }>;
  }>;
  diagnostics?: {
    safeMode?: boolean;
    offline?: boolean;
    lowResource?: boolean;
  };
};
```

### ThinUiEvent

```ts
export type ThinUiEvent = {
  type:
    | "action"
    | "select"
    | "navigate"
    | "dismiss"
    | "launch-browser"
    | "request-refresh";
  targetId?: string;
  value?: string;
  meta?: Record<string, string | number | boolean>;
};
```

## Runtime Responsibilities

uDOS-thinui should provide:

- a thin process host
- a small renderer shell
- view registry
- input handling
- state hydration from core
- theme adapter loading
- graceful fallback handling

It should not provide:

- business logic
- workflow planners
- direct provider orchestration
- scheduling engines
- semantic state mutation beyond explicit UI events

## Theming Contract

Thinui consumes uDOS-themes through stable manifests.

Thinui does not depend directly on external theme libraries in production.

### Initial theme targets

- thinui-c64
- thinui-nes-sonic
- minimal-safe

### Required behavior

- theme fallback if pack missing
- font fallback if font unavailable
- loader fallback if animation disabled
- monochrome-safe rendering path for degraded devices

## Alpine Integration

Thinui should integrate cleanly with uDOS-alpine for startup and local system flows.

### Alpine-linked responsibilities

- startup loader display
- boot handoff screen
- CLI-to-GUI launch bridge
- Petme-backed visual startup identity
- low-resource graphical loading pattern sequence

This must remain optional and modular.

## Sonic-Screwdriver Integration

Thinui should host sonic-screwdriver utility panels when a graphical utility surface is preferred.

Examples:

- settings tools
- diagnostics widgets
- peripheral tests
- compact operational panels

The sonic integration remains a hosted utility surface, not a semantic owner.

## Wizard Boundary

Wizard keeps its own browser GUI and workflow UI.

Thinui may:

- launch wizard in browser
- render a handoff card
- show local status before browser handoff

Thinui must not:

- replicate wizard scheduling views in full
- own OK workflow state
- become a browser workflow manager

## Resource Model

Thinui is explicitly optimized for low-resource operation.

### Design expectations

- fast startup
- low idle memory footprint
- minimal background work
- reduced animation requirements
- usable on older machines and lightweight local environments

## Initial View Set

Recommended first view set for v2.2.1:

- boot-loader
- home-launcher
- binder-select
- operation-progress
- sync-status
- recovery-panel
- handoff-to-browser
- utility-panel

## Suggested Repo Structure

```text
uDOS-thinui/
├── README.md
├── docs/
│   ├── spec.md
│   ├── contract.md
│   ├── views.md
│   ├── modes.md
│   └── integration.md
├── src/
│   ├── contracts/
│   ├── runtime/
│   ├── views/
│   ├── input/
│   ├── theme/
│   └── bridges/
├── examples/
│   ├── state-packets/
│   └── boot-screen/
├── schemas/
│   └── thinui-state.schema.json
└── package.json
```

## Release Intent

uDOS-thinui v2.2.1 establishes thinui as the dedicated local takeover GUI runtime for uDOS.

That gives v2 a clean separation:

- core for truth
- thinui for local graphical runtime
- themes for appearance
- wizard for browser orchestration

This separation should remain strict.
