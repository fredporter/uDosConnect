#!/usr/bin/env bash
# Lane-1 Wizard adapter listener: JSON health + /v1/status (broker HTTP later).
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PORT="${UDOS_WIZARD_ADAPTER_PORT:-7108}"
BIND="${UDOS_WIZARD_ADAPTER_BIND:-127.0.0.1}"
export UDOS_WIZARD_ADAPTER_PORT="$PORT"
exec python3 "$SCRIPT_DIR/lib/runtime_daemon_httpd.py" wizard_adapter --bind "$BIND" --port "$PORT"
