#!/usr/bin/env bash
# First-time Linux litmus: install common packages, clone cursor-01 runtime-spine
# sibling repos next to this uDOS-host checkout, install minimal Python tooling,
# run the full round proof.
#
# Self-upgrade / self-heal (default on):
#   - Fast-forwards this uDOS-host repo from origin, then re-invokes this script
#     once so the latest installer logic runs (disable: UDOS_SKIP_SELF_UPGRADE=1).
#   - Pulls siblings when already cloned (disable: UDOS_SKIP_SIBLING_UPGRADE=1).
#   - Removes broken sibling dirs (no .git or corrupt git) and re-clones.
#   - Refreshes pip bootstrap packages with -U (disable: UDOS_SKIP_PIP_UPGRADE=1).
#   - Optional: UDOS_APT_UPGRADE=1 runs apt-get upgrade -y after install.
#   - If ff-only pull fails: set UDOS_BOOTSTRAP_RESET_HARD=1 to reset --hard to origin/BRANCH.
#
# Prerequisites: git, network. Run from a clone of uDOS-host (any branch).
#
# Environment (optional):
#   UDOS_FAMILY_ROOT      parent directory for sibling clones (default: parent of uDOS-host)
#   UDOS_FAMILY_GIT_BASE  e.g. https://github.com/your-org  (default: derived from this repo's origin)
#   UDOS_FAMILY_BRANCH    branch for shallow clones / pulls (default: main)
#   UDOS_SKIP_APT=1       do not attempt apt-get install
#   UDOS_SKIP_ROUND_PROOF=1  clone/deps only; do not run runtime-spine-round-proof.sh
#   UDOS_SKIP_SELF_UPGRADE=1   do not git pull / re-exec this repo
#   UDOS_SKIP_SIBLING_UPGRADE=1  do not git pull sibling repos (still heal + clone if missing)
#   UDOS_SKIP_PIP_UPGRADE=1      only pip install if pytest missing (no -U)
#   UDOS_APT_UPGRADE=1    after apt install, run apt-get upgrade -y
#   UDOS_BOOTSTRAP_RESET_HARD=1  use git reset --hard origin/BRANCH when ff-only fails
#   UDOS_BOOTSTRAP_NO_REEXEC=1   internal guard; prevents infinite re-exec
#   UDOS_BOOTSTRAP_INSTALL_LAN_SERVICE=1  after bootstrap, install systemd --user unit
#     for LAN-visible command-centre (see docs/lan-command-centre-persistent.md)
#
# Usage:
#   git clone --depth 1 https://github.com/<ORG>/uDOS-host.git && cd uDOS-host
#   bash scripts/linux-family-bootstrap.sh

set -eu

UBUNTU_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BOOTSTRAP_SCRIPT="$UBUNTU_ROOT/scripts/linux-family-bootstrap.sh"
FAMILY_ROOT="${UDOS_FAMILY_ROOT:-$(cd "$UBUNTU_ROOT/.." && pwd)}"
BRANCH="${UDOS_FAMILY_BRANCH:-main}"

SIBLINGS=(uDOS-core uDOS-grid uDOS-wizard uDOS-dev uDOS-docs)

info() { printf '%s\n' "$*"; }
warn() { printf 'WARN: %s\n' "$*" >&2; }

install_lan_user_service_if_requested() {
  if [ "${UDOS_BOOTSTRAP_INSTALL_LAN_SERVICE:-0}" != "1" ]; then
    return 0
  fi
  if ! command -v systemctl >/dev/null 2>&1; then
    warn "systemctl not found; install LAN service manually: scripts/install-command-centre-demo-lan-user-service.sh"
    return 0
  fi
  info "UDOS_BOOTSTRAP_INSTALL_LAN_SERVICE=1: installing systemd user unit (LAN command-centre)..."
  if bash "$UBUNTU_ROOT/scripts/install-command-centre-demo-lan-user-service.sh" --now; then
    info "LAN service: systemctl --user status udos-command-centre-demo-lan.service"
  else
    warn "LAN user service install failed; see docs/lan-command-centre-persistent.md"
  fi
}

derive_git_base() {
  local raw base
  raw=$(git -C "$UBUNTU_ROOT" remote get-url origin 2>/dev/null) || true
  if [ -z "$raw" ]; then
    return 1
  fi
  if printf '%s' "$raw" | grep -q '^git@'; then
    base=$(printf '%s' "$raw" | sed -E 's|^git@([^:]+):(.+)/uDOS-host(\.git)?$|https://\1/\2|')
  else
    base=$(printf '%s' "$raw" | sed -E 's|/uDOS-host(\.git)?$||')
  fi
  if [ -z "$base" ] || [ "$base" = "$raw" ]; then
    return 1
  fi
  printf '%s' "$base"
}

