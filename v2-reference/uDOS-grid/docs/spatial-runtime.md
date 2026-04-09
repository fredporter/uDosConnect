# uDOS-grid Spatial Runtime

## Purpose

Define how the uDOS-grid system operates at runtime. The spatial runtime is
deterministic, text-first, and filesystem-compatible.

## Runtime Responsibilities

- resolve canonical place identities
- load seed spatial data on startup
- attach and index artifacts by place
- evaluate spatial conditions
- validate proximity rules
- support traversal and discovery
- project external coordinate systems onto grid cells

## Runtime Non-Goals

- world rendering
- simulation or physics loops
- camera or geometry systems
- gameplay presentation

---

## Canonical Identity

Short form:

`L{Layer}-{Cell}[-Z{z}]`

Portable place reference (PlaceRef):

`ANCHOR:SPACE:LAYER-CELL[-Z]`

Examples:

- `L300-AJ11`
- `EARTH:SUR:L300-AJ11`
- `EARTH:SUB:L300-AJ11-Z-3`
- `GAME:udosworld:SUR:L420-BD12`
- `SKY:ORB:L700-AC20-Z4`

---

## Spatial Resolution

Resolution order when resolving a PlaceRef:

1. Anchor
2. Space
3. Layer
4. Cell
5. Z offset

Example: `EARTH:SUR:L300-AJ11-Z1`

1. locate anchor `EARTH`
2. resolve space `SUR`
3. load layer `L300`
4. identify cell `AJ11`
5. apply local vertical offset `Z1`

The result is the **resolved place context**.

---

## Seed Load Order

The runtime loads seed data during spatial system initialization:

1. layer registry
2. place registry
3. artifact registry
4. optional render templates (downstream, not canonical truth)

Seed data path: `memory/spatial/`

---

## Spatial Indexes

The runtime maintains indexes for efficient lookup:

| Index | Key | Value |
| --- | --- | --- |
| Place Index | `place_id` | place record |
| Layer Index | `layer_id` | layer record |
| Artifact Index | `place_id` | artifacts at place |
| Alias Index | `alias` | `place_id` |
| Timezone Index | `timezone` | places in timezone |

---

## Traversal

Traversal allows movement across grid cells. Adjacency is deterministic from
the fixed 80x30 grid geometry and does not need to be stored.

Default directions: `north`, `south`, `east`, `west`

Optional diagonals: `north-east`, `north-west`, `south-east`, `south-west`

Adjacency logic:

```text
neighbor north  = row - 1
neighbor south  = row + 1
neighbor east   = column + 1
neighbor west   = column - 1
```

Traversal occurs within a layer unless explicitly crossing layers.

---

## Spatial Conditions

Conditions gate place-bound actions:

```yaml
conditions:
  place: EARTH:SUB:L300-AJ11-Z-3
  action: unlock_crypt
  handshake_required: true
```

Evaluation flow:

1. resolve place reference
2. verify actor role against required role set
3. verify proximity and optional handshake constraints
4. verify artifact gate policy
5. emit decision and audit payload

---

## Runtime Interfaces

Example runtime interface functions:

```text
resolvePlace(placeRef)
getArtifacts(placeRef)
getNeighbors(placeRef)
verifyConditions(placeRef, user)
projectCoordinates(lat, lon)
searchPlaces(query)
```

These allow Shell, Wizard, Gameplay, and apps to interact with the spatial
runtime without absorbing ownership of spatial truth.

---

## Coordinate Projection

The runtime may map real-world coordinates to grid cells.

```yaml
coordinates:
  system: WGS84
  lat: -27.4698
  lon: 153.0251
```

The projection algorithm must remain deterministic so results are rebuildable.

---

## Storage Model

The spatial system supports multiple storage backends without changing the
runtime contract:

- JSON seed files — default distribution, human-readable canonical source of truth
- SQLite index — runtime acceleration, derivable from seed files at any time
- filesystem metadata overlays — optional sidecar or frontmatter attachment

### SQLite Index (Optional but Recommended)

A lightweight SQLite database may be generated at runtime from seed JSON files.

Recommended file: `memory/spatial/index.db`

The index is never the canonical source of truth. It must be rebuildable from
seed JSON at any time.

Core tables: `layers`, `places`, `artifacts`, `artifact_places`, `aliases`

Key indexes: `idx_places_layer`, `idx_places_cell`, `idx_places_anchor`,
`idx_artifact_places`, `idx_aliases`

---

## Rebuild Process

The runtime must support rebuilding the spatial index:

1. clear index database
2. load seed JSON files
3. populate tables
4. generate indexes

Example command: `udos grid rebuild-index`

This ensures spatial state remains reproducible and portable.

---

## Runtime Rule

Grid runtime must stay:

- deterministic
- renderer agnostic
- filesystem compatible
- rebuildable from seed JSON

Shell, Wizard, Gameplay, and apps consume spatial truth through the runtime
interface. They must not bypass Grid-owned resolution or condition evaluation.
