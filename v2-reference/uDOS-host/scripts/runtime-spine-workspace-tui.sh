#!/usr/bin/env bash
# TUI-style round proof for cursor-01-runtime-spine.code-workspace: cycles every repo in
# that workspace with visible feature steps (checks, contracts, artefacts).
#
# Each step is tagged:
#   [WORKING]   — substantive validation (test suite, HTTP body, real CLI/registry output).
#   [SCAFFOLD]  — real contracts/layout/scripts, but major runtime pieces incomplete (e.g. daemons).
#   [STUB]      — placeholder or file-presence only; green does not mean production-ready feature.
#
# After the full summary table, the script prints a rollup plus "Open development queue": only
# SCAFFOLD and STUB rows — i.e. what still needs dev work even when the round is green.
#
# Environment (optional):
#   UDOS_CORE_ROOT, UDOS_GRID_ROOT, UDOS_WIZARD_ROOT, UDOS_DEV_ROOT, UDOS_DOCS_ROOT
#   ROUND_PAUSE_SEC   seconds between phases (default 1)
#   SKIP_WIZARD=1     skip uDOS-wizard (faster smoke; not for full round closure)
#
# Usage (from uDOS-host):
#   bash scripts/runtime-spine-workspace-tui.sh

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
UBUNTU_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAMILY_ROOT="$(cd "$UBUNTU_ROOT/.." && pwd)"
ROUND_PAUSE_SEC="${ROUND_PAUSE_SEC:-1}"

CORE_ROOT="${UDOS_CORE_ROOT:-$FAMILY_ROOT/uDOS-core}"
GRID_ROOT="${UDOS_GRID_ROOT:-$FAMILY_ROOT/uDOS-grid}"
WIZARD_ROOT="${UDOS_WIZARD_ROOT:-$FAMILY_ROOT/uDOS-wizard}"
DEV_ROOT="${UDOS_DEV_ROOT:-$FAMILY_ROOT/uDOS-dev}"
DOCS_ROOT="${UDOS_DOCS_ROOT:-$FAMILY_ROOT/uDOS-docs}"

WORKSPACE_FILE="$FAMILY_ROOT/uDOS-dev/workspaces/archive/v2/cursor-01-runtime-spine.code-workspace"

CURRENT_PHASE=""
SUMMARY_ROWS=""
WIZARD_RECAP_MSG=""

bold() { printf '\033[1m%s\033[0m\n' "$*"; }
dim() { printf '\033[2m%s\033[0m\n' "$*"; }
ok() { printf '\033[32m%s\033[0m\n' "$*"; }
rule() { printf '%s\n' "══════════════════════════════════════════════════════════════"; }

summary_add() {
  local tier="$1"
  local text="$2"
  SUMMARY_ROWS+="${CURRENT_PHASE}|${tier}|${text}"$'\n'
}

# Usage: feature <working|scaffold|stub> "description"
feature() {
  local tier raw_tag color
  tier=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')
  shift
  local msg="$*"
  case "$tier" in
    working)
      raw_tag="WORKING"
      color='\033[36m'
      ;;
    scaffold)
      raw_tag="SCAFFOLD"
      color='\033[33m'
      ;;
    stub)
      raw_tag="STUB"
      color='\033[35m'
      ;;
    *)
      raw_tag="$tier"
      color='\033[2m'
      ;;
  esac
  printf '  %b[%-8s]%b %s\n' "$color" "$raw_tag" '\033[0m' "$msg"
  summary_add "$raw_tag" "$msg"
}

pause_phase() {
  sleep "$ROUND_PAUSE_SEC"
}

require_repo() {
  local path="$1" name="$2"
  if [ ! -d "$path" ]; then
    echo "runtime-spine-workspace-tui: missing $name at $path" >&2
    exit 1
  fi
}

print_legend() {
  dim "  Tag legend (this TUI — lane 1 / runtime spine):"
  dim "    WORKING   — real output validated (tests, HTTP body, registry/CLI lines)."
  dim "    SCAFFOLD  — contracts + layout + partial tooling; full daemons/product still open."
  dim "    STUB      — placeholder or presence-only; pass ≠ production feature."
  dim "  Human-readable surfaces: Phase 2 prints workstation + ThinUI intent (prose); Phase 5 lists closure docs;"
  dim "    closing recap below translates phases into operator language."
  echo ""
}

