# Basic Docs Update

This is the smallest v2-local walkthrough for updating `uDOS-docs` without
crossing repo ownership boundaries.

## Validate The Repo

```bash
scripts/run-docs-checks.sh
```

## Update A Family Topic

1. Edit a topic file under `architecture/`, `wizard/`, `alpine/`, or `uhome/`.
2. Keep naming aligned with the owning repo and public contracts.
3. Add or update an entrypoint under `docs/` only when the repo-level map needs
   to change.

Expected outcome:

- documentation remains source-first and family-aligned
- private local-root references do not leak into tracked docs
- implementation ownership stays with the code repos
