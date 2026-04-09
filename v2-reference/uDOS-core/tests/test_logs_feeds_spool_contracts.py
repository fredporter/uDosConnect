"""Logs / feeds / spool contract tests.

Aligned with docs/feeds-and-spool.md: small, bounded checks—feeds are not raw logs;
tests stay minimal and avoid redundant surfaces.

PR fast path: ``pytest -m green_proof`` (see uDOS-dev docs/pr-checklist.md).
"""
from __future__ import annotations

import json
from pathlib import Path

import pytest
from jsonschema import Draft202012Validator
from referencing import Registry, Resource

ROOT = Path(__file__).resolve().parents[1]
CONTRACTS = ROOT / "contracts"
SCHEMAS = ROOT / "schemas"
EXAMPLES = ROOT / "examples" / "logs-feeds-spool"
TEMPLATES = ROOT / "templates" / "feeds"

_SCHEMA_FILES = (
    "feed-item-contract.schema.json",
    "spool-contract.schema.json",
    "event-record-contract.schema.json",
    "feed-create-request-contract.schema.json",
)


def _load(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


def _schema_registry() -> Registry:
    registry = Registry()
    for name in _SCHEMA_FILES:
        schema = _load(SCHEMAS / name)
        registry = registry.with_resource(schema["$id"], Resource.from_contents(schema))
    return registry


@pytest.mark.green_proof
def test_green_logs_feeds_spool_bundle_and_examples() -> None:
    """Single minimal gate: contract alignment + schema titles/enums + example validation."""
    event_c = _load(CONTRACTS / "event-record-contract.json")
    feed_item_c = _load(CONTRACTS / "feed-item-contract.json")
    feed_create_c = _load(CONTRACTS / "feed-create-request-contract.json")
    spool_c = _load(CONTRACTS / "spool-contract.json")

    for c in (event_c, feed_item_c, feed_create_c, spool_c):
        assert c["version"] == "v2.3.0"

    assert event_c["schema"] == "schemas/event-record-contract.schema.json"
    assert feed_item_c["schema"] == "schemas/feed-item-contract.schema.json"
    assert feed_create_c["schema"] == "schemas/feed-create-request-contract.schema.json"
    assert spool_c["schema"] == "schemas/spool-contract.schema.json"

    assert event_c["owners"]["contract"] == "uDOS-core"
    assert feed_item_c["owners"]["managed_runtime_owner"] == "uDOS-wizard"
    assert feed_create_c["owners"]["fixture_validation_owner"] == "uDOS-dev"
    assert spool_c["format_values"] == ["json", "xml", "hybrid"]

    event_schema = _load(SCHEMAS / "event-record-contract.schema.json")
    feed_item_schema = _load(SCHEMAS / "feed-item-contract.schema.json")
    feed_create_schema = _load(SCHEMAS / "feed-create-request-contract.schema.json")
    spool_schema = _load(SCHEMAS / "spool-contract.schema.json")

    assert event_schema["title"] == "uDOS Event Record Contract"
    assert feed_item_schema["title"] == "uDOS Feed Item Contract"
    assert feed_create_schema["title"] == "uDOS Feed Create Request Contract"
    assert spool_schema["title"] == "uDOS Spool Contract"

    assert event_schema["properties"]["class"]["enum"] == [
        "event",
        "ops",
        "diagnostic",
        "metric",
    ]
    assert feed_create_schema["properties"]["transform"]["properties"]["mode"]["enum"] == [
        "direct",
        "digest",
        "derived",
    ]
    assert spool_schema["properties"]["format"]["enum"] == ["json", "xml", "hybrid"]

    registry = _schema_registry()
    pairs = (
        (event_schema, EXAMPLES / "event-record.example.json"),
        (feed_item_schema, EXAMPLES / "feed-item.example.json"),
        (feed_create_schema, EXAMPLES / "feed-create-request.example.json"),
        (spool_schema, EXAMPLES / "spool.example.json"),
    )
    for schema, example_path in pairs:
        example = _load(example_path)
        Draft202012Validator(schema, registry=registry).validate(example)


@pytest.mark.green_proof
def test_green_feed_templates_minimal() -> None:
    """RSS/Atom templates remain present for feed emission (bounded string checks)."""
    rss = (TEMPLATES / "rss.xml").read_text(encoding="utf-8")
    atom = (TEMPLATES / "atom.xml").read_text(encoding="utf-8")
    assert '<rss version="2.0">' in rss
    assert "{{#items}}" in rss
    assert '<feed xmlns="http://www.w3.org/2005/Atom">' in atom
    assert "{{summary}}" in atom


@pytest.mark.contract
def test_logs_feeds_spool_contracts_surface_documented() -> None:
    """Extra assurance: reference paths in docs remain consistent (optional full-suite depth)."""
    assert (ROOT / "docs" / "feeds-and-spool.md").is_file()
    assert EXAMPLES.is_dir()
    assert len(list(EXAMPLES.glob("*.json"))) >= 4
