# Google MVP World Contract

## Purpose

Define the repo-owned export contract for Gameplay's first Google MVP
prototype:

- `multiplayer crypt-placement world`

This document states how generated or mirrored world state must be translated
back into Gameplay-owned artifacts.

## Ownership

Gameplay owns:

- world loop semantics
- player and object meaning
- export shape for examples, docs, and later tests

Gameplay does not own:

- provider routing
- remote-service supervision
- canonical cloud truth

## Required Export Shape

Generated output must be representable as:

- a world layout example
- a world object list with stable refs
- a player placement list
- export rules that state canonical truth remains repo-owned

## Required Fields

The first export artifact must define:

- `prototype`
- `state_owner`
- `prototype_owner`
- `generation_mode`
- `loop`
- `capabilities`
- `grid_context`
- `players`
- `world_objects`
- `export_rules`

## Mapping Rules

- `grid_context.place_ref` must remain Grid-owned place identity
- `players[].player_ref` must be stable, inspectable refs
- `world_objects[].object_ref` must be stable, inspectable refs
- object `kind` and `state` must remain gameplay-readable without cloud-only
  interpretation
- `export_rules.canonical_truth` must point back to repo-owned gameplay
  artifacts

## Non-Negotiables

- Firestore or realtime shared state is optional collaboration state only
- generated world state must be exportable into JSON or markdown artifacts in
  this repo
- Gameplay must be able to explain the prototype without requiring a live cloud
  service
