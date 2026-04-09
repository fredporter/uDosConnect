# PlaceRef Contract Documentation

This document describes the PlaceRef contract for uDOS-core, which defines the canonical structure for spatial and file-location references.

## Purpose
- Provide a neutral, contract-level format for referencing places, layers, and cells in uDOS artifacts and files.
- Ensure Core can validate and parse PlaceRefs without owning spatial datasets or gameplay logic.

## Canonical Fields
- `place_ref`: Canonical PlaceRef string (e.g., `EARTH:SUR:L300-AJ11`, `L300-AJ11-Z1`)
- `anchor`: Domain anchor (e.g., `EARTH`, `GAME`, `BODY:MARS`)
- `layer`: Layer identifier (e.g., `L300`)
- `cell`: Cell identifier (e.g., `AJ11`)
- `z`: Optional Z coordinate (integer)

## Validation Rules
- PlaceRef must match the canonical format.
- Layer and cell fields must match their respective patterns.
- Anchor must be a recognized domain anchor.

## Boundary Principles
- Core validates PlaceRefs, but does not own spatial datasets.
- Grid owns place truth and registries.
- Gameplay owns interpretation and presentation.

## Example
```json
{
  "place_ref": "EARTH:SUR:L300-AJ11-Z1",
  "anchor": "EARTH",
  "layer": "L300",
  "cell": "AJ11",
  "z": 1
}
```

---

See place_ref_contract.json for schema details.