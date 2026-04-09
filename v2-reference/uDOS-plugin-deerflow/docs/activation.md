# uDOS-plugin-deerflow Activation

Activate the optional Deer Flow execution backend for the uDOS family with
translation schemas, executor stubs, upstream sync helpers, and a repo-local
validation entrypoint.

## Activated Surfaces

- architecture and boundary docs under `docs/`
- translation and execution-result schemas under `schemas/`
- binder, workflow, and graph samples under `examples/`
- Python, TypeScript, and Go stubs under `src/`
- bootstrap and sync helpers under `scripts/`
- repo validation entrypoint under `scripts/run-deerflow-checks.sh`

## Current Validation Contract

Run:

```bash
bash scripts/run-deerflow-checks.sh
```

The command verifies required repository surfaces and runs the staged Python
translation test when Python tooling is available.
