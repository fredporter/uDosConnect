#!/usr/bin/env bash
# Lane-1 static command-centre page — v2 web listen contract (no port scanning).
#
# Contract: contracts/udos-web/command-centre-static-demo.v1.json
# Same env as production surface: config/env/udos-web.env.example
# Optional overrides: UDOS_WEB_BIND, UDOS_WEB_PORT (defaults in scripts/lib/udos-web-listen.sh).
#
# udos-web / runtime_daemon_httpd.py: bind 127.0.0.1 uses IPv6 dual-stack :: so localhost → ::1 works.
# Remote browser: UDOS_WEB_BIND=0.0.0.0 then open http://<host-ip>:<port>/
#
# Usage:
#   bash scripts/serve-command-centre-demo.sh

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DEMO_DIR="$REPO_ROOT/examples/command-centre-demo"
# shellcheck source=scripts/lib/udos-web-listen.sh
. "$SCRIPT_DIR/lib/udos-web-listen.sh"
udos_web_resolve_listen

if [ ! -f "$DEMO_DIR/index.html" ]; then
  echo "missing $DEMO_DIR/index.html" >&2
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required for the static demo server" >&2
  exit 1
fi

if [ ! -f "$SCRIPT_DIR/lib/runtime_daemon_httpd.py" ]; then
  echo "missing $SCRIPT_DIR/lib/runtime_daemon_httpd.py" >&2
  exit 1
fi

UDOS_HOME="${UDOS_HOME:-$HOME/.udos}"
export UDOS_HOME
if [ -f "$SCRIPT_DIR/lib/runtime-layout.sh" ]; then
  # shellcheck source=scripts/lib/runtime-layout.sh
  . "$SCRIPT_DIR/lib/runtime-layout.sh"
  ud_os_ensure_runtime_layout >/dev/null 2>&1 || true
fi

LOG_DIR="$UDOS_HOME/logs/command-centre-demo"
mkdir -p "$LOG_DIR"
echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") start bind=$UDOS_WEB_BIND port=$UDOS_WEB_PORT root=$DEMO_DIR contract=udos-web/command-centre-static-demo.v1.json" >>"$LOG_DIR/http.log"

BASE_URL="$(udos_web_base_url)"
echo "[uDOS-host] Command-centre static demo (v2 web protocol)"
echo "  contract: $REPO_ROOT/contracts/udos-web/command-centre-static-demo.v1.json"
echo "  open:     $BASE_URL  (localhost works on same host when bind is loopback)"
if [ "$UDOS_WEB_BIND" = "0.0.0.0" ]; then
  echo "  LAN:      http://<this-host-ip>:${UDOS_WEB_PORT}/  (hint: hostname -I)"
fi
echo "  log:      $LOG_DIR/http.log  |  stop: Ctrl+C"
echo ""

# Same process as production-oriented udos-web.sh (static tree + /health.json + /host/*).
exec bash "$SCRIPT_DIR/udos-web.sh"
