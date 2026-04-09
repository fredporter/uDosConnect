#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

UBUNTU_ROOT="${UDOS_UBUNTU_ROOT:-$REPO_ROOT/../uDOS-host}"
STRICT_MODE="${UDOS_SHARED_RUNTIME_STRICT:-0}"
CONTRACT_FILE="$REPO_ROOT/@dev/fixtures/shared-runtime-resource.v1.json"
LIFECYCLE_MATRIX_FILE="$REPO_ROOT/@dev/fixtures/shared-runtime-service-lifecycle.v1.json"

if [ "${1:-}" = "--strict" ]; then
  STRICT_MODE=1
fi

if [ ! -f "$CONTRACT_FILE" ]; then
  echo "shared-runtime-check: missing contract file $CONTRACT_FILE" >&2
  exit 1
fi
if [ ! -f "$LIFECYCLE_MATRIX_FILE" ]; then
  echo "shared-runtime-check: missing lifecycle matrix file $LIFECYCLE_MATRIX_FILE" >&2
  exit 1
fi

if [ ! -d "$UBUNTU_ROOT" ]; then
  msg="shared-runtime-check: skipped (uDOS-host not found at $UBUNTU_ROOT)"
  if [ "$STRICT_MODE" = "1" ]; then
    echo "$msg" >&2
    exit 1
  fi
  echo "$msg"
  exit 0
fi

# Validate machine-readable contract basics before any runtime probing.
python3 - "$CONTRACT_FILE" "$UBUNTU_ROOT" <<'PY'
import json
import pathlib
import sys

contract_path = pathlib.Path(sys.argv[1])
ubuntu_root = pathlib.Path(sys.argv[2])
data = json.loads(contract_path.read_text(encoding="utf-8"))

if data.get("contract_id") != "udos.shared-runtime-resource.v1":
    raise SystemExit("shared-runtime-check: contract_id mismatch")
if data.get("owner") != "uDOS-dev":
    raise SystemExit("shared-runtime-check: owner mismatch")

adapter = data.get("adapter", {})
if adapter.get("repo") != "uDOS-host":
    raise SystemExit("shared-runtime-check: adapter.repo mismatch")
verify_rel = adapter.get("verify_script")
if not verify_rel:
    raise SystemExit("shared-runtime-check: adapter.verify_script missing")
verify_abs = ubuntu_root / verify_rel
if not verify_abs.is_file():
    raise SystemExit(f"shared-runtime-check: missing adapter verify script {verify_abs}")

required_endpoints = data.get("required_health_endpoints", [])
for endpoint in ("/health.json", "/v1/status"):
    if endpoint not in required_endpoints:
        raise SystemExit(f"shared-runtime-check: required endpoint missing: {endpoint}")

required_services = set(data.get("required_services", []))
minimum = {
    "udos-hostd",
    "udos-commandd",
    "udos-vaultd",
    "udos-syncd",
    "udos-web",
}
missing = sorted(minimum - required_services)
if missing:
    raise SystemExit(f"shared-runtime-check: required services missing: {missing}")

required_lifecycle_ops = data.get("required_lifecycle_operations", [])
if not required_lifecycle_ops:
    raise SystemExit("shared-runtime-check: required_lifecycle_operations missing")

registry_path = ubuntu_root / "contracts" / "udos-commandd" / "operation-registry.v1.json"
if not registry_path.is_file():
    raise SystemExit(f"shared-runtime-check: missing operation registry {registry_path}")
registry = json.loads(registry_path.read_text(encoding="utf-8"))
ops = {item.get("operation_id"): item for item in registry.get("operations", [])}
for op_id in required_lifecycle_ops:
    if op_id not in ops:
        raise SystemExit(f"shared-runtime-check: lifecycle operation missing from registry: {op_id}")
    owner = ops[op_id].get("owner_service")
    if owner != "udos-hostd":
        raise SystemExit(
            f"shared-runtime-check: lifecycle operation {op_id} owner mismatch (expected udos-hostd, got {owner})"
        )
PY

python3 - "$LIFECYCLE_MATRIX_FILE" "$CONTRACT_FILE" <<'PY'
import json
import pathlib
import sys

matrix = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
contract = json.loads(pathlib.Path(sys.argv[2]).read_text(encoding="utf-8"))

if matrix.get("contract_id") != "udos.shared-runtime-service-lifecycle.v1":
    raise SystemExit("shared-runtime-check: lifecycle matrix contract_id mismatch")
if matrix.get("owner") != "uDOS-dev":
    raise SystemExit("shared-runtime-check: lifecycle matrix owner mismatch")
if matrix.get("mode") != "lane1-noop":
    raise SystemExit("shared-runtime-check: lifecycle matrix mode must be lane1-noop")

