# uDOS-grid — Spatial Identity, Layers, Locations, and Spatial Filesystem Brief

## Purpose

uDOS-grid defines the canonical spatial model for uDOS v2.

It owns:

- canonical flat grid identity
- location verification for conditional actions
- layer and location integration
- spatial attachment of files, binders, logs, and compiled artefacts
- projection between real-world coordinates and uDOS place references
- seed spatial maps and discoverable world scaffolds
- minimal policy support for proximity and place-gated operations

uDOS-grid is text-first, layered, deterministic, and flat by default.

It is not the 3D engine, scene graph, physics system, or gameplay renderer.

## Core Principle

Spatial truth lives in uDOS-grid.

Views, renderers, and gameplay spaces are downstream interpretations of canonical place identity.

This means:

- the grid owns identity
- locations attach to canonical place references
- gameplay may extend or reinterpret place, but not redefine persistence truth
- conditional actions validate against grid truth
- files and binders resolve to place records, not renderer-specific coordinates

## Canonical Addressing

Primary location format:

`L{Layer}-{Cell}[-Z{z}]`

Examples:

- `L300-AB10`
- `L300-AB10-Z1`
- `L300-AB10-Z-2`

Rules:

- `Layer` is the canonical map plane / scale band
- `Cell` is the canonical 80x30 tile address
- `Z` is an optional signed local vertical offset
- omitted `Z` implies `z=0`

## Z Semantics

`z` is always a **local vertical offset relative to the resolved canonical place plane**.

This is the default meaning in both flat world and 3D world.

### In flat / ASCII / text world

`z` expresses semantic verticality relative to the tile plane:

- `Z0` = tile plane
- `Z1..Zn` = above-plane structures, decks, bridges, rooftops, platforms
- `Z-1..Z-n` = below-plane structures, basements, tunnels, crypts, vaults

### In gameplay / 3D world

`z` keeps the same logical meaning, but a renderer may map it to height, floor, altitude, chunk offset, or movement space.

uDOS-grid does not define geometric metres, camera logic, or engine transforms.

## Layers and Locations

Layers and locations should integrate as **scale + place**, not as competing systems.

### Recommendation

- `Layer` = world scale / map band / projection level
- `Cell` = addressable tile within that layer
- `Location` = named, typed, metadata-rich place anchored to one or more cells
- `z` = local vertical offset within that place context

### Model

A location is not a replacement for a grid cell.

A location is a semantic record attached to grid space.

A location can:

- resolve to one primary cell
- span multiple cells
- exist across multiple layers as different abstractions
- expose aliases, tags, binder links, and conditions
- be projected from real-world or virtual coordinates

## Canonical Place Record

Suggested shape:

```yaml
place_id: EARTH:SUR:L300-AJ11
name: Brisbane
layer: 300
cell: AJ11
z: 0
space: SUR
anchor: EARTH
kind: city
region: Queensland
timezone: Australia/Brisbane
coordinates:
  system: WGS84
  lat: -27.4698
  lon: 153.0251
aliases:
  - brisbane
  - meanjin
seed: true
```

## Spaces

Keep space separate from layer:

- `SUR` = surface / overworld
- `SUB` = underground / interior / dungeon / crypt / vault
- `UDN` = hidden, beaconed, inverted, or gated under-network space

This allows the same layer band to host multiple spatial realities without multiplying address systems.

## Conditional Location Rules

uDOS-grid must verify location for conditional actions.

Examples:

- unlock crypt
- reveal binder cache
- enable handshake-only exchange
- activate beacon
- open portal / transition / vault

Suggested policy shape:

```yaml
conditions:
  place: EARTH:SUB:L300-AJ11-Z-2
  proximity:
    required: true
    radius_m: 5
  handshake:
    required: true
    methods: [nfc, bluetooth]
  role:
    any_of: [owner, invited]
  state:
    required_flags: [crypt_key_present]
action: unlock_crypt
```

uDOS-grid validates place truth.

Wizard, gameplay, or app layers may perform the UX and transport work.

## Spatial Filesystem

### Principle

The filesystem should remain normal enough to work everywhere.

Spatial meaning should be carried by metadata and indexed records, not forced into every path and filename.

### Recommendation

Use a **spatial filesystem overlay**:

