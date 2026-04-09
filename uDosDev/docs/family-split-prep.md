# Family Split State

This document records the active product-family split used for core-release
completion.

## Goal

Reduce completion risk for the first uDOS release by shrinking the active core
working set.

## Target Product Families

### Core uDOS Family

- `uDOS-core`
- `uDOS-shell`
- `uDOS-host`
- `uDOS-wizard`
- `uDOS-themes`
- `uDOS-thinui`
- `uDOS-workspace`
- `uDOS-docs`
- `uDOS-plugin-index`
- `uDOS-groovebox`
- `uDOS-gameplay`
- `uDOS-grid`
- `uDOS-dev`

### Adjacent Sonic Family

- `sonic-screwdriver`
- `sonic-ventoy`

Reason:

- Sonic is a standalone installer, recovery, and deployment product.
- Ventoy is only consumed through Sonic's boot-media lane.

### Adjacent uHOME Family

- `uHOME-server`
- `uHOME-client`
- `uHOME-matter`
- `uHOME-app-android`
- `uHOME-app-ios`

Reason:

- `uHOME` is its own product family with home/media/console gravity.
- It should consume the uDOS runtime spine rather than stay inside the core
  completion lane.

## Shared Contract Rule

Split families must still interoperate through stable contracts:

- `uDOS-core` semantic/runtime contracts
- `uDOS-host` runtime host contracts
- `uDOS-plugin-index` and theme/command registries where relevant
- explicit install and handoff contracts from Sonic into Ubuntu profiles

## Active Root Layout

Portable convention (replace with your machine’s development root):

- core family root: `~/Code/uDOS-family`
- Sonic family root: `~/Code/sonic-family`
- `uHOME` family root: `~/Code/uHOME-family`

## Active Split Rules

- docs and workspaces must reflect the live split, not the old shared-folder
  layout
- active core completion rounds must not treat Sonic and `uHOME` as equal-weight
  core lanes
- cross-family dependencies must remain contract-first
- adjacent family repos must resolve shared `uDOS` contracts from the
  `uDOS-family` root rather than reintroduce duplicated copies
