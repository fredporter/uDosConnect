# Credits and inspiration

Human-facing **names, forks, and upstream origins**. Verify **LICENSE** before vendoring files. Technical index: `docs/theme-upstream-index.md`.

---

## uDOS forks (integrations)

These are the **only** third-party theme integrations tracked for now (all under **fredporter** on GitHub).

| Project | uDOS fork | Upstream / author |
|---------|-----------|-------------------|
| c64css3 | https://github.com/fredporter/c64css3 | **Roel N** (`RoelN`), [Pixelambacht / CSS3 C64](http://www.pixelambacht.nl/2013/css3-c64/) |
| NES.css | https://github.com/fredporter/NES.css | **B.C.Rikko** and contributors, [nostalgic-css/NES.css](https://github.com/nostalgic-css/NES.css) (MIT) |
| svelte-notion-kit | https://github.com/fredporter/svelte-notion-kit | **Aftab Alam** (`one-aalam`), [one-aalam/svelte-notion-kit](https://github.com/one-aalam/svelte-notion-kit) |
| Teletext50 (bedstead) | https://github.com/fredporter/bedstead | **glxxyz/bedstead**; README credits **bjh21** bedstead / [galax.xyz Teletext50](https://galax.xyz/Teletext50/) lineage (see fork `README`, `COPYING` — **CC0-1.0** on GitHub for this mirror) |

**Demos (upstream or equivalent):** [c64css3 demo](https://roeln.github.io/c64css3/), [NES.css demo](https://nostalgic-css.github.io/NES.css/), [svelte-notion-kit demo](https://svelte-notion-kit.vercel.app/).

---

## Default stack (no extra forks)

| Piece | Source |
|-------|--------|
| Tailwind + Typography | [Tailwind Labs](https://tailwindcss.com/docs/typography-plugin) |
| Svelte | Used by the Notion-kit Wizard lane; framework default, not a theme fork. |

---

## GTX forms (forms adapter, not a theme fork)

GTX / Typeform-style **multi-step forms** live under the **forms** adapter (`src/adapters/forms/`) and **`gtx-form-default`** theme. They use shared Tailwind / Svelte conventions in host apps; they are **not** a fifth GitHub fork in the set above.

---

## Optional: Petme64 (C64 typography)

**Pet Me 64** — **Kreative Software** ([C64 fonts](https://www.kreativekorp.com/software/fonts/c64/)). Referenced in ThinUI docs as an optional face; **not** bundled in the four forks unless you add it under license. Unrelated to unrelated GitHub repos named “PetMe”.

---

## TeleText50 vs Teletext50 (uDOS naming)

- **TeleText50:** Readable **text** row in teletext-style UIs (labels, body, status).
- **Teletext50:** **Mosaic** / block-graphic row (panels, charts).

Both are supported by the **bedstead** / Teletext50 asset family and thinui teletext adapters.

---

## How to extend

1. Add a new row under **uDOS forks** (or default stack) with name + repo.
2. Add `README.md` next to any vendored binaries.
3. Update `docs/theme-upstream-index.md`.
