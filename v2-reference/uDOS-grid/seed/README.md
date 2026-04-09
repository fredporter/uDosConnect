# Seed

`seed/` holds checked-in spatial seed registries for `uDOS-grid`.

Current activation scope:

- starter layer registry
- starter place registry
- starter artifact registry
- canonical demo index

These records are deterministic starter spatial truth, not mutable runtime
state.

Current review rule:

- `basic-*.json` files define the starter reviewed seed set
- `canonical-demo-index.json` defines the approved demo subset for current
  consumer alignment
- future domain expansion should add new reviewed records rather than silently
  mutating the current demo meaning
