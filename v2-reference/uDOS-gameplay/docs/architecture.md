# uDOS-gameplay Architecture

This repo is a modular sandbox for gameplay patterns on top of public uDOS
semantics.

## Main Areas

- `src/` holds gameplay modules.
- `examples/` provides teachable interaction samples.
- `tests/` protects public behavior.
- `scripts/run-gameplay-checks.sh` is the activation validation entrypoint.

## Spatial Rule

Gameplay consumes canonical place and artifact truth from `uDOS-grid`.
Gameplay may also rely on Core-published spatial vocabulary only through the
Grid-owned contract lane.

That means:

- Grid owns place identity and starter spatial seed truth
- Core may publish shared spatial vocabulary and file-location semantics
- Gameplay owns visual or interactive interpretation
- Gameplay consumes the shared vocabulary through Grid-aligned contracts
- Gameplay must not redefine persistence identity or absorb Grid ownership

## World Prototype Rule

Gameplay currently keeps one bounded world prototype reference:

- `multiplayer crypt-placement world`

Gameplay owns:

- the world loop
- object semantics
- exportable state shape for examples and contracts

Gameplay does not own:

- provider routing or prompt generation
- remote-service supervision
- canonical storage truth

That means any generated or cloud-backed prototype must export back into inspectable
gameplay-owned artifacts instead of leaving its world state trapped in Firestore
or a generated app.
