#!/usr/bin/env bash
# Lane-1 budget edge listener: JSON health + /v1/status (policy integration later).
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PORT="${UDOS_BUDGETD_PORT:-7106}"
BIND="${UDOS_BUDGETD_BIND:-127.0.0.1}"
export UDOS_BUDGETD_PORT="$PORT"
exec python3 "$SCRIPT_DIR/lib/runtime_daemon_httpd.py" budgetd --bind "$BIND" --port "$PORT"
