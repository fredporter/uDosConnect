# Workspace web theme

- **`theme-tokens.json`** — copy of **`uDOS-themes/src/theme-tokens.json`** (browser-default). Refresh after palette changes:

  `bash uDOS-themes/scripts/sync-theme-tokens-to-workspace.sh` (from the family root, with `uDOS-themes` and `uDOS-workspace` as siblings).
- **`publish/tailwind-prose-preset.json`** — copy of
  **`uDOS-themes/src/adapters/publish/tailwind-prose-preset.json`** for shared
  publish prose class contract. Refresh with:

  `bash uDOS-themes/scripts/sync-publish-prose-preset-to-workspace.sh`

  For Node consumers that prefer a package path, the same JSON is also mirrored under **`uDOS-themes/packages/tailwind-prose-preset`** (refresh with `bash uDOS-themes/scripts/sync-publish-prose-preset-to-package.sh`; see that folder’s README).
- **`browserDefaultShell.ts`** — reads that JSON and builds `--ws-*` CSS custom properties for the Svelte shell (`lib/shell`, `lib/surfaces`).

See `uDOS-themes/docs/display-modes.md` and `uDOS-thinui/docs/themes-sibling-bridge.md`.
