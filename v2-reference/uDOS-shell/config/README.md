# `config/`

This lane holds checked-in shell-owned configuration as the interaction surface
grows.

Family placement rule:

- put checked-in non-secret shell config templates and presentation defaults
  here
- keep operator walkthroughs and starter interaction payloads in `examples/`
- reserve `defaults/` for reusable baseline shell profiles only when they are
  truly shared defaults

Current state:

- kept intentionally minimal during activation
- reserved for palette, panel, and presentation defaults that belong to Shell

Do not move core runtime semantics into this lane.
