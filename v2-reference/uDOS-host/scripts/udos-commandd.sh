#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
export UDOS_UBUNTU_ROOT="${UDOS_UBUNTU_ROOT:-$REPO_ROOT}"
GITD_SCRIPT="$REPO_ROOT/scripts/udos-gitd.sh"
SERVICE_ID="udos-commandd"
SERVICE_PORT="${UDOS_COMMANDD_PORT:-7101}"
UDOS_HOME="${UDOS_HOME:-$HOME/.udos}"
STATE_DIR="${STATE_DIR:-$UDOS_HOME/state/commandd}"
LOG_DIR="${LOG_DIR:-$UDOS_HOME/logs/commandd}"
OPS_REGISTRY="$REPO_ROOT/contracts/udos-commandd/operation-registry.v1.json"
GIT_SURFACE="$REPO_ROOT/contracts/udos-commandd/git-host-surface.v1.json"
WIZARD_SURFACE="$REPO_ROOT/contracts/udos-commandd/wizard-host-surface.v1.json"
GITHUB_POLICY="${UDOS_GITHUB_POLICY_PATH:-$REPO_ROOT/config/policy/github-action-policy.json.example}"
AUDIT_LOG="${UDOS_COMMANDD_AUDIT_LOG:-$LOG_DIR/operation-audit.log}"

mkdir -p "$STATE_DIR" "$LOG_DIR"
touch "$AUDIT_LOG"

print_stub_status() {
  echo "uDOS service stub"
  echo "service=$SERVICE_ID"
  echo "port=$SERVICE_PORT"
  echo "udos_home=$UDOS_HOME"
  echo "state_dir=$STATE_DIR"
  echo "log_dir=$LOG_DIR"
  echo "operation_registry=$OPS_REGISTRY"
  echo "github_policy=$GITHUB_POLICY"
  echo "audit_log=$AUDIT_LOG"
  echo "status=commandd-ready"
}

log_audit_event() {
  operation_id="$1"
  status="$2"
  detail="$3"
  printf '%s\t%s\t%s\t%s\n' "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" "$operation_id" "$status" "$detail" >>"$AUDIT_LOG"
}

ensure_operation_exists() {
  operation_id="$1"
  python3 - "$OPS_REGISTRY" "$operation_id" <<'PY'
import json
import sys
from pathlib import Path

registry_path = Path(sys.argv[1])
operation_id = sys.argv[2]
payload = json.loads(registry_path.read_text(encoding="utf-8"))
ops = {item["operation_id"] for item in payload.get("operations", [])}
if operation_id not in ops:
    raise SystemExit(f"unknown operation_id: {operation_id}")
PY
}

policy_field() {
  operation_id="$1"
  field_name="$2"
  python3 - "$GITHUB_POLICY" "$operation_id" "$field_name" <<'PY'
import json
import sys
from pathlib import Path

policy_path = Path(sys.argv[1])
operation_id = sys.argv[2]
field_name = sys.argv[3]
payload = json.loads(policy_path.read_text(encoding="utf-8"))
rules = payload.get("repo_rules", {}) | payload.get("github_rules", {})
rule = rules.get(operation_id, {})
value = rule.get(field_name, "")
if value:
    print(value)
PY
}

cmd_list_operations() {
  domain="${1:-}"
  python3 - "$OPS_REGISTRY" "$domain" <<'PY'
import json
import sys
from pathlib import Path

registry_path = Path(sys.argv[1])
domain = sys.argv[2]
payload = json.loads(registry_path.read_text(encoding="utf-8"))
ops = payload.get("operations", [])
if domain:
    ops = [item for item in ops if item.get("domain") == domain]
print(f"operation_count={len(ops)}")
for item in ops:
    print(
        "operation_id={operation_id} domain={domain} owner_service={owner_service} async_default={async_default}".format(
            **item
        )
    )
PY
}

cmd_surface_summary() {
  surface_name="${1:-git}"
  case "$surface_name" in
    git)
      surface_path="$GIT_SURFACE"
      ;;
    wizard)
      surface_path="$WIZARD_SURFACE"
      ;;
    *)
      echo "unknown surface: $surface_name" >&2
      echo "expected one of: git, wizard" >&2
      exit 1
      ;;
  esac
  python3 - "$surface_path" <<'PY'
import json
import sys
from pathlib import Path

surface_path = Path(sys.argv[1])
payload = json.loads(surface_path.read_text(encoding="utf-8"))
ops = payload.get("operations", [])
print(f"surface_id={payload.get('surface_id')}")
print(f"owner={payload.get('owner')}")
print(f"base_path={payload.get('base_path')}")
print(f"operation_count={len(ops)}")
for item in ops:
    print(f"operation_id={item['operation_id']} method={item['method']} route={item['route']}")
PY
}

cmd_policy_summary() {
  python3 - "$GITHUB_POLICY" <<'PY'
import json
import sys
from pathlib import Path

policy_path = Path(sys.argv[1])
payload = json.loads(policy_path.read_text(encoding="utf-8"))
print(f"policy_id={payload.get('policy_id')}")
print(f"default_mode={payload.get('default_mode')}")
print(f"audit_log={payload.get('audit_log')}")
for section_name in ("repo_rules", "github_rules"):
    section = payload.get(section_name, {})
    print(f"{section_name}_count={len(section)}")
    for operation_id, rule in section.items():
        print(f"operation_id={operation_id} mode={rule.get('mode')} approval_env={rule.get('approval_env', 'none')}")
PY
}

