# Root `scripts/` (uDosConnect)

Shared bash helpers for Python env bootstrap, multi-repo checks, and `~/.udos` path conventions used across the family workspace.

Details: **[`../docs/shared-resources-architecture.md`](../docs/shared-resources-architecture.md)**.

Run from the **repository root** (parent of this folder), for example:

```bash
./scripts/bootstrap-family-python.sh
```

**Courses:** `./scripts/validate-courses.sh` — ensures each `courses/[0-9][0-9]-*/` folder has a `README.md`.
