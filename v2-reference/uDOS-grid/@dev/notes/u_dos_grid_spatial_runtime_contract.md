# uDOS v2 — Spatial Runtime Contract (uDOS-grid)

## Purpose

The Spatial Runtime Contract defines how the uDOS-grid system operates at runtime. It specifies how spatial references are resolved, how artifacts are discovered and validated, how proximity conditions are checked, and how spatial data is indexed and traversed.

This contract allows the spatial model to function as an operational subsystem of the OS while remaining independent from rendering engines or gameplay systems.

The runtime is intentionally **deterministic, text-first, and filesystem-compatible**.

---

# Core Runtime Responsibilities

The spatial runtime must provide the following capabilities:

- resolve canonical spatial identities
- load seed spatial data
- attach and index artifacts by place
- evaluate spatial conditions
- validate proximity rules
- support traversal and discovery
- project external coordinate systems

The runtime **does not render worlds** and **does not simulate gameplay**.

---

# Canonical Spatial Identity

All runtime spatial operations are based on the canonical address format:

```
L{Layer}-{Cell}[-Z{z}]
```

Examples:

```
L300-AJ11
L300-AJ11-Z1
L300-AJ11-Z-2
```

Portable spatial references use the full PlaceRef format:

```
ANCHOR:SPACE:LAYER-CELL[-Z]
```

Example:

```
EARTH:SUR:L300-AJ11
EARTH:SUB:L300-AJ11-Z-3
GAME:udosworld:SUR:L420-BD12
```

The runtime must parse and validate both formats.

---

# Spatial Resolution

## Resolution Order

When resolving a location, the runtime should evaluate components in this order:

1. Anchor
2. Space
3. Layer
4. Cell
5. Z offset

Example resolution:

```
EARTH:SUR:L300-AJ11-Z1
```

Resolution steps:

1. locate anchor `EARTH`
2. resolve space `SUR`
3. load layer `L300`
4. identify cell `AJ11`
5. apply local vertical offset `Z1`

The resulting object is the **resolved place context**.

---

# Seed Data Loading

The runtime loads seed data during spatial system initialization.

Recommended load order:

1. layer registry
2. place registry
3. artifact registry
4. optional render templates

Example seed path:

```
memory/spatial/
```

Subdirectories:

```
layers/
places/
artifacts/
templates/
indexes/
```

Seed data provides the baseline spatial world.

User-created spatial data may extend it.

---

# Spatial Indexing

The runtime maintains indexes for efficient lookup.

Primary indexes:

### Place Index

```
place_id -> place record
```

### Layer Index

```
layer_id -> layer record
```

### Artifact Index

```
place_id -> artifacts
```

### Alias Index

```
alias -> place_id
```

### Timezone Index

```
timezone -> places
```

These indexes allow fast lookup and discovery.

---

# Artifact Attachment

Artifacts are OS objects that can be attached to spatial locations.

Examples:

- compiled binders
- vaults
- crypts
- portals
- beacons

Artifacts reference one or more places:

```yaml
artifact_id: binder.crypt.south
artifact_type: compiled-binder
places:
  - EARTH:SUB:L300-AJ11-Z-3
```

The runtime must be able to query:

- artifacts at a place
- artifacts near a place
- artifacts gated by conditions

---

# Spatial Traversal

Traversal allows movement across grid cells.

Traversal is defined by grid adjacency.

Default directions:

```
north
south
east
west
```

Optional diagonals:

```
north-east
north-west
south-east
south-west
```

Traversal occurs within a layer unless explicitly crossing layers.

Example traversal query:

```
getNeighbors(EARTH:SUR:L300-AJ11)
```

Returns adjacent cells.

---

# Conditional Location Evaluation

Spatial conditions gate actions.

Example conditions:

- unlock crypt
- reveal binder
- activate beacon

Condition example:

```yaml
conditions:
  place: EARTH:SUB:L300-AJ11-Z-3
  proximity_required: true
  handshake_required: true
```

Evaluation flow:

1. resolve place
2. verify user position
3. evaluate proximity rule
4. evaluate handshake rule
5. unlock artifact

The grid runtime performs condition validation.

---

# Proximity Verification

Proximity rules allow real-world interaction.

Verification methods are handled by **uDOS-wizard** but evaluated by grid.

Example methods:

- NFC
- Bluetooth
- QR exchange
- local beacon

Runtime interface example:

