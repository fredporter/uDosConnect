# Contracts

This lane holds the checked-in spatial contract surfaces for `uDOS-grid`.

Current activation scope:

- canonical place identity
- layer records
- place records
- artifact attachment records
- spatial runtime ownership notes
- place-bound artifact attachment direction
- deterministic place resolution order
- security permission classes for place-gated actions
- seed domain alignment across Earth, Virtual, Planetary, Orbital, and Stellar lanes

Current machine-readable surfaces:

- `place-record.contract.json`
- `layer-record.contract.json`
- `artifact-record.contract.json`

These contracts are intentionally metadata-first and filesystem-friendly so
sibling repos can consume canonical spatial truth without inheriting renderer
or gameplay ownership.

Ownership rule:

- Grid defines canonical spatial identity and gate-validation inputs.
- Wizard handles transport and proximity verification methods.
- Gameplay consumes Grid truth and must not redefine persistence identity.
