# Vendored fonts (optional extracts)

The **Teletext50** source of truth is the **`bedstead`** fork submodule under `vendor/forks/bedstead` (see `vendor/forks/README.md`). It contains generators, `Teletext50.css`, and links to distributed font files.

Use this `fonts/` tree only when you **copy built outputs** (e.g. woff2) out of `bedstead` or another licensed source for packaging:

```
fonts/
  teletext50/
    README.md    # attribution + license (match bedstead COPYING / upstream)
    *.woff2
```

**Petme64** and other Kreative fonts belong here only with explicit license documentation — see `wiki/credits-and-inspiration.md`.