```
verifyProximity(user, place)
```

Result:

```
true | false
```

---

# Coordinate Projection

The runtime may map real-world coordinates to grid cells.

Example metadata:

```yaml
coordinates:
  system: WGS84
  lat: -27.4698
  lon: 153.0251
```

Projection algorithm maps coordinates to grid cells.

The projection system must remain deterministic.

---

# Spatial Discovery

Discovery allows users to explore spatial locations.

Discovery queries may include:

```
findNearbyPlaces
findArtifacts
searchByAlias
searchByTag
```

Discovery does not require gameplay rendering.

It operates entirely through spatial indexes.

---

# Runtime Interfaces

Example runtime interface functions:

```
resolvePlace(placeRef)
getArtifacts(placeRef)
getNeighbors(placeRef)
verifyConditions(placeRef, user)
projectCoordinates(lat, lon)
searchPlaces(query)
```

These functions allow shell, wizard, and gameplay systems to interact with the spatial runtime.

---

# Runtime Boundaries

### uDOS-grid runtime

Owns:

- spatial identity resolution
- place and layer indexing
- artifact attachment
- spatial condition evaluation
- coordinate projection

### uDOS-wizard

Owns:

- device proximity verification
- handshake flows

### uDOS-gameplay

Owns:

- rendering
- world traversal visuals
- gameplay systems

Gameplay must consume spatial truth rather than replacing it.

---

# Design Principles

The spatial runtime must remain:

- deterministic
- ASCII compatible
- metadata driven
- renderer agnostic
- filesystem compatible

This ensures the spatial system remains a stable foundation for both OS functionality and optional gameplay layers.


---

# Spatial Index + Storage Model

This section defines how spatial data is stored and indexed so that the runtime contract can be implemented efficiently while remaining portable and filesystem‑friendly.

## Storage Philosophy

The spatial system should support multiple storage backends without changing the runtime contract:

- JSON seed files (default distribution)
- SQLite index (runtime acceleration)
- filesystem metadata overlays

Seed data remains human‑readable while runtime indexes provide performance.

---

# Canonical Storage Layout

Recommended directory layout:

```
memory/spatial/

  layers/
  places/
  artifacts/
  templates/
  indexes/

  cache/
```

### Purpose of directories

| Directory | Purpose |
|---|---|
| layers | canonical layer definitions |
| places | place records |
| artifacts | spatially attached OS objects |
| templates | optional render templates |
| indexes | generated lookup indexes |
| cache | runtime caches |

---

# Runtime SQLite Index (Optional but Recommended)

A lightweight SQLite database may be generated at runtime.

Example file:

```
memory/spatial/index.db
```

This database is derived from seed JSON files.

It must be rebuildable at any time.

---

# Core Tables

## layers

```
layers(
  layer_id TEXT PRIMARY KEY,
  anchor TEXT,
  space TEXT,
  domain TEXT,
  cols INTEGER,
  rows INTEGER
)
```

## places

```
places(
  place_id TEXT PRIMARY KEY,
  anchor TEXT,
  space TEXT,
  layer INTEGER,
  cell TEXT,
  z INTEGER,
  name TEXT,
  kind TEXT,
  region TEXT,
  timezone TEXT
)
```

## artifacts

```
artifacts(
  artifact_id TEXT PRIMARY KEY,
  artifact_type TEXT,
  canonical_name TEXT
)
```

## artifact_places

```
artifact_places(
  artifact_id TEXT,
  place_id TEXT
)
```

## aliases

```
aliases(
  alias TEXT,
  place_id TEXT
)
```

---

# Spatial Indexes

Recommended database indexes:

```
INDEX idx_places_layer
INDEX idx_places_cell
INDEX idx_places_anchor
INDEX idx_artifact_places
INDEX idx_aliases
```

These support fast discovery and lookup.

---

# Traversal Graph

Traversal across cells is deterministic because the grid geometry is fixed.

Cells can be derived algorithmically rather than stored.

Example adjacency logic:

```
neighbor north  = row - 1
neighbor south  = row + 1
neighbor east   = column + 1
neighbor west   = column - 1
```

Optional diagonals may be enabled by runtime configuration.

Traversal graphs therefore do not need to be persisted in storage.

---

# Coordinate Projection Cache

Real‑world coordinate projections may be cached.

Example table:

```
coordinate_projection(
  lat REAL,
  lon REAL,
  place_id TEXT
)
```

