# uDOS v2 Dependency Matrix

## Allowed Dependencies

| Repo | Allowed Depends On |
| --- | --- |
| `uDOS-core` | none |
| `uDOS-shell` | `uDOS-core` |
| `sonic-screwdriver` | `uDOS-core`, released public contracts |
| `uDOS-plugin-index` | `uDOS-core` |
| `uDOS-wizard` | `uDOS-core` |
| `uDOS-gameplay` | `uDOS-core` |
| `uDOS-groovebox` | `uDOS-core`, `uDOS-host` public contracts |
| `uDOS-grid` | `uDOS-core` |
| `uDOS-empire` | `uDOS-core`, `uDOS-wizard`, `uDOS-host` public contracts |
| `uDOS-dev` | none for runtime behavior |
| `uDOS-themes` | public family contracts |
| `uDOS-thinui` | `uDOS-core`, `uDOS-themes`, `uDOS-host` public contracts |
| `uDOS-workspace` | `uDOS-core`, `uDOS-themes`, `uDOS-wizard`, `uDOS-empire` public contracts |
| `uDOS-docs` | public repo docs and READMEs |
| `uDOS-alpine` | released public contracts, `uDOS-host` network contracts |
| `uDOS-host` | `uDOS-core`, `sonic-screwdriver` deployment contracts |
| `sonic-ventoy` | `sonic-screwdriver`, released Ventoy compatibility contracts |
| `uHOME-matter` | `uDOS-core`, `uHOME-server`, `uDOS-host` public contracts |
| `uHOME-client` | `uDOS-core`, `uHOME-server` contracts |
| `uHOME-server` | `uDOS-core`, `uDOS-host` |
| `omd-mac-osx-app` | public contracts only |
| `uHOME-app-android` | public contracts only |
| `uHOME-app-ios` | public contracts only |

## Forbidden Reverse Dependencies

- `uDOS-core` must never depend on consumer repos
- `uDOS-core` must never depend on OMD repos
- no public repo may depend on any OMD repo
- `uDOS-dev` must not define runtime behavior
- packaging repos must not become semantic owners

## Cross-Repo Promotion Order

When one change spans multiple repos, merge in this order:

1. `uDOS-core`
2. direct contract consumers
3. packaging and deployment repos
4. docs and release surfaces
