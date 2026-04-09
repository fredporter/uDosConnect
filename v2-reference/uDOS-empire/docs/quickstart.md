# uDOS-empire Quickstart

This is the shortest practical path for checking the repo, previewing a pack,
and running one flow against a host runtime.

## Prerequisites

- Python 3.9+
- local family workspace with the host runtime available when you want live
  dispatch

## 1. Validate The Repo

```bash
bash scripts/run-empire-checks.sh
```

## 2. Inspect The Pack Library

```bash
python3 scripts/smoke/pack_catalog.py --json
python3 scripts/smoke/pack_catalog.py --write-default-artifact
```

## 3. Preview The Starter Pack

```bash
python3 scripts/smoke/pack_preview.py --json --pack quickstart --execution-brief
python3 scripts/smoke/pack_preview.py --pack quickstart --write-default-artifact
```

## 4. Run Against A Local Host

With the Ubuntu host runtime already running on `127.0.0.1:8000`:

```bash
python3 scripts/smoke/pack_run.py --json --pack quickstart --host-url http://127.0.0.1:8000 --write-default-report
```

If you want to probe sibling code in-process instead of live HTTP, swap
`--host-url` for `--local-host-app`.

## 5. Probe The Brokered Handoff Path

With the broker available on `127.0.0.1:8787` and the host runtime already
running:

```bash
python3 scripts/smoke/sync_plan.py --json --wizard-url http://127.0.0.1:8787 --probe --execution-brief
python3 scripts/smoke/sync_plan.py --json --wizard-url http://127.0.0.1:8787 --handoff-url http://127.0.0.1:8000 --queue-automation-url http://127.0.0.1:8000 --process-automation-url http://127.0.0.1:8000 --fetch-automation-results-url http://127.0.0.1:8000
```

## Default Artifact Locations

- `reports/pack-catalog/pack-catalog.json`
- `reports/pack-preview/quickstart.json`
- `reports/pack-run/quickstart.json`
