# Ubuntu + Empire strict completion contract

Status: active  
Target: single-host Ubuntu lab (local-network-first)  
Scope owners: `uDOS-host`, `uDOS-empire`

## Purpose

Define machine-verifiable gates for strict completion of the Ubuntu host lane and
Empire application lane. "Strict completion" means no draft/transitional core
posture for these lanes and reproducible operator proof.

## Gate set

### Gate A — Ubuntu runtime host is strict-operational

Required command:

```bash
bash scripts/run-ubuntu-strict-completion-gate.sh
```

Pass criteria:

- Runtime daemon and host persistence checks pass.
- Command-centre HTTP checks pass.
- LAN bind continuity checks pass.
- Host repo/GitHub operation surfaces are verified.

### Gate B — Empire plugin lane is strict-operational

Required command:

```bash
bash scripts/run-empire-strict-completion-gate.sh
```

Pass criteria:

- Repo checks pass with stable (non-draft) plugin manifest posture.
- WordPress-md publish contract + smoke checks pass.
- Workflow/task automation checks pass.
- Data safety checks (backup/restore + migration safety contract) pass.

### Gate C — Cross-repo operator flow proof

Required command set (in order):

```bash
bash uDOS-host/scripts/run-ubuntu-strict-completion-gate.sh
bash uDOS-empire/scripts/run-empire-strict-completion-gate.sh
bash uDOS-docs/scripts/run-docs-checks.sh
bash uDOS-dev/scripts/run-dev-checks.sh
```

Pass criteria:

- All commands pass in one run.
- Evidence report is written in `uDOS-dev/@dev/notes/reports/`.
- Backlog trackers are updated to show strict-completion closure.

## Evidence rule

Every strict completion run must record:

- date/time
- commands executed
- pass/fail outcome
- operator notes for LAN probe and publish lane

Evidence file location:

- `uDOS-dev/@dev/notes/reports/ubuntu-empire-strict-readiness-YYYY-MM-DD.md`

## Boundary rule

- Ubuntu owns runtime host authority, persistence, LAN service, and host Git/GitHub execution surfaces.
- Empire owns WordPress plugin logic and WordPress-md local publishing workflow.
- Wizard remains broker/UI; it does not assume Ubuntu host ownership.
