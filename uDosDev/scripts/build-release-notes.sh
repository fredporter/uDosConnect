#!/usr/bin/env bash

set -eu

TAG="${1:-}"
CHANGELOG_PATH="${2:-CHANGELOG.md}"
OUT_PATH="${3:-release_notes.md}"

if [ -z "$TAG" ]; then
  echo "usage: $0 <tag> [changelog-path] [out-path]" >&2
  exit 1
fi

if [ -f "$CHANGELOG_PATH" ]; then
  notes="$(python3 - "$TAG" "$CHANGELOG_PATH" <<'PY'
import re
import sys
from pathlib import Path

tag = sys.argv[1]
normalized = tag[1:] if tag.startswith("v") else tag
path = Path(sys.argv[2])
text = path.read_text(encoding="utf-8")

patterns = [
    rf"^## \[{re.escape(tag)}\](?:\s+-.*)?$",
    rf"^## {re.escape(tag)}(?:\s+-.*)?$",
    rf"^## \[{re.escape(normalized)}\](?:\s+-.*)?$",
    rf"^## {re.escape(normalized)}(?:\s+-.*)?$",
    r"^## \[Unreleased\]$",
    r"^## Unreleased$",
]

lines = text.splitlines()

for pattern in patterns:
    start = None
    for index, line in enumerate(lines):
        if re.match(pattern, line):
            start = index
            break
    if start is None:
        continue
    end = len(lines)
    for index in range(start + 1, len(lines)):
        if lines[index].startswith("## "):
            end = index
            break
    print("\n".join(lines[start:end]).strip())
    break
PY
)"
  if [ -n "$notes" ]; then
    {
      printf 'Release %s\n\n' "$TAG"
      printf '%s\n' "$notes"
    } >"$OUT_PATH"
    exit 0
  fi
  head -80 "$CHANGELOG_PATH" >"$OUT_PATH"
  exit 0
fi

printf 'Release %s\n' "$TAG" >"$OUT_PATH"
