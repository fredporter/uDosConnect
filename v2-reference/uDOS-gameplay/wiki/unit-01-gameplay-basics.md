# Unit 01: Gameplay Basics

## What This Module Is

`uDOS-gameplay` is the family module for gameplay patterns, interaction
experiments, and exportable world-state examples built on family contracts.

## What You Should Learn

By the end of this unit you should be able to:

- explain what Gameplay owns
- run the repo checks
- describe the Grid boundary
- identify why generated world state must export back into repo-owned artifacts

## Practical How-To

1. Inspect the starter gameplay state.
2. Inspect the Grid-backed example.
3. Run the repo checks.

```bash
cat examples/basic-gameplay-state.json
cat examples/basic-grid-gameplay-state.json
bash scripts/run-gameplay-checks.sh
```

## Editable Demo

Compare the plain gameplay example with the Grid-backed example and note which
parts stay gameplay-owned and which parts come from Grid.

## Quick Check

You pass this unit if you can answer:

- What does Gameplay own?
- Which repo owns canonical spatial truth?
- Why must cloud or generated state export back into repo artifacts?