cmd_repo_operation() {
  operation_id="${1:?operation id required}"
  shift
  ensure_operation_exists "$operation_id"

  case "$operation_id" in
    repo.list)
      bash "$GITD_SCRIPT" repo-list "$@"
      log_audit_event "$operation_id" "ok" "bridged-to-gitd"
      ;;
    repo.status)
      bash "$GITD_SCRIPT" repo-status "$@"
      log_audit_event "$operation_id" "ok" "bridged-to-gitd"
      ;;
    repo.fetch)
      bash "$GITD_SCRIPT" repo-fetch "$@"
      log_audit_event "$operation_id" "ok" "bridged-to-gitd"
      ;;
    repo.branch)
      bash "$GITD_SCRIPT" repo-branch "$@"
      log_audit_event "$operation_id" "ok" "bridged-to-gitd"
      ;;
    repo.pull)
      bash "$GITD_SCRIPT" repo-pull "$@"
      log_audit_event "$operation_id" "ok" "bridged-to-gitd"
      ;;
    repo.push)
      policy_mode="$(policy_field "$operation_id" mode)"
      policy_reason="$(policy_field "$operation_id" reason)"
      policy_approval_env="$(policy_field "$operation_id" approval_env)"
      if [ "$policy_mode" = "require-approval" ] && [ "${!policy_approval_env:-0}" != "1" ]; then
        log_audit_event "$operation_id" "blocked" "approval-required"
        echo "status=blocked"
        echo "operation_id=$operation_id"
        echo "reason=${policy_reason:-approval-required}"
        echo "approval_env=${policy_approval_env:-unset}"
        return 0
      fi
      bash "$GITD_SCRIPT" repo-push "$@"
      log_audit_event "$operation_id" "ok" "bridged-to-gitd"
      ;;
    repo.clone_or_attach)
      mode="${1:?mode required: attach|clone}"
      shift
      case "$mode" in
        attach)
          bash "$GITD_SCRIPT" repo-attach "$@"
          ;;
        clone)
          bash "$GITD_SCRIPT" repo-clone "$@"
          ;;
        *)
          echo "unknown repo.clone_or_attach mode: $mode" >&2
          exit 1
          ;;
      esac
      log_audit_event "$operation_id" "ok" "bridged-to-gitd:$mode"
      ;;
    github.issue.read|github.pr.comment|github.pr.create)
      policy_mode="$(policy_field "$operation_id" mode)"
      policy_adapter="$(policy_field "$operation_id" adapter)"
      policy_approval_env="$(policy_field "$operation_id" approval_env)"
      log_audit_event "$operation_id" "policy-gated" "${policy_mode:-unconfigured}"
      echo "status=policy-gated"
      echo "operation_id=$operation_id"
      echo "mode=${policy_mode:-unknown}"
      echo "adapter=${policy_adapter:-none}"
      echo "approval_env=${policy_approval_env:-none}"
      ;;
    runtime.service.status)
      target_service="${1:-all}"
      log_audit_event "$operation_id" "ok" "lane1-status:${target_service}"
      echo "status=ok"
      echo "operation_id=$operation_id"
      echo "target_service=$target_service"
      echo "state=lane1-minimal"
      echo "note=No centralized supervisor in lane1; per-daemon health probes are authoritative."
      ;;
    runtime.service.start|runtime.service.stop|runtime.service.restart)
      target_service="${1:-}"
      if [ -z "$target_service" ]; then
        echo "missing target service for $operation_id" >&2
        exit 1
      fi
      log_audit_event "$operation_id" "accepted" "lane1-lifecycle:${target_service}"
      echo "status=accepted"
      echo "operation_id=$operation_id"
      echo "target_service=$target_service"
      echo "mode=lane1-noop"
      echo "note=Lifecycle command accepted in contract lane; concrete supervisor wiring is a later implementation step."
      ;;
    *)
      echo "operation bridge not implemented for: $operation_id" >&2
      exit 1
      ;;
  esac
}

case "${1:-serve}" in
  serve)
    BIND="${UDOS_COMMANDD_BIND:-127.0.0.1}"
    PORT="${UDOS_COMMANDD_PORT:-7101}"
    exec python3 "$SCRIPT_DIR/lib/runtime_daemon_httpd.py" commandd --bind "$BIND" --port "$PORT"
    ;;
  stub|status)
    print_stub_status
    ;;
  list-operations)
    shift
    cmd_list_operations "${1:-}"
    ;;
  surface-summary)
    shift
    cmd_surface_summary "${1:-git}"
    ;;
  policy-summary)
    cmd_policy_summary
    ;;
  repo-op)
    shift
    cmd_repo_operation "$@"
    ;;
  *)
    echo "unknown command: $1" >&2
    echo "expected one of: serve, stub, list-operations, surface-summary, policy-summary, repo-op" >&2
    exit 1
    ;;
esac
