# Step 3 — Spatial / layer / map system

## Goal

Treat location and layer data as first-class binder objects.

This is a Tier 2 optional capability. It should not be treated as part of the
Tier 1 release baseline for the markdown-first command-centre path.

This enables:
- real-world campaign territories
- venue maps
- crypt/drop points
- route planning
- virtual levels
- gameplay-linked operating surfaces
- planet / dimension / outer-space style layer sets

## Model

A spatial object is not just a point on a map. It is a binder-linked reference in a layer-aware filesystem.

## Core object types

### Layer
A world or space context.

Examples:
- earth-australia
- virtual-grid-1
- home-network
- planet-seed-01
- orbit-shell
- crypt-layer-public

### Location
A point or area in a layer.

Examples:
- Adelaide Festival Centre
- Brisbane CBD
- Sector 7 node
- Orbit relay marker

### Zone
A bounded area or region.

Examples:
- national-tour-east
- virtual-demo-realm
- campaign-radius-5km

### Route
An ordered path between locations or zones.

Examples:
- adelaide-media-run
- launch-route-v1
- patrol-path-gamma

### Artifact
A binder-linked object placed within a layer.

Examples:
- crypt
- note
- package
- publish trigger
- event beacon
- compiled binder shard

## Spatial object example

```yaml
spatial_object:
  id: crypt-footloose-adelaide
  kind: artifact
  binder_id: footloose-adelaide-launch
  layer_id: earth-australia
  location:
    mode: geo
    lat: -34.9205
    lng: 138.6007
  visibility:
    access: public-password
    state: active
  metadata:
    title: Adelaide street crypt
    tags: [tour, crypt, promo]
    publish_linked: true
```

## Layer schema sketch

```yaml
layer:
  id: earth-australia
  type: physical
  parent: earth
  projection: web-mercator
  visibility: standard
  capabilities:
    geocoded: true
    routable: true
    gameplay: optional
```

```yaml
layer:
  id: virtual-grid-1
  type: virtual
  parent: null
  projection: grid
  visibility: internal
  capabilities:
    geocoded: false
    routable: true
    gameplay: true
```

## Workspace view behaviors

### Map mode
- marker and area display
- cluster/filter by layer
- view linked tasks/publish entries
- route overlays
- quick inspector actions

### Layer switcher
- physical
- virtual
- home/private
- crypt/public
- orbit/external

### Inspector
- binder link
- task link
- publish link
- permissions
- route membership
- artifact status

## Boundaries

### Core
Owns canonical spatial contracts

### Workspace
Owns visualization, filtering, inspectors, and map/layer UX

### Wizard
Owns browser rendering and optional provider-backed map presentation surfaces.
Runtime-backed networking, credentials, and shared host policy should remain
owned by the Ubuntu command-centre host.

### Empire
Consumes spatial references where publishing or events are location-sensitive

## Seed recommendations

Start with:
- earth-australia
- national-tour
- venue-network
- virtual-demo-grid
- crypt-public
- home-private

Do not block Tier 1 implementation on any of these seeds. Spatial work should
follow after the core runtime, browser host bridge, and binder/document flow
are stable.
