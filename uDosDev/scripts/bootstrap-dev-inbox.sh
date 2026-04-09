#!/usr/bin/env bash
# Install @dev/inbox/README.md and guidelines/ from tracked docs (inbox is gitignored).

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

WITH_BRIEFS=0
for arg in "$@"; do
  case "$arg" in
    --with-briefs) WITH_BRIEFS=1 ;;
    -h|--help)
      echo "usage: $(basename "$0") [--with-briefs]" >&2
      echo "  Copies docs/dev-inbox/guidelines -> @dev/inbox/guidelines" >&2
      echo "  Copies docs/dev-inbox/local-inbox-README.md -> @dev/inbox/README.md" >&2
      echo "  --with-briefs  also copies 00/01/02 briefs into @dev/inbox/" >&2
      exit 0
      ;;
  esac
done

cd "$REPO_ROOT"

GUID_SRC="$REPO_ROOT/docs/dev-inbox/guidelines"
README_SRC="$REPO_ROOT/docs/dev-inbox/local-inbox-README.md"
INBOX="$REPO_ROOT/@dev/inbox"

if [ ! -d "$GUID_SRC" ]; then
  echo "missing: $GUID_SRC" >&2
  exit 1
fi
if [ ! -f "$README_SRC" ]; then
  echo "missing: $README_SRC" >&2
  exit 1
fi

mkdir -p "$INBOX"
rm -rf "$INBOX/guidelines"
cp -a "$GUID_SRC" "$INBOX/guidelines"
cp -a "$README_SRC" "$INBOX/README.md"

if [ "$WITH_BRIEFS" -eq 1 ]; then
  for f in 00-family-repo-structure-brief.md 01-family-terminology-and-spec-guardrails.md 02-dev-brief-template.md; do
    cp -a "$REPO_ROOT/docs/dev-inbox/$f" "$INBOX/$f"
  done
fi

echo "Installed: $INBOX/README.md and $INBOX/guidelines/"
[ "$WITH_BRIEFS" -eq 1 ] && echo "Copied brief templates 00–02 into $INBOX/"
