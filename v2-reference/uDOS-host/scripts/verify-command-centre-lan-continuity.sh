#!/usr/bin/env bash
# Verifies LAN-capable command-centre continuity path in local lab mode.
# - boots udos-web with 0.0.0.0 bind on an ephemeral port
# - proves localhost HTTP marker and /health.json
# - validates systemd --user installer script emits expected unit settings

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required" >&2
  exit 1
fi

FREE_PORT="$(python3 -c 'import socket; s=socket.socket(); s.bind(("127.0.0.1", 0)); print(s.getsockname()[1]); s.close()')"

UDOS_WEB_BIND=0.0.0.0 UDOS_WEB_PORT="$FREE_PORT" bash "$SCRIPT_DIR/udos-web.sh" >/dev/null 2>&1 &
SRV_PID=$!

cleanup() {
  kill "$SRV_PID" 2>/dev/null || true
  wait "$SRV_PID" 2>/dev/null || true
}
trap cleanup EXIT

sleep 0.5

if ! body="$(curl -fsS --max-time 5 "http://127.0.0.1:${FREE_PORT}/")"; then
  echo "verify-command-centre-lan-continuity: GET failed" >&2
  exit 1
fi
printf '%s' "$body" | grep -q 'uDOS command centre'
curl -fsS --max-time 5 "http://127.0.0.1:${FREE_PORT}/health.json" | grep -q '"service":"udos-web"'

if command -v systemctl >/dev/null 2>&1 && systemctl --version >/dev/null 2>&1; then
  TMP_HOME="$(mktemp -d)"
  trap 'cleanup; rm -rf "$TMP_HOME"' EXIT
  XDG_CONFIG_HOME="$TMP_HOME/.config" HOME="$TMP_HOME" bash "$SCRIPT_DIR/install-command-centre-demo-lan-user-service.sh"
  UNIT_PATH="$TMP_HOME/.config/systemd/user/udos-command-centre-demo-lan.service"
  test -f "$UNIT_PATH"
  grep -q 'UDOS_WEB_BIND=0.0.0.0' "$UNIT_PATH"
else
  grep -q 'UDOS_WEB_BIND=0.0.0.0' "$SCRIPT_DIR/install-command-centre-demo-lan-user-service.sh"
fi

echo "verify-command-centre-lan-continuity: OK (ephemeral LAN port $FREE_PORT)"
