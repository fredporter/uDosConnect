# Unit 01: Core Basics

This unit introduces what `uDOS-core` does and what it does not do.

## Learn This First

- Core owns deterministic contracts and runtime semantics
- Core does not own network execution, provider routing, or browser UI
- changes to Core should be test-backed and boundary-safe

## Short Practical How-To

1. Read the doc index.

```text
docs/README.md
```

2. Read the three core entry docs.

```text
docs/getting-started.md
docs/architecture.md
docs/boundary.md
```

3. Run the standard checks.

```bash
bash scripts/run-core-checks.sh
bash scripts/run-contract-enforcement.sh
```

## Editable Demo

Use this tiny workflow when changing a Core contract:

```bash
#!/usr/bin/env bash
set -euo pipefail

bash scripts/run-core-checks.sh
bash scripts/run-contract-enforcement.sh
```

Add the relevant test run if you are touching one contract family repeatedly.

## Outcome Check

1. What does Core own?
   Deterministic runtime semantics and public contracts.
2. What does Core not own?
   Browser UI, provider routing, host networking, and managed runtime policy.
3. Which script checks family-boundary safety?
   `scripts/run-contract-enforcement.sh`

## Pass Condition

Pass when you can explain Core ownership clearly and run both standard check
scripts successfully.
