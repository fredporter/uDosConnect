"""Contract tests for schemas/binder-spine-payload.v1.schema.json (v2.6 Round A)."""

from __future__ import annotations

import json
from pathlib import Path

import pytest

from udos_core.binder_spine import load_binder_spine_schema, validate_binder_spine_payload

pytest.importorskip("jsonschema")

REPO_ROOT = Path(__file__).resolve().parents[1]


@pytest.mark.contract
def test_binder_spine_schema_loads():
    schema = load_binder_spine_schema(REPO_ROOT)
    assert schema["title"] == "Binder spine payload (v1)"


@pytest.mark.contract
def test_fixture_minimal_validates():
    raw = (Path(__file__).parent / "fixtures" / "binder-spine-demo.v1.json").read_text(encoding="utf-8")
    payload = json.loads(raw)
    validate_binder_spine_payload(payload, repo_root=REPO_ROOT)


@pytest.mark.contract
def test_rejects_missing_schema_version():
    from jsonschema import ValidationError

    payload = {"id": "x", "title": "t", "items": [{"id": "1", "title": "a", "recordType": "task"}]}
    with pytest.raises(ValidationError):
        validate_binder_spine_payload(payload, repo_root=REPO_ROOT)


@pytest.mark.contract
def test_thinui_demo_binder_conforms_when_sibling_present():
    thinui_demo = REPO_ROOT.parent / "uDOS-thinui" / "demo" / "public" / "demo-binder.json"
    if not thinui_demo.is_file():
        pytest.skip("uDOS-thinui sibling checkout not present")
    payload = json.loads(thinui_demo.read_text(encoding="utf-8"))
    validate_binder_spine_payload(payload, repo_root=REPO_ROOT)
