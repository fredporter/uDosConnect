# uDOS Logging Policy

Status: stable reference
Owner: `uDOS-core`

## Purpose

Logs record execution, not memory.

uDOS keeps logs structured, bounded, useful, and cleanable so the system stays
observable without turning logs into a second knowledge store.

## Core Rule

Canonical truth belongs in records, contracts, binders, vault data, and other
durable workspace artifacts.

Logs exist to explain what happened during execution.

## Log Classes

### Event ledger

Compact records of meaningful system events.

Examples:

- compile completed
- migration applied
- sync failed after retries
- cleanup finished
- release package generated

### Operational logs

Runtime support logs used to operate and troubleshoot the system.

Examples:

- service start and stop
- task start and completion
- scheduler runs
- adapter failures
- queue backoff

### Diagnostic logs

Verbose development and troubleshooting traces.

Examples:

- parser traces
- stack traces
- resolver paths
- payload inspection
- timing breakdowns

### Metrics

Aggregated counters and measurements rather than narrative lines.

Examples:

- queue depth
- compile duration
- sync latency
- failure count
- reclaimed storage

## Logging Rules

- one event per record
- no roadmap duplication
- no design narrative in log streams
- no large payload dumps by default
- prefer references over embedded content
- detailed traces are opt-in
- logs must be reducible into summaries and feeds

## Forbidden Uses

Logs must not become:

- memory
- canonical user data
- a debug archive with no retention boundary
- a second roadmap lane
- a narrative changelog

## Retention Guidance

| Class | Retention |
|---|---|
| Event ledger | medium to long |
| Operational logs | short to medium |
| Diagnostic logs | very short |
| Metrics | aggregated |

## Cleanup

Cleanup is part of normal runtime behavior.

Logs should be:

- rotated automatically
- compacted into summaries where useful
- deduplicated where possible
- pruned when stale
- reduced into feed items when they represent meaningful change

## Relationship to Feeds

Logs answer "what happened during execution."

Feeds answer "what changed that downstream tools or people should care about."

Feeds must never be treated as raw log dumps, and raw logs must not be exposed
by default as publishable feeds.
