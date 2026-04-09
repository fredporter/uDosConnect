# Ubuntu + Empire strict operations runbook

## Purpose

Single ordered runbook for strict completion re-validation on a local Ubuntu
host with Empire plugin workflows.

## Preconditions

- Local family checkouts available (`uDOS-host`, `uDOS-empire`, `uDOS-docs`,
  `uDOS-wizard`, `uDOS-dev`).
- Python and Node available per repo checks.

## Step 1 — Ubuntu strict host gate

```bash
cd /path/to/uDOS-host
bash scripts/run-ubuntu-strict-completion-gate.sh
```

Expected:

- `uDOS-host checks passed`
- `verify-command-centre-http: OK`
- `verify-command-centre-lan-continuity: OK`
- `uDOS-host strict completion gate passed`

## Step 2 — Empire strict application gate

```bash
cd /path/to/uDOS-empire
bash scripts/run-empire-strict-completion-gate.sh
```

Expected:

- `uDOS-empire checks passed`
- wizard release gate `PASS`
- `uDOS-empire strict completion gate passed`

## Step 3 — External publishing (GitHub Pages) surface

```bash
cd /path/to/uDOS-docs
node scripts/generate-site-data.mjs
bash scripts/run-docs-checks.sh
```

Expected:

- generated `site/data/family.json`, `site/data/library-manifest.json`
- `uDOS-docs checks passed`

## Step 4 — Internal publishing (WordPress-md) surface

```bash
cd /path/to/uDOS-empire
python3 scripts/smoke/wordpress_md_publish_smoke.py --json
```

Expected:

- schema `udos-empire-wordpress-md-publish/v1`
- mode/status `dry-run`
- deterministic slug and audit fields

## Step 5 — Family reconciliation

```bash
cd /path/to/uDOS-dev
bash scripts/run-dev-checks.sh
```

Expected:

- `uDOS-dev checks passed`

## Step 6 — Evidence capture

Create:

- `uDOS-dev/@dev/notes/reports/ubuntu-empire-strict-readiness-YYYY-MM-DD.md`

Include:

- command transcript summary
- pass/fail per gate
- LAN probe note (host + second-device URL verification)
- publishing lane note (GitHub Pages regeneration + WordPress-md dry-run proof)

## Failure handling

- If Ubuntu gate fails: stop and fix host/runtime or LAN continuity before Empire.
- If Empire gate fails: keep plugin manifest/docs in stable posture, fix failing
  smoke/tests, then rerun strict gate.
- If docs publishing fails: regenerate site data and resolve schema/link drift
  before final sign-off.
