#!/usr/bin/env python3
"""Validate profiles/*/surface.json and optional input-mapping.json (stdlib only)."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

REQUIRED_SURFACE = ("id", "layout", "navigation", "input", "modes", "thinui", "session")
REQUIRED_THINUI = ("density", "theme", "components")
REQUIRED_SESSION = ("multiWindow", "restoreState")
REQUIRED_INPUT_MAP = ("profileId", "schemaVersion", "primaryInput")
VALID_MODES = frozenset({"windowed", "fullscreen"})


def _err(path: Path, msg: str) -> str:
    return f"{path}: {msg}"


def validate_surface(path: Path, data: object) -> list[str]:
    errors: list[str] = []
    if not isinstance(data, dict):
        return [_err(path, "root must be an object")]
    d = data
    for key in REQUIRED_SURFACE:
        if key not in d:
            errors.append(_err(path, f"missing required key '{key}'"))
    if errors:
        return errors
    assert isinstance(d["input"], list)  # for type checkers
    if not d["input"] or not all(isinstance(x, str) for x in d["input"]):
        errors.append(_err(path, "'input' must be a non-empty array of strings"))
    modes = d.get("modes")
    if not isinstance(modes, list) or not modes:
        errors.append(_err(path, "'modes' must be a non-empty array"))
    else:
        for m in modes:
            if m not in VALID_MODES:
                errors.append(_err(path, f"invalid mode '{m}' (expect windowed|fullscreen)"))
    tu = d.get("thinui")
    if not isinstance(tu, dict):
        errors.append(_err(path, "'thinui' must be an object"))
    else:
        for key in REQUIRED_THINUI:
            if key not in tu:
                errors.append(_err(path, f"thinui missing '{key}'"))
        if isinstance(tu.get("components"), list) and not tu["components"]:
            errors.append(_err(path, "thinui.components must be non-empty"))
    sess = d.get("session")
    if not isinstance(sess, dict):
        errors.append(_err(path, "'session' must be an object"))
    else:
        for key in REQUIRED_SESSION:
            if key not in sess:
                errors.append(_err(path, f"session missing '{key}'"))
            elif not isinstance(sess[key], bool):
                errors.append(_err(path, f"session.{key} must be boolean"))
    return errors


def validate_input_mapping(path: Path, data: object) -> list[str]:
    errors: list[str] = []
    if not isinstance(data, dict):
        return [_err(path, "root must be an object")]
    d = data
    for key in REQUIRED_INPUT_MAP:
        if key not in d:
            errors.append(_err(path, f"missing required key '{key}'"))
        elif key != "schemaVersion" and not isinstance(d[key], str):
            errors.append(_err(path, f"'{key}' must be a string"))
        elif key == "schemaVersion" and not isinstance(d[key], str):
            errors.append(_err(path, "'schemaVersion' must be a string"))
    return errors


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument(
        "--root",
        type=Path,
        default=None,
        help="uDOS-surface repo root (default: parent of scripts/)",
    )
    args = ap.parse_args()
    root = args.root
    if root is None:
        root = Path(__file__).resolve().parent.parent
    profiles = root / "profiles"
    if not profiles.is_dir():
        print(f"validate_surface_profiles: no profiles/ under {root}", file=sys.stderr)
        return 1

    all_errors: list[str] = []
    for prof_dir in sorted(profiles.iterdir()):
        if not prof_dir.is_dir() or prof_dir.name.startswith("."):
            continue
        sf = prof_dir / "surface.json"
        if sf.is_file():
            try:
                data = json.loads(sf.read_text(encoding="utf-8"))
            except json.JSONDecodeError as e:
                all_errors.append(f"{sf}: invalid JSON ({e})")
                continue
            all_errors.extend(validate_surface(sf, data))
        im = prof_dir / "input-mapping.json"
        if im.is_file():
            try:
                im_data = json.loads(im.read_text(encoding="utf-8"))
            except json.JSONDecodeError as e:
                all_errors.append(f"{im}: invalid JSON ({e})")
                continue
            all_errors.extend(validate_input_mapping(im, im_data))

    if all_errors:
        print("Surface profile validation failed:", file=sys.stderr)
        for line in all_errors:
            print(f"  {line}", file=sys.stderr)
        return 1
    print(f"OK: validated surface profiles under {profiles}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
