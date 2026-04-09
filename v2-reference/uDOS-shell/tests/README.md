# `tests/`

Repo-facing tests for `uDOS-shell`.

Current implementation tests live in `src/tests/` so the TypeScript build can
emit runnable Node tests under `dist/tests/`.

Use this root for:

- higher-level shell behavior tests
- future integration notes
- test entrypoint documentation

## Demo Integration Test

- `demo_test.go` runs an end-to-end non-TUI demo path.
- coverage includes uCODE parser expectations.
- coverage includes dispatch preview behavior.
- coverage includes contract loading checks.
- coverage includes selector filter behavior.
- coverage includes pipeline walk snapshots.

Run directly:

```bash
go test ./tests/... -v
```

Or run through the full script lane:

```bash
bash scripts/run-demo.sh
```
