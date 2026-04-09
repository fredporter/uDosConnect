#!/usr/bin/env bash
# Lane-1 scheduler listener: JSON health + /v1/status (job runner later).
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PORT="${UDOS_SCHEDULED_PORT:-7104}"
BIND="${UDOS_SCHEDULED_BIND:-127.0.0.1}"
export UDOS_SCHEDULED_PORT="$PORT"
exec python3 "$SCRIPT_DIR/lib/runtime_daemon_httpd.py" scheduled --bind "$BIND" --port "$PORT"
