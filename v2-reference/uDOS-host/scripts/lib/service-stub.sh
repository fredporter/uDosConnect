#!/usr/bin/env bash

set -eu

SERVICE_ID="${SERVICE_ID:?SERVICE_ID is required}"
SERVICE_PORT="${SERVICE_PORT:-0}"
UDOS_HOME="${UDOS_HOME:-$HOME/.udos}"
STATE_DIR="${STATE_DIR:-$UDOS_HOME/state/${SERVICE_ID#udos-}}"
LOG_DIR="${LOG_DIR:-$UDOS_HOME/logs/${SERVICE_ID#udos-}}"

mkdir -p "$STATE_DIR" "$LOG_DIR"

echo "uDOS service stub"
echo "service=$SERVICE_ID"
echo "port=$SERVICE_PORT"
echo "udos_home=$UDOS_HOME"
echo "state_dir=$STATE_DIR"
echo "log_dir=$LOG_DIR"
echo "status=stub-ready"
