#!/usr/bin/env bash
# Post-08 O3: when sibling repos exist, optional_compat lifecycle entries have owner docs.
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MATRIX="$REPO_ROOT/@dev/fixtures/shared-runtime-service-lifecycle.v1.json"

if [ ! -f "$MATRIX" ]; then
  echo "missing lifecycle matrix: $MATRIX" >&2
  exit 1
fi

python3 - "$MATRIX" "$REPO_ROOT" <<'PY'
import json
import pathlib
import sys

matrix_path = pathlib.Path(sys.argv[1])
family_root = pathlib.Path(sys.argv[2]).resolve().parent
data = json.loads(matrix_path.read_text(encoding="utf-8"))
for entry in data.get("optional_compat_services", []):
    repo = entry.get("owner_repo")
    sid = entry.get("service_id")
    if not repo or not sid:
        sys.exit("optional_compat_services entry missing owner_repo or service_id")
    root = family_root / repo
    if not root.is_dir():
        continue
    if repo == "uDOS-host":
        doc = root / "docs" / "docker-compose-compatibility.md"
        if not doc.is_file():
            sys.exit(f"O3 verify: missing {doc}")
        text = doc.read_text(encoding="utf-8")
        if sid not in text:
            sys.exit(f"O3 verify: {doc} must mention {sid}")
    elif repo == "uDOS-groovebox":
        doc = root / "docs" / "docker-posture.md"
        if not doc.is_file():
            sys.exit(f"O3 verify: missing {doc}")
        text = doc.read_text(encoding="utf-8")
        if "transitional compatibility" not in text.lower():
            sys.exit(f"O3 verify: {doc} must state transitional compatibility posture")
PY

echo "O3 docker compat sibling verify passed"
