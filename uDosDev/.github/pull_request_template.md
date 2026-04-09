## Summary

- binder:
- **Target branch:** `main` (family default; no long-lived feature branches)
- repo role:

## Branch policy

- [ ] PR is **into `main`** (family default)
- [ ] Branch was **worth creating** (not created by habit—explain if non-obvious)
- [ ] After merge: **delete** remote topic branch; **`git checkout main` && `git pull`**

## Checks

- [ ] `docs/pr-checklist.md` reviewed for repos touched
- [ ] docs updated where needed
- [ ] boundary ownership confirmed
- [ ] tests or validation run (CI green)
- [ ] promotion / roadmap notes updated if this closes family-tracked work
