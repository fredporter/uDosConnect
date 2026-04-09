#!/usr/bin/env bash
# Post-08 O4: Learning Hub wiki_units ↔ on-disk wiki files, venv lane strings, GUI vocabulary anchors.
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAMILY_ROOT="${UDOS_FAMILY_ROOT:-$(cd "$REPO_ROOT/.." && pwd)}"
DOCS_ROOT="${UDOS_DOCS_ROOT:-$FAMILY_ROOT/uDOS-docs}"
SOURCE_JSON="$DOCS_ROOT/site/data/family-source.json"
VENV_FIXTURE="$REPO_ROOT/@dev/fixtures/operational-hygiene-venv-lanes.v1.json"

if [ ! -f "$SOURCE_JSON" ]; then
  echo "O4 verify: missing $SOURCE_JSON (set UDOS_DOCS_ROOT or use family checkout)" >&2
  exit 1
fi
if [ ! -f "$VENV_FIXTURE" ]; then
  echo "O4 verify: missing $VENV_FIXTURE" >&2
  exit 1
fi

python3 - "$SOURCE_JSON" "$FAMILY_ROOT" <<'PY'
import json
import pathlib
import re
import sys

source_path = pathlib.Path(sys.argv[1])
family_root = pathlib.Path(sys.argv[2])
data = json.loads(source_path.read_text(encoding="utf-8"))
blob_re = re.compile(
    r"^https://github\.com/fredporter/([^/]+)/blob/main/(.+)$"
)
for entry in data.get("wiki_units", []):
    url = (entry.get("url") or "").strip()
    m = blob_re.match(url)
    if not m:
        raise SystemExit(f"O4 wiki: unsupported wiki_units url shape: {url!r}")
    repo, rel = m.group(1), m.group(2)
    root = family_root / repo
    if not root.is_dir():
        continue
    target = root / rel
    if not target.is_file():
        raise SystemExit(f"O4 wiki hub drift: indexed file missing on disk: {target}")
PY

python3 - "$VENV_FIXTURE" "$FAMILY_ROOT" <<'PY'
import json
import os
import pathlib
import sys

fixture_path = pathlib.Path(sys.argv[1])
family_root = pathlib.Path(sys.argv[2])
data = json.loads(fixture_path.read_text(encoding="utf-8"))
for lane in data.get("lanes", []):
    repo = lane.get("repo")
    script_rel = lane.get("check_script")
    frag = lane.get("default_path_fragment")
    if not repo or not script_rel or not frag:
        raise SystemExit("O4 venv fixture: lane missing repo, check_script, or default_path_fragment")
    script = family_root / repo / script_rel
    if not script.is_file():
        continue
    text = script.read_text(encoding="utf-8")
    if frag not in text:
        raise SystemExit(f"O4 venv drift: {script} must contain default path fragment {frag!r}")
    if "UDOS_VENV_DIR" not in text:
        raise SystemExit(f"O4 venv drift: {script} must allow UDOS_VENV_DIR override")
for alt in data.get("optional_alt_roots", []):
    env_name = alt.get("env")
    repo = alt.get("repo")
    script_rel = alt.get("check_script")
    frag = alt.get("default_path_fragment")
    if not env_name or not repo or not script_rel or not frag:
        raise SystemExit("O4 venv fixture: optional_alt_roots entry incomplete")
    root_override = os.environ.get(env_name, "").strip()
    if not root_override:
        continue
    script = pathlib.Path(root_override) / script_rel
    if not script.is_file():
        raise SystemExit(f"O4 venv: {env_name} set but missing {script}")
    text = script.read_text(encoding="utf-8")
    if frag not in text or "UDOS_VENV_DIR" not in text:
        raise SystemExit(f"O4 venv drift: optional root {script} missing fragment or UDOS_VENV_DIR")
PY

GUI="$REPO_ROOT/docs/gui-system-family-contract.md"
if [ ! -f "$GUI" ]; then
  echo "O4 verify: missing $GUI" >&2
  exit 1
fi
if ! grep -q "ThinUI" "$GUI" || ! grep -q "Wizard" "$GUI" || ! grep -q "browser" "$GUI"; then
  echo "O4 vocabulary: gui-system-family-contract.md must mention ThinUI, Wizard, and browser" >&2
  exit 1
fi

CORE_B="$FAMILY_ROOT/uDOS-core/docs/wizard-surface-delegation-boundary.md"
if [ -f "$CORE_B" ]; then
  if ! grep -qi "delegat" "$CORE_B"; then
    echo "O4 vocabulary: wizard-surface-delegation-boundary.md should retain delegation wording" >&2
    exit 1
  fi
else
  echo "O4 vocabulary: skip Core boundary (no sibling uDOS-core)" >&2
fi

UBU_ACT="$FAMILY_ROOT/uDOS-host/docs/activation.md"
if [ -f "$UBU_ACT" ]; then
  if ! grep -qiE "host|ubuntu" "$UBU_ACT"; then
    echo "O4 vocabulary: ubuntu activation.md should retain host/ubuntu posture wording" >&2
    exit 1
  fi
fi

WIZ_ARCH="$FAMILY_ROOT/uDOS-wizard/docs/architecture.md"
if [ -f "$WIZ_ARCH" ]; then
  if ! grep -qiE "broker|delegat|surface" "$WIZ_ARCH"; then
    echo "O4 vocabulary: wizard architecture.md should retain broker/delegation/surface wording" >&2
    exit 1
  fi
fi

echo "O4 operational hygiene verify passed"
