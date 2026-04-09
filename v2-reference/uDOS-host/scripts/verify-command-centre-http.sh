#!/usr/bin/env bash
# Automated proof: command-centre static page is served and contains the lane-1 GUI marker.
# Uses a free ephemeral TCP port so this does not fight with a developer server on 7107.
#
# Usage:
#   bash scripts/verify-command-centre-http.sh

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DEMO_DIR="$REPO_ROOT/examples/command-centre-demo"
SERVE_PY="$SCRIPT_DIR/lib/serve_static_http.py"

if [ ! -f "$DEMO_DIR/index.html" ]; then
  echo "missing $DEMO_DIR/index.html" >&2
  exit 1
fi
if [ ! -f "$SERVE_PY" ]; then
  echo "missing $SERVE_PY" >&2
  exit 1
fi
if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required" >&2
  exit 1
fi

FREE_PORT="$(python3 -c 'import socket; s=socket.socket(); s.bind(("127.0.0.1", 0)); print(s.getsockname()[1]); s.close()')"

python3 "$SERVE_PY" --bind 127.0.0.1 --port "$FREE_PORT" --directory "$DEMO_DIR" >/dev/null 2>&1 &
SRV_PID=$!

cleanup() {
  kill "$SRV_PID" 2>/dev/null || true
  wait "$SRV_PID" 2>/dev/null || true
}
trap cleanup EXIT

sleep 0.4

fail=0
for url in "http://127.0.0.1:${FREE_PORT}/" "http://localhost:${FREE_PORT}/"; do
  if ! body="$(curl -fsS --max-time 5 "$url")"; then
    echo "verify-command-centre-http: GET failed: $url" >&2
    fail=1
    continue
  fi
  if ! printf '%s' "$body" | grep -q 'uDOS command centre'; then
    echo "verify-command-centre-http: page body missing marker 'uDOS command centre' ($url)" >&2
    fail=1
  fi
done

if [ "$fail" -ne 0 ]; then
  exit 1
fi

echo "verify-command-centre-http: OK (ephemeral port $FREE_PORT; 127.0.0.1 + localhost)"
