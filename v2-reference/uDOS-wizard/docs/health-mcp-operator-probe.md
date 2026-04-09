# Wizard health and MCP — operator probes

**Purpose:** quick checks that **`uDOS-wizard`** is listening and exposing MCP tools **without** opening the browser UI.

## Endpoints

| Probe | Method | Expected |
| --- | --- | --- |
| Service health | `GET /` | JSON: `service`, `status`, `role` |
| MCP tool catalog | `GET /mcp/tools` | JSON: `count`, `tools[]` with `name` (includes `ok.route`, `ok.providers.list`) |
| JSON-RPC list | `POST /mcp` body `tools/list` | JSON-RPC result with `tools` |
| Family health (optional) | `GET /family/health` | Disk / host snapshot; may shell out to **`uDOS-host`** scripts |

## Environment

- **`UDOS_WIZARD_HOST`** — default `127.0.0.1`
- **`UDOS_WIZARD_PORT`** — default **`8787`** (see `docs/first-launch-quickstart.md`)

## Examples

```bash
curl -sS "http://127.0.0.1:8787/"
curl -sS "http://127.0.0.1:8787/mcp/tools"
```

## Automated contract tests

In-repo **`tests/test_api_contracts.py`** covers `GET /`, `GET /mcp/tools`, MCP invoke, and JSON-RPC `tools/list` / `tools/call`. CI runs them via **`scripts/run-wizard-checks.sh`**.

## Related

- `mcp/README.md`
- `docs/first-launch-quickstart.md` § Family health
- `uDOS-shell/docs/wizard-shell-operator-runbook.md` (Shell + Wizard together)
