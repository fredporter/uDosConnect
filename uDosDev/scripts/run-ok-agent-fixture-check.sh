#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
WIZARD_ROOT="$(cd "$REPO_ROOT/../uDOS-wizard" && pwd)"

require_file() {
  if [ ! -f "$1" ]; then
    echo "missing required file: $1" >&2
    exit 1
  fi
}

require_dir() {
  if [ ! -d "$1" ]; then
    echo "missing required directory: $1" >&2
    exit 1
  fi
}

require_dir "$REPO_ROOT/@dev/pathways/templates"
require_dir "$WIZARD_ROOT/wizard/ok/providers"

require_file "$REPO_ROOT/@dev/pathways/templates/ok-provider-manifest-template.json"
require_file "$REPO_ROOT/@dev/pathways/templates/mcp-tool-manifest-template.json"
require_file "$REPO_ROOT/@dev/pathways/templates/deferred-packet-template.json"
require_file "$REPO_ROOT/@dev/pathways/templates/budget-policy-template.json"
require_file "$WIZARD_ROOT/wizard/ok/providers/anthropic.json"
require_file "$WIZARD_ROOT/wizard/ok/providers/openai.json"
require_file "$WIZARD_ROOT/wizard/ok/providers/openrouter.json"
require_file "$WIZARD_ROOT/wizard/ok/providers/mistral.json"
require_file "$WIZARD_ROOT/wizard/ok/providers/gemini.json"

python3 - "$REPO_ROOT" "$WIZARD_ROOT" <<'PY'
import json
import sys
from pathlib import Path

repo_root = Path(sys.argv[1])
wizard_root = Path(sys.argv[2])

template_json_files = [
    repo_root / "@dev/pathways/templates/ok-provider-manifest-template.json",
    repo_root / "@dev/pathways/templates/mcp-tool-manifest-template.json",
    repo_root / "@dev/pathways/templates/deferred-packet-template.json",
    repo_root / "@dev/pathways/templates/budget-policy-template.json",
]

provider_files = sorted((wizard_root / "wizard/ok/providers").glob("*.json"))

for file_path in template_json_files + provider_files:
    payload = json.loads(file_path.read_text(encoding="utf-8"))
    if not isinstance(payload, dict):
        raise SystemExit(f"invalid JSON object payload: {file_path}")

required_provider_keys = {
    "provider_id",
    "provider_class",
    "network_required",
    "models",
    "capabilities",
    "budget_group",
    "retry_policy",
    "cache_policy",
    "approval_required",
}

for provider_file in provider_files:
    payload = json.loads(provider_file.read_text(encoding="utf-8"))
    missing = sorted(required_provider_keys - set(payload))
    if missing:
        raise SystemExit(
            f"provider manifest missing keys in {provider_file}: {', '.join(missing)}"
        )

print("OK agent fixture checks passed")
PY
