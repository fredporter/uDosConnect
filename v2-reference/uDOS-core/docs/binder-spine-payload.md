# Binder spine payload (v1)

**Owner:** `uDOS-core`  
**Family plan:** `v2.6` Round A (`#binder/core-v2-6-binder-contract-alignment`)

This document defines the **JSON shape** for **binder-native workspace** payloads consumed by **`uDOS-thinui`** (unified workspace demo) and **`uDOS-workspace`** operator surfaces. It complements **`schemas/mdc-output-contract.schema.json`** (MDC normalization) with a **stable spine** for fetched or embedded binder JSON.

## Schema

- **JSON Schema:** `schemas/binder-spine-payload.v1.schema.json`
- **Version field:** root `schema_version` must be **`"1"`** for v1 payloads.

### Required (root)

| Field | Meaning |
| --- | --- |
| `schema_version` | Must be **`"1"`** for this contract revision. |
| `id` | Stable binder identifier (string). |
| `title` | Human title. |
| `items` | Non-empty array of binder rows. |

### Required (each `items[]`)

| Field | Meaning |
| --- | --- |
| `id` | Row id. |
| `title` | Row title. |
| `recordType` | Discriminator (`task`, `doc`, `post`, `metric`, …). |

Additional properties are allowed on items and on the root object for forward-compatible extensions.

## Validation (Python)

```python
from pathlib import Path
from udos_core.binder_spine import validate_binder_spine_payload

validate_binder_spine_payload(payload, repo_root=Path("/path/to/uDOS-core"))
```

Requires optional dependency **`jsonschema`** (`pip install -e ".[dev]"`).

## Tests

- `tests/test_binder_spine_contract.py` (marker **`contract`**)
- Fixture: `tests/fixtures/binder-spine-demo.v1.json`

## Consumers

- **`uDOS-thinui`** — `demo/public/demo-binder.json`, `src/workspace/demo-binder.json`, and `examples/demo-binder.json` include `schema_version: "1"`. The workspace demo parses fetched JSON as spine v1 when `schema_version` is `"1"` (`src/workspace/binder-spine-v1.ts`, `binder-source.ts`); use `?binderLegacy=1` for legacy JSON without `schema_version`. See **`uDOS-dev`** `docs/thinui-unified-workspace-entry.md`.
- **`uDOS-workspace`** — browser shell consumes spine v1 for operator snapshots (validated sample data and UI copy); see `docs/workspace-binder-spine.md` in that repo.
- Workspace repos should validate or document alignment when ingesting binder JSON.

## Related

- `docs/contract-enforcement.md`
- `@dev/notes/roadmap/v2.6-rounds.md` Round A
- `schemas/mdc-output-contract.schema.json`
