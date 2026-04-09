#!/usr/bin/env bash
# Proves lane-1 runtime daemons are real HTTP listeners (not print-and-exit stubs).
# Uses ephemeral ports and a temp UDOS_HOME.
#
# Usage:
#   bash scripts/verify-udos-runtime-daemons.sh

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HTTPD_PY="$SCRIPT_DIR/lib/runtime_daemon_httpd.py"
DEMO_DIR="$REPO_ROOT/examples/command-centre-demo"

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required" >&2
  exit 1
fi
if [ ! -f "$HTTPD_PY" ]; then
  echo "missing $HTTPD_PY" >&2
  exit 1
fi
if [ ! -f "$DEMO_DIR/index.html" ]; then
  echo "missing $DEMO_DIR/index.html" >&2
  exit 1
fi

free_tcp_port() {
  python3 -c 'import socket; s=socket.socket(); s.bind(("127.0.0.1", 0)); print(s.getsockname()[1]); s.close()'
}

TMP_HOME="$(mktemp -d)"
export UDOS_HOME="$TMP_HOME/.udos"

P_HOSTD="$(free_tcp_port)"
P_VAULT="$(free_tcp_port)"
P_SYNC="$(free_tcp_port)"
P_WEB="$(free_tcp_port)"
P_CMD="$(free_tcp_port)"

export UDOS_HOSTD_PORT="$P_HOSTD"
export UDOS_VAULTD_PORT="$P_VAULT"
export UDOS_SYNCD_PORT="$P_SYNC"
export UDOS_WEB_BIND=127.0.0.1
export UDOS_WEB_PORT="$P_WEB"
export UDOS_COMMANDD_PORT="$P_CMD"
export UDOS_UBUNTU_ROOT="$REPO_ROOT"

UDOS_HOME="$UDOS_HOME" bash "$REPO_ROOT/scripts/udos-hostd.sh" >/dev/null 2>&1 &
PID_H=$!
sleep 0.15
UDOS_HOME="$UDOS_HOME" UDOS_UBUNTU_ROOT="$REPO_ROOT" bash "$REPO_ROOT/scripts/udos-gitd.sh" init-layout >/dev/null 2>&1 || true
UDOS_HOME="$UDOS_HOME" bash "$REPO_ROOT/scripts/udos-vaultd.sh" >/dev/null 2>&1 &
PID_V=$!
UDOS_HOME="$UDOS_HOME" bash "$REPO_ROOT/scripts/udos-syncd.sh" >/dev/null 2>&1 &
PID_S=$!
UDOS_HOME="$UDOS_HOME" UDOS_UBUNTU_ROOT="$REPO_ROOT" bash "$REPO_ROOT/scripts/udos-commandd.sh" >/dev/null 2>&1 &
PID_C=$!
UDOS_HOME="$UDOS_HOME" UDOS_UBUNTU_ROOT="$REPO_ROOT" bash "$REPO_ROOT/scripts/udos-web.sh" >/dev/null 2>&1 &
PID_W=$!

P_BD="$(free_tcp_port)"
P_NW="$(free_tcp_port)"
P_SC="$(free_tcp_port)"
P_TU="$(free_tcp_port)"
P_TH="$(free_tcp_port)"
P_WZ="$(free_tcp_port)"
UDOS_HOME="$UDOS_HOME" UDOS_UBUNTU_ROOT="$REPO_ROOT" python3 "$HTTPD_PY" budgetd --bind 127.0.0.1 --port "$P_BD" >/dev/null 2>&1 &
PID_BD=$!
UDOS_HOME="$UDOS_HOME" UDOS_UBUNTU_ROOT="$REPO_ROOT" python3 "$HTTPD_PY" networkd --bind 127.0.0.1 --port "$P_NW" >/dev/null 2>&1 &
PID_NW=$!
UDOS_HOME="$UDOS_HOME" UDOS_UBUNTU_ROOT="$REPO_ROOT" python3 "$HTTPD_PY" scheduled --bind 127.0.0.1 --port "$P_SC" >/dev/null 2>&1 &
PID_SC=$!
UDOS_HOME="$UDOS_HOME" UDOS_UBUNTU_ROOT="$REPO_ROOT" python3 "$HTTPD_PY" tuid --bind 127.0.0.1 --port "$P_TU" >/dev/null 2>&1 &
PID_TU=$!
UDOS_HOME="$UDOS_HOME" UDOS_UBUNTU_ROOT="$REPO_ROOT" python3 "$HTTPD_PY" thinui --bind 127.0.0.1 --port "$P_TH" >/dev/null 2>&1 &
PID_TH=$!
UDOS_HOME="$UDOS_HOME" UDOS_UBUNTU_ROOT="$REPO_ROOT" python3 "$HTTPD_PY" wizard_adapter --bind 127.0.0.1 --port "$P_WZ" >/dev/null 2>&1 &
PID_WZ=$!