services = matrix.get("services", [])
if not services:
    raise SystemExit("shared-runtime-check: lifecycle matrix services missing")
required = set(contract.get("required_services", []))
missing = sorted(required - set(services))
if missing:
    raise SystemExit(f"shared-runtime-check: lifecycle matrix missing required services: {missing}")

compat = matrix.get("optional_compat_services", [])
allowed_profiles = {"docker-fallback", "external-compat"}
for entry in compat:
    if not isinstance(entry, dict):
        raise SystemExit("shared-runtime-check: optional_compat_services entries must be objects")
    sid = entry.get("service_id")
    if not sid:
        raise SystemExit("shared-runtime-check: optional_compat_services.service_id missing")
    profile = entry.get("control_profile")
    if profile not in allowed_profiles:
        raise SystemExit(
            f"shared-runtime-check: optional_compat_services {sid} invalid control_profile: {profile}"
        )
    if sid in services:
        raise SystemExit(
            f"shared-runtime-check: optional_compat_services {sid} must not duplicate core services"
        )
    if not entry.get("owner_repo"):
        raise SystemExit(f"shared-runtime-check: optional_compat_services {sid} owner_repo missing")

op_expect = matrix.get("operation_expectations", {})
for op in contract.get("required_lifecycle_operations", []):
    if op not in op_expect:
        raise SystemExit(f"shared-runtime-check: lifecycle matrix missing expectation for {op}")
PY

VERIFY_SCRIPT="$UBUNTU_ROOT/$(python3 - "$CONTRACT_FILE" <<'PY'
import json
import pathlib
import sys
data = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
print(data["adapter"]["verify_script"])
PY
)"

if [ ! -f "$VERIFY_SCRIPT" ]; then
  echo "shared-runtime-check: missing $VERIFY_SCRIPT" >&2
  exit 1
fi

LIFECYCLE_OPS="$(python3 - "$CONTRACT_FILE" <<'PY'
import json
import pathlib
import sys
data = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
for op in data.get("required_lifecycle_operations", []):
    print(op)
PY
)"

COMMANDD_SCRIPT="$UBUNTU_ROOT/scripts/udos-commandd.sh"
if [ ! -f "$COMMANDD_SCRIPT" ]; then
  echo "shared-runtime-check: missing $COMMANDD_SCRIPT" >&2
  exit 1
fi

TMP_HOME_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMP_HOME_ROOT"' EXIT

while IFS= read -r op; do
  [ -n "$op" ] || continue
  op_home="$TMP_HOME_ROOT/$op/.udos"
  case "$op" in
    runtime.service.start|runtime.service.stop|runtime.service.restart)
      out="$(UDOS_HOME="$op_home" bash "$COMMANDD_SCRIPT" repo-op "$op" udos-web || true)"
      ;;
    runtime.service.status)
      out="$(UDOS_HOME="$op_home" bash "$COMMANDD_SCRIPT" repo-op "$op" udos-web || true)"
      ;;
    *)
      out="$(UDOS_HOME="$op_home" bash "$COMMANDD_SCRIPT" repo-op "$op" || true)"
      ;;
  esac
  if ! printf '%s' "$out" | grep -q 'operation_id='"$op"; then
    echo "shared-runtime-check: lifecycle operation not callable: $op" >&2
    echo "$out" >&2
    exit 1
  fi
done <<EOF
$LIFECYCLE_OPS
EOF

SERVICE_LIST="$(python3 - "$LIFECYCLE_MATRIX_FILE" <<'PY'
import json
import pathlib
import sys
data = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
for name in data.get("services", []):
    print(name)
PY
)"

while IFS= read -r svc; do
  [ -n "$svc" ] || continue
  op_home="$TMP_HOME_ROOT/svc/$svc/.udos"

  out_start="$(UDOS_HOME="$op_home" bash "$COMMANDD_SCRIPT" repo-op runtime.service.start "$svc" || true)"
  if ! printf '%s' "$out_start" | grep -Eq 'status=accepted|mode=lane1-noop'; then
    echo "shared-runtime-check: lifecycle start expectation failed for $svc" >&2
    echo "$out_start" >&2
    exit 1
  fi

  out_status="$(UDOS_HOME="$op_home" bash "$COMMANDD_SCRIPT" repo-op runtime.service.status "$svc" || true)"
  if ! printf '%s' "$out_status" | grep -Eq 'status=ok|state=lane1-minimal'; then
    echo "shared-runtime-check: lifecycle status expectation failed for $svc" >&2
    echo "$out_status" >&2
    exit 1
  fi
done <<EOF
$SERVICE_LIST
EOF

echo "shared-runtime-check: verifying runtime daemon contract via uDOS-host"
bash "$VERIFY_SCRIPT"
echo "shared-runtime-check: OK"
