# udos-db-schema

**In-tree** SQL DDL for **uDos** Tier 1 (**SQLite** cell/cube registry). This folder is **not** a Git submodule yet; a future **`udos-db-schema`** repository may be split out when versioning and CI are ready.

**Locked architecture:** [uDosDev — `UDOS_FIVE_TIER_DATABASE_STRATEGY_LOCKED_v1.md`](../../uDosDev/docs/specs/v4/UDOS_FIVE_TIER_DATABASE_STRATEGY_LOCKED_v1.md).

| Path | Role |
| --- | --- |
| [`sqlite/schema.sql`](sqlite/schema.sql) | Create tables: `users`, `cells`, `cubes`, `spatial_links`, `sync_state` |

**Initialize locally:** from repo root, `bash scripts/init-udos-sqlite.sh` (creates `~/.udos/cells.db` if missing).