cleanup() {
  kill "$PID_H" "$PID_V" "$PID_S" "$PID_C" "$PID_W" \
    "$PID_BD" "$PID_NW" "$PID_SC" "$PID_TU" "$PID_TH" "$PID_WZ" 2>/dev/null || true
  wait "$PID_H" 2>/dev/null || true
  wait "$PID_V" 2>/dev/null || true
  wait "$PID_S" 2>/dev/null || true
  wait "$PID_C" 2>/dev/null || true
  wait "$PID_W" 2>/dev/null || true
  wait "$PID_BD" 2>/dev/null || true
  wait "$PID_NW" 2>/dev/null || true
  wait "$PID_SC" 2>/dev/null || true
  wait "$PID_TU" 2>/dev/null || true
  wait "$PID_TH" 2>/dev/null || true
  wait "$PID_WZ" 2>/dev/null || true
  rm -rf "$TMP_HOME"
}
trap cleanup EXIT

sleep 1.2

fail=0

_json_field() {
  python3 -c 'import json,sys; d=json.load(sys.stdin); print(d.get(sys.argv[1],""))' "$1"
}

h="$(curl -fsS --max-time 5 "http://127.0.0.1:${P_HOSTD}/health.json")"
if ! printf '%s' "$h" | _json_field service | grep -qx udos-hostd; then
  echo "verify-udos-runtime-daemons: hostd /health.json service mismatch" >&2
  fail=1
fi
if ! curl -fsS --max-time 5 "http://127.0.0.1:${P_HOSTD}/v1/runtime-layout.json" | grep -q '"runtime_layout"'; then
  echo "verify-udos-runtime-daemons: hostd /v1/runtime-layout.json missing runtime_layout" >&2
  fail=1
fi

v="$(curl -fsS --max-time 5 "http://127.0.0.1:${P_VAULT}/health.json")"
if ! printf '%s' "$v" | _json_field service | grep -qx udos-vaultd; then
  echo "verify-udos-runtime-daemons: vaultd /health.json service mismatch" >&2
  fail=1
fi
if ! curl -fsS --max-time 5 "http://127.0.0.1:${P_VAULT}/v1/status" | grep -q 'vault_paths'; then
  echo "verify-udos-runtime-daemons: vaultd /v1/status unexpected" >&2
  fail=1
fi

s="$(curl -fsS --max-time 5 "http://127.0.0.1:${P_SYNC}/health.json")"
if ! printf '%s' "$s" | _json_field service | grep -qx udos-syncd; then
  echo "verify-udos-runtime-daemons: syncd /health.json service mismatch" >&2
  fail=1
fi
if ! curl -fsS --max-time 5 "http://127.0.0.1:${P_SYNC}/v1/status" | grep -q 'sync_paths'; then
  echo "verify-udos-runtime-daemons: syncd /v1/status unexpected" >&2
  fail=1
fi

w="$(curl -fsS --max-time 5 "http://127.0.0.1:${P_WEB}/health.json")"
if ! printf '%s' "$w" | _json_field service | grep -qx udos-web; then
  echo "verify-udos-runtime-daemons: udos-web /health.json service mismatch" >&2
  fail=1
fi
if ! curl -fsS --max-time 5 "http://127.0.0.1:${P_WEB}/" | grep -q 'uDOS command centre'; then
  echo "verify-udos-runtime-daemons: udos-web / missing GUI marker" >&2
  fail=1
fi
if ! curl -fsS --max-time 5 "http://127.0.0.1:${P_WEB}/host/runtime-summary" | grep -q 'runtime_layout_present'; then
  echo "verify-udos-runtime-daemons: udos-web /host/runtime-summary missing expected keys" >&2
  fail=1
fi
if ! curl -fsS --max-time 5 "http://127.0.0.1:${P_WEB}/host/contract" | grep -q 'wizard-browser-host-bridge'; then
  echo "verify-udos-runtime-daemons: udos-web /host/contract missing wizard surface id" >&2
  fail=1
fi
if ! curl -fsS --max-time 5 "http://127.0.0.1:${P_WEB}/host/orchestration-status" | grep -q 'lane1-udos-web'; then
  echo "verify-udos-runtime-daemons: udos-web /host/orchestration-status unexpected" >&2
  fail=1
