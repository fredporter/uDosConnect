# O2 execution checklist — image ingestion → markdown

Post-08 optional round **O2** (pathways promotion). Documentation and ingest **lane** owner: **`uDOS-docs`**. Core contracts apply when automation ships.

## Promotion record

- **Decision:** Promoted **2026-04-02** from candidate to **concrete docs + ingest lane**.
- **Public lane doc:** `docs/image-ingestion-markdown-lane.md` (this repo).
- **Core alignment:** `uDOS-core/docs/v2.4-mdc-conversion-engine.md` (and related intake contracts) — no duplicate semantics in `uDOS-docs`.

## Lane readiness

- [ ] Lane doc reviewed against current MDC / intake docs in Core.
- [ ] Vault / privacy rules for image inbox documented for your instance (not necessarily in this public repo).

## Implementation tranches (future)

- [ ] Ingest tool or script checked into an **owning repo** (Core, Ubuntu, or Wizard lane) with tests.
- [ ] Learning hub / `family-source.json` entry when a wiki unit ships for operators.

## Verification

From `uDOS-docs` repo root:

```bash
bash scripts/verify-o2-image-ingestion-lane.sh
```
