#!/usr/bin/env bash
set -euo pipefail

EXPORT_DIR="${1:-$HOME/udos-export-helper-exports}"
DAYS="${2:-7}"

find "$EXPORT_DIR" -type f -name "*.zip" -mtime +"$DAYS" -delete || true
find "$EXPORT_DIR" -mindepth 1 -maxdepth 1 -type d -mtime +"$DAYS" -exec rm -rf {} + || true
