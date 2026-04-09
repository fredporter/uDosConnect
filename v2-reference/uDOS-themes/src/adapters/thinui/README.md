# thinui adapters

This adapter lane maps theme assets into a stable ThinUI render contract.

Responsibilities:

- resolve a theme from `themeId`
- expose loader frames, font information, and render tokens
- provide theme-aware frame rendering while preserving ThinUI semantics
- provide a low-resource safe fallback for recovery mode

Current adapter families:

- `thinui-c64` for Alpine-linked startup surfaces
- `thinui-nes-sonic` for Sonic utility/launcher panels
- `thinui-teletext` for teletext-style service and block-graphic displays

Boundary rule:

- appearance and tokens live here
- semantic state mutation never lives here

## Upstream sources (forks)

ThinUI visual families are normalised from third-party bases. See `docs/theme-upstream-index.md` for **c64css3**, **NES.css**, and **teletext** font repos, demos, and the target `adapters/thinui/` layout.
