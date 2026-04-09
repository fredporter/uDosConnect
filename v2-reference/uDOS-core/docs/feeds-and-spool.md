# uDOS Feeds and Spool

Status: stable reference
Owner: `uDOS-core`

## Purpose

uDOS separates execution records from meaningful change.

- logs record execution
- feeds carry meaningful change
- spools retain and transform feeds locally

## Core Model

```text
activity/source
-> logs
-> feeds
-> spool
-> outputs
```

## Definitions

### Feed

A structured stream of meaningful updates.

Feeds are smaller, cleaner, and more contextual than raw logs.

### Spool

A local rotating collection of feed items that can store, compact,
deduplicate, slice, merge, and export feed data.

### Canonical records

Durable human-relevant truth stored outside the logs and feed pipeline.

## Feed Types

- source feeds
- event feeds
- content feeds
- reduction feeds
- private feeds

## Spool Responsibilities

A spool can:

- store feed items in bounded local form
- retain feed-native formats such as JSON and XML
- deduplicate repeated items
- checkpoint ingestion
- rotate by size or time
- compact many items into digests
- merge multiple feeds
- export feed data to publish or UI surfaces

## Lifecycle

```text
ingest -> classify -> spool -> transform -> emit
```

## Transformations

- logs to feed items
- feeds to digests
- feeds to markdown
- feeds to tables or database snapshots

## Design Rules

- feeds must never be raw logs
- feed items should be smaller than the source they represent
- spools are local retention and transformation surfaces, not canonical storage
- reduction should preserve useful references and summaries, not bulky payloads

## Relationship to the Rest of Core

The logs, feeds, and spool layer is a bounded event layer inside the wider
runtime.

It exists alongside canonical records rather than replacing them.

## Summary

Logs capture what happened.

Feeds carry what changed.

Spools decide what is kept locally and how those feed items are reduced,
transformed, and emitted.

## Reference Artifacts

Stable example payloads live in `examples/logs-feeds-spool/`.

Reference RSS and Atom templates live in `templates/feeds/`.

## Tests (minimisation)

Contract checks are consolidated in `tests/test_logs_feeds_spool_contracts.py`.
The **`green_proof`** pytest marker is the **minimal PR gate** for this surface
(fast path: `bash scripts/run-green-proof.sh` or `pytest -m green_proof`). See
`uDOS-dev/docs/pr-checklist.md`.

## Family pathway execution (Post-08 O2)

Promotion checklists and verify scripts for the **logs / feeds / spool** pathway
live in **`uDOS-dev`** (`@dev/pathways/o2-logs-feeds-spool-execution-checklist.md`,
`scripts/verify-pathway-o2-logs-feeds-spool.sh`). This document remains the
**semantic** source of truth; the pathway files track cross-repo execution only.