maybe_apt_install() {
  if [ "${UDOS_SKIP_APT:-0}" = "1" ]; then
    info "Skipping apt (UDOS_SKIP_APT=1)."
    return 0
  fi
  if ! command -v apt-get >/dev/null 2>&1; then
    warn "apt-get not found; ensure git, python3 (3.11+ for Wizard), curl, ca-certificates, nodejs/npm are installed."
    return 0
  fi
  local pkgs="git curl ca-certificates python3 python3-venv python3-pip nodejs npm"
  if apt-cache show python3.11 >/dev/null 2>&1; then
    pkgs="$pkgs python3.11 python3.11-venv"
  fi
  info "Installing packages via apt-get: $pkgs"
  if [ "$(id -u)" -eq 0 ]; then
    DEBIAN_FRONTEND=noninteractive apt-get update -qq
    DEBIAN_FRONTEND=noninteractive apt-get install -y $pkgs
  elif command -v sudo >/dev/null 2>&1; then
    sudo DEBIAN_FRONTEND=noninteractive apt-get update -qq
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y $pkgs
  else
    warn "No sudo; install manually: $pkgs"
  fi
  if [ "${UDOS_APT_UPGRADE:-0}" = "1" ]; then
    info "UDOS_APT_UPGRADE=1: apt-get upgrade -y"
    if [ "$(id -u)" -eq 0 ]; then
      DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
    else
      sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
    fi
  fi
}

ensure_pytest_extras() {
  if [ "${UDOS_SKIP_PIP_UPGRADE:-0}" = "1" ]; then
    if python3 -c 'import pytest' >/dev/null 2>&1; then
      return 0
    fi
    info "Installing pytest / jsonschema / referencing for Core checks (user site)..."
    python3 -m pip install --user -q pytest jsonschema referencing || pip3 install --user -q pytest jsonschema referencing
    return 0
  fi
  info "Refreshing pip bootstrap tools (pytest, jsonschema, referencing) with -U..."
  python3 -m pip install --user -q -U pytest jsonschema referencing || pip3 install --user -q -U pytest jsonschema referencing
}

git_repo_corrupt() {
  local dest="$1"
  [ -d "$dest/.git" ] || return 1
  git -C "$dest" rev-parse -q --verify HEAD >/dev/null 2>&1 && return 1
  return 0
}

self_upgrade_ubuntu_repo() {
  if [ "${UDOS_SKIP_SELF_UPGRADE:-0}" = "1" ]; then
    info "Skipping self-upgrade (UDOS_SKIP_SELF_UPGRADE=1)."
    return 0
  fi
  if [ ! -d "$UBUNTU_ROOT/.git" ]; then
    warn "uDOS-host has no .git; skipping self-upgrade (copy or archive install)."
    return 0
  fi
  local before after
  before=$(git -C "$UBUNTU_ROOT" rev-parse HEAD 2>/dev/null) || return 0
  info "Self-upgrade: fetching origin for uDOS-host (branch $BRANCH)..."
  if ! git -C "$UBUNTU_ROOT" fetch origin "$BRANCH" 2>/dev/null; then
    git -C "$UBUNTU_ROOT" fetch origin || {
      warn "git fetch failed for uDOS-host; continuing with current tree."
      return 0
    }
  fi
  if ! git -C "$UBUNTU_ROOT" show-ref -q --verify "refs/remotes/origin/$BRANCH" 2>/dev/null; then
    warn "No origin/$BRANCH; skipping ubuntu upgrade (set UDOS_FAMILY_BRANCH?)."
    return 0
  fi
  if git -C "$UBUNTU_ROOT" show-ref -q --verify "refs/heads/$BRANCH" 2>/dev/null; then
    git -C "$UBUNTU_ROOT" checkout -q "$BRANCH" 2>/dev/null || true
  fi
  if git -C "$UBUNTU_ROOT" merge --ff-only -q "origin/$BRANCH" 2>/dev/null; then
    :
  elif [ "${UDOS_BOOTSTRAP_RESET_HARD:-0}" = "1" ]; then
    warn "UDOS_BOOTSTRAP_RESET_HARD=1: resetting uDOS-host to origin/$BRANCH"
    git -C "$UBUNTU_ROOT" reset --hard -q "origin/$BRANCH"
  else
    warn "Fast-forward blocked for uDOS-host (local commits or diverged). Set UDOS_BOOTSTRAP_RESET_HARD=1 to match origin/$BRANCH, or fix manually."
    return 0
  fi
  after=$(git -C "$UBUNTU_ROOT" rev-parse HEAD)
  if [ "$before" != "$after" ] && [ "${UDOS_BOOTSTRAP_NO_REEXEC:-0}" != "1" ]; then
    info "uDOS-host updated; re-invoking installer with latest script..."
    export UDOS_BOOTSTRAP_NO_REEXEC=1
    exec bash "$BOOTSTRAP_SCRIPT"
  fi
}

