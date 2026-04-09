# Source

`src/` is the cross-surface theme source lane for `uDOS-themes`.

Current source surfaces include:

- `theme-tokens.json` as the smallest checked-in theme contract
- `tokens/` for base token categories
- `components/` for primitive UI contracts
- `adapters/` for surface-specific translation layers
- `themes/` for theme packs
- `skins/` for theme overrides
- `adapters/thinui/` for ThinUI runtime theme resolver and adapter hooks

Boundary rule:

- keep public tokens and theme contracts here
- keep machine-readable primitive and adapter contracts here
- keep shell behavior in `uDOS-shell`

ThinUI adapter responsibilities:

- resolve theme by `themeId`
- expose loader, font, and render token hooks
- provide theme-specific frame decoration without semantic state mutation

Cross-surface rule:

- a button is always a button
- a form is always a form
- a loader is always a loader
