#!/usr/bin/env python3
"""uDOS-empire contract smoke scaffold for active and legacy-transition assets."""

from __future__ import annotations

import json
from pathlib import Path


def main() -> int:
    repo_root = Path(__file__).resolve().parents[2]
    targets = [
        repo_root / "src" / "sync-contract.json",
        repo_root / "src" / "sync-record-profile.json",
        repo_root / "src" / "legacy" / "asset-inventory.json",
        repo_root / "src" / "udos_empire_compat" / "legacy_sync_runtime.py",
        repo_root / "src" / "wordpress-plugin" / "plugin-manifest.json",
        repo_root / "src" / "wordpress-plugin" / "contact-record-profile.json",
        repo_root / "schemas" / "pack-manifest.schema.json",
        repo_root / "src" / "webhooks" / "webhook-server-template.json",
        repo_root / "src" / "webhooks" / "google-sync-template.json",
        repo_root / "src" / "webhooks" / "hubspot-sync-template.json",
        repo_root / "src" / "webhooks" / "mappings" / "default-contact-master.json",
        repo_root / "src" / "webhooks" / "mappings" / "google-lead-enrichment.json",
        repo_root / "src" / "webhooks" / "mappings" / "calendar-followup-task.json",
        repo_root / "packs" / "campaign-starter" / "pack.json",
        repo_root / "packs" / "event-launch" / "pack.json",
        repo_root / "packs" / "legacy" / "README.md",
        repo_root / "packs" / "wordpress-contact-import" / "pack.json",
        repo_root / "examples" / "basic-sync-record-envelope.json",
        repo_root / "examples" / "configurable-webhook-server.json",
    ]

    for path in targets:
        if path.suffix == ".json":
            payload = json.loads(path.read_text(encoding="utf-8"))
            print(f"PASS {path.relative_to(repo_root)} :: keys={sorted(payload.keys())}")
        else:
            text = path.read_text(encoding="utf-8")
            print(f"PASS {path.relative_to(repo_root)} :: chars={len(text)}")

    print("Contract smoke passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
