"""Binder spine payload (v1) — JSON schema validation for workspace-facing binders."""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any

_SCHEMA_REL = Path("schemas") / "binder-spine-payload.v1.schema.json"


def binder_spine_schema_path(repo_root: Path) -> Path:
    return repo_root / _SCHEMA_REL


def load_binder_spine_schema(repo_root: Path) -> dict[str, Any]:
    path = binder_spine_schema_path(repo_root)
    return json.loads(path.read_text(encoding="utf-8"))


def validate_binder_spine_payload(
    payload: dict[str, Any],
    *,
    repo_root: Path,
) -> None:
    """Raise ``jsonschema.ValidationError`` if ``payload`` does not match v1 schema."""
    try:
        from jsonschema import Draft202012Validator
    except ImportError as exc:  # pragma: no cover
        raise RuntimeError("jsonschema is required for validate_binder_spine_payload") from exc

    schema = load_binder_spine_schema(repo_root)
    Draft202012Validator(schema).validate(payload)
