#!/usr/bin/env bash
# Lane-1 vault listener: JSON health and status (vault API in later lanes).
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SERVICE_PORT="${UDOS_VAULTD_PORT:-7102}"
BIND="${UDOS_VAULTD_BIND:-127.0.0.1}"
export SERVICE_PORT
exec python3 "$SCRIPT_DIR/lib/runtime_daemon_httpd.py" vaultd --bind "$BIND" --port "$SERVICE_PORT"