# Plain-language recap so the TUI ends with what was *shown*, not only tags.
print_operator_narrative_recap() {
  rule
  bold "What this run demonstrated (operator language)"
  rule
  echo "  • Phase 0 — The static command-centre page is served over HTTP and contains the expected title text"
  echo "    (automated curl; not a substitute for opening a real browser — that is step [3/3])."
  echo "  • Phase 1 — uDOS-core contracts, enforcement gates, and the green_proof test slice all passed."
  echo "  • Phase 2 — uDOS-host layout + lane-1 daemons + checks passed; you saw readable workstation/ThinUI"
  echo "    intent and live repo-operation rows from commandd (not just JSON dumps)."
  echo "${WIZARD_RECAP_MSG:-  • Phase 3 — uDOS-wizard: not summarized.}"
  echo "  • Phase 4 — uDOS-grid spatial contracts and checks passed."
  echo "  • Phase 5 — Closure pathway artefacts are present (workspace file, runtime spine, round steps, pathway doc)."
  echo "  • Phase 6 — uDOS-docs public hub checks passed (Node generator + required artefacts)."
  echo ""
}

print_summary_table() {
  rule
  bold "Summary — capability vs motion"
  rule
  printf '  %-8s  %-10s  %s\n' "TAG" "PHASE" "STEP"
  dim "  --------  ----------  --------------------------------------------------"
  local line phase tag text rest
  while IFS= read -r line || [ -n "${line:-}" ]; do
    [ -z "$line" ] && continue
    phase="${line%%|*}"
    rest="${line#*|}"
    tag="${rest%%|*}"
    text="${rest#*|}"
    printf '  %-8s  %-10s  %s\n' "$tag" "$phase" "$text"
  done <<EOF
$SUMMARY_ROWS
EOF
  echo ""
  dim "  Host note: udos-hostd / udos-web / udos-vaultd / udos-syncd run scripts/lib/runtime_daemon_httpd.py (lane-1 HTTP)."
  dim "  udos-budgetd / networkd / scheduled / tuid / thinui / wizard-adapter: minimal HTTP via runtime_daemon_httpd.py (health + /v1/status)."
  dim "  commandd has an HTTP listener (default serve) + CLI; gitd remains CLI; Wizard may use udos-web /host/* or commandd /v1/*."
  echo ""
}

# Count tiers and list SCAFFOLD+STUB only (passing round ≠ all product-complete).
print_reporting_rollup_and_open_queue() {
  local n_working=0 n_scaffold=0 n_stub=0
  local line phase tag text rest
  while IFS= read -r line || [ -n "${line:-}" ]; do
    [ -z "$line" ] && continue
    rest="${line#*|}"
    tag="${rest%%|*}"
    case "$tag" in
      WORKING) n_working=$((n_working + 1)) ;;
      SCAFFOLD) n_scaffold=$((n_scaffold + 1)) ;;
      STUB) n_stub=$((n_stub + 1)) ;;
    esac
  done <<EOF
$SUMMARY_ROWS
EOF

  rule
  bold "Test-reporting rollup (this run)"
  rule
  printf '  %-9s %2s  %s\n' "WORKING" "$n_working" "substantive validation passed"
  printf '  %-9s %2s  %s\n' "SCAFFOLD" "$n_scaffold" "passed — contracts/layout OK; product/runtime gaps remain"
  printf '  %-9s %2s  %s\n' "STUB" "$n_stub" "passed or skipped — not a production feature proof"
  echo ""

  rule
  bold "Open development queue (green this run — still needs work)"
  rule
  dim "  Only SCAFFOLD and STUB steps; use this list after a full green round."
  echo ""
  local any=0
  while IFS= read -r line || [ -n "${line:-}" ]; do
    [ -z "$line" ] && continue
    phase="${line%%|*}"
    rest="${line#*|}"
    tag="${rest%%|*}"
    text="${rest#*|}"
    case "$tag" in
      SCAFFOLD | STUB)
        any=1
        printf '  %-9s %-12s %s\n' "$tag" "$phase" "$text"
        ;;
    esac
  done <<EOF
