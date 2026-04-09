#!/usr/bin/env bash
# Install a systemd --user unit so the lane-1 static command-centre stays up across
# logins (LAN-visible on 0.0.0.0:7107 by default). For physical hosts used as the
# family “always-on” spine between rounds.
#
# Requires: systemd, loginctl (optional: loginctl enable-linger for boot without login)
#
# Usage:
#   bash scripts/install-command-centre-demo-lan-user-service.sh [--now] [--remove]
#
# After install:
#   systemctl --user status udos-command-centre-demo-lan.service
#   journalctl --user -u udos-command-centre-demo-lan.service -f

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
UBUNTU_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
UNIT_NAME="udos-command-centre-demo-lan.service"
USER_SYSTEMD="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"
UNIT_PATH="$USER_SYSTEMD/$UNIT_NAME"
PYTHON3="$(command -v python3)"

DO_NOW=0
REMOVE=0
for a in "$@"; do
  case "$a" in
    --now) DO_NOW=1 ;;
    --remove) REMOVE=1 ;;
  esac
done

if [ -z "$PYTHON3" ]; then
  echo "python3 not found" >&2
  exit 1
fi

if ! command -v systemctl >/dev/null 2>&1 || ! systemctl --version >/dev/null 2>&1; then
  echo "systemd not available. Use a foreground server instead:" >&2
  echo "  bash $UBUNTU_ROOT/scripts/serve-command-centre-demo-lan.sh" >&2
  echo "  (or run it under tmux/screen on this host.)" >&2
  exit 1
fi

if [ "$REMOVE" = "1" ]; then
  systemctl --user stop "$UNIT_NAME" 2>/dev/null || true
  systemctl --user disable "$UNIT_NAME" 2>/dev/null || true
  rm -f "$UNIT_PATH"
  systemctl --user daemon-reload
  echo "Removed $UNIT_NAME"
  exit 0
fi

mkdir -p "$USER_SYSTEMD"

# shellcheck source=scripts/lib/udos-web-listen.sh
. "$SCRIPT_DIR/lib/udos-web-listen.sh"
udos_web_resolve_listen
PORT="$UDOS_WEB_PORT"

cat >"$UNIT_PATH" <<EOF
[Unit]
Description=uDOS command-centre static demo (LAN, round continuity)
Documentation=file://$UBUNTU_ROOT/docs/lan-command-centre-persistent.md
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
Environment=UDOS_HOME=%h/.udos
Environment=UDOS_UBUNTU_ROOT=$UBUNTU_ROOT
Environment=UDOS_WEB_BIND=0.0.0.0
Environment=UDOS_WEB_PORT=$PORT
WorkingDirectory=$UBUNTU_ROOT
ExecStart=/usr/bin/env bash $UBUNTU_ROOT/scripts/udos-web.sh
Restart=on-failure
RestartSec=5

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable "$UNIT_NAME"
echo "Installed $UNIT_PATH"
echo "  Port: $PORT (all interfaces). Docs: $UBUNTU_ROOT/docs/lan-command-centre-persistent.md"
if [ "$DO_NOW" = "1" ]; then
  systemctl --user start "$UNIT_NAME"
  systemctl --user status "$UNIT_NAME" --no-pager || true
else
  echo "Start with: systemctl --user start $UNIT_NAME"
fi
echo "Logs: journalctl --user -u $UNIT_NAME -f"
echo "For boot-without-login: loginctl enable-linger \$USER"
