#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPORT_DIR="$REPO_ROOT/@dev/notes/reports"
STAMP="$(date '+%Y-%m-%d-%H%M%S')"
REPORT_PATH="$REPORT_DIR/public-structure-$STAMP.md"

mkdir -p "$REPORT_DIR"

# shellcheck disable=SC1091
. "$REPO_ROOT/automation/family-repos.sh"

roots_for_repo() {
  find "$ROOT_DIR/$1" -maxdepth 1 -mindepth 1 -type d \
    ! -name .git \
    ! -name .venv \
    ! -name .pytest_cache \
    ! -name __pycache__ \
    -exec basename {} \; | sort
}

repo_class() {
  case "$1" in
    uDOS-core|uDOS-plugin-index|uDOS-grid) echo "contract-first" ;;
    uDOS-wizard|uHOME-server|uDOS-host|uDOS-groovebox) echo "service" ;;
    uDOS-dev) echo "operations" ;;
    uDOS-docs) echo "docs" ;;
    uDOS-alpine|sonic-screwdriver|sonic-ventoy) echo "packaging" ;;
    uDOS-themes) echo "presentation" ;;
    uDOS-workspace|uDOS-thinui) echo "ui" ;;
    *) echo "standard" ;;
  esac
}

expected_roots() {
  case "$1" in
    contract-first) printf '%s\n' config contracts docs tests scripts schemas ;;
    service) printf '%s\n' config docs tests scripts services ;;
    operations) printf '%s\n' @dev automation courses docs scripts ;;
    docs) printf '%s\n' docs scripts tests config ;;
    packaging) printf '%s\n' docs scripts ;;
    presentation) printf '%s\n' config docs examples registry scripts src tests ;;
    ui) printf '%s\n' config docs examples scripts tests ;;
    standard) printf '%s\n' config docs examples scripts src tests ;;
  esac
}

special_allowances() {
  case "$1" in
    uDOS-core) printf '%s\n' binder compile plugins runtime vault udos_core ;;
    uDOS-plugin-index) printf '%s\n' schemas ;;
    uDOS-wizard) printf '%s\n' mcp wizard ;;
    uDOS-dev) printf '%s\n' @dev automation courses ;;
    uDOS-docs) printf '%s\n' alpine architecture uhome wizard ;;
    uDOS-alpine) printf '%s\n' apkbuild distribution openrc profiles ;;
    uDOS-grid) printf '%s\n' seed ;;
    uDOS-groovebox) printf '%s\n' containers sessions ;;
    uDOS-themes) printf '%s\n' registry ;;
    uDOS-thinui) printf '%s\n' src ;;
    uDOS-workspace) printf '%s\n' apps packages ;;
    uDOS-host) printf '%s\n' boot build contracts proton sonic-hooks ;;
    sonic-ventoy) printf '%s\n' profiles templates ;;
    sonic-screwdriver) printf '%s\n' apps build config core courses datasets distribution examples installers library memory modules payloads services tests ui vault wiki ;;
    uHOME-server) printf '%s\n' apps courses defaults examples library memory modules scheduling src uhome vault ;;
    *) true ;;
  esac
}

{
  echo "# Public Structure Sweep"
  echo
  echo "- generated: $STAMP"
  echo "- root: $ROOT_DIR"
  echo "- binder: #binder/dev-public-structure-normalization"
  echo

  for repo in "${public_repos[@]}"; do
    class="$(repo_class "$repo")"
    actual="$(roots_for_repo "$repo")"
    expected="$(expected_roots "$class")"
    allowed="$(special_allowances "$repo")"

    echo "## $repo"
    echo
    echo "- class: $class"
    echo "- expected roots: $(printf '%s' "$expected" | tr '\n' ' ' | sed 's/ $//')"
    echo "- actual roots: $(printf '%s' "$actual" | tr '\n' ' ' | sed 's/ $//')"

    missing="$(comm -23 <(printf '%s\n' "$expected" | sort) <(printf '%s\n' "$actual" | sort) || true)"
    extra="$(comm -13 <(printf '%s\n' "$expected"$'\n'"$allowed"$'\n''.github' | sed '/^$/d' | sort -u) <(printf '%s\n' "$actual" | sort) || true)"

    if [ -n "$missing" ]; then
      echo "- missing recommended roots: $(printf '%s' "$missing" | tr '\n' ' ' | sed 's/ $//')"
    else
      echo "- missing recommended roots: none"
    fi

    if [ -n "$extra" ]; then
      echo "- extra transitional roots: $(printf '%s' "$extra" | tr '\n' ' ' | sed 's/ $//')"
    else
      echo "- extra transitional roots: none"
    fi

    if [ -n "$extra" ] || [ -n "$missing" ]; then
      echo "- status: transitional"
    else
      echo "- status: aligned"
    fi
    echo
  done
} >"$REPORT_PATH"

echo "Wrote $REPORT_PATH"
