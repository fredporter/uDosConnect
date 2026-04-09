#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEV_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LOG_DIR="$DEV_ROOT/@dev/logs"
PID_DIR="$LOG_DIR/pids"
KILL_LOG_PATH="$LOG_DIR/kill-switch.log"
KILL_JSONL_PATH="$LOG_DIR/kill-switch.jsonl"

MODE="all"
TAG_FILTER=""
SIGNAL_NAME="TERM"
FORCE_AFTER_SECONDS=5
DRY_RUN=false

usage() {
  cat <<'EOF'
usage: run-dev-kill-switch.sh [options]

Options:
  --all                     Kill all registered @dev processes (default).
  --tag <tag>               Kill only processes with an exact matching tag.
  --signal <TERM|INT|KILL>  Initial signal to send (default: TERM).
  --force-after <seconds>   Seconds to wait before SIGKILL fallback (default: 5).
  --dry-run                 Print targets without sending signals.
  -h, --help                Show this message.

Examples:
  bash scripts/run-dev-kill-switch.sh --all
  bash scripts/run-dev-kill-switch.sh --tag @dev/operations-checks
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --all)
      MODE="all"
      TAG_FILTER=""
      shift
      ;;
    --tag)
      if [[ $# -lt 2 ]]; then
        echo "missing value for --tag" >&2
        exit 2
      fi
      MODE="tag"
      TAG_FILTER="$2"
      shift 2
      ;;
    --signal)
      if [[ $# -lt 2 ]]; then
        echo "missing value for --signal" >&2
        exit 2
      fi
      SIGNAL_NAME="$2"
      shift 2
      ;;
    --force-after)
      if [[ $# -lt 2 ]]; then
        echo "missing value for --force-after" >&2
        exit 2
      fi
      FORCE_AFTER_SECONDS="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

case "$SIGNAL_NAME" in
  TERM|INT|KILL)
    ;;
  *)
    echo "invalid --signal value: $SIGNAL_NAME (use TERM, INT, or KILL)" >&2
    exit 2
    ;;
esac

if ! [[ "$FORCE_AFTER_SECONDS" =~ ^[0-9]+$ ]]; then
  echo "invalid --force-after value: $FORCE_AFTER_SECONDS" >&2
  exit 2
fi

mkdir -p "$LOG_DIR"
mkdir -p "$PID_DIR"

timestamp_utc() {
  date -u '+%Y-%m-%dT%H:%M:%SZ'
}

log_line() {
  local message="$1"
  printf '%s %s\n' "$(timestamp_utc)" "$message" | tee -a "$KILL_LOG_PATH"
}

log_json() {
  local event="$1"
  local pid="$2"
  local script_name="$3"
  local run_id="$4"
  local tags="$5"
  local result="$6"
  local note="$7"

  python3 - "$KILL_JSONL_PATH" \
    "$(timestamp_utc)" \
    "$event" \
    "$pid" \
    "$script_name" \
    "$run_id" \
    "$tags" \
    "$result" \
    "$note" \
    "$MODE" \
    "$TAG_FILTER" \
    "$SIGNAL_NAME" \
    "$FORCE_AFTER_SECONDS" \
    "$DRY_RUN" <<'PY'
import json
import sys

(
    path,
    timestamp,
    event,
    pid,
    script_name,
    run_id,
    tags,
    result,
    note,
    mode,
    tag_filter,
    signal_name,
    force_after,
    dry_run,
) = sys.argv[1:15]

record = {
    "timestamp": timestamp,
    "event": event,
    "pid": pid,
    "script": script_name,
    "run_id": run_id,
    "tags": [tag for tag in tags.split(",") if tag],
    "result": result,
    "note": note,
    "mode": mode,
    "tag_filter": tag_filter,
    "signal": signal_name,
    "force_after_seconds": int(force_after),
    "dry_run": dry_run.lower() == "true",
    "operator": "run-dev-kill-switch.sh",
}

with open(path, "a", encoding="utf-8") as handle:
    handle.write(json.dumps(record, sort_keys=True) + "\n")
PY
}

has_tag() {
  local tags_csv="$1"
  local wanted="$2"
  local item

  IFS=',' read -r -a items <<<"$tags_csv"
  for item in "${items[@]}"; do
    item="${item#"${item%%[![:space:]]*}"}"
    item="${item%"${item##*[![:space:]]}"}"
    if [[ "$item" == "$wanted" ]]; then
      return 0
    fi
  done

  return 1
}

target_count=0
killed_count=0
forced_count=0
stale_count=0
failed_count=0

shopt -s nullglob
pid_files=("$PID_DIR"/*.pid)
shopt -u nullglob

if [[ ${#pid_files[@]} -eq 0 ]]; then
  log_line "kill-switch: no registered @dev processes found under $PID_DIR"
  exit 0
fi

log_line "kill-switch: mode=$MODE tag_filter=${TAG_FILTER:-none} signal=$SIGNAL_NAME force_after=${FORCE_AFTER_SECONDS}s dry_run=$DRY_RUN"

for pid_file in "${pid_files[@]}"; do
  pid="$(sed -n 's/^pid=//p' "$pid_file" | head -n 1)"
  run_id="$(sed -n 's/^run_id=//p' "$pid_file" | head -n 1)"
  script_name="$(sed -n 's/^script=//p' "$pid_file" | head -n 1)"
  tags="$(sed -n 's/^tags=//p' "$pid_file" | head -n 1)"

  if [[ -z "$pid" ]]; then
    log_line "kill-switch: malformed pid file skipped: $pid_file"
    log_json "malformed_pid_file" "" "$script_name" "$run_id" "$tags" "skip" "missing pid"
    continue
  fi

  if [[ "$MODE" == "tag" ]]; then
    if ! has_tag "$tags" "$TAG_FILTER"; then
      continue
    fi
  fi

  target_count=$((target_count + 1))

  if ! kill -0 "$pid" 2>/dev/null; then
    stale_count=$((stale_count + 1))
    rm -f "$pid_file"
    log_line "kill-switch: stale pid=$pid run_id=${run_id:-unknown} script=${script_name:-unknown}; removed pid file"
    log_json "stale_process" "$pid" "$script_name" "$run_id" "$tags" "stale" "pid not running"
    continue
  fi

  log_line "kill-switch: targeting pid=$pid run_id=${run_id:-unknown} script=${script_name:-unknown} tags=${tags:-none}"
  log_json "target_identified" "$pid" "$script_name" "$run_id" "$tags" "target" "identified for kill"

  if [[ "$DRY_RUN" == true ]]; then
    continue
  fi

  kill -s "$SIGNAL_NAME" "$pid" 2>/dev/null || true
  log_json "signal_sent" "$pid" "$script_name" "$run_id" "$tags" "signal" "sent SIG$SIGNAL_NAME"

  terminated=false
  if [[ "$SIGNAL_NAME" != "KILL" && "$FORCE_AFTER_SECONDS" -gt 0 ]]; then
    waited=0
    while [[ "$waited" -lt "$FORCE_AFTER_SECONDS" ]]; do
      if ! kill -0 "$pid" 2>/dev/null; then
        terminated=true
        break
      fi
      sleep 1
      waited=$((waited + 1))
    done
  fi

  if [[ "$terminated" == false ]] && kill -0 "$pid" 2>/dev/null; then
    kill -s KILL "$pid" 2>/dev/null || true
    forced_count=$((forced_count + 1))
    log_json "signal_sent" "$pid" "$script_name" "$run_id" "$tags" "signal" "sent SIGKILL fallback"
    sleep 1
  fi

  if kill -0 "$pid" 2>/dev/null; then
    failed_count=$((failed_count + 1))
    log_line "kill-switch: FAILED pid=$pid still running"
    log_json "kill_result" "$pid" "$script_name" "$run_id" "$tags" "failed" "process still running"
  else
    killed_count=$((killed_count + 1))
    rm -f "$pid_file"
    log_line "kill-switch: stopped pid=$pid"
    log_json "kill_result" "$pid" "$script_name" "$run_id" "$tags" "stopped" "process terminated"
  fi
done

log_line "kill-switch: summary targets=$target_count stopped=$killed_count forced=$forced_count stale=$stale_count failed=$failed_count dry_run=$DRY_RUN"
log_json "kill_summary" "" "run-dev-kill-switch.sh" "" "" "summary" "targets=$target_count stopped=$killed_count forced=$forced_count stale=$stale_count failed=$failed_count"

if [[ "$failed_count" -gt 0 ]]; then
  exit 1
fi
