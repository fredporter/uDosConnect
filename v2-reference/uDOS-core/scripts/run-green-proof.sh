#!/usr/bin/env bash
# Fast PR gate: logs/feeds/spool green_proof markers only.
set -eu
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
exec python3 -m pytest -m green_proof -q --strict-markers "$@"
