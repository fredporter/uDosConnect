#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SERVICE_ID="udos-gitd"
SERVICE_PORT="${UDOS_GITD_PORT:-7109}"
UDOS_HOME="${UDOS_HOME:-$HOME/.udos}"
STATE_DIR="${STATE_DIR:-$UDOS_HOME/state/gitd}"
LOG_DIR="${LOG_DIR:-$UDOS_HOME/logs/gitd}"
REPOS_ROOT="${UDOS_REPOS_ROOT:-$UDOS_HOME/repos}"
REGISTRY_PATH="${UDOS_GITD_REGISTRY_PATH:-$STATE_DIR/repo-registry.tsv}"

mkdir -p "$STATE_DIR" "$LOG_DIR" "$REPOS_ROOT"
touch "$REGISTRY_PATH"

print_stub_status() {
  echo "uDOS service stub"
  echo "service=$SERVICE_ID"
  echo "port=$SERVICE_PORT"
  echo "udos_home=$UDOS_HOME"
  echo "state_dir=$STATE_DIR"
  echo "log_dir=$LOG_DIR"
  echo "repos_root=$REPOS_ROOT"
  echo "registry_path=$REGISTRY_PATH"
  echo "status=gitd-ready"
}

ensure_git() {
  if ! command -v git >/dev/null 2>&1; then
    echo "git is required for $1" >&2
    exit 1
  fi
}

registry_has_repo() {
  repo_id="$1"
  awk -F '\t' -v repo_id="$repo_id" '$1 == repo_id {found=1} END {exit found ? 0 : 1}' "$REGISTRY_PATH"
}

registry_get_path() {
  repo_id="$1"
  awk -F '\t' -v repo_id="$repo_id" '$1 == repo_id {print $2; exit}' "$REGISTRY_PATH"
}

write_registry_entry() {
  repo_id="$1"
  repo_path="$2"
  tmp_registry="$(mktemp)"
  if [ -s "$REGISTRY_PATH" ]; then
    awk -F '\t' -v repo_id="$repo_id" '$1 != repo_id {print}' "$REGISTRY_PATH" >"$tmp_registry"
  fi
  printf '%s\t%s\n' "$repo_id" "$repo_path" >>"$tmp_registry"
  mv "$tmp_registry" "$REGISTRY_PATH"
}

resolve_repo_path() {
  repo_id="$1"
  if registry_has_repo "$repo_id"; then
    registry_get_path "$repo_id"
    return 0
  fi
  candidate="$REPOS_ROOT/$repo_id"
  if [ -d "$candidate" ]; then
    printf '%s\n' "$candidate"
    return 0
  fi
  echo "unknown repo: $repo_id" >&2
  exit 1
}

cmd_init_layout() {
  mkdir -p "$STATE_DIR" "$LOG_DIR" "$REPOS_ROOT"
  touch "$REGISTRY_PATH"
  echo "initialized=true"
  echo "repos_root=$REPOS_ROOT"
  echo "registry_path=$REGISTRY_PATH"
}

cmd_repo_list() {
  if [ ! -s "$REGISTRY_PATH" ]; then
    echo "repo_count=0"
    return 0
  fi
  repo_count="$(wc -l <"$REGISTRY_PATH" | tr -d ' ')"
  echo "repo_count=$repo_count"
  while IFS=$'\t' read -r repo_id repo_path; do
    [ -n "$repo_id" ] || continue
    echo "repo_id=$repo_id path=$repo_path"
  done <"$REGISTRY_PATH"
}

cmd_repo_attach() {
  repo_id="${1:?repo id required}"
  source_path="${2:?source path required}"
  if [ ! -d "$source_path" ]; then
    echo "missing repo path: $source_path" >&2
    exit 1
  fi
  if [ ! -d "$source_path/.git" ]; then
    echo "path is not a git checkout: $source_path" >&2
    exit 1
  fi
  write_registry_entry "$repo_id" "$source_path"
  echo "attached=true"
  echo "repo_id=$repo_id"
  echo "path=$source_path"
}

