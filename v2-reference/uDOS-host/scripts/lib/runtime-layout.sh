#!/usr/bin/env bash
# Materialize canonical ~/.udos/ directories for the Ubuntu command-centre host.
# Source this file; do not execute standalone.
# Aligned to uDOS-dev compost filesystem contract and docs/config-layout.md.

set -eu

ud_os_runtime_layout_version="1"

ud_os_runtime_roots() {
  local base="${1:?}"
  cat <<EOF
${base}/bin
${base}/envs
${base}/state
${base}/state/hostd
${base}/state/gitd
${base}/state/web
${base}/state/host
${base}/vault
${base}/vault/inbox
${base}/vault/projects
${base}/vault/library
${base}/publish
${base}/publish/static
${base}/sync
${base}/sync/queue
${base}/sync/archive
${base}/memory
${base}/library
${base}/repos
${base}/logs
${base}/cache
${base}/tmp
EOF
}

# Idempotent: creates dirs and writes a small manifest under state/hostd/.
ud_os_ensure_runtime_layout() {
  local udos_home="${UDOS_HOME:-$HOME/.udos}"
  local manifest="$udos_home/state/hostd/runtime-layout.json"

  # Single batch mkdir (paths have no spaces; see ud_os_runtime_roots).
  ud_os_runtime_roots "$udos_home" | xargs mkdir -p

  local ts
  ts="$(date -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date -u +"%Y-%m-%dT%H:%M:%SZ")"
  mkdir -p "$(dirname "$manifest")"
  # shellcheck disable=SC2016
  printf '{"layout_version":"%s","created_utc":"%s","udos_home":"%s"}\n' \
    "$ud_os_runtime_layout_version" "$ts" "$udos_home" >"$manifest"

  echo "runtime-layout=ok"
  echo "layout_version=$ud_os_runtime_layout_version"
  echo "manifest=$manifest"
}