fi
if ! curl -fsS --max-time 5 "http://127.0.0.1:${P_WEB}/host/budget-status" | grep -q 'budget-status.lane1'; then
  echo "verify-udos-runtime-daemons: udos-web /host/budget-status unexpected" >&2
  fail=1
fi
if ! curl -fsS --max-time 5 "http://127.0.0.1:${P_WEB}/host/providers" | grep -q '"providers"'; then
  echo "verify-udos-runtime-daemons: udos-web /host/providers unexpected" >&2
  fail=1
fi
if ! curl -fsS --max-time 5 "http://127.0.0.1:${P_WEB}/host/secrets" | grep -q 'runtime.host.secrets.list'; then
  echo "verify-udos-runtime-daemons: udos-web GET /host/secrets unexpected" >&2
  fail=1
fi
sec_post="$(curl -sS --max-time 5 -o /dev/null -w "%{http_code}" -X POST -H 'Content-Type: application/json' -d '{}' "http://127.0.0.1:${P_WEB}/host/secrets")"
if [ "$sec_post" != "403" ]; then
  echo "verify-udos-runtime-daemons: udos-web POST /host/secrets expected 403 got ${sec_post}" >&2
  fail=1
fi

for pair in "$P_BD:udos-budgetd" "$P_NW:udos-networkd" "$P_SC:udos-scheduled" "$P_TU:udos-tuid" "$P_TH:udos-thinui" "$P_WZ:udos-wizard-adapter"; do
  port="${pair%%:*}"
  want="${pair##*:}"
  j="$(curl -fsS --max-time 5 "http://127.0.0.1:${port}/health.json")"
  if ! printf '%s' "$j" | _json_field service | grep -qx "$want"; then
    echo "verify-udos-runtime-daemons: aux ${want} /health.json mismatch" >&2
    fail=1
  fi
  if ! curl -fsS --max-time 5 "http://127.0.0.1:${port}/v1/status" | grep -q '"role"'; then
    echo "verify-udos-runtime-daemons: aux ${want} /v1/status unexpected" >&2
    fail=1
  fi
done

ls_json="$(curl -fsS --max-time 10 "http://127.0.0.1:${P_CMD}/v1/list-operations?domain=repo")"
if ! printf '%s' "$ls_json" | grep -q '"exit_code":0'; then
  echo "verify-udos-runtime-daemons: commandd list-operations failed" >&2
  fail=1
fi
if ! printf '%s' "$ls_json" | grep -q 'repo.list'; then
  echo "verify-udos-runtime-daemons: commandd list-operations missing repo.list" >&2
  fail=1
fi

c="$(curl -fsS --max-time 5 "http://127.0.0.1:${P_CMD}/health.json")"
if ! printf '%s' "$c" | _json_field service | grep -qx udos-commandd; then
  echo "verify-udos-runtime-daemons: commandd /health.json service mismatch" >&2
  fail=1
fi

rop="$(curl -fsS --max-time 15 -X POST -H 'Content-Type: application/json' \
  -d '{"operation_id":"repo.list","arguments":[]}' \
  "http://127.0.0.1:${P_CMD}/v1/repo-op")"
if ! printf '%s' "$rop" | grep -q '"exit_code":0'; then
  echo "verify-udos-runtime-daemons: commandd repo-op repo.list failed" >&2
  fail=1
fi

if ! curl -fsS --max-time 5 "http://127.0.0.1:${P_WEB}/host/local-state" | grep -q '"local_state"'; then
  echo "verify-udos-runtime-daemons: udos-web GET /host/local-state unexpected" >&2
  fail=1
fi
if ! curl -fsS --max-time 5 -X POST -H 'Content-Type: application/json' \
  -d '{"verify_probe":{"round":"01"}}' \
  "http://127.0.0.1:${P_WEB}/host/local-state" | grep -q 'verify_probe'; then
  echo "verify-udos-runtime-daemons: udos-web POST /host/local-state merge failed" >&2
  fail=1
fi
if ! curl -fsS --max-time 5 "http://127.0.0.1:${P_WEB}/host/local-state" | grep -q '"round":"01"'; then
  echo "verify-udos-runtime-daemons: udos-web local-state not persisted" >&2
  fail=1
fi

if [ "$fail" -ne 0 ]; then
  exit 1
fi

echo "verify-udos-runtime-daemons: OK (hostd:${P_HOSTD} vaultd:${P_VAULT} syncd:${P_SYNC} commandd:${P_CMD} web:${P_WEB} aux:${P_BD},${P_NW},${P_SC},${P_TU},${P_TH},${P_WZ})"
