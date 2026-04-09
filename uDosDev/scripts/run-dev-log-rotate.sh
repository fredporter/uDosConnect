#!/usr/bin/env bash
# run-dev-log-rotate.sh — prune old per-run JSONL and check logs from @dev/logs/
#
# Keeps the most recent N files for each log pattern. Default: 20.
# Dry-run mode prints what would be removed without deleting.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LOG_DIR="$REPO_ROOT/@dev/logs"
REPORT_DIR="$REPO_ROOT/@dev/notes/reports"

KEEP=20
DRY_RUN=false

usage() {
  cat <<'EOF'
usage: run-dev-log-rotate.sh [options]

Options:
  --keep <n>    Number of recent files to retain per pattern (default: 20).
  --dry-run     Print files that would be removed without deleting them.
  -h, --help    Show this message.

Patterns rotated:
  @dev/logs/v2-1-operations-checks-*.jsonl
  @dev/notes/reports/v2-1-operations-checks-*.md
  @dev/notes/reports/v2-1-check-*-*.log
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --keep)
      if [[ $# -lt 2 ]]; then
        echo "missing value for --keep" >&2
        exit 2
      fi
      KEEP="$2"
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

if ! [[ "$KEEP" =~ ^[0-9]+$ ]] || [[ "$KEEP" -eq 0 ]]; then
  echo "invalid --keep value: $KEEP" >&2
  exit 2
fi

mkdir -p "$LOG_DIR"
mkdir -p "$REPORT_DIR"

removed=0
kept=0

rotate_pattern() {
  local dir="$1"
  local glob="$2"
  local label="$3"

  shopt -s nullglob
  local files=("$dir"/$glob)
  shopt -u nullglob

  # Sort oldest-first by name (timestamps in filenames make lexical sort work)
  IFS=$'\n' sorted=($(printf '%s\n' "${files[@]:-}" | sort))
  unset IFS

  local total=${#sorted[@]}
  if [[ $total -le $KEEP ]]; then
    kept=$((kept + total))
    return
  fi

  local to_remove=$((total - KEEP))
  kept=$((kept + KEEP))

  for i in $(seq 0 $((to_remove - 1))); do
    local f="${sorted[$i]}"
    if [[ "$DRY_RUN" == true ]]; then
      echo "[dry-run] would remove $label: $f"
    else
      rm -f "$f"
      echo "[rotate] removed $label: $(basename "$f")"
    fi
    removed=$((removed + 1))
  done
}

rotate_pattern "$LOG_DIR" "v2-1-operations-checks-*.jsonl" "structured-log"
rotate_pattern "$REPORT_DIR" "v2-1-operations-checks-*.md" "operations-report"
rotate_pattern "$REPORT_DIR" "v2-1-check-*-*.log" "check-log"
rotate_pattern "$REPORT_DIR" "roadmap-status-*.md" "roadmap-report"

if [[ "$DRY_RUN" == true ]]; then
  echo "log-rotate dry-run: would remove $removed file(s), keep $kept"
else
  echo "log-rotate complete: removed $removed file(s), kept $kept"
fi
