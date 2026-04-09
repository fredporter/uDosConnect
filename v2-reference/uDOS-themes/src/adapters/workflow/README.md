# Workflow Adapter

Maps theme tokens and workflow primitives into binder-driven task, lane, and
state views.

Implemented surface:

- `index.mjs` normalizes workflow lanes and renders a textual board summary.
- `gtx-step-task-map.json` defines a stable step-id to task-id mapping contract
  so workflow/wizard lanes can mirror GTX form step ids.