- normal files remain in human-readable folders
- files gain spatial attachment via front matter / sidecar / index db
- the grid index resolves files, binders, logs, and artefacts by place

### Example document

```yaml
---
title: South Crypt Binder
canonical_name: south-crypt-binder
places:
  - EARTH:SUB:L300-AJ11-Z-3
binder_id: binder.crypt.south
kind: compiled-binder
seed: false
visibility: discoverable
conditions:
  action: unlock_crypt
  handshake_required: true
---
```

## Binder as Place / Crypt

This is the clean integration point for gameplay without bloating core.

A compiled binder can be treated as a **place-bound artefact**.

That means a binder can be:

- left in a real-world location
- hidden in a crypt or vault
- attached to a virtual dungeon room
- anchored to a seed exploration layer
- surfaced through gameplay rules while still remaining an OS artefact

### Concept

- core stores and resolves binder identity
- grid binds the binder to place
- wizard validates proximity or handshake conditions
- gameplay renders discovery, traversal, portals, crypt doors, encounters, or map visuals

### Result

Gameplay becomes a lens over canonical OS operations, rather than a second runtime.

## Real, Virtual, and Cosmic Locations

Use the same place system across realities.

### Examples

- `EARTH:SUR:L300-AJ11` = real world surface place
- `EARTH:SUB:L300-AJ11-Z-3` = real world crypt / underground / hidden vault
- `GAME:udosworld:SUR:L420-BD12` = virtual level surface
- `GAME:udosworld:SUB:L420-BD12-Z-8` = dungeon layer
- `SKY:ORB:L700-AC20-Z4` = orbital location
- `BODY:MARS:SUR:L610-AB22` = planetary mapping

This keeps one mental model while allowing multiple anchors and realities.

## Seed Layer Maps

The v1 seed data should be incorporated into v2, but normalised into a cleaner canonical structure.

The newly surfaced seed files show four distinct seed families:

- Earth layer templates with presentational formats such as teletext, ASCII, SVG, and diagrams fileciteturn5file0
- Galaxy layer templates for orbital and deep-space relay structures fileciteturn5file1
- A very large terrestrial location seed set for `L300-L305` built around an `80 x 30` grid, IANA timezone anchors, layer/cell identities, and derived fields such as `depth` and `effective_layer` fileciteturn5file2
- Virtual overlay layers for workspace and data-mesh style worlds fileciteturn5file3

### v2 recommendation

Retain the seed concept, but separate **canonical spatial data** from **render templates**.

### Canonical seed categories

- `earth` = real-world terrestrial and regional anchors
- `virtual` = synthetic or application-defined worlds
- `orbital` / `galaxy` = cosmic and relay-scale anchors
- `seed_places` = named locations attached to canonical cells
- `seed_templates` = optional view/render templates for TUI, teletext, SVG, diagrams

### Normalisation rule

The v1 seed files currently mix some concerns together:

- canonical location identity
- effective layer derivation
- presentation template data
- legacy ids containing multiple embedded cell references
- timezone catalogue behaviour

In v2 these should be split.

#### 1. Canonical layer registry

```yaml
layer_id: L300
anchor: EARTH
space: SUR
domain: terrestrial
band: seed
kind: canonical-grid
cols: 80
rows: 30
```

#### 2. Canonical place seed

```yaml
place_id: EARTH:SUR:L300-AJ11
name: Brisbane
layer: 300
cell: AJ11
z: 0
space: SUR
anchor: EARTH
continent: Australia
region: Australia
timezone: Australia/Brisbane
type: city
region_type: urban
seed: true
```

This matches the existing seed intent while removing ambiguity. For example, the terrestrial seed clearly places Brisbane at `L300-AJ11`, Adelaide at `L300-BI24`, Canberra at `L300-BH28`, Sydney at `L300-AT32`, Melbourne at `L300-AW17`, and Perth at `L300-BZ24`. fileciteturn5file2

#### 3. Optional seed template

```yaml
template_id: EARTH-L100-teletext
layer_id: L100
format: teletext
palette: terrestrial
usage: optional-render-template
```

This preserves files like the Earth, galaxy, and virtual layer template sets, but makes them explicitly optional view assets instead of canonical location truth. fileciteturn5file0 fileciteturn5file1 fileciteturn5file3

### Important v2 cleanup decisions

#### A. Make `PlaceRef` the canonical id

Prefer:

