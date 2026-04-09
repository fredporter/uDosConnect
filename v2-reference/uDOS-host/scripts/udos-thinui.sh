#!/usr/bin/env bash
# Lane-1 ThinUI listener: JSON health + /v1/status (thin client UI later).
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PORT="${UDOS_THINUI_PORT:-7111}"
BIND="${UDOS_THINUI_BIND:-127.0.0.1}"
export UDOS_THINUI_PORT="$PORT"
exec python3 "$SCRIPT_DIR/lib/runtime_daemon_httpd.py" thinui --bind "$BIND" --port "$PORT"
