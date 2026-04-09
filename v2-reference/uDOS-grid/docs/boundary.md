# uDOS-grid Boundary

## Owns

- canonical place identity
- layer and cell addressing
- place records and aliases
- seed spatial registries
- place-bound artifact indexing contracts

## Does Not Own

- gameplay loops, rendering, or simulation
- network transport, provider APIs, or remote execution
- general-purpose workflow semantics outside spatial conditions
- private app-local runtime behavior

## Dependency Direction

- may depend on `uDOS-core` contracts when shared runtime vocabulary is needed
- shared spatial vocabulary may be promoted into Core support in a future round,
  but Grid remains a separate repo and owner during the current round
- must not redefine Core command or workflow semantics
- may be consumed by `uDOS-shell`, `uDOS-wizard`, `uDOS-gameplay`, and apps
- must not depend on `uDOS-gameplay` for canonical spatial truth
