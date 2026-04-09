# Optional backlog — Round 2 (GitHub contract roll-forward)

Status: **CLOSED** **2026-04-03**  
Ledger: `docs/optional-backlog-rounds-1-7.md`

## Intent

Align public family repos with **`docs/github-actions-family-contract.md`**: `Validate` on `main`, script-owned checks, reference implementation on **`uDOS-host`**.

## Scope

- [x] Baseline **`--report`** snapshot: `@dev/notes/reports/github-contract-rollforward-baseline-2026-04-03.md` (sections A + B)
- [x] **`check-github-contract-rollforward.sh`:** resolve repos under optional **`UDOS_GITHUB_CONTRACT_REPO_ROOTS`** (colon-separated sibling roots)
- [x] **Script-owned** detection extended for **`uses:`** of **`uDOS-dev`** reusable `validate.yml` / `family-policy-check.yml`
- [x] **`uHOME-app-android` / `uHOME-app-ios`:** add **`family-policy-check.yml`** (reusable policy)
- [x] **`docs/github-actions-family-contract.md`** — roll-forward + env + `uses:` semantics
- [x] Strict roll-forward with extended roots: **pass** (maintainer machine 2026-04-03)

## Commands

```bash
cd uDOS-dev
bash automation/check-github-contract-rollforward.sh
UDOS_GITHUB_CONTRACT_REPO_ROOTS="/path/sonic-family:/path/uHOME-family" \
  bash automation/check-github-contract-rollforward.sh --report
```

## Binder tag (optional)

`#binder/optional-backlog-round-2-github-contract`
