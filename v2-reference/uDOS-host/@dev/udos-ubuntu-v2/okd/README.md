# OKD

Managed OK execution lives on Ubuntu.

## Responsibilities

- classify request type
- evaluate offline-first execution options
- check cache before paid or remote routes
- enforce budget and approval policy
- execute deterministic fallback ladder
- defer optional enrichments when blocked
- audit every managed request

## Device-Facing Endpoints

```text
POST /ok/run
POST /ok/format
POST /ok/research
POST /ok/ingest/link
POST /ok/ingest/topic
POST /ok/ingest/file
GET  /ok/status/{id}
```

## Execution Ladder

```text
deterministic TS
-> local/offline helper
-> cache
-> local model
-> OpenRouter free
-> OpenRouter economy
-> premium provider
-> defer
```

## Request Envelope

```json
{
  "task": "format_doc",
  "class": "transformation",
  "input": "...",
  "target": "#binder",
  "mode": "merge",
  "budget_group": "tier0_free",
  "schedule_class": "immediate",
  "client_id": "iphone.local",
  "degraded_ok": true
}
```

## Routing Rule

If a usable deterministic or local result exists, return it first. Remote
providers are escalation lanes, not the default runtime assumption.