- `EARTH:SUR:L300-AJ11`
- `EARTH:SUB:L300-AJ11-Z-3`
- `GAME:udosworld:SUR:L500-AB10`

Do not keep legacy composite ids such as `L300-BV34-AQ35` as canonical identity. Those can survive only as imported legacy source ids if needed. The v1 seed shows a mixture of clean ids and composite ids, so a normalisation pass is important. fileciteturn5file2

#### B. Convert `depth` / `effective_layer` into explicit semantics

Where the seed currently uses:

- `depth`
- `effective_layer`

v2 should prefer:

- `space: SUR | SUB | UDN`
- `z`
- optional `depth`
- canonical base `layer`

That avoids treating derived or projected state as the canonical identity.

#### C. Keep templates out of core truth

The Earth, galaxy, and virtual layer files are valuable, but they read as view/template assets rather than canonical map definitions. They should therefore live as optional seed render packs, not as the authoritative place registry. fileciteturn5file0 fileciteturn5file1 fileciteturn5file3

### Suggested v2 seed file layout

```text
memory/
  spatial/
    layers/
      earth.layers.json
      virtual.layers.json
      orbital.layers.json
    places/
      earth.seed.places.json
      virtual.seed.places.json
      galaxy.seed.places.json
    templates/
      earth.templates.json
      virtual.templates.json
      galaxy.templates.json
    indexes/
      timezone.index.json
      aliases.index.json
      legacy-id-map.json
```

### Seed exploration model

Seed maps should ship as explorable scaffolds, not just as hidden lookup data.

That means the seed system can provide:

- default real-world discovery locations
- tutorial places and onboarding routes
- public crypts / vaults / portals for demo flows
- sample virtual layers and holographic workspaces
- orbital and cosmic anchors for later exploration bands

This is where gameplay can plug in cleanly:

- core/grid loads canonical seed truth
- shell can browse and search it
- wizard can use it for verified location and proximity flows
- gameplay can render it as explorable worldspace

## Layers, Locations, and the Spatial Filesystem

### Scale + place model

Use the following rule throughout the spatial spec:

- `Layer` = scale band / projection plane
- `Cell` = canonical tile address
- `Location` = semantic place attached to grid space
- `PlaceRef` = portable canonical place identity
- `z` = local vertical offset relative to the resolved place plane

This keeps the grid flat and canonical, while allowing named places, virtual overlays, and gameplay spaces to coexist without creating competing coordinate systems.

### Spatial filesystem overlay

The spatial filesystem should act as an overlay across ordinary files.

That means:

- normal folders and filenames remain human-readable
- spatial meaning is attached through metadata and indexes
- files, binders, logs, beacons, portals, and crypts can all resolve to place records
- the seed maps provide the default world scaffold those artefacts can attach to

### Binder as crypt architecture

A compiled binder should be able to exist as a place-bound artefact within the spatial filesystem.

Examples:

- a binder left at a real-world seed location
- a binder hidden in `EARTH:SUB:L300-AJ11-Z-3`
- a binder embedded in a virtual dungeon or level
- a binder placed in orbital or galaxy seed space

Suggested record shape:

```yaml
artifact_id: binder.crypt.south
artifact_type: compiled-binder
canonical_name: south-crypt-binder
places:
  - EARTH:SUB:L300-AJ11-Z-3
seed_attached: false
discoverable: true
conditions:
  action: unlock_crypt
  proximity_required: true
  handshake_required: true
```

### Why this avoids core bloat

Because the responsibilities stay split:

- grid owns canonical place truth
- filesystem overlay owns attachment and lookup
- wizard owns proximity and handshake verification
- gameplay owns presentation, traversal, and encounter logic

So gameplay is incorporated into OS operations by spatial attachment, not by moving game logic into core.

## v2 Seed Data Normalisation Contract

The v1 seed assets must be normalised so that canonical spatial truth is cleanly separated from optional rendering templates and exploration assets.

The goal is that **uDOS-grid loads only canonical spatial truth**, while shells, themes, and gameplay engines may optionally load render packs.

### Canonical objects

uDOS-grid should only load three canonical spatial object types:

- `layer`
- `place`
- `artifact`

Everything else (templates, diagrams, ASCII maps, SVG, teletext, etc.) is optional.

---

# Layer Object

Defines a canonical spatial projection band.

