#!/usr/bin/env bash
# Materialize ~/.udos layout then run a long-lived hostd HTTP listener (health + layout JSON).
# Usage: default = layout + HTTP daemon. First arg `layout-only` = materialize dirs + manifest then exit (CI / smoke).
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SERVICE_PORT="${UDOS_HOSTD_PORT:-7100}"
BIND="${UDOS_HOSTD_BIND:-127.0.0.1}"
export SERVICE_PORT
# shellcheck source=scripts/lib/runtime-layout.sh
. "$SCRIPT_DIR/lib/runtime-layout.sh"
ud_os_ensure_runtime_layout
if [ "${1:-}" = "layout-only" ]; then
  exit 0
fi
exec python3 "$SCRIPT_DIR/lib/runtime_daemon_httpd.py" hostd --bind "$BIND" --port "$SERVICE_PORT"
