# Optional backlog Round 4 — runtime / host checks (report)

Date: 2026-04-03  
Ledger: `docs/optional-backlog-rounds-1-7.md`

## Change (uDOS-ubuntu)

- Extracted static **udos-commandd** / web / policy validation from the inline Python heredoc in **`scripts/run-ubuntu-checks.sh`** into **`scripts/lib/verify-ubuntu-static-contracts.py`**.
- **`scripts/README.md`** documents the module and OB-R4 rationale.
- **`bash scripts/run-ubuntu-checks.sh`** — **PASS** after extraction.

## Backlog re-scope (`v2-family-roadmap.md`)

- Prior **“Open (optional): further extraction of `run-ubuntu-checks` internals”** is **partially addressed** by this module; deeper manifest/DRY refactors remain **repo-local** optional work in `uDOS-ubuntu` (no new Docker dependency; shared-runtime posture unchanged).

## Next

- **OB-R5** — next `v2.x` gate packet (`docs/next-family-plan-gate.md`).
