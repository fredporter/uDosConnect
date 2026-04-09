# Sonic Thin GUI Launcher Contract

## Purpose

Define how sonic-screwdriver invokes ThinUI for utility and kiosk-oriented local panels.

## Ownership

- launcher orchestration: sonic-screwdriver
- state semantics: uDOS-core
- local GUI runtime: uDOS-thinui
- appearance and adapter tokens: uDOS-themes

## Launcher Input

Required fields:

- `mode`: `windowed` | `fullscreen` | `recovery`
- `themeId`: preferred theme id
- `entryView`: e.g. `boot-loader`, `utility-panel`, `operation-progress`

Optional fields:

- `loaderId`
- `title`
- `subtitle`
- `actions`
- `panels`
- `diagnostics`

## Launch Invocation

```json
{
  "runtime": "thinui",
  "entryView": "utility-panel",
  "mode": "windowed",
  "themeId": "thinui-c64",
  "title": "sonic utility",
  "subtitle": "device diagnostics"
}
```

## Runtime Expectations

1. sonic launcher creates initial ThinUiStatePacket payload.
2. ThinUI runtime resolves view and theme adapter.
3. Frame output is emitted to local GUI surface.
4. Events return through ThinUI event channel and are routed by caller.

## Kiosk Notes

For kiosk/fullscreen utility mode:

- launcher should set `mode: fullscreen`
- launcher should disable unsupported actions
- launcher should enable recovery fallback path (`minimal-safe`)

## Boundary Rules

- sonic may host utility panels in ThinUI.
- sonic must not define or mutate core semantic workflow state.
- sonic must not own theme token definitions.
