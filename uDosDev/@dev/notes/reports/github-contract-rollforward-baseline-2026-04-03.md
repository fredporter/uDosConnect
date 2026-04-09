# GitHub contract roll-forward — baseline snapshot (OB-R2)

Date: 2026-04-03 (updated same day: extended roots + reusable `uses:` detection)  
Commands: `bash automation/check-github-contract-rollforward.sh [--report]`  
Family root: `ROOT_DIR` as resolved by `automation/family-repos.sh` (parent of `uDOS-dev`).

## A — Default `ROOT_DIR` only (`uDOS-family/*`)

```
repo|status|validate|family_policy|script_owned
uDOS-core|aligned|yes|yes|yes
uDOS-shell|aligned|yes|yes|yes
sonic-screwdriver|missing-local-repo|n/a|n/a|n/a
uDOS-plugin-index|aligned|yes|yes|yes
uDOS-wizard|aligned|yes|yes|yes
uDOS-gameplay|aligned|yes|yes|yes
uDOS-groovebox|aligned|yes|yes|yes
uDOS-empire|aligned|yes|yes|yes
uHOME-matter|missing-local-repo|n/a|n/a|n/a
uDOS-dev|aligned|yes|yes|yes
uDOS-themes|aligned|yes|yes|yes
uDOS-thinui|aligned|yes|yes|yes
uDOS-workspace|aligned|yes|yes|yes
uDOS-docs|aligned|yes|yes|yes
uDOS-alpine|aligned|yes|yes|yes
uDOS-ubuntu|aligned|yes|yes|yes
sonic-ventoy|missing-local-repo|n/a|n/a|n/a
uHOME-client|missing-local-repo|n/a|n/a|n/a
uHOME-server|missing-local-repo|n/a|n/a|n/a
uHOME-app-android|missing-local-repo|n/a|n/a|n/a
uHOME-app-ios|missing-local-repo|n/a|n/a|n/a
```

## B — Extended roots (example: sonic + uHOME siblings)

Env:

`UDOS_GITHUB_CONTRACT_REPO_ROOTS="/Users/fredbook/Code/sonic-family:/Users/fredbook/Code/uHOME-family"`

(Use your own paths; no spaces in entries.)

```
repo|status|validate|family_policy|script_owned
uDOS-core|aligned|yes|yes|yes
uDOS-shell|aligned|yes|yes|yes
sonic-screwdriver|aligned|yes|yes|yes
uDOS-plugin-index|aligned|yes|yes|yes
uDOS-wizard|aligned|yes|yes|yes
uDOS-gameplay|aligned|yes|yes|yes
uDOS-groovebox|aligned|yes|yes|yes
uDOS-empire|aligned|yes|yes|yes
uHOME-matter|aligned|yes|yes|yes
uDOS-dev|aligned|yes|yes|yes
uDOS-themes|aligned|yes|yes|yes
uDOS-thinui|aligned|yes|yes|yes
uDOS-workspace|aligned|yes|yes|yes
uDOS-docs|aligned|yes|yes|yes
uDOS-alpine|aligned|yes|yes|yes
uDOS-ubuntu|aligned|yes|yes|yes
sonic-ventoy|aligned|yes|yes|yes
uHOME-client|aligned|yes|yes|yes
uHOME-server|aligned|yes|yes|yes
uHOME-app-android|aligned|yes|yes|yes
uHOME-app-ios|aligned|yes|yes|yes
```

Strict check (no `--report`) with **B** env: **pass** (2026-04-03).

## Interpretation

- **`aligned`:** `validate.yml` + `family-policy-check.yml` present; **script-owned** if local `bash scripts/` / `run-*-checks.sh` **or** `uses:` of `uDOS-dev/.github/workflows/(validate|family-policy-check).yml`.
- **`missing-local-repo`:** no checkout found under `ROOT_DIR/<repo>` nor under `UDOS_GITHUB_CONTRACT_REPO_ROOTS` — not a CI failure; clone or set env.
- **Strict check (no `--report`):** exits **0** when every **resolved** repo is `aligned`; skips repos with no checkout.

## Round 2 follow-up

- Re-run `--report` after cloning siblings or editing workflows.
- **`uHOME-app-android` / `uHOME-app-ios`:** `family-policy-check.yml` added (reusable uDOS-dev policy) as part of OB-R2 closeout.
