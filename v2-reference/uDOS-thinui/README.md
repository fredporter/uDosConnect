> **Archive (uDos v2/v3)**  
> This is a conceptual uDos v2/v3 project which has been archived for posterity.
>
> **Scheduled extension track:** **4.1.15** (uDos **4.1.0** line; numbers may be reprioritized in [`uDosDev/TASKS.md`](../uDosDev/TASKS.md)).
>
> **When to reintegrate:** after `uDosGo` is locked for **v4.0**, when a Task Forge item for this module is scheduled in `uDosDev` (see [dev-process-v4.md](../uDosDev/docs/dev-process-v4.md)).
>
> **How:** rebuild against the current `uDosGo` contracts and tests; publish as a **submodule under `uDosConnect`** (not merged into `uDosGo`). Extension releases are numbered **4.1.1+** in order of landing.
>
> ---

# uDOS-thinui

uDOS-thinui is the dedicated low-resource GUI runtime for uDOS.

It provides the single-window, full-screen, app-like takeover GUI surface for local operational views that sit between the TUI shell and a full browser application.

## Position

- core owns semantics
- thinui owns takeover GUI runtime
- uDOS-themes owns theme packs (`docs/theme-upstream-index.md`, `wiki/credits-and-inspiration.md`, `docs/theme-fork-rollout.md` in that repo)
- Ubuntu hosts the primary browser command centre
- ThinUI remains the low-resource fullscreen GUI lane across the family

See `docs/spec.md` for the repo specification.

## Runtime Scaffold

Current scaffold surfaces now include:

- state contract: `src/contracts/state.ts`
- event contract: `src/contracts/event.ts`
- view contract and render frame types: `src/runtime/types.ts`
- view registry: `src/runtime/view-registry.ts`
- runtime loop: `src/runtime/runtime-loop.ts`
- default theme resolver: `src/runtime/default-theme-resolver.ts`
- views: `boot-loader`, `home-launcher`, `binder-select`, `operation-progress`, `sync-status`, `recovery-panel`, `handoff-to-browser`, `utility-panel`, `teletext-display` under `src/views/`
- mock core bridge: `src/bridge/mock-core.ts` (navigation stack + demo actions)
- bootstrap helper: `src/runtime/bootstrap.ts`
- surface profile bridge: `src/surface/surface-profile.ts` (built-in `ubuntu-gnome` mirrors `uDOS-surface/profiles/ubuntu-gnome/surface.json`)
- demo and validation: `npm run demo`, `npm run demo:tour`, `npm run dev` (browser), `scripts/demo-thinui.js`, `scripts/run-thinui-checks.sh`

## uDOS-surface profiles

`createThinUiRuntime({ surfaceProfileId: "ubuntu-gnome" })` merges profile defaults before `seedState`: **windowed** boot mode, **udos-default** theme (Classic Modern palette in `default-theme-resolver.ts`), and `state.surface` metadata for layout or navigation. Mock core uses `surface.homeMode` when leaving **boot-loader** for **home-launcher**.

- CLI: `npm run demo -- --profile ubuntu-gnome`
- CLI (load JSON from sibling checkout): `npm run demo -- --surface-profile-file ../uDOS-surface/profiles/ubuntu-gnome/surface.json`
- Browser demo: `npm run dev` → add query `?profile=ubuntu-gnome`

`createThinUiRuntime({ surfaceProfileData })` accepts a profile parsed with `parseSurfaceProfileThinUiV01FromJson` (throws `SurfaceProfileValidationError` on bad JSON).

Keep `UBUNTU_GNOME_SURFACE_PROFILE` in `src/surface/surface-profile.ts` aligned with `uDOS-surface/profiles/ubuntu-gnome/surface.json`. Family checks run `python3 ../uDOS-surface/scripts/validate_surface_profiles.py` when that repo is present.

## Bridge Surfaces

- launch sequence: `docs/thinui-boot-launch-sequence.md`
- Alpine launcher contract: `contracts/alpine-thin-gui.md`
- sonic-screwdriver launcher contract: `contracts/sonic-thin-gui.md`

ThinUI now supports a theme adapter resolver bridge through `renderThinUiState()`.
The runtime accepts an injected resolver (`createThinUiRuntime({ themeResolver })`) so
`uDOS-themes` can provide loader/font/token hooks per `themeId`.

Current demoable theme lanes:

- `udos-default` for Classic Modern palette (ubuntu-gnome surface profile)
- `thinui-c64` for Alpine-linked startup surfaces
- `thinui-nes-sonic` for Sonic utility panels
- `thinui-teletext` for teletext-style service and block-graphic displays

This is the minimal ThinUI runtime architecture slice for Core -> ThinUI ->
Render -> Event -> Core loop development.

Run the local demo/check pass with:

```bash
npm install
bash scripts/run-thinui-checks.sh
```

### TypeScript runtime demo (canonical)

```bash
npm run demo -- --theme thinui-c64
npm run demo:tour
```

### Browser demo (interactive)

```bash
npm run dev
```

Opens the Vite dev server (default port **5179**): theme selector, live `<pre>` frame, and buttons wired to the same mock core as the CLI. Theme fonts load from `demo/theme-fonts.css` (C64 woff via jsDelivr, Teletext50 OTF via galax.xyz) and Google Fonts for NES (**Press Start 2P**), matching `default-theme-resolver.ts` families.

For a full local checkout of upstream theme CSS sources, clone **uDOS-themes** and run `bash scripts/init-vendor-forks.sh`. The family helper **`uDOS-dev/scripts/install-thinui-themes-lane.sh`** runs that plus `npm install` in this repo when both sit as siblings under the family root.

### Terminal theme frames (legacy, zero-deps)

```bash
node scripts/demo-thinui.js --theme thinui-c64
node scripts/demo-thinui.js --theme thinui-nes-sonic
node scripts/demo-thinui.js --theme thinui-teletext --view teletext-display
```

For **browser** previews with the same theme ids loaded via Core’s shell map,
use the Wizard Surface demo page **`/demo`** (Thin GUI links) or **`/app/thin-gui`**
after `npm run build` in `uDOS-wizard/apps/surface-ui` — see
`uDOS-dev/docs/gui-system-family-contract.md` § Operator visual sign-off.
