#!/usr/bin/env bash
# Lane-1 TUI adapter listener: JSON health + /v1/status (operator TUI later).
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PORT="${UDOS_TUID_PORT:-7110}"
BIND="${UDOS_TUID_BIND:-127.0.0.1}"
export UDOS_TUID_PORT="$PORT"
exec python3 "$SCRIPT_DIR/lib/runtime_daemon_httpd.py" tuid --bind "$BIND" --port "$PORT"
