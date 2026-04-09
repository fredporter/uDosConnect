# Theme fork rollout (procedure)

Canonical list of integration repos: **`docs/theme-upstream-index.md`**. Authors: **`wiki/credits-and-inspiration.md`**.

## 1. Submodules (fredporter forks)

| Lane | Submodule remote |
|------|------------------|
| C64 / ThinUI | https://github.com/fredporter/c64css3 |
| NES / ThinUI | https://github.com/fredporter/NES.css |
| Wizard | https://github.com/fredporter/svelte-notion-kit |
| Teletext50 | https://github.com/fredporter/bedstead |

After clone: `bash scripts/init-vendor-forks.sh` (see `vendor/forks/README.md`).

## 2. Attribution

- Keep `wiki/credits-and-inspiration.md` aligned with fork URLs and upstream authors.
- Add `README.md` beside any copied font binaries under `vendor/fonts/`.

## 3. Normalise into adapters

Per `examples/v2-2-2-thinui-next/docs/fork-plans-and-adapter-mappings.md` (plus **bedstead** for teletext):

- Extract **tokens** into `src/themes/` and adapter contracts.
- Map **primitives** to ThinUI / Wizard slots; no upstream class names in Core contracts.
- **Forms:** GTX flows stay in `src/adapters/forms/` — not a fifth theme fork.

## 4. Default stack

- **Tailwind Typography** via npm / Tailwind config (publish, prose).
- **Svelte** with the Notion-kit app — framework choice, not a submodule.

## 5. Validate

```bash
bash scripts/run-theme-checks.sh
```

## 6. Consumers

- **ThinUI:** resolver + `thinui-*` theme packs.
- **Wizard:** browser surfaces; separate asset graph from ThinUI.
- **GTX forms:** `gtx-form-default` + forms adapter.
