# uDOS v2 Repo Family Map

## Governance Split

- `uDOS-core` owns semantic hierarchy, dependency direction, and contract requirements
- `uDOS-dev` owns workflow, binder process, sync policy, and family automation

## Release Tiers

See `uDOS-dev/docs/release-tier-map.md`.

- Tier 1 required: runtime spine, shell, GUI, themes, docs, and handover control plane
- Tier 2 optional: product or extension modules that may ship if they do not slow Tier 1
- Tier 3 defer: adjacent-family repos and delayed streams

## Core uDOS Working Set

| Repo | Owner | Purpose | Upstream Dependencies | Must Not Depend On |
| --- | --- | --- | --- | --- |
| `uDOS-core` | semantics | runtime contracts and deterministic execution | none | `uDOS-shell`, `uDOS-wizard`, `uHOME-*`, `OMD` |
| `uDOS-shell` | shell | interactive shell and public UX surfaces | `uDOS-core` | `OMD`, `uHOME-server` as a semantic owner |
| `uDOS-grid` | spatial identity | canonical spatial identity, layers, seed registries, and place-bound artifact attachment | `uDOS-core` contracts | `uDOS-gameplay` as a persistence owner, `OMD`, network runtime ownership |
| `uDOS-plugin-index` | registry | plugin and package metadata | `uDOS-core` contracts | `OMD`, network runtime ownership |
| `uDOS-wizard` | network/orchestration | providers, API bridges, MCP, autonomy controls | `uDOS-core` | `OMD`, ownership of canonical runtime semantics |
| `uDOS-gameplay` | optional module | gameplay and simulation patterns | `uDOS-core` | `OMD`, ownership of runtime semantics |
| `uDOS-groovebox` | optional module | pattern-first music sequencing, Songscribe bridge artifacts, and portable composition surfaces | `uDOS-core` | `OMD`, ownership of shell commands or network transport |
| `uDOS-empire` | optional service/module | sync, CRM, remote workflow, and publishing extension surfaces | `uDOS-core`, `uDOS-host`, `uDOS-wizard` contracts | `OMD`, ownership of runtime semantics |
| `uDOS-dev` | operations | binder workflow, governance, automation | none for runtime behavior | runtime ownership |
| `uDOS-themes` | presentation | themes, tokens, shell-facing assets | public family contracts | `OMD` branding ownership |
| `uDOS-workspace` | browser workspace | binder-first visual operator shell, compile-manifest mapping, and spatial/task/publish workspace surfaces | `uDOS-core` contracts, `uDOS-wizard` and `uDOS-empire` boundaries | canonical truth ownership, orchestration ownership, publishing ownership |
| `uDOS-docs` | docs | canonical public docs and onboarding | public family READMEs and docs | implementation ownership |
| `uDOS-alpine` | lean runtime/profile | Core plus TUI and ThinUI only on Alpine, with optional pairing to the Ubuntu command centre | released public contracts, `uDOS-host` network contracts | browser command-centre ownership |
| `uDOS-host` | command-centre runtime | always-on Ubuntu command centre for networking, vault, sync, scheduling, browser GUI, and operator shell | `uDOS-core` contracts, `sonic-screwdriver` deployment lane | canonical runtime semantics ownership |

## Adjacent Sonic Family

| Repo | Owner | Purpose | Upstream Dependencies | Must Not Depend On |
| --- | --- | --- | --- | --- |
| `sonic-screwdriver` | packaging | bootstrap, install, update, managed environments | `uDOS-core`, released public contracts | `OMD`, ownership of runtime semantics |
| `sonic-ventoy` | boot-platform | Ventoy-compatible boot templates, curated GRUB menu extension, and sonic-stick media layout assets | `sonic-screwdriver`, released Ventoy compatibility model | deployment orchestrator ownership, runtime ownership |

## Adjacent uHOME Family

| Repo | Owner | Purpose | Upstream Dependencies | Must Not Depend On |
| --- | --- | --- | --- | --- |
| `uHOME-matter` | optional service/module | Matter and Home Assistant extension surfaces for the local `uHOME` environment | `uDOS-core`, `uHOME-server` contracts | `OMD`, ownership of canonical runtime semantics |
| `uHOME-client` | client runtime | lightweight local-network client runtime and contract consumption | `uDOS-core`, `uHOME-server` contracts | platform UI ownership, runtime ownership |
| `uHOME-server` | uHOME services | downstream uHOME service stream behind the family runtime spine | `uDOS-core`, `uDOS-host` contracts | `OMD`, family runtime-spine ownership |
| `uHOME-app-android` | mobile UI | Android application for the v2 uHOME UI and kiosk lane | `uDOS-core`, `uHOME-client`, `uHOME-server` contracts | runtime ownership |
| `uHOME-app-ios` | mobile UI | iOS application for the v2 uHOME UI and kiosk lane | `uDOS-core`, `uHOME-client`, `uHOME-server` contracts | runtime ownership |

## Staged uHOME v2 Direction

The current active public `uHOME` family root is:

- `uHOME-server`
- `uHOME-client`
- `uHOME-matter`
- `uHOME-app-android`
- `uHOME-app-ios`

The `uHOME v2 Master Architecture Specification` is adopted as a staged
direction around the repos that actually exist in the workspace today.

`uHOME-client` remains the shared client-runtime and contract owner.
`uHOME-app-android` and `uHOME-app-ios` implement the platform-specific client,
kiosk, and portal app surfaces around that runtime, while `uHOME-matter` and
the optional `uDOS-empire` integration remain active extension lanes.

## Prohibited Dependency Directions

- no public repo depends on external private app repos
- `uDOS-core` never depends on `uDOS-shell`, `uDOS-wizard`, `uHOME-*`, or packaging repos
- `uDOS-core` may later recognize neutral spatial and file-location vocabulary, but it must not absorb Grid-owned seed datasets or gameplay interpretation
- packaging repos do not redefine runtime semantics
- `uDOS-workspace` may present and edit Core-backed truth but must not become
  the canonical owner of binder, task, spatial, publish, or compile semantics
- `uDOS-host` owns the always-on command-centre runtime but does not redefine core semantics
- `sonic-ventoy` owns boot-template and menu-extension assets while `sonic-screwdriver` owns deployment orchestration
- `uDOS-grid` owns spatial truth and must not depend on `uDOS-gameplay` for canonical place identity
- `uDOS-dev` documents and coordinates runtime repos but does not own their behavior
