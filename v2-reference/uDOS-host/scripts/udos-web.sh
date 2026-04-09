#!/usr/bin/env bash
# Long-running command-centre HTTP: static demo + JSON + Wizard /host/* (local-state file, contract, …).
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
export UDOS_UBUNTU_ROOT="${UDOS_UBUNTU_ROOT:-$REPO_ROOT}"
DEMO_DIR="$REPO_ROOT/examples/command-centre-demo"
# shellcheck source=scripts/lib/udos-web-listen.sh
. "$SCRIPT_DIR/lib/udos-web-listen.sh"
udos_web_resolve_listen
if [ ! -d "$DEMO_DIR" ]; then
  echo "udos-web: missing $DEMO_DIR" >&2
  exit 1
fi
if [ -f "$SCRIPT_DIR/lib/runtime-layout.sh" ]; then
  # shellcheck source=scripts/lib/runtime-layout.sh
  . "$SCRIPT_DIR/lib/runtime-layout.sh"
  ud_os_ensure_runtime_layout >/dev/null 2>&1 || true
fi
exec python3 "$SCRIPT_DIR/lib/runtime_daemon_httpd.py" web \
  --bind "$UDOS_WEB_BIND" --port "$UDOS_WEB_PORT" --static "$DEMO_DIR"
