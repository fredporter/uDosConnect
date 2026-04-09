#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CORE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
WORKSPACE_ROOT="$(cd "$CORE_ROOT/.." && pwd)"

repo_name="${1:-uDOS-core}"
repo_path="${2:-$CORE_ROOT}"

failures=0

is_public_repo() {
  case "$1" in
    uDOS-core|uDOS-shell|sonic-screwdriver|uDOS-plugin-index|uDOS-wizard|uDOS-gameplay|uDOS-empire|uDOS-dev|uDOS-themes|uDOS-docs|uDOS-alpine|uHOME-client|uHOME-server|uDOS-host)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

require_file() {
  local path="$1"
  if [ ! -f "$path" ]; then
    echo "Missing required file: $path" >&2
    failures=$((failures + 1))
  fi
}

require_readme_section() {
  local heading="$1"
  local ok=1
  if command -v rg >/dev/null 2>&1; then
    rg -q "^## ${heading}\$" "$repo_path/README.md" && ok=0 || ok=1
  else
    grep -qE "^## ${heading}\$" "$repo_path/README.md" && ok=0 || ok=1
  fi
  if [ "$ok" -ne 0 ]; then
    echo "Missing README section in $repo_name: ## $heading" >&2
    failures=$((failures + 1))
  fi
}

# implementation: full repo tree + config/schemas/tests; dependency: code deps only (no config/schemas)
_collect_repo_targets() {
  local mode="$1"
  local candidate
  local dir_candidates
  if [ "$mode" = "implementation" ]; then
    dir_candidates="apps binder compile config contracts core mcp modules plugins runtime schemas scheduling services src tests udos_core vault wizard"
  else
    dir_candidates="apps binder compile core mcp modules plugins runtime scheduling services src udos_core vault wizard"
  fi
  for candidate in $dir_candidates; do
    if [ -d "$repo_path/$candidate" ]; then
      printf '%s\n' "$repo_path/$candidate"
    fi
  done
  for candidate in pyproject.toml package.json Cargo.toml go.mod; do
    if [ -f "$repo_path/$candidate" ]; then
      printf '%s\n' "$repo_path/$candidate"
    fi
  done
}

implementation_targets() {
  _collect_repo_targets implementation
}

dependency_targets() {
  _collect_repo_targets dependency
}

scan_forbidden_pattern() {
  local label="$1"
  local pattern="$2"
  local matches=""
  local d
  local m
  while IFS= read -r d; do
    [ -z "$d" ] && continue
    if command -v rg >/dev/null 2>&1; then
      m="$(rg -n "$pattern" "$d" 2>/dev/null || true)"
    else
      m="$(grep -RIn --binary-files=without-match --exclude-dir=.git -F "$pattern" "$d" 2>/dev/null || true)"
    fi
    [ -n "$m" ] && matches="${matches}${matches:+$'\n'}$m"
  done < <(implementation_targets)
  if [ -n "$matches" ]; then
    echo "Forbidden $label references found in implementation surfaces for $repo_name:" >&2
    printf '%s\n' "$matches" >&2
    failures=$((failures + 1))
  fi
}

scan_dependency_pattern() {
  local label="$1"
  local pattern="$2"
  local matches=""
  local d
  local m
  while IFS= read -r d; do
    [ -z "$d" ] && continue
    if command -v rg >/dev/null 2>&1; then
      m="$(rg -n \
        --glob '*.py' \
        --glob '*.sh' \
        --glob '*.ts' \
        --glob '*.tsx' \
        --glob '*.js' \
        --glob '*.jsx' \
        --glob '*.mjs' \
        --glob '*.cjs' \
        --glob 'pyproject.toml' \
        --glob 'package.json' \
        --glob 'Cargo.toml' \
        --glob 'go.mod' \
        "$pattern" "$d" 2>/dev/null || true)"
    else
      m="$(find "$d" \( \
        -name '*.py' -o -name '*.sh' -o -name '*.ts' -o -name '*.tsx' \
        -o -name '*.js' -o -name '*.jsx' -o -name '*.mjs' -o -name '*.cjs' \
        -o -name 'pyproject.toml' -o -name 'package.json' -o -name 'Cargo.toml' -o -name 'go.mod' \
        \) ! -path '*/.git/*' -print0 2>/dev/null \
        | xargs -0 grep -nHE "$pattern" 2>/dev/null || true)"
    fi
    [ -n "$m" ] && matches="${matches}${matches:+$'\n'}$m"
  done < <(dependency_targets)
  if [ -n "$matches" ]; then
    echo "Forbidden $label references found in dependency surfaces for $repo_name:" >&2
    printf '%s\n' "$matches" >&2
    failures=$((failures + 1))
  fi
}

require_file "$CORE_ROOT/docs/family-boundary.md"
require_file "$CORE_ROOT/docs/repo-requirements.md"
require_file "$CORE_ROOT/docs/dependency-matrix.md"
require_file "$CORE_ROOT/docs/contract-enforcement.md"

if is_public_repo "$repo_name"; then
  require_file "$repo_path/README.md"
  require_file "$repo_path/docs/architecture.md"
  require_file "$repo_path/docs/boundary.md"
  require_file "$repo_path/docs/getting-started.md"
  require_readme_section "Purpose"
  require_readme_section "Ownership"
  require_readme_section "Non-Goals"

  scan_forbidden_pattern \
    "OMD" \
    'omd-mac-osx-app'
fi

if [ "$repo_name" = "uDOS-core" ]; then
  scan_dependency_pattern \
    "consumer-repo-dependency" \
    '(family_root\(\)|WORKSPACE_ROOT|workspace_root|repo_root|repo_path|\.\./)[^\n]{0,160}(uDOS-shell|uDOS-wizard|uHOME-server|uHOME-client|sonic-screwdriver|uDOS-alpine|uDOS-gameplay|uDOS-empire|uDOS-themes|uDOS-docs|uDOS-plugin-index|uDOS-dev|uDOS-host)'
fi

if [ "$failures" -ne 0 ]; then
  echo "Contract enforcement failed for $repo_name with $failures issue(s)." >&2
  exit 1
fi

echo "Contract enforcement checks passed for $repo_name"
