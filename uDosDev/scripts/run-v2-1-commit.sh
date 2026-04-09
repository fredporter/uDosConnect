#!/usr/bin/env bash
# run-v2-1-commit.sh
# Commits all v2.1 staged changes across the family with outcome-driven messages.
# Does NOT push. Run git push per repo after review.
#
# Usage: bash scripts/run-v2-1-commit.sh
# Safe to run multiple times — repos with nothing to commit are skipped.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEV_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BASE="$(cd "$DEV_ROOT/.." && pwd)"
PASS=0
SKIP=0
FAIL=0

commit_repo() {
  local repo="$1"
  local msg="$2"
  local path="$BASE/$repo"

  if [ ! -d "$path/.git" ]; then
    echo "SKIP  $repo — no .git"
    SKIP=$((SKIP + 1))
    return
  fi

  local dirty
  dirty=$(git -C "$path" status --porcelain 2>/dev/null)
  if [ -z "$dirty" ]; then
    echo "SKIP  $repo — nothing to commit"
    SKIP=$((SKIP + 1))
    return
  fi

  echo "COMMIT $repo"
  git -C "$path" add -A
  git -C "$path" commit -m "$msg" || {
    echo "FAIL  $repo — commit failed"
    FAIL=$((FAIL + 1))
    return
  }
  PASS=$((PASS + 1))
}

echo "=== v2.1 family commit pass ==="
echo ""

# --- Core runtime contracts ---

commit_repo "uDOS-core" "v2.1: vault survival contract, API/MCP quickstart, and contract README published

- vault-survival-contract.json and vault-survival.md defining crash-survival, .compost recovery, and sandbox protocols
- docs/v2.0.8-vault-survival.md and docs/v2.1-api-mcp-quickstart.md published
- test_vault_survival_contract.py passing
- QUICKSTART.md and contracts/README.md updated"

commit_repo "uDOS-shell" "v2.1: Shell quickstart and Core MCP consumption doc published

- QUICKSTART.md covering TUI launch, plugin load, MCP presence, and Grid context
- docs/v2.1-core-mcp-consumption.md defining how Shell consumes Core MCP surface
- README.md updated to reference quickstart and v2.1 docs"

commit_repo "uDOS-grid" "v2.1: Grid spatial contracts and seed data stable

- spatial identity, PlaceRef vocabulary, and seed registry aligned to v2.1 family baseline
- no functional changes this round — clean branch"

# --- ThinUI runtime wiring ---

commit_repo "uDOS-thinui" "v2.1: ThinUI runtime loop, adapter bridge, and boot contracts delivered

- src/index.ts: renderThinUiState runtime bridge entry point
- src/bridge/: state hydrator and view resolver modules
- src/contracts/event.ts and contracts/ directory published
- docs/runtime-loop-scaffold.md, spec.md, thinui-boot-launch-sequence.md updated
- Alpine/Sonic launcher contracts documented"

# --- Themes ---

commit_repo "uDOS-themes" "v2.1: ThinUI theme adapters, @dev staging, and examples added

- src/adapters/: thinui-c64 and minimal-safe theme adapters
- resolveThinUiTheme hook published
- @dev/ staging workspace and v2-2-2 examples added
- docs/v2.0.1 and v2.0.2 historical docs archived (cleanup)
- src/README.md updated"

# --- OS distribution layer ---

commit_repo "uDOS-host" "v2.1: uDOS-host repo activated with full governance scaffold

- full repo scaffold: boot/, build/, config/, docs/, src/, scripts/, tests/
- .github/, .gitignore, CHANGELOG.md, README.md established
- browser-workstation decision integrated into architecture layer
- governance alignment and v2.0.6 family activation complete"

commit_repo "sonic-ventoy" "v2.1: sonic-ventoy repo activated with full governance scaffold

- full repo scaffold: config/, docs/, examples/, profiles/, scripts/, src/, templates/, tests/
- .github/, .gitignore, CHANGELOG.md, README.md established
- Ventoy boot-platform profile wiring and Sonic integration contracted
- governance alignment and v2.0.6 family activation complete"

# --- Launcher integration ---

commit_repo "uDOS-alpine" "v2.1: Alpine Thin GUI launcher integration doc and activation updates

- docs/thin-gui-launcher-integration.md: launch sequence for ThinUI on Alpine
- docs/activation.md and docs/getting-started.md updated to reference ThinUI lane"

commit_repo "sonic-screwdriver" "v2.1: Sonic Thin GUI launcher integration doc and activation updates

- docs/thin-gui-launcher-integration.md: Sonic init/add/update/theme flow for ThinUI
- docs/activation.md and docs/getting-started.md updated to reference ThinUI lane"

# --- uHOME services ---

commit_repo "uHOME-server" "v2.1: uHOME console launch path documented

- docs/operations/UHOME-CONSOLE-LAUNCH-PATH.md: step-by-step console activation
- docs/operations/README.md updated with console launch path reference"

commit_repo "uHOME-client" "v2.1: uhome-client check script aligned to v2.1 family baseline"

commit_repo "uDOS-empire" "v2.1: empire clean — no surface changes this round"

commit_repo "uHOME-matter" "v2.1: uhome-matter check script aligned to v2.1 family baseline"

# --- Mobile apps ---

commit_repo "uHOME-app-android" "v2.1: android app check script aligned to v2.1 family baseline"

commit_repo "uHOME-app-ios" "v2.1: iOS app check script aligned to v2.1 family baseline"

# --- Wizard ---

commit_repo "uDOS-wizard" "v2.1: Wizard @dev staging workspace checkpointed

- @dev/udos-wizard-v2.1/ planning surface staged for networking boundary follow-up work"

# --- Plugin index and docs ---

commit_repo "uDOS-plugin-index" "v2.1: plugin-index check script aligned to v2.1 family baseline"

commit_repo "uDOS-docs" "v2.1: docs check script aligned to v2.1 family baseline"

commit_repo "uDOS-gameplay" "v2.1: gameplay check script aligned to v2.1 family baseline"

# --- Dev governance (largest — do last) ---

commit_repo "uDOS-dev" "v2.1: full governance, binder lifecycle, roadmap, reporting, and operations module complete

- roadmap ledger: v2-family-roadmap.md, v2-roadmap-status.md, v2.1-rounds.md updated
- binder lifecycle: all four v2.1 round binders closed (A-D)
- submissions: v2-1-promotion-notes.md and round submission receipts
- operations: OK ASSIST MCP operations module in @dev/operations/
- reporting: v2-1-operations-checks, v2-1-archive-dependency-audit, roadmap-status reports
- scripts: run-v2-1-operations-checks.sh, run-v2-1-operations-audit.sh, run-v2-1-archive-dependency-audit.sh
- archive gate: v2.1-archive-decommission-gate.md (10/10 checks, decisions, rollback notes)
- dev-workflow.instructions.md: agent-assist instructions in .github/instructions/
- path surfaces cleaned: inbox decisions merged, pathways updated, routing updated"

echo ""
echo "=== commit pass complete ==="
echo "  passed: $PASS"
echo "  skipped: $SKIP"
echo "  failed: $FAIL"
echo ""
echo "Next: review commits per repo, then git push per repo when ready."
echo "Tag after push: git tag v2.1 && git push origin v2.1"
