# Dev Brief — uDOS GPT Export Helper
**Feature:** Deterministic ZIP export for Agent Digital and future GPT surfaces
**Placement:** `uDOS-gpthelper` + lightweight webhook/export server on `uDOS-host`
**Status:** Brief for implementation

## Purpose

Create a small, reliable export service that allows ChatGPT custom GPTs in the uDOS family to generate real downloadable ZIP files from structured project output.

This solves a current platform gap:
- GPT can structure a binder
- GPT may fail to package and return a real ZIP consistently
- users need a simple, immediate export path
- this must work without forcing full local runtime adoption on day one

This feature gives:
- Agent Digital → real binder ZIP export on `COMPILE`
- future uDOS Developer → code-binder export
- a clean path into broader uDOS local runtime / MCP tooling

## Recommended Placement

### Primary home
**`uDOS-gpthelper`**
- GPT-facing specs
- action schemas
- prompt patches
- export payload formats
- integration docs

### Runtime host
**`uDOS-host`**
- runs the export helper service
- handles local/ngrok/public webhook exposure
- acts as the lightweight always-on bridge for GPT export features

## Out of Scope (v1)
- full account/auth system
- multi-tenant SaaS dashboard
- cloud document editing
- persistent project database
- async/background job queue
- broad MCP-linked local tool orchestration
- requiring full uDOS installation for basic GPT export use

## Future Fit

Broad MCP-linked local console workflows are out of scope for v1 of this feature, but this helper should be designed as an early bridge into future `uDOS-host` MCP capabilities.
