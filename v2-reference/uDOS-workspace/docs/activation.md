# uDOS-workspace Activation

## Purpose

Activate the first public binder-first browser workspace lane for the uDOS
family with a real repo scaffold, documented contract boundaries, a visible web
prototype, and a repo-local validation entrypoint.

## Activated Surfaces

- browser workspace scaffold under `apps/web/`
- workspace package boundaries under `packages/`
- architecture and contract docs under `docs/`
- sample binder and compile manifests under `examples/`
- repo validation entrypoint under `scripts/run-workspace-checks.sh`
- repo-local dev tracking under `@dev/`

## Current Validation Contract

Run:

```bash
bash scripts/run-workspace-checks.sh
```

The command verifies required repository surfaces and runs the workspace app
type-check when local dependencies are already installed.
