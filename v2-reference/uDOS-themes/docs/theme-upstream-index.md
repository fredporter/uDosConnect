# Theme upstream index

uDOS **integrations** for third-party visual sources are pinned to these **four forks** under [fredporter](https://github.com/fredporter) (plus the **default web stack** below). Submodule them from `vendor/forks/` per `docs/theme-fork-rollout.md`.

**Credits (authors + upstream origins):** `wiki/credits-and-inspiration.md`.

**Adapter refactor ideas:** `examples/v2-2-2-thinui-next/docs/fork-plans-and-adapter-mappings.md`.

---

## Four integration forks (canonical)

| Lane | uDOS fork | Demo |
|------|-----------|------|
| **ThinUI C64** | https://github.com/fredporter/c64css3 | https://roeln.github.io/c64css3/ |
| **ThinUI NES** | https://github.com/fredporter/NES.css | https://nostalgic-css.github.io/NES.css/ |
| **Wizard Notion-style** | https://github.com/fredporter/svelte-notion-kit | https://svelte-notion-kit.vercel.app/ |
| **Teletext50** (font + CSS) | https://github.com/fredporter/bedstead | (see fork `README`; font drops e.g. [galax.xyz/Teletext50](https://galax.xyz/Teletext50/)) |

**Roles**

- **c64css3:** ThinUI retro base — `css.css`, **C64_User_Mono**, **Giana**, demo HTML. Tokenise into `thinui-c64`; optional Petme elsewhere (Kreative Software — see credits).
- **NES.css:** `thinui-nes-sonic`, Sonic / kiosk / game-shell panels (MIT upstream).
- **svelte-notion-kit:** Wizard browser patterns (blocks, workspace); bind to uDOS tokens, not ThinUI.
- **bedstead:** **Teletext50** pixel font (SAA5050 / Mode 7 style); includes `Teletext50.css` and related tooling. Upstream chain: **glxxyz/bedstead** → work credited in fork README (bjh21 bedstead lineage). **TeleText50** = readable text lane naming in uDOS notes; **Teletext50** = mosaic / block-graphic lane — both satisfied via this family of assets and adapters.

---

## Default web stack (not separate forks)

These are **ecosystem defaults**, not additional GitHub forks in the set of four.

| Piece | Reference |
|-------|-----------|
| **Tailwind** + **Typography (prose)** | https://tailwindcss.com/docs/typography-plugin |
| **Svelte** | Default framework for the Notion-kit Wizard lane (kit already uses Svelte + Tailwind). |

Use for: publish HTML, MDC reading, binder output, GitHub Pages, email-safe prose (adapted).

---

## GTX forms (forms surface — not in the four forks)

**GTX-style step flows** (Typeform-like multi-step forms) are a **first-class `uDOS-themes` surface**, not a fifth theme fork:

- **Adapter:** `src/adapters/forms/` — see `adapter-contract.json`, `gtx-form-prototype.mjs`.
- **Theme pack:** `src/themes/gtx-form-default.json` and registry entries.

They **compose** the default stack: Tailwind tokens, Svelte (or other) in the host app that embeds the flow. **Marp** and slide publishing stay a **publish / prose** concern (tokens + prose theme), not a duplicate of GTX forms.

---

## Teletext pipeline (concept)

Teletext is a **cell grid + mosaic** model: good for ThinUI fallback, TUI, binder, low-bandwidth UIs.

Conceptual direction: `ASCII / MD → teletext layout → terminal or SVG frame`.

Implementation assets: **`fredporter/bedstead`** submodule + `src/adapters/thinui/` teletext adapters (existing TS) + future `vendor/forks/bedstead` normalisation.

---

## Surface map (v2)

| Surface | Anchors |
|---------|---------|
| ThinUI | `c64css3`, `NES.css`, `bedstead` / teletext adapters |
| Wizard | `svelte-notion-kit` |
| Publish / prose | Tailwind Typography |
| Step forms (GTX) | `forms` adapter + `gtx-form-default` theme |
| MDC / slides | Prose theme + Marp (or similar) in publish tooling — not listed as theme forks |

---

## Suggested `vendor/forks/` layout

```
vendor/forks/
  c64css3/          → git@github.com:fredporter/c64css3.git
  NES.css/          → git@github.com:fredporter/NES.css.git
  svelte-notion-kit/
  bedstead/
```

Token extraction and adapter wiring stay in `src/themes/` and `src/adapters/`; do not leak upstream class names into Core contracts.
