# uDos courses — learning pathway (v4)

**Status:** Locked structure · **content** grows per course folder.  
**Pathway docs:** [uDosDocs — Educational user acquisition](https://github.com/fredporter/uDosDocs/blob/main/docs/educational-content/v4-educational-user-acquisition-pathway.md) · [Courses catalog & style](https://github.com/fredporter/uDosDocs/blob/main/docs/educational-content/v4-courses-catalog-and-style.md) · [uCode course pathway](https://github.com/fredporter/uDosDocs/blob/main/docs/educational-content/ucode-course-pathway.md).

## Catalog

| Level | Course | Folder | Role |
| --- | --- | --- | --- |
| 00 | Orientation | [`00-orientation/`](00-orientation/README.md) | What the family is; how repos relate |
| 01 | Markdown systems | [`01-markdown-first/`](01-markdown-first/README.md) | Vaults, frontmatter, links |
| 02 | Local-first dev | [`02-local-first-dev/`](02-local-first-dev/README.md) | Runnable local loop |
| 03 | API & automation | [`03-api-automation/`](03-api-automation/README.md) | APIs, triggers |
| 04 | Modular architecture | [`04-modular-architecture/`](04-modular-architecture/README.md) | Modules, boundaries |
| 05 | Personal infrastructure | [`05-personal-infrastructure/`](05-personal-infrastructure/README.md) | Deploy, operate, contribute back |
| 06 | **uCode runtime** | [`06-ucode-runtime/`](06-ucode-runtime/README.md) | uCode language + CLI + sandbox (specs in uDosDev) |

## Validate

From **uDosConnect** repo root:

```bash
bash scripts/validate-courses.sh
```

## Principle

One connect checkout: **governance** (`uDosDev`), **docs** (`uDosDocs` submodule), **courses** (this tree), **scripts** — versioned together.
