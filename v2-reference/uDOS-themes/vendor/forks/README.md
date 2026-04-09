# Upstream fork slots

After cloning **uDOS-themes**, initialize checked-out forks (one command from repo root):

```bash
bash scripts/init-vendor-forks.sh
```

Add each row as a **git submodule** pointing at the **fredporter** fork (already recorded in `.gitmodules` on main).

| Slot | Clone URL | Demo |
|------|-----------|------|
| **c64css3** | https://github.com/fredporter/c64css3 | https://roeln.github.io/c64css3/ |
| **NES.css** | https://github.com/fredporter/NES.css | https://nostalgic-css.github.io/NES.css/ |
| **svelte-notion-kit** | https://github.com/fredporter/svelte-notion-kit | https://svelte-notion-kit.vercel.app/ |
| **bedstead** (Teletext50) | https://github.com/fredporter/bedstead | see fork README / https://galax.xyz/Teletext50/ |

Example:

```bash
cd vendor/forks
git submodule add https://github.com/fredporter/c64css3.git c64css3
git submodule add https://github.com/fredporter/NES.css.git NES.css
git submodule add https://github.com/fredporter/svelte-notion-kit.git svelte-notion-kit
git submodule add https://github.com/fredporter/bedstead.git bedstead
```

**Credits:** `wiki/credits-and-inspiration.md`.