cmd_repo_clone() {
  ensure_git "repo-clone"
  repo_id="${1:?repo id required}"
  remote_url="${2:?remote url required}"
  branch="${3:-}"
  target_path="$REPOS_ROOT/$repo_id"
  if [ -e "$target_path" ]; then
    echo "target already exists: $target_path" >&2
    exit 1
  fi
  if [ -n "$branch" ]; then
    git clone --branch "$branch" "$remote_url" "$target_path"
  else
    git clone "$remote_url" "$target_path"
  fi
  write_registry_entry "$repo_id" "$target_path"
  echo "cloned=true"
  echo "repo_id=$repo_id"
  echo "path=$target_path"
}

cmd_repo_status() {
  ensure_git "repo-status"
  repo_id="${1:?repo id required}"
  repo_path="$(resolve_repo_path "$repo_id")"
  if [ ! -d "$repo_path/.git" ]; then
    echo "registered path is not a git checkout: $repo_path" >&2
    exit 1
  fi
  branch="$(git -C "$repo_path" rev-parse --abbrev-ref HEAD)"
  short_status="$(git -C "$repo_path" status --short)"
  dirty="false"
  if [ -n "$short_status" ]; then
    dirty="true"
  fi
  remote_url="$(git -C "$repo_path" remote get-url origin 2>/dev/null || true)"
  echo "repo_id=$repo_id"
  echo "path=$repo_path"
  echo "branch=$branch"
  echo "dirty=$dirty"
  echo "remote_origin=${remote_url:-none}"
}

cmd_repo_fetch() {
  ensure_git "repo-fetch"
  repo_id="${1:?repo id required}"
  repo_path="$(resolve_repo_path "$repo_id")"
  git -C "$repo_path" fetch --all --prune
  echo "fetched=true"
  echo "repo_id=$repo_id"
  echo "path=$repo_path"
}

cmd_repo_branch() {
  ensure_git "repo-branch"
  repo_id="${1:?repo id required}"
  branch_name="${2:?branch name required}"
  repo_path="$(resolve_repo_path "$repo_id")"
  git -C "$repo_path" checkout -B "$branch_name"
  echo "branched=true"
  echo "repo_id=$repo_id"
  echo "path=$repo_path"
  echo "branch=$branch_name"
}

cmd_repo_pull() {
  ensure_git "repo-pull"
  repo_id="${1:?repo id required}"
  repo_path="$(resolve_repo_path "$repo_id")"
  git -C "$repo_path" pull --ff-only
  echo "pulled=true"
  echo "repo_id=$repo_id"
  echo "path=$repo_path"
}

cmd_repo_push() {
  ensure_git "repo-push"
  repo_id="${1:?repo id required}"
  repo_path="$(resolve_repo_path "$repo_id")"
  branch_name="$(git -C "$repo_path" rev-parse --abbrev-ref HEAD)"
  git -C "$repo_path" push -u origin "$branch_name"
  echo "pushed=true"
  echo "repo_id=$repo_id"
  echo "path=$repo_path"
  echo "branch=$branch_name"
}

case "${1:-serve}" in
  serve|stub)
    print_stub_status
    ;;
  init-layout)
    cmd_init_layout
    ;;
  repo-list)
    cmd_repo_list
    ;;
  repo-attach)
    shift
    cmd_repo_attach "$@"
    ;;
  repo-clone)
    shift
    cmd_repo_clone "$@"
    ;;
  repo-status)
    shift
    cmd_repo_status "$@"
    ;;
  repo-fetch)
    shift
    cmd_repo_fetch "$@"
    ;;
  repo-branch)
    shift
    cmd_repo_branch "$@"
    ;;
  repo-pull)
    shift
    cmd_repo_pull "$@"
    ;;
  repo-push)
    shift
    cmd_repo_push "$@"
    ;;
  *)
    echo "unknown command: $1" >&2
    echo "expected one of: serve, init-layout, repo-list, repo-attach, repo-clone, repo-status, repo-fetch, repo-branch, repo-pull, repo-push" >&2
    exit 1
    ;;
esac
