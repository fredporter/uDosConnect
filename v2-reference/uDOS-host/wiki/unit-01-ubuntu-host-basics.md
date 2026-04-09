# Unit 01: Ubuntu Host Basics

This unit introduces `uDOS-host` as the always-on host for the family.

## Learn This First

- Ubuntu is the runtime host, not the semantic source of truth
- it owns service uptime, networked execution, and local hosting
- it should consume Core contracts instead of redefining them

## Short Practical How-To

1. Read the main entry docs.

```text
docs/README.md
docs/getting-started.md
docs/architecture.md
docs/boundary.md
```

2. Run the local validation entrypoint.

```bash
bash scripts/run-ubuntu-checks.sh
```

3. Review the first-run and service layout docs.

```text
docs/first-run-story.md
docs/config-layout.md
docs/systemd-unit-plan.md
```

## Editable Demo

Use this tiny host-check loop:

```bash
#!/usr/bin/env bash
set -euo pipefail

bash scripts/run-ubuntu-checks.sh
bash scripts/demo-first-run-setup.sh
```

## Outcome Check

1. What does Ubuntu own?
   Always-on host runtime, local services, network-facing execution, and uptime.
2. What does Ubuntu not own?
   Canonical semantics and deterministic contract truth.
3. Which script validates the repo scaffold?
   `scripts/run-ubuntu-checks.sh`

## Pass Condition

Pass when you can explain the host role clearly and run the standard repo check.
