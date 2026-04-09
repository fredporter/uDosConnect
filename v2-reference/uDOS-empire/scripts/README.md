# Scripts

`scripts/` is the checked-in validation lane for `uDOS-empire`.

Current script surfaces include:

- `run-empire-checks.sh` for repo activation validation
- `smoke/` for runtime-safe smoke and preflight scaffolds
- `smoke/pack_catalog.py` for the starter pack library artifact
- `smoke/pack_preview.py` for inspectable dry-run pack previews
- `smoke/pack_run.py` for starter-pack dispatch into local or HTTP runtime seams
- `smoke/hubspot_lane_gate.py` as a legacy transition gate while old provider
  artifacts still exist
- `smoke/wordpress_md_publish_smoke.py` for markdown-to-WordPress payload and
  audit contract smoke coverage
- `smoke/data_safety_smoke.py` for backup/restore and integrity safety checks
- `run-empire-wizard-release-gate.sh` for the hardened empire-to-wizard gate
- `run-empire-strict-completion-gate.sh` for strict completion gating

Boundary rule:

- keep lightweight workflow checks here
- keep host runtime, repo-store, and Git or GitHub execution logic outside this
  repo
