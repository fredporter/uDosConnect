# uDOS-grid Architecture

`uDOS-grid` is the family module for canonical spatial identity, place
references, and spatial lookup.

## Main Areas

- `contracts/` defines spatial identity and runtime contract surfaces
- `seed/` holds checked-in spatial seed registries and world scaffolds
- `examples/` holds small sample place and artifact records
- `config/` holds checked-in config examples and templates
- `scripts/run-grid-checks.sh` is the validation entrypoint

## Spatial Domains

Grid supports a unified PlaceRef model across multiple domains:

- Earth
- Virtual
- Planetary
- Orbital
- Stellar

All seed layers preserve canonical `80 x 30` geometry for text-first and
renderer-independent use.

## Runtime Rule

Grid owns spatial truth, not renderer truth.

That means:

- place identity persists here
- gameplay may interpret place visually but not redefine it
- other family modules may consume Grid records without owning spatial runtime
