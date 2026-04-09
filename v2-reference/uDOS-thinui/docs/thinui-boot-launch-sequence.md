# ThinUI Boot Launch Sequence

This document defines the first executable launch path for ThinUI.

## Sequence

1. Host launcher starts uDOS runtime (Alpine, sonic-screwdriver, or local dev host).
2. Core publishes an initial `ThinUiStatePacket` (or mock bridge seed state).
3. ThinUI runtime starts through `createThinUiRuntime()`.
4. Runtime resolves a view by `state.view` from `ThinUiViewRegistry`.
5. Runtime calls `renderThinUiState(state, registry, themeResolver)`.
6. Theme resolver (`resolveThinUiTheme`) returns adapter hooks:
   - loader
   - font
   - render tokens
7. Adapter decorates the base frame and returns themed output.
8. Frame renderer emits frame to console/canvas/output device.
9. UI events flow back through `handleEvent()` to the core bridge.

## Local Dev Example

```ts
import { createThinUiRuntime } from "../src/runtime/bootstrap";

const runtime = createThinUiRuntime();
runtime.start();
```

## Themes Adapter Integration Example

```ts
import { createThinUiRuntime } from "../src/runtime/bootstrap";
import { resolveThinUiTheme } from "uDOS-themes/src/adapters/thinui/utils/resolve-thinui-theme";

const runtime = createThinUiRuntime({
  themeResolver: {
    resolveThinUiTheme,
  },
});

runtime.start();
```

## First Themed Boot Path

Default seed state in the mock bridge uses:

- `view: "boot-loader"`
- `themeId: "thinui-c64"`
- progress/action metadata

With either default resolver or the Themes resolver wired in, boot output is rendered with C64-themed frame lines and loader text.

## Additional Render Targets

- `thinui-nes-sonic`
  - utility-panel styling for Sonic-hosted launch surfaces
- `thinui-teletext`
  - teletext-style service pages and block graphic demo output

Repo-local demo runner:

```bash
node scripts/demo-thinui.js --theme thinui-c64
node scripts/demo-thinui.js --theme thinui-nes-sonic
node scripts/demo-thinui.js --theme thinui-teletext --view teletext-display
```

## Recovery Mode Behavior

If mode is `recovery`, resolver must return a low-resource safe adapter when available (or fallback to `minimal-safe`).

## Handoff Targets

- Alpine Thin GUI launcher contract: `contracts/alpine-thin-gui.md`
- Sonic Thin GUI launcher contract: `contracts/sonic-thin-gui.md`