```yaml
layer_id: L300
anchor: EARTH
space: SUR
domain: terrestrial
kind: canonical-grid
cols: 80
rows: 30
seed: true
```

### Layer meaning

Layers represent **scale and projection**, not physical height.

Example bands:

| Layer Range | Meaning |
|--------------|--------|
| L300-L305 | terrestrial seed exploration |
| L306-L399 | regional overlays |
| L400-L499 | metropolitan / dense overlays |
| L500-L599 | continental scale |
| L600-L699 | planetary |
| L700-L799 | orbital |
| L800-L899 | stellar / cosmic |

These bands provide expansion headroom without changing the canonical address format.

---

# Place Object

Places attach meaning to canonical grid space.

```yaml
place_id: EARTH:SUR:L300-AJ11
name: Brisbane
anchor: EARTH
space: SUR
layer: 300
cell: AJ11
z: 0
continent: Australia
region: Queensland
country: Australia
timezone: Australia/Brisbane
kind: city
aliases:
  - brisbane
  - meanjin
seed: true
```

### Rules

- a place may reference one or more grid cells
- a place may exist in multiple spaces
- a place may span multiple layers
- `z` defaults to `0`

Places are semantic, human‑meaningful records layered over grid identity.

---

# Artifact Object

Artifacts represent OS objects that are spatially attached.

Artifacts may include:

- compiled binders
- vaults
- crypts
- beacons
- portals
- messages
- logs

Example:

```yaml
artifact_id: binder.crypt.south
artifact_type: compiled-binder
canonical_name: south-crypt-binder
places:
  - EARTH:SUB:L300-AJ11-Z-3
seed_attached: false
visibility: discoverable
conditions:
  action: unlock_crypt
  proximity_required: true
  handshake_required: true
```

Artifacts are **OS entities first** and gameplay objects second.

This keeps gameplay optional.

---

# Legacy ID Mapping

The v1 seeds contain composite identifiers such as:

```
L300-BV34-AQ35
```

These must not remain canonical in v2.

Instead they are preserved in a migration map.

Example:

```yaml
legacy_id: L300-BV34-AQ35
canonical_place: EARTH:SUR:L300-AJ11
source: v1.seed
```

This ensures backward compatibility while keeping the new identity system clean.

---

# Spatial Filesystem Contract

The spatial filesystem acts as an **overlay index**.

Files remain normal.

Spatial meaning is attached via metadata.

Example:

```yaml
---
title: South Crypt Binder
canonical_name: south-crypt-binder
places:
  - EARTH:SUB:L300-AJ11-Z-3
binder_id: binder.crypt.south
kind: compiled-binder
visibility: discoverable
conditions:
  action: unlock_crypt
  proximity_required: true
---
```

This allows:

- normal filesystem usage
- spatial discovery
- binder‑crypt mechanics
- gameplay integration

without forcing spatial complexity into filenames or directory structures.

---

# Seed Exploration Model

Seed maps are shipped as explorable world scaffolds.

They provide:

- named real‑world anchors
- onboarding routes
- demonstration crypts and vaults
- exploration examples
- tutorial locations

Example flow:

1. user explores seed map
2. user discovers location
3. grid verifies location
4. artifact unlocks
5. gameplay optionally renders discovery

This allows OS operations and gameplay to share the same spatial foundation.

---

# Final Architectural Boundaries

### uDOS-grid

Owns:

- canonical grid identity
- layer registry
- place records
- artifact spatial attachment
- conditional location validation
- seed map loading
- real/virtual coordinate projection

### uDOS-wizard

Owns:

- NFC / Bluetooth proximity verification
- handshake flows
- in‑person identity exchange
- network verification

### uDOS-gameplay

Owns:

- rendering
- world traversal
- dungeon / level presentation
- camera and scene graph
- encounters and mechanics

Gameplay is therefore a **lens over OS spatial truth**, not a replacement runtime.

---

# Summary

uDOS-grid provides a flat, layered ASCII‑compatible spatial model that maps both real‑world and virtual locations into a canonical address system.

The model remains:

- deterministic
- text‑first
- filesystem‑compatible
- metadata‑driven

By binding artifacts and binders to canonical places, the system allows gameplay mechanics such as crypts, vaults, and exploration to exist naturally within OS operations without expanding the core runtime.

