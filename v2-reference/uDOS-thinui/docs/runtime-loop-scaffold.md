# ThinUI Runtime Loop Scaffold

## Purpose

Document the first executable architecture slice for ThinUI runtime development.

## File Map

- `src/contracts/state.ts`
- `src/contracts/event.ts`
- `src/runtime/types.ts`
- `src/runtime/view-registry.ts`
- `src/runtime/runtime-loop.ts`
- `src/runtime/default-theme-resolver.ts`
- `src/views/boot-loader.ts`
- `src/bridge/mock-core.ts`
- `src/runtime/bootstrap.ts`

## Runtime Flow

1. Core bridge emits `ThinUiStatePacket`
2. Runtime loop resolves the requested view from registry
3. View returns a base `ThinUiRenderFrame`
4. `renderThinUiState()` resolves `themeId` via `ThinUiThemeResolver`
5. Theme adapter decorates frame with loader/font/tokens and returns themed frame
6. Frame renderer outputs the current frame
7. ThinUI emits `ThinUiEvent` back through the core bridge
8. Updated state packet is rendered again

## Current Wiring Status

- `renderThinUiState()` bridge: implemented in `src/runtime/runtime-loop.ts`
- default theme resolver: implemented in `src/runtime/default-theme-resolver.ts`
- first themed boot path (`thinui-c64`): active via mock bridge seed state
- external themes resolver integration: supported via `createThinUiRuntime({ themeResolver })`