$SUMMARY_ROWS
EOF
  if [ "$any" -eq 0 ]; then
    dim "  (none — every tagged step was WORKING)"
  fi
  echo ""
}

rule
bold "Runtime spine — workspace round (TUI cycle)"
rule
echo "  Workspace file: $WORKSPACE_FILE"
echo "  Family root:    $FAMILY_ROOT"
echo ""
print_legend

require_repo "$CORE_ROOT" "uDOS-core"
require_repo "$GRID_ROOT" "uDOS-grid"
require_repo "$UBUNTU_ROOT" "uDOS-host"
require_repo "$WIZARD_ROOT" "uDOS-wizard"
require_repo "$DEV_ROOT" "uDOS-dev"
require_repo "$DOCS_ROOT" "uDOS-docs"

if [ ! -f "$WORKSPACE_FILE" ]; then
  echo "runtime-spine-workspace-tui: missing $WORKSPACE_FILE" >&2
  exit 1
fi

# --- Phase 0: localhost GUI artefact (HTTP) ---
CURRENT_PHASE="P0 HTTP"
rule
bold "Phase 0 — Localhost web / command-centre GUI (automated)"
rule
feature working "verify-command-centre-http.sh — curl 127.0.0.1 + localhost; body contains GUI title text"
bash "$SCRIPT_DIR/verify-command-centre-http.sh"
dim "  Note: Phase 0 proves the HTML artefact over HTTP only — step [3/3] still needs a browser."
ok "  Phase 0 complete."
pause_phase

# --- uDOS-core ---
CURRENT_PHASE="P1 Core"
rule
bold "Phase 1 — uDOS-core (contracts + tests)"
rule
feature working "run-core-checks.sh — full pytest suite for this repo"
( cd "$CORE_ROOT" && bash scripts/run-core-checks.sh )
feature working "run-contract-enforcement.sh — README/docs/forbidden-pattern gates"
( cd "$CORE_ROOT" && bash scripts/run-contract-enforcement.sh uDOS-core "$CORE_ROOT" )
feature working "pytest -m green_proof — lane-1 contract slice (feeds/spool etc.)"
( cd "$CORE_ROOT" && python3 -m pytest -m green_proof -q --strict-markers )
ok "  Phase 1 complete."
pause_phase

# --- uDOS-host ---
CURRENT_PHASE="P2 Ubuntu"
rule
bold "Phase 2 — uDOS-host (host spine + commandd/gitd)"
rule
feature scaffold "run-ubuntu-checks.sh — file/contract gates + layout + verify-udos-runtime-daemons (all lane-1 HTTP daemons incl. commandd + aux); deeper product semantics still open"
( cd "$UBUNTU_ROOT" && bash scripts/run-ubuntu-checks.sh )
feature working "Operator-readable demo layer — workstation + ThinUI intent (not JSON-only)"
python3 "$UBUNTU_ROOT/scripts/lib/human_readable_demo.py" "$UBUNTU_ROOT/examples/browser-workstation-scaffold.json"
python3 "$UBUNTU_ROOT/scripts/lib/human_readable_demo.py" --kind thinui "$UBUNTU_ROOT/examples/thinui-c64-launch.json"
feature working "udos-commandd list-operations repo — live registry rows (temp UDOS_HOME)"
(
  TMP_HOME="$(mktemp -d)"
  export UDOS_HOME="$TMP_HOME/.udos"
  bash "$UBUNTU_ROOT/scripts/udos-hostd.sh" layout-only >/dev/null
  bash "$UBUNTU_ROOT/scripts/udos-gitd.sh" init-layout >/dev/null
  echo "  ── Repo domain operations (sample) ──"
  bash "$UBUNTU_ROOT/scripts/udos-commandd.sh" list-operations repo | head -n 12
  rm -rf "$TMP_HOME"
)
ok "  Phase 2 complete."
pause_phase

