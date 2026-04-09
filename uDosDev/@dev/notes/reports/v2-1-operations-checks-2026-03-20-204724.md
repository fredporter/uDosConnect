# v2.1 Operations Checks Report

- generated: 2026-03-20-204724
- run id: 2026-03-20-204724-18038
- workspace root: /Users/fredbook/Code
- invocation source: manual
- workflow tags: @dev/operations-checks,@dev/scheduler
- resume mode: false
- checkpoint path: /Users/fredbook/Code/uDOS-dev/@dev/logs/checkpoints/v2-1-operations-checks.state
- structured log: /Users/fredbook/Code/uDOS-dev/@dev/logs/v2-1-operations-checks-2026-03-20-204724.jsonl
- loop guard max checks: 25
- runtime guard max seconds: 7200

## Check Results

### Core runtime checks

- status: pass
- command: bash /Users/fredbook/Code/uDOS-core/scripts/run-core-checks.sh
- log: /Users/fredbook/Code/uDOS-dev/@dev/notes/reports/v2-1-check-core-2026-03-20-204724.log

### Shell runtime checks

- status: pass
- command: bash /Users/fredbook/Code/uDOS-shell/scripts/run-shell-checks.sh
- log: /Users/fredbook/Code/uDOS-dev/@dev/notes/reports/v2-1-check-shell-2026-03-20-204724.log

### Wizard API and MCP checks

- status: pass
- command: bash /Users/fredbook/Code/uDOS-wizard/scripts/run-wizard-checks.sh
- log: /Users/fredbook/Code/uDOS-dev/@dev/notes/reports/v2-1-check-wizard-2026-03-20-204724.log

### Plugin index checks

- status: pass
- command: bash /Users/fredbook/Code/uDOS-plugin-index/scripts/run-plugin-index-checks.sh
- log: /Users/fredbook/Code/uDOS-dev/@dev/notes/reports/v2-1-check-plugin-index-2026-03-20-204724.log

### uHOME server checks

- status: pass
- command: bash /Users/fredbook/Code/uHOME-server/scripts/run-uhome-server-checks.sh
- log: /Users/fredbook/Code/uDOS-dev/@dev/notes/reports/v2-1-check-uhome-server-2026-03-20-204724.log

### Alpine packaging checks

- status: pass
- command: bash /Users/fredbook/Code/uDOS-alpine/scripts/run-alpine-checks.sh
- log: /Users/fredbook/Code/uDOS-dev/@dev/notes/reports/v2-1-check-alpine-2026-03-20-204724.log

### Sonic runtime checks

- status: pass
- command: bash /Users/fredbook/Code/sonic-screwdriver/scripts/run-sonic-checks.sh
- log: /Users/fredbook/Code/uDOS-dev/@dev/notes/reports/v2-1-check-sonic-2026-03-20-204724.log

### ThinUI scaffold presence

- status: pass
- command: test -f /Users/fredbook/Code/uDOS-thinui/src/runtime/runtime-loop.ts
- log: /Users/fredbook/Code/uDOS-dev/@dev/notes/reports/v2-1-check-thinui-2026-03-20-204724.log

### @dev operations audit

- status: pass
- command: bash /Users/fredbook/Code/uDOS-dev/scripts/run-v2-1-operations-audit.sh
- log: /Users/fredbook/Code/uDOS-dev/@dev/notes/reports/v2-1-check-dev-operations-2026-03-20-204724.log

## Summary

- pass: 9
- fail: 0
- skip: 0
