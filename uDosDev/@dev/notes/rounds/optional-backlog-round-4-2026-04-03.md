# Optional backlog — Round 4 (runtime lane / host checks)

Status: **CLOSED** **2026-04-03**  
Ledger: `docs/optional-backlog-rounds-1-7.md`

## Intent

Clarify and optionally extract **`run-ubuntu-checks.sh`** internals; **`udos_commandd`** contract validation path; no new default Docker dependency.

## Scope

- [x] Extract static contract validation into **`uDOS-host/scripts/lib/verify-ubuntu-static-contracts.py`**
- [x] Wire **`run-ubuntu-checks.sh`** + **`require_file`** for the new module
- [x] **`scripts/README.md`** updated
- [x] **`bash scripts/run-ubuntu-checks.sh`** pass
- [x] Re-scope family backlog row (further DRY deferred repo-local)

## Binder tag (optional)

`#binder/optional-backlog-round-4-runtime-host-checks`
