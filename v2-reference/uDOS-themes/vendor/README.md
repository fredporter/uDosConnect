# Vendor and upstream forks

**Four** integration repos are tracked (all [fredporter](https://github.com/fredporter) forks). See `docs/theme-upstream-index.md` and `wiki/credits-and-inspiration.md`.

## Before you vendor

1. Submodules use the **fredporter** fork URLs (already created).
2. Record **name + repo** in `wiki/credits-and-inspiration.md` if anything changes.
3. Confirm **LICENSE** / font terms next to any binaries you ship.
4. Prefer **submodules** so upstream merges are explicit.

## Layout

| Path | Intended content |
|------|------------------|
| `forks/` | **c64css3**, **NES.css**, **svelte-notion-kit**, **bedstead** (Teletext50) — see `forks/README.md` |
| `fonts/` | Optional **built** font drops copied from `forks/bedstead` or other licensed sources — see `fonts/README.md` |

**GTX forms** and **Tailwind prose** are **not** vendored here: forms use `src/adapters/forms/`; prose uses npm Tailwind Typography.

## Procedure

`docs/theme-fork-rollout.md`.
