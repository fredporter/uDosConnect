# v2.1 Operations Checks Report

- generated: 2026-03-20-204744
- run id: 2026-03-20-204744-18381
- workspace root: /Users/fredbook/Code
- invocation source: manual
- workflow tags: @dev/operations-checks,@dev/scheduler
- resume mode: true
- checkpoint path: /Users/fredbook/Code/uDOS-dev/@dev/logs/checkpoints/v2-1-operations-checks.state
- structured log: /Users/fredbook/Code/uDOS-dev/@dev/logs/v2-1-operations-checks-2026-03-20-204744.jsonl
- loop guard max checks: 25
- runtime guard max seconds: 7200

## Check Results

### Core runtime checks

- status: skip (checkpoint pass)
- command: bash /Users/fredbook/Code/uDOS-core/scripts/run-core-checks.sh
- log: /Users/fredbook/Code/uDOS-dev/@dev/logs/checkpoints/v2-1-operations-checks.state

### Shell runtime checks

- status: skip (checkpoint pass)
- command: bash /Users/fredbook/Code/uDOS-shell/scripts/run-shell-checks.sh
- log: /Users/fredbook/Code/uDOS-dev/@dev/logs/checkpoints/v2-1-operations-checks.state

### Wizard API and MCP checks

- status: skip (checkpoint pass)
- command: bash /Users/fredbook/Code/uDOS-wizard/scripts/run-wizard-checks.sh
- log: /Users/fredbook/Code/uDOS-dev/@dev/logs/checkpoints/v2-1-operations-checks.state

### Plugin index checks

- status: skip (checkpoint pass)
- command: bash /Users/fredbook/Code/uDOS-plugin-index/scripts/run-plugin-index-checks.sh
- log: /Users/fredbook/Code/uDOS-dev/@dev/logs/checkpoints/v2-1-operations-checks.state

### uHOME server checks

- status: skip (checkpoint pass)
- command: bash /Users/fredbook/Code/uHOME-server/scripts/run-uhome-server-checks.sh
- log: /Users/fredbook/Code/uDOS-dev/@dev/logs/checkpoints/v2-1-operations-checks.state

### Alpine packaging checks

- status: skip (checkpoint pass)
- command: bash /Users/fredbook/Code/uDOS-alpine/scripts/run-alpine-checks.sh
- log: /Users/fredbook/Code/uDOS-dev/@dev/logs/checkpoints/v2-1-operations-checks.state

### Sonic runtime checks

- status: skip (checkpoint pass)
- command: bash /Users/fredbook/Code/sonic-screwdriver/scripts/run-sonic-checks.sh
- log: /Users/fredbook/Code/uDOS-dev/@dev/logs/checkpoints/v2-1-operations-checks.state

### ThinUI scaffold presence

- status: skip (checkpoint pass)
- command: test -f /Users/fredbook/Code/uDOS-thinui/src/runtime/runtime-loop.ts
- log: /Users/fredbook/Code/uDOS-dev/@dev/logs/checkpoints/v2-1-operations-checks.state

### @dev operations audit

- status: skip (checkpoint pass)
- command: bash /Users/fredbook/Code/uDOS-dev/scripts/run-v2-1-operations-audit.sh
- log: /Users/fredbook/Code/uDOS-dev/@dev/logs/checkpoints/v2-1-operations-checks.state

## Summary

- pass: 0
- fail: 0
- skip: 9
