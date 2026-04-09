#!/usr/bin/env bash
# smoke-wizard-http.sh — probe a running uDOS-wizard HTTP surface (health + MCP catalog).
#
# Usage:
#   export UDOS_WIZARD_HOST=127.0.0.1
#   export UDOS_WIZARD_PORT=8787
#   bash scripts/smoke-wizard-http.sh
#
# Requires: curl, python3 (for JSON assertions). Does not start the server.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

HOST="${UDOS_WIZARD_HOST:-127.0.0.1}"
PORT="${UDOS_WIZARD_PORT:-8787}"
BASE="http://${HOST}:${PORT}"

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required" >&2
  exit 1
fi
if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required" >&2
  exit 1
fi

echo "[smoke-wizard-http] GET $BASE/"
root_json="$(curl -sS -f --connect-timeout 2 "$BASE/" || true)"
if [[ -z "$root_json" ]]; then
  echo "Wizard not reachable at $BASE (start the Wizard service first)." >&2
  exit 1
fi
echo "$root_json" | python3 -c 'import json,sys; d=json.load(sys.stdin); assert d.get("service")=="wizard"; assert d.get("status")=="ok"; print("  ok: root health")'

echo "[smoke-wizard-http] GET $BASE/mcp/tools"
mcp_json="$(curl -sS -f --connect-timeout 2 "$BASE/mcp/tools")"
echo "$mcp_json" | python3 -c '
import json,sys
d=json.load(sys.stdin)
n=d.get("count",0)
assert n>=3, n
names={t["name"] for t in d.get("tools",[])}
for req in ("ok.route","ok.providers.list"):
    assert req in names, (req, names)
print("  ok: mcp tools count=%s"%n)
'

echo "[smoke-wizard-http] done"
