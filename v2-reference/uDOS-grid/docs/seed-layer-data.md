# uDOS-grid Seed Layer Data

## Purpose

Seed layer data provides the initial spatial scaffolding shipped with uDOS v2.
These layers allow users, developers, and gameplay systems to immediately explore
a canonical spatial world without requiring custom map generation.

Seed layers define anchors, projection bands, and exploration scaffolds.
They do not define gameplay logic or renderer behaviour.

## Grid Geometry

All seed layers use the canonical grid geometry:

- Columns: 80
- Rows: 30

Cells use two-letter column identifiers and numeric row identifiers (e.g. `AJ11`).
This preserves compatibility with ASCII, TUI, and teletext-style map rendering.

## Seed Domains

Seed layers are grouped by domain anchor. Domains define how a layer maps to
reality or simulation.

| Domain | Anchor | Layer Band | Purpose |
| --- | --- | --- | --- |
| Earth | `EARTH` | L300–L305 (seed), L306–L399 (regional overlays) | Real-world terrestrial mapping and discovery |
| Virtual | `GAME` | L420+ | Tutorial worlds, gameplay levels, collaborative environments |
| Planetary | `BODY:{planet}` | L610+ | Extraterrestrial bodies (Mars, Moon, Europa) |
| Orbital | `SKY` | L700+ | Near-planet space, relay networks, satellite nodes |
| Stellar / Galaxy | `GALAXY` | L800+ | Deep-space and galaxy-scale exploration |

---

## Earth Domain

Anchor: `EARTH`

Primary purpose: real-world mapping and discovery. Earth layers connect grid
space to real-world coordinates using WGS84 projection metadata.

```yaml
layer_id: L300
anchor: EARTH
space: SUR
domain: terrestrial
cols: 80
rows: 30
seed: true
```

Example seed places:

```yaml
place_id: EARTH:SUR:L300-AJ11
name: Brisbane
anchor: EARTH
space: SUR
region: Queensland
timezone: Australia/Brisbane
coordinates:
  lat: -27.4698
  lon: 153.0251
```

```yaml
place_id: EARTH:SUR:L300-AT32
name: Sydney
anchor: EARTH
space: SUR
region: New South Wales
```

Earth seed layers support real-world exploration, location verification, and
proximity-based features.

---

## Virtual Domain

Anchor: `GAME`

Virtual layers provide application worlds, gameplay environments, and
spatial workspaces. They do not require real-world coordinates.

Uses: tutorial worlds, gameplay levels, collaborative environments, onboarding routes.

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

```yaml
place_id: GAME:udosworld:SUR:L420-BD12
name: tutorial plaza
kind: hub
seed: true
```

---

## Planetary Domain

Anchor format: `BODY:{planet}` — examples: `BODY:MARS`, `BODY:MOON`, `BODY:EUROPA`

Planetary layers allow mapping of extraterrestrial bodies. They may optionally
include astronomical coordinate systems.

```yaml
layer_id: L610
anchor: BODY:MARS
space: SUR
domain: planetary
cols: 80
rows: 30
seed: true
```

```yaml
place_id: BODY:MARS:SUR:L610-AB22
name: olympus mons
kind: landmark
```

Status: **staged** — expansion seed entries defined in `seed/basic-layer-registry.json`.
Full place datasets and geological coordinate projection are future round work.

---

## Orbital Domain

Anchor: `SKY`

Orbital layers represent near-planet space and satellite networks.

```yaml
layer_id: L700
anchor: SKY
space: ORB
domain: orbital
cols: 80
rows: 30
seed: true
```

```yaml
place_id: SKY:ORB:L700-AC20
name: orbital relay
kind: station
```

Status: **staged** — expansion seed entry defined.

---

## Stellar / Galaxy Domain

Anchor: `GALAXY`

Stellar layers represent deep-space and galaxy-scale exploration. They primarily
serve exploration and advanced gameplay.

```yaml
layer_id: L800
anchor: GALAXY
space: COS
domain: stellar
cols: 80
rows: 30
seed: true
```

```yaml
place_id: GALAXY:COS:L800-AA01
name: milky way core
kind: stellar-region
```

Status: **staged** — expansion seed entry defined.

---

## Seed Registries

The current seed lane includes:

- `seed/basic-layer-registry.json` — all 5 domains; Earth/Virtual canonically reviewed; Planetary/Orbital/Stellar staged
- `seed/basic-place-registry.json` — canonical demo places (Brisbane, south crypt, tutorial plaza, north gate)
- `seed/basic-artifact-registry.json` — demo artifacts (gated binder, public beacon)
- `seed/canonical-demo-index.json` — demo index for sibling consumption

## Render Templates

Seed packs may include optional render templates (ASCII maps, teletext layouts,
SVG diagrams). These are **not** canonical spatial truth — they are optional
visual aids stored separately from place records.

## Design Principles

Seed layers must remain:

- deterministic
- ASCII compatible
- human readable
- metadata driven
- filesystem friendly

Gameplay engines may visualise these layers but must not replace canonical
spatial truth defined by uDOS-grid.
