#!/usr/bin/env bash
# Ensures Docker Compose compatibility is documented (Post-08 O3). Does not run Docker.
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DOC="$REPO_ROOT/docs/docker-compose-compatibility.md"
COMPOSE="$REPO_ROOT/@dev/udos-ubuntu-v2/publish/wordpress/docker/docker-compose.yml"

if [ ! -f "$DOC" ]; then
  echo "missing $DOC" >&2
  exit 1
fi
if ! grep -q "ubuntu-wordpress-publish-stack" "$DOC"; then
  echo "docker-compose-compatibility.md must reference lifecycle registry id" >&2
  exit 1
fi
if ! grep -q "transitional compatibility" "$DOC"; then
  echo "docker-compose-compatibility.md must state transitional posture" >&2
  exit 1
fi
if [ ! -f "$COMPOSE" ]; then
  echo "missing wordpress compose file: $COMPOSE" >&2
  exit 1
fi
if ! head -n 5 "$COMPOSE" | grep -q "transitional-compatibility"; then
  echo "wordpress docker-compose.yml must carry transitional-compatibility header comment" >&2
  exit 1
fi

echo "ubuntu docker-compose compatibility doc verify passed"
