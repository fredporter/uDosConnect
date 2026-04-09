# uDOS v2 — Seed Layer Data Specification

## Purpose

Seed layer data provides the initial spatial scaffolding shipped with uDOS v2. These layers allow users, developers, and gameplay extensions to immediately explore and interact with a canonical spatial world without requiring custom map generation.

Seed layers define **anchors, projection bands, and exploration scaffolds**. They do not define gameplay logic or renderer behaviour.

Seed layers are used by:

- uDOS-grid (canonical spatial registry)
- uDOS-shell (navigation and discovery)
- uDOS-wizard (location verification and proximity features)
- uDOS-gameplay (visualisation and traversal engines)

The system supports **real-world, virtual, planetary, orbital, and cosmic locations** using a unified spatial identity model.

---

# Core Spatial Identity

All spatial references use the canonical format:

`L{Layer}-{Cell}[-Z{z}]`

Examples:

```
L300-AJ11
L300-AJ11-Z1
L300-AJ11-Z-2
```

Portable location identity uses a full **PlaceRef** format:

```
ANCHOR:SPACE:LAYER-CELL[-Z]
```

Example:

```
EARTH:SUR:L300-AJ11
EARTH:SUB:L300-AJ11-Z-3
GAME:udosworld:SUR:L420-BD12
SKY:ORB:L700-AC20-Z4
```

---

# Grid Geometry

All seed layers use the canonical grid geometry:

- Columns: 80
- Rows: 30

Cells use two-letter column identifiers and numeric row identifiers.

Example cell:

```
AJ11
```

This geometry preserves compatibility with ASCII, TUI, and teletext style map rendering.

---

# Seed Layer Categories

Seed layers are grouped by **domain anchor**.

Domains define how a layer maps to reality or simulation.

Primary seed domains:

- Earth (real-world terrestrial)
- Virtual (application worlds)
- Orbital (near-planet space)
- Planetary (other planets and moons)
- Stellar (interstellar / galaxy scale)

Each domain may contain multiple layer bands.

---

# Earth Domain

Anchor:

```
EARTH
```

Primary purpose:

Real-world mapping and discovery.

Earth layers connect grid space to real-world coordinates using WGS84 projection metadata.

Example layer registry:

```yaml
layer_id: L300
anchor: EARTH
space: SUR
domain: terrestrial
cols: 80
rows: 30
seed: true
```

### Earth Seed Layer Bands

| Layer | Purpose |
|------|--------|
| L300-L305 | terrestrial seed world |
| L306-L399 | regional overlays |

### Example Places

```yaml
place_id: EARTH:SUR:L300-AJ11
name: Brisbane
continent: Australia
country: Australia
region: Queensland
timezone: Australia/Brisbane
coordinates:
  lat: -27.4698
  lon: 153.0251
```

```yaml
place_id: EARTH:SUR:L300-AT32
name: Sydney
continent: Australia
country: Australia
region: New South Wales
```

Earth seed layers support real-world exploration, location verification, and proximity-based features.

---

# Virtual Domain

Anchor:

```
GAME
```

Virtual layers provide application worlds, gameplay environments, and experimental spatial workspaces.

Example layer registry:

```yaml
layer_id: L420
anchor: GAME
space: SUR
domain: virtual
world: udosworld
cols: 80
rows: 30
seed: true
```

### Virtual Layer Uses

- tutorial worlds
- gameplay levels
- spatial workspaces
- collaborative environments
- learning environments

### Example Place

```yaml
place_id: GAME:udosworld:SUR:L420-BD12
name: tutorial plaza
kind: hub
seed: true
```

Virtual domains do not require real-world coordinates.

---

# Planetary Domain

Anchor format:

```
BODY:{planet}
```

Example anchors:

```
BODY:MARS
BODY:MOON
BODY:EUROPA
```

Planetary layers allow mapping of extraterrestrial bodies.

Example layer registry:

```yaml
layer_id: L610
anchor: BODY:MARS
space: SUR
domain: planetary
cols: 80
rows: 30
seed: true
```

### Example Place

```yaml
place_id: BODY:MARS:SUR:L610-AB22
name: olympus mons
kind: landmark
```

Planetary layers may optionally include astronomical coordinate systems.

---

# Orbital Domain

Anchor:

```
SKY
```

Orbital layers represent near-planet space and satellite networks.

Example layer registry:

```yaml
layer_id: L700
anchor: SKY
space: ORB
domain: orbital
cols: 80
rows: 30
seed: true
```

### Example Places

```yaml
place_id: SKY:ORB:L700-AC20
name: orbital relay
kind: station
```

Orbital layers support:

- relay networks
- satellite nodes
- gameplay exploration

---

# Stellar / Galaxy Domain

Anchor:

```
GALAXY
```

Stellar layers represent deep-space and galaxy-scale exploration.

Example layer registry:

```yaml
layer_id: L800
anchor: GALAXY
space: COS
domain: stellar
cols: 80
rows: 30
seed: true
```

### Example Places

```yaml
place_id: GALAXY:COS:L800-AA01
name: milky way core
kind: stellar-region
```

Galaxy layers primarily serve exploration and advanced gameplay.

---

# Optional Render Templates

Seed packs may also include optional render templates.

Examples:

- ASCII maps
- teletext layouts
- SVG diagrams
- gameplay visual layers

Example template object:

```yaml
template_id: EARTH-L300-teletext
layer_id: L300
format: teletext
palette: terrestrial
```

Templates are not canonical spatial truth.

They are optional visual aids.

---

# Seed Artifact Examples

Seed layers may include demo artifacts to demonstrate spatial operations.

Examples:

- starter vaults
- tutorial crypts
- sample binders

Example:

```yaml
artifact_id: tutorial.crypt
artifact_type: binder
places:
  - EARTH:SUB:L300-AJ11-Z-2
visibility: discoverable
seed: true
```

---

# Seed Data Storage Layout

Recommended filesystem structure:

```
memory/spatial/

  layers/
    earth.layers.json
    virtual.layers.json
    planetary.layers.json
    orbital.layers.json
    galaxy.layers.json

  places/
    earth.seed.places.json
    virtual.seed.places.json

  artifacts/
    seed.artifacts.json

  templates/
    earth.templates.json
    virtual.templates.json
    galaxy.templates.json

  indexes/
    timezone.index.json
    aliases.index.json
    legacy-id-map.json
```

---

# Design Principles

Seed layers must remain:

- deterministic
- ASCII compatible
- human readable
- metadata driven
- filesystem friendly

They provide a **discoverable spatial OS layer** that supports both real-world interaction and virtual exploration.

Gameplay engines may visualise these layers but must not replace canonical spatial truth defined by uDOS-grid.

