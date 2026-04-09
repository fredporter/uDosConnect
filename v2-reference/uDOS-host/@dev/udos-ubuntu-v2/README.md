# uDOS-host v2.2 Package

This package defines the Ubuntu-owned server runtime for uDOS.

It supersedes earlier Ubuntu-side notes that treated Wizard as the managed
control plane for provider routing, beacon runtime, or MCP bridge ownership.

## Position

uDOS-host owns:

- local network setup and config
- beacon node behavior
- managed OK execution
- managed MCP execution
- Docker and localhost WordPress
- vault publishing and local library serving
- local device access to OK functions
- fallback-aware local service routing

Wizard becomes the GUI and render layer only.

Wizard may remain relevant as a family delegation broker, but not as runtime
authority. If retained, it should resolve requests to the correct service,
package delegation envelopes, and return help when no valid handler exists.

Core keeps:

- local schemas
- validation
- permissions
- offline-safe tool use
- deterministic local MCP boundaries

## Browser GUI Naming

The browser GUI layer should be renamed from `Wizard` to `Surface`.

Use `Surface` for GUI, preview, publishing, and operator presentation terms.
Do not use it for runtime authority. Ubuntu owns the runtime plane.

## Package Layout

- `network/`: beacon modes, Wi-Fi and LAN config, DNS, proxy, auth, health
- `publish/wordpress/`: Docker stack, adapters, themes, plugins, portal shell
- `library/`: browse, search, permissions, render contracts for markdown views
- `ingest/`, `normalize/`, `dedupe/`, `split/`, `wiki/`, `compost/`: canonical
  vault processing pipeline
- `okd/`: managed OK routing, workers, budgets, cache, schedules, audit
- `mcpd/`: managed MCP registry, bridge, auth, budgets, schedules, audit
- `vault/`: canonical, derived, and index-backed artifact storage

## Canonical Spec

See `UDOS-UBUNTU-v2.2-SPEC.md` for the full decision and acceptance criteria.
See `SURFACE-RENAME-DECISION.md` and `SURFACE-RENAME-TARGETS.md` for the
browser-layer rename plan.
See `WIZARD-BROKER-v1.md` for the broker-only repurpose of Wizard.
