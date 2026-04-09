# uDOS MCP Event Surface

Status: stable reference
Owner: `uDOS-core`

## Purpose

Expose logs, feeds, and spools through a bounded MCP surface.

This surface allows tools to query recent event summaries, inspect spools,
transform event streams, and publish feed outputs without turning MCP into a
canonical store or raw debug proxy.

## Scope

MCP may:

- access bounded event views
- transform streams into summaries and feed outputs
- publish feed representations
- trigger spool lifecycle operations

MCP must not:

- store canonical data
- expose raw diagnostic logs by default
- become a permanent event archive

## Tool Families

### Logs

- `logs.query`
- `logs.summary`

### Feeds

- `feeds.fetch`
- `feeds.emit`
- `feeds.create`
- `feeds.render`

### Spool

- `spool.list`
- `spool.read`
- `spool.write`
- `spool.compact`
- `spool.rotate`
- `spool.merge`

### Reduction

- `reduce.logs_to_feed`
- `reduce.notifications`

## Relationship to the MCP Contract

This event surface is built on the existing core-owned MCP tool contract.

It does not define a second MCP standard. It defines a bounded semantic family
of tools that should each conform to the existing contract metadata, approval,
and scheduling rules.

## JSON and XML Posture

uDOS should stay JSON-first internally for:

- event records
- runtime messages
- MCP payloads
- feed item models

uDOS may use XML where it is the correct external format, especially for:

- RSS
- Atom
- import and export pathways

## Rule

uDOS stores truth in records, records execution in logs, carries meaningful
change in feeds, and exposes controlled event access through MCP.
