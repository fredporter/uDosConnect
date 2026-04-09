# ThinUI Scripts

Checked-in demo and validation helpers for `uDOS-thinui`.

- `run-thinui-checks.sh` — installs npm deps, runs `tsc`, `npm run validate:binder-spine` (binder spine v1 JSON fixtures), TypeScript runtime demo lanes, scripted tour, Vite demo build, and the legacy zero-dep `demo-thinui.js` smoke pass
- `validate-binder-spine-payload.ts` — `npm run validate:binder-spine`; checks bundled / public / example `demo-binder.json` files against Core-aligned spine v1
- Browser demo fonts: `demo/theme-fonts.css` (`@font-face` for C64 User Mono, Teletext50) plus Google Fonts **Press Start 2P** in `demo/index.html`; pair with `uDOS-themes` `scripts/init-vendor-forks.sh` for local fork sources
- `demo-thinui-run.ts` — **canonical** demo: real `createThinUiRuntime()` + views + theme resolver + mock core (`npm run demo`, `npm run demo:tour`)
- `demo-thinui.js` — legacy ASCII frames only (no TypeScript); kept for environments without `npm install`
- `print-themes-skin.mjs` — optional: load **`uDOS-themes`** `loadSkinBundle` for a skin id (sibling repo or `UDOS_THEMES_ROOT`); see `docs/themes-sibling-bridge.md`
