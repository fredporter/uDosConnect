# v2.0.5 Core Contract Lift

## Purpose
Publish the neutral spatial and file-location contracts in uDOS-core, ensuring datasets and registries remain outside Core. Update sibling repos to consume the new Core-supported PlaceRef vocabulary.

## Actions
- PlaceRef contract and schema published in uDOS-core/contracts/
- PlaceRef contract documentation published in uDOS-core/contracts/
- Validation tests/examples published in uDOS-core/tests/
- No spatial datasets or registries added to Core
- Sibling repos (uDOS-grid, uDOS-shell, uDOS-wizard, uHOME-server, uDOS-empire, uDOS-gameplay) to update their PlaceRef usage to reference the Core contract

## Boundary Principles
- Core only provides contract and validation for PlaceRef
- Grid remains the owner of spatial datasets and registries
- Gameplay remains the owner of interpretation and presentation

## Next Steps
- Notify sibling repo maintainers to update PlaceRef usage
- Reference the Core contract in sibling repo docs and schemas

---

This note documents the contract lift for v2.0.5 Round B.