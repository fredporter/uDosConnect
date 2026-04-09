# Alpine Thin GUI Launcher Contract

## Purpose

Define how Alpine boot lanes start ThinUI for low-resource local GUI startup.

## Ownership

- launcher transport and OS hooks: uDOS-alpine
- runtime semantics and state packet meaning: uDOS-core
- thin GUI runtime: uDOS-thinui
- appearance and styling: uDOS-themes

## Launcher Input

Launcher must provide:

- `mode`: `windowed` | `fullscreen` | `recovery`
- `themeId`: preferred theme id (defaults to `minimal-safe` in recovery)
- `loaderId`: optional loader override
- `entryView`: default `boot-loader`
- `diagnostics`: optional `{ offline, lowResource, safeMode }`

## Launch Invocation

Minimal invocation shape:

```json
{
  "runtime": "thinui",
  "entryView": "boot-loader",
  "mode": "fullscreen",
  "themeId": "thinui-c64",
  "loaderId": "c64-boot-seq"
}
```

## Runtime Expectations

1. ThinUI starts from `createThinUiRuntime()`.
2. Entry state packet is hydrated from launcher payload.
3. `renderThinUiState()` resolves adapter and emits first frame.
4. Launcher remains outside semantic mutation path.

## Failure / Recovery

If theme cannot resolve:

- fallback to `minimal-safe`
- set mode to `recovery` if startup diagnostics require it
- continue boot with minimal-safe renderer

## Boundary Rules

- Alpine may choose launch mode and theme preference.
- Alpine must not redefine state semantics.
- Alpine must not bypass core ownership of state transitions.
