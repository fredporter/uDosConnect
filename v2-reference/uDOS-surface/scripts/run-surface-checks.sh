#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
python3 "$SCRIPT_DIR/validate_surface_profiles.py" --root "$(cd "$SCRIPT_DIR/.." && pwd)"
"$SCRIPT_DIR/run-wizard-checks.sh"