Projection algorithms must remain deterministic so cache entries can be rebuilt.

---

# Artifact Discovery Index

Artifacts may be indexed by multiple discovery attributes.

Example optional fields:

- tags
- binder_id
- visibility
- seed flag

Example table extension:

```
artifact_meta(
  artifact_id TEXT,
  key TEXT,
  value TEXT
)
```

This supports flexible queries without rigid schema expansion.

---

# Runtime Cache

The runtime may maintain in‑memory caches for:

- recently resolved places
- artifact lookup results
- coordinate projection results

Caches must always be safe to invalidate.

---

# Rebuild Process

The runtime must support rebuilding the spatial index.

Example flow:

1. clear index database
2. load seed JSON files
3. populate tables
4. generate indexes

Example command:

```
udos grid rebuild-index
```

This ensures spatial state remains reproducible and portable.

---

# Storage Design Principles

The spatial storage system must remain:

- deterministic
- rebuildable
- human inspectable
- filesystem friendly
- renderer independent

Seed JSON files remain the **canonical source of truth**, while the SQLite index exists purely as a runtime acceleration layer.

This model keeps the spatial runtime lightweight while still supporting large exploration maps and artifact discovery systems.


---

# Spatial Commands + CLI Contract

The spatial system must be operable through the uDOS command interface. This ensures the grid can be explored, queried, and manipulated without requiring graphical rendering.

Commands operate on canonical spatial identities and interact with the spatial runtime.

---

## Core Command Namespace

Recommended root command:

```
udos grid
```

Alternative namespaces may be provided for usability:

```
udos place
udos artifact
udos map
```

---

# Place Commands

## Resolve Current Location

```
udos place here
```

Returns the resolved PlaceRef for the current context.

Example output:

```
EARTH:SUR:L300-AJ11
Brisbane
Queensland, Australia
```

---

## Navigate to a Place

```
udos place goto <place>
```

Examples:

```
udos place goto brisbane
udos place goto EARTH:SUR:L300-AJ11
```

Resolution may use alias lookup.

---

## Show Place Details

```
udos place show <place>
```

Displays metadata for the location.

Example:

```
name: Brisbane
layer: L300
cell: AJ11
timezone: Australia/Brisbane
artifacts: 3
```

---

# Grid Commands

## List Neighbor Cells

```
udos grid neighbors <place>
```

Example:

```
udos grid neighbors EARTH:SUR:L300-AJ11
```

Output example:

```
north  L300-AJ10
south  L300-AJ12
east   L300-AK11
west   L300-AI11
```

---

## Traverse Grid

```
udos grid move <direction>
```

Examples:

```
udos grid move north
udos grid move east
```

Traversal updates the current spatial context.

---

# Artifact Commands

## List Artifacts at Location

```
udos artifact list <place>
```

Example:

```
udos artifact list here
```

---

## Drop Artifact

Places an artifact at the current spatial location.

```
udos artifact drop <artifact_id>
```

Example:

```
udos artifact drop binder.crypt.south
```

---

## Discover Artifacts

```
udos artifact discover
```

Evaluates discovery rules and returns artifacts visible at the location.

---

# Map Commands

## Render ASCII Map

```
udos map render
```

Renders the current grid layer in ASCII format.

Example:

```
L300

.............
.....@.......
.............
```

Where `@` represents the current position.

---

## Render Neighbor Map

```
udos map local
```

Displays a small region around the current cell.

---

# Seed Exploration Commands

## List Seed Locations

```
udos place seeds
```

Returns seed exploration locations available on the current layer.

---

## Discover Nearby Seed Locations

```
udos place nearby
```

Lists seed places near the current grid position.

---

# Administrative Commands

## Rebuild Spatial Index

```
udos grid rebuild-index
```

Reloads seed data and regenerates the spatial index database.

---

## Validate Spatial Data

```
udos grid validate
```

Checks seed files and indexes for structural errors.

---

# Command Design Principles

The spatial CLI must remain:

- deterministic
- human-readable
- scriptable
- renderer-independent

This ensures that the spatial system can function fully within the terminal while remaining compatible with higher-level interfaces such as graphical shells or gameplay engines.

---

# Example User Flow

Example exploration session:

```
udos place here
udos map local
udos artifact discover
udos grid move north
udos place nearby
udos artifact drop binder.secret
```

This demonstrates how spatial OS features can be accessed directly through the command interface.

