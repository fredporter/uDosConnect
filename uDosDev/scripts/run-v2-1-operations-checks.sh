#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEV_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPORT_DIR="$DEV_ROOT/@dev/notes/reports"
LOG_DIR="$DEV_ROOT/@dev/logs"
PID_DIR="$LOG_DIR/pids"
CHECKPOINT_DIR="$LOG_DIR/checkpoints"
PROCESS_REGISTRY_PATH="$LOG_DIR/process-registry.log"
SCHEDULER_AUDIT_PATH="$LOG_DIR/workflow-scheduler-audit.jsonl"
STAMP="$(date '+%Y-%m-%d-%H%M%S')"
RUN_ID="$STAMP-$$"
REPORT_PATH="$REPORT_DIR/v2-1-operations-checks-$STAMP.md"
STRUCTURED_LOG_PATH="$LOG_DIR/v2-1-operations-checks-$STAMP.jsonl"

CHECKPOINT_PATH_DEFAULT="$CHECKPOINT_DIR/v2-1-operations-checks.state"
CHECKPOINT_PATH="$CHECKPOINT_PATH_DEFAULT"

RESUME=false
INVOCATION_SOURCE="${UDOS_DEV_INVOCATION_SOURCE:-manual}"
WORKFLOW_TAGS="${UDOS_DEV_WORKFLOW_TAGS:-@dev/operations-checks,@dev/scheduler}"
MAX_CHECKS="${UDOS_DEV_MAX_CHECKS:-25}"
MAX_RUNTIME_SECONDS="${UDOS_DEV_MAX_RUNTIME_SECONDS:-7200}"

mkdir -p "$REPORT_DIR"
mkdir -p "$LOG_DIR"
mkdir -p "$PID_DIR"
mkdir -p "$CHECKPOINT_DIR"

PASS_COUNT=0
FAIL_COUNT=0
SKIP_COUNT=0
CHECK_COUNT=0
RUN_STARTED_EPOCH="$(date '+%s')"
SEEN_SLUGS=""
PID_FILE="$PID_DIR/v2-1-operations-checks-$RUN_ID.pid"

