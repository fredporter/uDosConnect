# Step 2 — Binder → Compiler schema

## Goal

Define a canonical workspace-facing schema for mapping a binder into generated operational surfaces.

The schema below is **workspace-side mapping truth**. Wizard executes compile jobs. Core remains canonical for binder/task/location contracts.

For the Tier 1 release path, this contract should default to document, task,
publish, and browser workflow surfaces. Calendar, map, route, and Empire-backed
business scheduling lanes are optional Tier 2 extensions.

## Compiler manifest

```yaml
version: 1

binder:
  id: footloose-adelaide-launch
  type: campaign
  title: Footloose Adelaide Launch

compile:
  id: compile-footloose-dashboard
  target: dashboard
  template: campaign-dashboard
  provider: wizard
  status: draft

sources:
  docs:
    enabled: true
    path: binders/footloose-adelaide-launch.md
  tasks:
    enabled: true
    source: core.tasks
  publish:
    enabled: true
    source: ubuntu.publish.local

views:
  - id: summary
    kind: card-grid
    fields: [title, status, next_milestone]
  - id: task_board
    kind: kanban
    fields: [task_title, owner, stage, due_at]
  - id: publish_queue
    kind: table
    fields: [title, publish_state, target_surface]

forms:
  - id: quick-update
    kind: modal-form
    fields: [status, owner, publish_state]

actions:
  - id: mark_publish_ready
    type: mutation
    target: publish.state
  - id: run_compile
    type: wizard_job
    target: compile.execute

permissions:
  mode: binder-scoped
  roles:
    - owner
    - editor
    - reviewer
    - publisher
```

## JSON schema sketch

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "uDOS Binder Compiler Manifest",
  "type": "object",
  "required": ["version", "binder", "compile", "views"],
  "properties": {
    "version": { "type": "integer", "minimum": 1 },
    "binder": {
      "type": "object",
      "required": ["id", "type", "title"],
      "properties": {
        "id": { "type": "string" },
        "type": { "type": "string" },
        "title": { "type": "string" }
      }
    },
    "compile": {
      "type": "object",
      "required": ["id", "target", "provider", "status"],
      "properties": {
        "id": { "type": "string" },
        "target": { "type": "string" },
        "template": { "type": "string" },
        "provider": { "type": "string", "enum": ["wizard"] },
        "status": { "type": "string", "enum": ["draft", "queued", "running", "complete", "failed"] }
      }
    },
    "views": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["id", "kind", "fields"],
        "properties": {
          "id": { "type": "string" },
          "kind": {
            "type": "string",
            "enum": ["card-grid", "kanban", "table", "calendar", "map", "detail", "form"]
          },
          "fields": {
            "type": "array",
            "items": { "type": "string" }
          }
        }
      }
    }
  }
}
```

## Compiler flow

1. Workspace loads binder + related task/publish references
2. User chooses compile target/template
3. User maps fields into views/forms/actions
4. Workspace validates manifest
5. Workspace submits job to Wizard
6. Wizard executes provider-specific compile pipeline
7. Artifact or app endpoint returns to workspace

Location-aware or Empire-backed compile sources may be added later, but they
should not be assumed by the Tier 1 binder compiler baseline.

## Suggested compile targets

- campaign-dashboard
- publishing-console
- host-operations-console
- doc-binder-view
- kiosk-view

Optional Tier 2 targets:

- field-console
- venue-manager
- contact-intake
- route-map-console
