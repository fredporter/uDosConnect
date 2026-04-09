# uDOS v3 System Brief (Bootstrap)

**Naming:** **uDos** expands to **Universal Device Operating Surface**; the capital **D** is intentional in new copy ([integration monorepo docs](https://github.com/fredporter/uDOS-v3/blob/main/docs/dev-process-v4.md)).

**Local spine:** integration monorepo at **`~/Code/uDosGo/`**, governance and this brief under **`~/Code/uDosConnect/`** — [`../../docs/family-workspace-layout.md`](../../docs/family-workspace-layout.md).

**v3.0.1 planning pack:** the public-facing cut with milestone checklists, exact file tree, first-draft schemas, and demo docs lives in the integration monorepo ([**README**](https://github.com/fredporter/uDOS-v3/blob/main/README.md), [**docs**](https://github.com/fredporter/uDOS-v3/blob/main/docs/README.md)).

**Current engineering pairing:** primary implementation work lands in **[uDOS-v3 on GitHub](https://github.com/fredporter/uDOS-v3)** (clone as **`~/Code/uDosGo/`**). **UniversalSurfaceXD** is the interchange / lab repo (typically **`~/Code/UniversalSurfaceXD/`**). Open multi-root workspaces from each repo (for example **`uDosConnect.code-workspace`**, **`UniversalSurfaceXD-v4.siblings.code-workspace`**) and add folders for **`~/Code/uDosGo`** as documented in those files.

## One-Sentence Definition

uDOS v3 is a local-first orchestration demo where Hivemind plans work, Host executes it safely on a persistent local node, a local WordPress runtime handles identity/privacy and restricted pages, and ThinUI lets the user enter and inspect the system from any point.

## Purpose

This brief locks v3 to one complete, working loop for demo and PR:

User input -> Hivemind decision -> Host execution -> local state/files written -> ThinUI visibility.

This is intentionally not the full uDOS family rebuild.

## In Scope (Must Ship)

- `apps/host`: always-on local runtime with HTTP API, workspace/vault ownership, execution adapter, event/task storage, provider config loading.
- `packages/hivemind`: deterministic 4-role orchestration loop (Scout, Planner, Maker, Reviewer).
- `apps/thinui`: 3-panel operator shell (Feed, Graph/Queue, Output/Event Log) with manual actions.
- `apps/wordpress` plus `packages/wp-plugin-empire-bridge`: local identity/privacy/restricted-page engine and Host/Hivemind bridge.
- `packages/schemas`: shared feed/task/event/provider/budget contracts used by Host, Hivemind, ThinUI, plugin.
- `packages/sdk`: typed local client for ThinUI/plugin integrations to call Host API.
- `demo/`: runnable sample input set plus sample workspace data for one gold-path scenario.
- `docs/`: architecture, runbook, and demo script with exact startup commands.

## Out of Scope (Explicitly Deferred)

- Full product-family split and broad module parity.
- Full cloud sync engine, beacon/public networking, multi-user remote auth.
- Full Apple automation lanes and broad MCP provider universe.
- Full plugin marketplace and public registry workflows.
- Advanced autonomous swarms, memory abstractions, personality systems, self-modifying agents.
- App-store-grade polish, deep theming, or large settings surfaces.

## Non-Negotiable Demo Capabilities

### Host

- Confirmed local network node endpoint (`localhost` and optional LAN bind).
- Persistent workspace drive/vault and spool paths.
- Local HTTP API for ThinUI, Hivemind, and WordPress bridge.
- Persistent task/event state (`JSON` or `SQLite`).
- Safe job runner abstraction (single adapter in MVP).
- File writer + event logger.
- Provider config loader with budget policy hooks.

### Hivemind

- Shared schema-compliant feed/task/event handling.
- 4 roles only:
  - Scout: classify incoming item.
  - Planner: produce task graph.
  - Maker: execute task via Host tools.
  - Reviewer: mark pass/fail/needs-fix with reason.
- Deterministic task state transitions (`queued`, `ready`, `running`, `blocked`, `done`, `failed`).
- Provider router with budget awareness and fallback behavior.

### ThinUI

- Panel 1 Feed/Inbox: incoming item, source, summary, enqueue actions.
- Panel 2 Graph/Queue: tasks, dependencies, states, blocked/ready/done.
- Panel 3 Output/Event Log: files produced, tool runs, errors, provider/cost usage.
- Manual controls: submit, rerun task, retry failed node, approve/reject reviewer result.
- Local API connection only (no remote dependency in MVP).

### WordPress Runtime + Empire Bridge Plugin

- Local WordPress instance under Host ownership (persistent data path).
- Identity and session basics (local login, password reset, app passwords).
- Privacy/export/erasure extension hooks registered by plugin.
- Restricted local pages for private views/forms.
- Two-tier contact model:
  - `EmpireContact` is canonical contact record.
  - Optional linked `WP_User` only when login/self-service is needed.
- Plugin responsibilities (`udos-empire-local`):
  - map contacts <-> optional users,
  - expose local REST bridge endpoints,
  - register privacy exporter/eraser callbacks,
  - add self-service profile fields,
  - enforce page gating by role/capability.

## Proposed v3 Monorepo Shape

```text
uDOS-v3/
  apps/
    host/
      src/
        api/
        runtime/
        execution/
        storage/
        providers/
      config/
      package.json
    thinui/
      src/
        panels/
          feed/
          graph/
          output/
        lib/api/
      package.json
    wordpress/
      docker/              # optional in MVP, default local runtime allowed
      wp-content/
        mu-plugins/
      README.md
  packages/
    hivemind/
      src/
        roles/
          scout/
          planner/
          maker/
          reviewer/
        loop/
        router/
        budget/
      package.json
    schemas/
      src/
        feed.ts
        task.ts
        event.ts
        provider.ts
        budget.ts
      package.json
    sdk/
      src/
        host-client.ts
        events-client.ts
      package.json
    wp-plugin-empire-bridge/
      udos-empire-local.php
      includes/
        class-rest-routes.php
        class-contact-user-bridge.php
        class-privacy-hooks.php
      README.md
  demo/
    sample-inputs/
    sample-workspace/
    scripts/
  docs/
    README.md
    ARCHITECTURE.md
    DEMO.md
```

## Module Boundaries (Exact Contracts)

- `apps/host` owns:
  - process lifecycle,
  - workspace/vault mount paths,
  - task/event persistence,
  - tool execution sandbox adapter,
  - provider credential/config loading,
  - primary local API surface.
- `packages/hivemind` owns:
  - orchestration policy and state machine,
  - role execution order,
  - task decomposition logic,
  - budget-aware provider selection requests.
- `apps/thinui` owns:
  - operator UX and manual intervention controls,
  - polling/stream consumption of Host events,
  - rendering of feed/task/output state.
- `apps/wordpress` owns:
  - local identity/session surfaces,
  - restricted page runtime,
  - privacy baseline features from WordPress core.
- `packages/wp-plugin-empire-bridge` owns:
  - contact-user bridge logic,
  - bridge REST endpoints,
  - privacy callbacks for plugin data,
  - self-service profile extensions.
- `packages/schemas` is the single source of truth for wire contracts.
- `packages/sdk` is the only reusable API client surface for UI/plugin callers.

Boundary rule: `thinui`, `hivemind`, and WordPress plugin do not write storage directly; all runtime writes go through `host` APIs (except WordPress-internal core tables/files managed by WordPress itself).

## Gold-Path Demo Definition

### Input

User submits one item (URL, note, email-like text, or plain request):

"Research this topic, create a markdown note, extract 3 tasks, and save everything to the local vault."

### System Path

1. ThinUI writes feed item to Host.
2. Hivemind Scout classifies intent.
3. Planner creates:
   - note creation task,
   - summary task,
   - task extraction task.
4. Maker executes through Host tools:
   - fetch/parser,
   - formatter,
   - file writer.
5. Reviewer checks output and sets final status.
6. ThinUI shows:
   - created markdown file path,
   - generated tasks,
   - event log timeline,
   - provider/model used,
   - cost and budget usage.

### Done Criteria

v3 demo is done when an operator can:

1. start Host locally,
2. open ThinUI,
3. submit one input,
4. watch Hivemind plan + execute,
5. confirm files written under workspace/vault,
6. inspect event log and budget usage,
7. rerun or intervene manually at any task node.

## Provider Setup for MVP

- Primary: OpenRouter.
- Fallback: OpenAI.
- Optional secondary: Gemini or Mistral.
- Local/offline placeholder mode allowed (no full parity required).

Required proof points:

- budget policy enforcement,
- provider switch/fallback event visibility,
- resilient completion of the gold path.

## Storage Layout (Host-Owned)

```text
/udos-data
  /vault
  /spool
  /events
  /exports
  /wordpress
  /backups
```

`/wordpress` persists local database, uploads, plugin state, and plugin/theme code mount or sync target.

## MVP Milestones

### M1 - Runtime Spine

- scaffold monorepo,
- host API boot,
- schemas package,
- local persistent storage init,
- health endpoint and startup command.

### M2 - Orchestration Loop

- implement 4 roles,
- deterministic task state machine,
- provider router + budget checks,
- host execution adapter for fetch/format/write.

### M3 - ThinUI + Observability

- implement 3 panels,
- wire live event/task updates,
- add manual actions (rerun/retry/approve).

### M4 - WordPress Bridge + Demo Pack

- local WordPress runtime wiring under Host,
- `udos-empire-local` plugin baseline,
- contact-user bridge + privacy hooks,
- demo script/data and reproducible walkthrough.

## Commands and Operator Entry

At minimum, v3 must expose one clear local startup path:

- `npm run dev`

Optional convenience wrappers may be added later:

- `udos-host start`
- `udos demo run`

## v3 Scope Lock Statement

If a candidate feature does not directly improve the one-loop demo (input -> plan -> execute -> write -> inspect), it is deferred until after v3 demo acceptance.