pull_sibling() {
  local dest="$1"
  local name="$2"
  if [ "${UDOS_SKIP_SIBLING_UPGRADE:-0}" = "1" ]; then
    return 0
  fi
  info "Updating $name: git fetch / fast-forward..."
  if ! git -C "$dest" fetch origin "$BRANCH" 2>/dev/null; then
    git -C "$dest" fetch origin || {
      warn "fetch failed for $name"
      return 0
    }
  fi
  if ! git -C "$dest" show-ref -q --verify "refs/remotes/origin/$BRANCH" 2>/dev/null; then
    warn "No origin/$BRANCH for $name; skip pull."
    return 0
  fi
  if git -C "$dest" show-ref -q --verify "refs/heads/$BRANCH" 2>/dev/null; then
    git -C "$dest" checkout -q "$BRANCH" 2>/dev/null || true
  fi
  if git -C "$dest" merge --ff-only -q "origin/$BRANCH" 2>/dev/null; then
    return 0
  fi
  if [ "${UDOS_BOOTSTRAP_RESET_HARD:-0}" = "1" ]; then
    warn "UDOS_BOOTSTRAP_RESET_HARD=1: resetting $name to origin/$BRANCH"
    git -C "$dest" reset --hard -q "origin/$BRANCH"
    return 0
  fi
  warn "Could not fast-forward $name; set UDOS_BOOTSTRAP_RESET_HARD=1 or fix manually."
}

clone_or_heal_and_sync() {
  local name dest url
  name=$1
  dest="$FAMILY_ROOT/$name"
  url="$GIT_BASE/$name.git"

  if [ -d "$dest" ] && ! [ -d "$dest/.git" ]; then
    warn "Removing non-git directory (self-heal): $dest"
    rm -rf "$dest"
  fi
  if git_repo_corrupt "$dest"; then
    warn "Removing corrupt git checkout (self-heal): $dest"
    rm -rf "$dest"
  fi

  if [ -d "$dest/.git" ]; then
    pull_sibling "$dest" "$name"
    return 0
  fi

  info "Cloning $url -> $dest"
  local attempt=1
  while [ "$attempt" -le 3 ]; do
    if git clone --depth 1 --branch "$BRANCH" "$url" "$dest" 2>/dev/null; then
      return 0
    fi
    if git clone --depth 1 "$url" "$dest" 2>/dev/null; then
      return 0
    fi
    warn "Clone attempt $attempt failed for $name; retrying after short wait..."
    sleep 2
    attempt=$((attempt + 1))
    rm -rf "$dest"
  done
  warn "Shallow clone on branch $BRANCH failed; final try without depth..."
  git clone "$url" "$dest"
}

GIT_BASE="${UDOS_FAMILY_GIT_BASE:-}"
if [ -z "$GIT_BASE" ]; then
  GIT_BASE=$(derive_git_base) || true
fi
if [ -z "$GIT_BASE" ]; then
  warn "Could not derive git base from 'git remote get-url origin'."
  info "Set UDOS_FAMILY_GIT_BASE, e.g.:"
  info "  export UDOS_FAMILY_GIT_BASE=https://github.com/<your-org>"
  exit 1
fi

info "uDOS-host root:  $UBUNTU_ROOT"
info "Family root:       $FAMILY_ROOT"
info "Family git base:   $GIT_BASE"
info "Clone branch:      $BRANCH"
info ""

self_upgrade_ubuntu_repo

maybe_apt_install

mkdir -p "$FAMILY_ROOT"

for r in "${SIBLINGS[@]}"; do
  clone_or_heal_and_sync "$r"
done

ensure_pytest_extras

if [ "${UDOS_SKIP_ROUND_PROOF:-0}" = "1" ]; then
  info "UDOS_SKIP_ROUND_PROOF=1 — skipping runtime-spine-round-proof.sh"
  info "Next: bash $UBUNTU_ROOT/scripts/runtime-spine-round-proof.sh"
  install_lan_user_service_if_requested
  exit 0
fi

info ""
info "Running runtime spine round proof (automated steps [1/3][2/3] only)..."
bash "$UBUNTU_ROOT/scripts/runtime-spine-round-proof.sh"

install_lan_user_service_if_requested

info ""
info "Bootstrap complete."
info "MANDATORY Step [3/3] — final GUI render (round not closed without this):"
info "  bash $UBUNTU_ROOT/scripts/serve-command-centre-demo.sh"
info "  or LAN: bash $UBUNTU_ROOT/scripts/serve-command-centre-demo-lan.sh"
info "  Open the URL in a real browser; record sign-off in uDOS-dev @dev/notes/rounds/ or devlog."
info "Doc: uDOS-dev/docs/round-closure-three-steps.md"
info "LAN persistence: docs/lan-command-centre-persistent.md"
# shellcheck source=scripts/lib/udos-web-listen.sh
. "$UBUNTU_ROOT/scripts/lib/udos-web-listen.sh"
udos_web_resolve_listen
info "Loopback URL: $(udos_web_base_url)"
info "Re-run this script anytime to pull latest uDOS-host + siblings and refresh tools."