usage() {
  cat <<'EOF'
usage: run-v2-1-operations-checks.sh [options]

Options:
  --resume                           Resume from checkpoint and skip checks already marked pass.
  --checkpoint <path>                Override checkpoint path.
  --invocation-source <label>        Set invocation source (default: manual or UDOS_DEV_INVOCATION_SOURCE).
  --workflow-tags <csv>              Set workflow tags CSV (default: @dev/operations-checks,@dev/scheduler).
  --max-checks <n>                   Loop-guard max checks threshold (default: 25).
  --max-runtime-seconds <seconds>    Runtime guard threshold (default: 7200).
  -h, --help                         Show this message.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --resume)
      RESUME=true
      shift
      ;;
    --checkpoint)
      if [[ $# -lt 2 ]]; then
        echo "missing value for --checkpoint" >&2
        exit 2
      fi
      CHECKPOINT_PATH="$2"
      shift 2
      ;;
    --invocation-source)
      if [[ $# -lt 2 ]]; then
        echo "missing value for --invocation-source" >&2
        exit 2
      fi
      INVOCATION_SOURCE="$2"
      shift 2
      ;;
    --workflow-tags)
      if [[ $# -lt 2 ]]; then
        echo "missing value for --workflow-tags" >&2
        exit 2
      fi
      WORKFLOW_TAGS="$2"
      shift 2
      ;;
    --max-checks)
      if [[ $# -lt 2 ]]; then
        echo "missing value for --max-checks" >&2
        exit 2
      fi
      MAX_CHECKS="$2"
      shift 2
      ;;
    --max-runtime-seconds)
      if [[ $# -lt 2 ]]; then
        echo "missing value for --max-runtime-seconds" >&2
        exit 2
      fi
      MAX_RUNTIME_SECONDS="$2"
      shift 2
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

if ! [[ "$MAX_CHECKS" =~ ^[0-9]+$ ]] || [[ "$MAX_CHECKS" -eq 0 ]]; then
  echo "invalid --max-checks value: $MAX_CHECKS" >&2
  exit 2
fi

if ! [[ "$MAX_RUNTIME_SECONDS" =~ ^[0-9]+$ ]] || [[ "$MAX_RUNTIME_SECONDS" -eq 0 ]]; then
  echo "invalid --max-runtime-seconds value: $MAX_RUNTIME_SECONDS" >&2
  exit 2
fi

mkdir -p "$(dirname "$CHECKPOINT_PATH")"

if [[ "$RESUME" == true ]]; then
  if [[ ! -f "$CHECKPOINT_PATH" ]]; then
    echo "resume requested but checkpoint file not found: $CHECKPOINT_PATH" >&2
    exit 1
  fi
else
  : >"$CHECKPOINT_PATH"
fi

json_log() {
  local event="$1"
  local check_name="$2"
  local check_slug="$3"
  local status="$4"
  local command="$5"
  local log_path="$6"
  local code="$7"
  local timestamp
  timestamp="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"

  python3 - "$STRUCTURED_LOG_PATH" \
    "$timestamp" \
    "$event" \
    "$RUN_ID" \
    "$INVOCATION_SOURCE" \
    "$WORKFLOW_TAGS" \
    "$CHECKPOINT_PATH" \
    "$check_name" \
    "$check_slug" \
    "$status" \
    "$command" \
    "$log_path" \
    "$code" <<'PY'
import json
import sys

(
    path,
    timestamp,
    event,
    run_id,
    invocation_source,
    workflow_tags,
    checkpoint_path,
    check_name,
    check_slug,
    status,
    command,
    log_path,
    code,
) = sys.argv[1:14]

record = {
    "timestamp": timestamp,
    "event": event,
    "run_id": run_id,
    "script": "run-v2-1-operations-checks.sh",
    "invocation_source": invocation_source,
    "workflow_tags": [tag for tag in workflow_tags.split(",") if tag],
    "checkpoint_path": checkpoint_path,
}

check = {}
if check_name:
    check["name"] = check_name
if check_slug:
    check["slug"] = check_slug
if command:
    check["command"] = command
if log_path:
    check["log_path"] = log_path
if check:
    record["check"] = check

if status:
    record["status"] = status

if code:
    try:
        record["exit_code"] = int(code)
    except ValueError:
        record["exit_code"] = code

with open(path, "a", encoding="utf-8") as handle:
    handle.write(json.dumps(record, sort_keys=True) + "\n")
PY
}

scheduler_audit() {
  local phase="$1"
  local summary="$2"
  local timestamp
  timestamp="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"

  python3 - "$SCHEDULER_AUDIT_PATH" \
    "$timestamp" \
    "$phase" \
    "$RUN_ID" \
    "$INVOCATION_SOURCE" \
    "$WORKFLOW_TAGS" \
    "$CHECKPOINT_PATH" \
    "$RESUME" \
    "$PASS_COUNT" \
    "$FAIL_COUNT" \
    "$SKIP_COUNT" \
    "$summary" <<'PY'
import json
import sys

(
    path,
    timestamp,
    phase,
    run_id,
    invocation_source,
    workflow_tags,
    checkpoint_path,
    resume,
    pass_count,
    fail_count,
    skip_count,
    summary,
) = sys.argv[1:13]

record = {
    "timestamp": timestamp,
    "phase": phase,
    "run_id": run_id,
    "script": "run-v2-1-operations-checks.sh",
    "invocation_source": invocation_source,
    "workflow_tags": [tag for tag in workflow_tags.split(",") if tag],
    "checkpoint_path": checkpoint_path,
    "resume": resume.lower() == "true",
    "pass_count": int(pass_count),
    "fail_count": int(fail_count),
    "skip_count": int(skip_count),
    "summary": summary,
}

with open(path, "a", encoding="utf-8") as handle:
    handle.write(json.dumps(record, sort_keys=True) + "\n")
PY
}

checkpoint_write() {
  local slug="$1"
  local name="$2"
  local status="$3"
  local code="$4"
  local log_path="$5"
  local command="$6"
  local timestamp
  timestamp="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"

  python3 - "$CHECKPOINT_PATH" \
    "$timestamp" \
    "$RUN_ID" \
    "$slug" \
    "$name" \
    "$status" \
    "$code" \
    "$log_path" \
    "$command" <<'PY'
import json
import sys

(
    path,
    timestamp,
    run_id,
    slug,
    name,
    status,
    code,
    log_path,
    command,
) = sys.argv[1:10]

record = {
    "timestamp": timestamp,
    "run_id": run_id,
    "slug": slug,
    "name": name,
    "status": status,
    "log_path": log_path,
    "command": command,
}

if code:
    try:
        record["exit_code"] = int(code)
    except ValueError:
        record["exit_code"] = code

with open(path, "a", encoding="utf-8") as handle:
    handle.write(json.dumps(record, sort_keys=True) + "\n")
PY
}

checkpoint_has_pass() {
  local slug="$1"
  python3 - "$CHECKPOINT_PATH" "$slug" <<'PY'
import json
import sys

path = sys.argv[1]
slug = sys.argv[2]
latest_status = ""

try:
    with open(path, encoding="utf-8") as handle:
        for line in handle:
            line = line.strip()
            if not line:
                continue
            try:
                record = json.loads(line)
            except json.JSONDecodeError:
                continue
            if record.get("slug") == slug:
                latest_status = str(record.get("status", ""))
except FileNotFoundError:
    print("no")
    raise SystemExit(0)

print("yes" if latest_status == "pass" else "no")
PY
}

register_process() {
  {
    echo "pid=$$"
    echo "run_id=$RUN_ID"
    echo "script=run-v2-1-operations-checks.sh"
    echo "tags=$WORKFLOW_TAGS"
    echo "started_at=$STAMP"
    echo "checkpoint_path=$CHECKPOINT_PATH"
  } >"$PID_FILE"

  printf '%s start pid=%s run_id=%s script=%s tags=%s\n' \
    "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" \
    "$$" \
    "$RUN_ID" \
    "run-v2-1-operations-checks.sh" \
    "$WORKFLOW_TAGS" >>"$PROCESS_REGISTRY_PATH"
}

finish_run() {
  local exit_code="$1"
  local phase="completed"

  if [[ "$exit_code" -ne 0 ]]; then
    phase="failed"
  fi

  scheduler_audit "$phase" "exit=$exit_code pass=$PASS_COUNT fail=$FAIL_COUNT skip=$SKIP_COUNT"
  json_log "run_$phase" "" "" "$phase" "" "$REPORT_PATH" "$exit_code"

  rm -f "$PID_FILE" || true
  printf '%s stop pid=%s run_id=%s script=%s exit_code=%s\n' \
    "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" \
    "$$" \
    "$RUN_ID" \
    "run-v2-1-operations-checks.sh" \
    "$exit_code" >>"$PROCESS_REGISTRY_PATH"
}

on_exit() {
  local exit_code=$?
  finish_run "$exit_code"
}

trap on_exit EXIT

guard_runtime() {
  local slug="$1"
  local now
  local elapsed

  CHECK_COUNT=$((CHECK_COUNT + 1))
  if [[ "$CHECK_COUNT" -gt "$MAX_CHECKS" ]]; then
    echo "[guard] max-checks threshold reached ($MAX_CHECKS) while evaluating $slug" >&2
    json_log "loop_guard_triggered" "" "$slug" "fail" "" "" "70"
    exit 70
  fi

  now="$(date '+%s')"
  elapsed=$((now - RUN_STARTED_EPOCH))
  if [[ "$elapsed" -gt "$MAX_RUNTIME_SECONDS" ]]; then
    echo "[guard] max-runtime threshold reached (${MAX_RUNTIME_SECONDS}s) while evaluating $slug" >&2
    json_log "runtime_guard_triggered" "" "$slug" "fail" "" "" "71"
    exit 71
  fi

  case " $SEEN_SLUGS " in
    *" $slug "*)
      echo "[guard] duplicate check slug detected: $slug" >&2
      json_log "duplicate_slug_guard_triggered" "" "$slug" "fail" "" "" "72"
      exit 72
      ;;
    *)
      SEEN_SLUGS="$SEEN_SLUGS $slug"
      ;;
  esac
}

register_process
json_log "run_started" "" "" "started" "" "" ""
scheduler_audit "started" "resume=$RESUME max_checks=$MAX_CHECKS max_runtime_seconds=$MAX_RUNTIME_SECONDS"

log_result() {
  local name="$1"
  local status="$2"
  local command="$3"
  local log_path="$4"

  {
    echo "### $name"
    echo
    echo "- status: $status"
    echo "- command: $command"
    echo "- log: $log_path"
    echo
  } >>"$REPORT_PATH"
}

run_check() {
  local name="$1"
  local command="$2"
  local log_slug="$3"
  local log_path="$REPORT_DIR/v2-1-check-$log_slug-$STAMP.log"

  guard_runtime "$log_slug"

  if [[ "$RESUME" == true ]]; then
    if [[ "$(checkpoint_has_pass "$log_slug")" == "yes" ]]; then
      echo "[skip] $name (checkpoint pass)"
      SKIP_COUNT=$((SKIP_COUNT + 1))
      log_result "$name" "skip (checkpoint pass)" "$command" "$CHECKPOINT_PATH"
      json_log "check_skipped" "$name" "$log_slug" "skip" "$command" "$CHECKPOINT_PATH" ""
      checkpoint_write "$log_slug" "$name" "skip" "" "$CHECKPOINT_PATH" "$command"
      return
    fi
  fi

  set +e
  bash -lc "$command" >"$log_path" 2>&1
  local code=$?
  set -e

  if [[ $code -eq 0 ]]; then
    echo "[pass] $name"
    PASS_COUNT=$((PASS_COUNT + 1))
    log_result "$name" "pass" "$command" "$log_path"
    json_log "check_completed" "$name" "$log_slug" "pass" "$command" "$log_path" "$code"
    checkpoint_write "$log_slug" "$name" "pass" "$code" "$log_path" "$command"
  else
    echo "[fail] $name"
    FAIL_COUNT=$((FAIL_COUNT + 1))
    log_result "$name" "fail (exit $code)" "$command" "$log_path"
    json_log "check_completed" "$name" "$log_slug" "fail" "$command" "$log_path" "$code"
    checkpoint_write "$log_slug" "$name" "fail" "$code" "$log_path" "$command"
  fi
}

cat >"$REPORT_PATH" <<EOF
# v2.1 Operations Checks Report

- generated: $STAMP
- run id: $RUN_ID
- workspace root: $ROOT
- invocation source: $INVOCATION_SOURCE
- workflow tags: $WORKFLOW_TAGS
- resume mode: $RESUME
- checkpoint path: $CHECKPOINT_PATH
- structured log: $STRUCTURED_LOG_PATH
- loop guard max checks: $MAX_CHECKS
- runtime guard max seconds: $MAX_RUNTIME_SECONDS

## Check Results

EOF

run_check "Core runtime checks" "bash $ROOT/uDOS-core/scripts/run-core-checks.sh" "core"
run_check "Shell runtime checks" "bash $ROOT/uDOS-shell/scripts/run-shell-checks.sh" "shell"
run_check "Wizard API and MCP checks" "bash $ROOT/uDOS-wizard/scripts/run-wizard-checks.sh" "wizard"
run_check "Plugin index checks" "bash $ROOT/uDOS-plugin-index/scripts/run-plugin-index-checks.sh" "plugin-index"
run_check "uHOME server checks" "bash $ROOT/uHOME-server/scripts/run-uhome-server-checks.sh" "uhome-server"
run_check "Alpine packaging checks" "bash $ROOT/uDOS-alpine/scripts/run-alpine-checks.sh" "alpine"
run_check "Sonic runtime checks" "bash $ROOT/sonic-screwdriver/scripts/run-sonic-checks.sh" "sonic"
run_check "ThinUI scaffold presence" "test -f $ROOT/uDOS-thinui/src/runtime/runtime-loop.ts" "thinui"
run_check "@dev operations audit" "bash $ROOT/uDOS-dev/scripts/run-v2-1-operations-audit.sh" "dev-operations"

{
  echo "## Summary"
  echo
  echo "- pass: $PASS_COUNT"
  echo "- fail: $FAIL_COUNT"
  echo "- skip: $SKIP_COUNT"
} >>"$REPORT_PATH"

echo "Wrote $REPORT_PATH"
echo "Wrote $STRUCTURED_LOG_PATH"

if [[ $FAIL_COUNT -gt 0 ]]; then
  exit 1
fi
