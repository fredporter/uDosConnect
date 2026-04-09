#!/usr/bin/env bash
# Lane-1 network listener stub: JSON health + /v1/status (Beacon/Portal later).
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PORT="${UDOS_NETWORKD_PORT:-7105}"
BIND="${UDOS_NETWORKD_BIND:-127.0.0.1}"
export UDOS_NETWORKD_PORT="$PORT"
exec python3 "$SCRIPT_DIR/lib/runtime_daemon_httpd.py" networkd --bind "$BIND" --port "$PORT"
