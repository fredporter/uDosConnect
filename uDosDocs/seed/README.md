# Public seeds

Small, inspectable starter content for new instances and for the educational
stream. Policy: `architecture/08_seed_and_template_policy.md`.

## Why this lives in `uDOS-docs`

- Same files are **documentation** (teach layout and naming) and **templates**
  (copy or vendor into a runtime).
- GitHub Pages and raw GitHub URLs can serve as a **fallback** when local or
  upstream roots are unavailable, alongside copies vendored by installers.

## Read-only vs working copy

| Mode | When | Behaviour |
| --- | --- | --- |
| Read-only | Empty state, demos, static serve | Runtime points at bundled path or URL; no writes to the seed. |
| Duplicate first | User edits, vault work, courses | Copy seed into the user or instance tree on first open, then only the **copy** is mutable; the repo seed stays canonical. |

Implementations choose one or the other per surface; both are valid.

## Layout (incremental)

Subfolders will be added as needed, for example:

- `typo/` — welcome and empty-selection markdown shown in Typo-style surfaces
- `binders/` — example binder stubs
- `vault/` — minimal clean vault scaffold (no secrets, no machine state)
- optional read-only copy of `docs/knowledge/` for offline General Knowledge
  Library (see `docs/general-knowledge-library.md`)

Until those exist, this file defines intent and consumption rules.
