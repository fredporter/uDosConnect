# uDOS-core Quickstart

This is the shortest path to validate local core runtime contracts and checks.

## Prerequisites

- Python 3.9+
- Git

## 1. Run Baseline Checks

From repo root:

```bash
bash scripts/run-core-checks.sh
```

This runs the full core test suite.

## 2. Run Contract Enforcement

```bash
bash scripts/run-contract-enforcement.sh
```

Use this whenever you touch boundaries, contracts, or dependency policy.

## 3. Inspect Core MCP Contract Surface

```bash
cat contracts/mcp-tool-contract.json | head -40
cat schemas/mcp-tool-contract.schema.json | head -40
```

## 4. Run MCP/OK-Agent Contract Tests

```bash
python3 -m pytest tests/test_ok_agent_contracts.py -q
```

## 5. Continue With Docs

- docs/getting-started.md
- docs/MCP-SCHEMA.md
- docs/OK-AGENT-CORE-CONTRACT.md
- docs/contract-enforcement.md
