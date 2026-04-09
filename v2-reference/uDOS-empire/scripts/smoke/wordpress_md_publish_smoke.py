#!/usr/bin/env python3

from __future__ import annotations

import argparse
import hashlib
import json
from datetime import UTC, datetime


def _slugify(text: str) -> str:
    cleaned = "".join(ch.lower() if ch.isalnum() else "-" for ch in text).strip("-")
    while "--" in cleaned:
        cleaned = cleaned.replace("--", "-")
    return cleaned or "untitled"


def build_publish_payload(markdown: str, title: str, source_path: str) -> dict[str, object]:
    slug = _slugify(title)
    digest = hashlib.sha256(markdown.encode("utf-8")).hexdigest()
    publish_id = f"wp-md-{digest[:12]}"
    timestamp = datetime.now(UTC).isoformat()
    return {
        "schema": "udos-empire-wordpress-md-publish/v1",
        "publish_id": publish_id,
        "source_path": source_path,
        "source_sha256": digest,
        "target": "wordpress",
        "mode": "dry-run",
        "status": "dry-run",
        "timestamp": timestamp,
        "payload": {
            "post_title": title,
            "post_name": slug,
            "post_content": markdown,
            "meta_input": {
                "empire_publish_id": publish_id,
                "empire_source_sha256": digest,
                "empire_source_path": source_path,
            },
        },
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args()

    markdown = "# Campaign Update\n\nThis is a local publish dry-run."
    result = build_publish_payload(markdown, "Campaign Update", "packs/wordpress-contact-import/templates/import-preview.md")

    assert result["schema"] == "udos-empire-wordpress-md-publish/v1"
    assert result["payload"]["post_name"] == "campaign-update"
    assert result["status"] == "dry-run"
    assert result["payload"]["meta_input"]["empire_publish_id"] == result["publish_id"]

    if args.json:
        print(json.dumps(result, indent=2))
    else:
        print("wordpress_md_publish_smoke: OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
