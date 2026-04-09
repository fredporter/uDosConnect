# uDOS-host Activation

## Purpose

Activate the first public base-image lane for the uDOS family with deterministic
build surfaces, sonic-compatible install hooks, and an always-on command-centre
setup direction.

## Host vs browser operator (family vocabulary)

**Ubuntu** owns the runtime host, command-centre HTTP surfaces, and `~/.udos/`
materialisation per the runtime spine. The **Surface** browser app and **Wizard**
broker in **`uDOS-wizard`** provide orchestration and operator UI; they do **not**
replace host uptime authority. Shared GUI vocabulary: [`uDOS-dev/docs/gui-system-family-contract.md`](../../uDOS-dev/docs/gui-system-family-contract.md). Core delegation fields: [`uDOS-core/docs/wizard-surface-delegation-boundary.md`](../uDOS-core/docs/wizard-surface-delegation-boundary.md).

## Activated Surfaces

- reproducible build lane under build/
- package and system defaults under config/
- sonic pre/post install hooks under sonic-hooks/
- command-centre scaffolding, service-boot planning, and config layout docs
- legacy-named scaffold manifest under examples/
- optional **GPT export helper** (Node) under `services/gpt-export-helper/` — deterministic ZIP export for GPT Actions; specs in **`uDOS-gpthelper`**; see `services/gpt-export-helper/README.md`
- repo validation entrypoint under scripts/run-ubuntu-checks.sh

## Current Validation Contract

Run:

```bash
bash scripts/run-ubuntu-checks.sh
bash scripts/verify-command-centre-http.sh
```

The checks verify required repository surfaces, runtime daemon smoke, and the
command-centre HTTP marker.

For strict completion runs:

```bash
bash scripts/run-ubuntu-strict-completion-gate.sh
```

This gate composes repo checks, HTTP checks, and LAN continuity proof.

## v2.6 family spine parity (host lane)

**Binder:** `#binder/ubuntu-v2-6-host-parity-checks`

Core **binder spine v1** (`uDOS-core`), the ThinUI workspace bridge (`uDOS-thinui`), and workspace operator snapshots (`uDOS-workspace`) live in **sibling repos**. `uDOS-host` does **not** ship those JSON payloads or claim canonical binder truth; it remains the Ubuntu runtime, `~/.udos/` materialisation, and command-centre/daemon surfaces documented here.

**After pulling** `uDOS-host` or when validating a spine-related family update on a workstation, re-run the repo checks from this repository root:

```bash
bash scripts/run-ubuntu-checks.sh
```

For the stricter local gate (HTTP + LAN continuity composed), use `bash scripts/run-ubuntu-strict-completion-gate.sh` (see **Current Validation Contract** above).

**Environment:** no new variables are required for spine v1. Python selection remains `PYTHON`, optional `UDOS_SHARED_PYTHON_BIN`, and `UDOS_USE_SHARED_RESOURCES` as described in `scripts/run-ubuntu-checks.sh`.

## GitHub Actions

Workflows live under `.github/workflows/`:

| Workflow | Role |
| --- | --- |
| **`validate.yml`** | On **push/PR to `main`**: `run-ubuntu-checks.sh` + `verify-command-centre-http.sh` (self-contained on GitHub runners). |
| **`family-policy-check.yml`** | Same triggers: family **governance** file layout (`uDOS-dev` scripts) + **Core** `run-contract-enforcement.sh`. |

There is **no** `develop` branch or automated promote job; integration is **`main`**
only. Other family repos may still call reusable workflows from `uDOS-dev`; this
repo is the **reference** for a slimmer, `main`-first layout.

### GitHub contract vs local source of truth

- **Canonical contract:** sibling `uDOS-dev/docs/github-actions-family-contract.md` (clone layout `../uDOS-dev/docs/...` from this repo). Summary: **`main`-only** Actions, script-owned checks, **`promote.yml` not required** here; CI mirrors `run-ubuntu-checks.sh` + `verify-command-centre-http.sh`.
- **Engineering backlog pointer:** `uDOS-dev/@dev/notes/roadmap/v2-family-roadmap.md` § Engineering backlog (roll-forward for other repos).
- **Local source of truth:** your **clone of this repo** on the Ubuntu host plus **`~/.udos/`** materialised by `scripts/lib/runtime-layout.sh` and the `udos-*` host scripts. Operators treat **green checks on real hardware** as primary truth; GitHub is a **mirror** on `ubuntu-latest`.
