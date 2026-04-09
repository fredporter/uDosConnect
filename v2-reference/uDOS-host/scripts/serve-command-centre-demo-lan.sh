#!/usr/bin/env bash
# Same as serve-command-centre-demo.sh but bind all IPv4 interfaces (0.0.0.0) so
# other machines on the LAN can open http://<this-host-ip>:<UDOS_WEB_PORT>/
#
# Lab / continuity use: keep running between Cursor rounds after a successful physical install.
# Do not expose to untrusted networks without TLS and auth (production is udos-web + policy).
#
# Usage:
#   bash scripts/serve-command-centre-demo-lan.sh

set -eu
export UDOS_WEB_BIND=0.0.0.0
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=scripts/lib/udos-web-listen.sh
. "$SCRIPT_DIR/lib/udos-web-listen.sh"
udos_web_resolve_listen
echo "[uDOS-host] Command-centre demo — LAN bind (0.0.0.0, port $UDOS_WEB_PORT)"
echo "  this host:  http://127.0.0.1:${UDOS_WEB_PORT}/"
echo "  other LAN:  http://<this-host-ip>:${UDOS_WEB_PORT}/  (Linux: hostname -I | awk '{print \$1}')"
echo "  stop:       Ctrl+C"
echo ""
# Same long-lived process as udos-web.sh (static GUI + /health.json + /host/* JSON).
exec bash "$SCRIPT_DIR/udos-web.sh"
