#!/usr/bin/env bash
# Lane-1 sync listener: JSON health and status (queue worker in later lanes).
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SERVICE_PORT="${UDOS_SYNCD_PORT:-7103}"
BIND="${UDOS_SYNCD_BIND:-127.0.0.1}"
export SERVICE_PORT
exec python3 "$SCRIPT_DIR/lib/runtime_daemon_httpd.py" syncd --bind "$BIND" --port "$SERVICE_PORT"