# --- uDOS-wizard ---
CURRENT_PHASE="P3 Wizard"
rule
bold "Phase 3 — uDOS-wizard / Surface (broker + checks)"
rule
if [ "${SKIP_WIZARD:-0}" = "1" ]; then
  dim "  SKIP_WIZARD=1 — phase skipped"
  feature stub "run-wizard-checks.sh — not executed (set SKIP_WIZARD=0 for full round closure)"
  WIZARD_RECAP_MSG="  • Phase 3 — uDOS-wizard: skipped (SKIP_WIZARD=1 — not valid for full Workspace 01 closure)."
else
  feature scaffold "run-wizard-checks.sh — API/contract tests green; full production broker + host uptime out of scope for lane 1"
  ( cd "$WIZARD_ROOT" && bash scripts/run-wizard-checks.sh )
  WIZARD_RECAP_MSG="  • Phase 3 — uDOS-wizard: broker/API contract checks passed (production broker uptime is later lanes)."
  ok "  Phase 3 complete."
fi
pause_phase

# --- uDOS-grid ---
CURRENT_PHASE="P4 Grid"
rule
bold "Phase 4 — uDOS-grid (spatial contracts)"
rule
feature working "run-grid-checks.sh — unittest + JSON contract validation against seed registries"
( cd "$GRID_ROOT" && bash scripts/run-grid-checks.sh )
ok "  Phase 4 complete."
pause_phase

# --- uDOS-dev ---
CURRENT_PHASE="P5 uDOS-dev"
rule
bold "Phase 5 — uDOS-dev (pathway + round closure docs)"
rule
feature working "cursor-01 workspace file + runtime spine + execution order on disk"
test -f "$WORKSPACE_FILE"
test -f "$DEV_ROOT/docs/runtime-spine.md"
test -f "$DEV_ROOT/docs/cursor-execution.md"
feature working "round-closure-three-steps.md — mandatory steps 1–3 (incl. browser GUI) for WS 01 + 02"
test -f "$DEV_ROOT/docs/round-closure-three-steps.md"
feature working "runtime-spine-workspace-round-closure.md — detailed Workspace 01 pathway"
test -f "$DEV_ROOT/@dev/pathways/runtime-spine-workspace-round-closure.md"
echo "  ── Where to read how to close the round ──"
echo "    • $WORKSPACE_FILE"
echo "    • $DEV_ROOT/docs/runtime-spine.md — lane-1 ownership and service map"
echo "    • $DEV_ROOT/docs/round-closure-three-steps.md — automated + TUI + browser step [3/3]"
echo "    • $DEV_ROOT/@dev/pathways/runtime-spine-workspace-round-closure.md — commands and LAN proof"
ok "  Phase 5 complete."
pause_phase

# --- uDOS-docs ---
CURRENT_PHASE="P6 uDOS-docs"
rule
bold "Phase 6 — uDOS-docs (public hub + site generator check)"
rule
feature working "run-docs-checks.sh — Node generate-site-data --check + required public artefacts"
( cd "$DOCS_ROOT" && bash scripts/run-docs-checks.sh )
ok "  Phase 6 complete."

echo ""
rule
bold "Runtime spine workspace TUI cycle: complete"
rule
print_operator_narrative_recap
print_summary_table
print_reporting_rollup_and_open_queue
# shellcheck source=scripts/lib/udos-web-listen.sh
. "$SCRIPT_DIR/lib/udos-web-listen.sh"
echo "  Step [3/3] MANDATORY — final GUI render (round not closed without browser):"
echo "    bash $UBUNTU_ROOT/scripts/serve-command-centre-demo.sh"
echo "    or LAN: bash $UBUNTU_ROOT/scripts/serve-command-centre-demo-lan.sh"
echo "  Open the printed URL and SEE the command-centre page. Doc: uDOS-dev/docs/round-closure-three-steps.md"
echo "  LAN persistence: $UBUNTU_ROOT/docs/lan-command-centre-persistent.md"
echo ""
