#!/usr/bin/env python3

from __future__ import annotations

import argparse
import json
import shutil
import tempfile
from pathlib import Path


def _write_json(path: Path, payload: dict[str, object]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args()

    with tempfile.TemporaryDirectory(prefix="empire-data-safety-") as tmp:
        root = Path(tmp)
        live = root / "live"
        backup = root / "backup"

        _write_json(live / "contacts.json", {"count": 2, "records": ["a", "b"]})
        _write_json(live / "activity-log.json", {"events": ["import", "enrich"]})
        _write_json(live / "publish-log.json", {"events": ["dry-run"]})
        _write_json(live / "manifest.json", {"snapshot": "live-01", "status": "ready"})

        shutil.copytree(live, backup)

        _write_json(live / "contacts.json", {"count": 0, "records": []})
        shutil.rmtree(live)
        shutil.copytree(backup, live)

        restored_contacts = json.loads((live / "contacts.json").read_text(encoding="utf-8"))
        restored_manifest = json.loads((live / "manifest.json").read_text(encoding="utf-8"))

        assert restored_contacts["count"] == 2
        assert restored_manifest["snapshot"] == "live-01"

        result = {
            "schema": "udos-empire-data-safety-smoke/v1",
            "snapshot_created": True,
            "restore_passed": True,
            "integrity_passed": True,
            "restored_contact_count": restored_contacts["count"],
        }

        if args.json:
            print(json.dumps(result, indent=2))
        else:
            print("data_safety_smoke: OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
