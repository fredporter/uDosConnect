# Step 1 — ThinUI workspace wireframe and panel model

## UX direction

The workspace should feel like one binder-centric operating surface, not a bundle of separate tools.

Primary surfaces:
- Overview
- Docs
- Tasks
- Calendar
- Map
- Publish
- Compile
- History

## Default desktop shell

```txt
┌────────────────────────────────────────────────────────────────────────────┐
│ ThinUI Topbar: Binder Title | Search | Command Palette | Status | Profile │
├───────────────┬─────────────────────────────────────────┬──────────────────┤
│ Left Nav      │ Main Surface                            │ Right Inspector  │
│               │                                         │                  │
│ Overview      │ Docs / Tasks / Calendar / Map /         │ Context details  │
│ Docs          │ Publish / Compile                       │ selection info   │
│ Tasks         │                                         │ quick actions    │
│ Calendar      │                                         │ references       │
│ Map           │                                         │ history          │
│ Publish       │                                         │                  │
│ Compile       │                                         │                  │
│ History       │                                         │                  │
├───────────────┴─────────────────────────────────────────┴──────────────────┤
│ Bottom Tray: compile jobs | sync state | wizard notices | empire queue     │
└────────────────────────────────────────────────────────────────────────────┘
```

## Mobile/tablet shell

```txt
┌──────────────────────────────┐
│ Topbar / binder / command    │
├──────────────────────────────┤
│ Active Surface               │
│                              │
│ Docs / Tasks / Calendar ...  │
│                              │
├──────────────────────────────┤
│ Tabs: O D T C M P C H        │
└──────────────────────────────┘
```

## Panel rules

### Left nav
Owns:
- binder surface switching
- saved views
- filters
- quick jumps to linked binders

### Main surface
Owns:
- editor
- task board/table/calendar
- map canvas
- compile designer
- publish schedule

### Right inspector
Owns:
- metadata
- references
- selected item detail
- actions
- compile hints
- Empire/Wizard context status

### Bottom tray
Owns:
- compile queue
- sync/runtime state
- notifications
- provider issues
- social publish queue

## View behaviors

### Docs
- split edit/preview optional
- prose rendering mode
- inline references to tasks, locations, publish entries

### Tasks
- board/table/calendar toggle
- lane, owner, stage, location, publish-state filters
- quick detail edit in inspector

### Calendar
- editorial schedule
- milestone timeline
- task due dates
- Empire publish calendar overlay

### Map
- layers toggle
- real vs virtual mode
- route overlays
- binder-linked markers
- access/visibility states

### Publish
- Empire social queue
- per-channel status
- drafts / scheduled / sent / blocked

### Compile
- schema inspection
- template pickers
- mapping editor
- generated app preview
- compile handoff to Wizard

## ThinUI requirements

- low-clutter frame
- app-like single window takeover
- keyboard and controller-friendly navigation
- themable via uDOS-themes tokens
- shell composability for browser/app/kiosk contexts
