#!/usr/bin/env python3
"""Turn demo scaffold JSON into operator-facing terminal prose (not JSON dumps)."""

from __future__ import annotations

import argparse
import json
import textwrap
from pathlib import Path


def _indent_wrap(text: str, width: int = 68, hang: str = "       ") -> list[str]:
    text = " ".join(text.split())
    if not text:
        return [hang.rstrip()]
    lines: list[str] = []
    for chunk in textwrap.wrap(text, width=max(20, width - len(hang))):
        lines.append(hang + chunk)
    return lines


def render_workstation(data: dict) -> str:
    lines: list[str] = []
    wid = data.get("id", "workstation")
    lines.append(f"── What this is (operator view) ──")
    lines.append(f"  {wid}")
    if v := data.get("version"):
        lines.append(f"  Track: {v}")
    if m := data.get("mode"):
        lines.append(f"  Mode: {m}")
    if ev := data.get("entry_view"):
        lines.append(f"  Entry: {ev}")
    if pt := data.get("parity_target"):
        lines.append(f"  Parity target: {pt}")
    if data.get("binder_native"):
        lines.append("  Operator shell: browser-first on this host (binder-native).")
    lines.append("")
    lines.append("  Surfaces you get (names match what a user would see):")
    for i, view in enumerate(data.get("views") or [], 1):
        title = view.get("title") or view.get("id", "?")
        lines.append(f"    {i}. {title}")
        purpose = (view.get("purpose") or "").strip()
        if purpose:
            lines.extend(_indent_wrap(purpose, width=68))
    fh = data.get("family_handoffs") or {}
    if fh:
        lines.append("")
        wr = fh.get("wizard_routes") or []
        if wr:
            lines.append("  Wizard routes (sibling app):")
            for r in wr:
                lines.append(f"    • {r}")
        se = fh.get("shell_entrypoints") or []
        if se:
            lines.append("  Shell / CLI entrypoints:")
            for s in se:
                lines.append(f"    • {s}")
    ng = data.get("non_goals") or []
    if ng:
        lines.append("")
        lines.append("  Not claiming in this lane:")
        for g in ng:
            lines.append(f"    — {g}")
    return "\n".join(lines)


def render_thinui(data: dict) -> str:
    lines = ["── ThinUI first-run (when thinui repo is present) ──"]
    if data.get("title"):
        lines.append(f"  Screen title: {data['title']}")
    if data.get("subtitle"):
        lines.append(f"  Tag line: {data['subtitle']}")
    if sp := data.get("surfaceProfileId"):
        lines.append(f"  Surface profile: {sp}")
    if src := data.get("surfaceProfileSource"):
        lines.append(f"  Profile contract: {src}")
    for label, key in (
        ("Runtime", "runtime"),
        ("Entry view", "entryView"),
        ("Window mode", "mode"),
        ("Theme", "themeId"),
        ("Loader", "loaderId"),
    ):
        if key in data and data[key] is not None:
            lines.append(f"  {label}: {data[key]}")
    lines.append(
        "  Input intents: uDOS-surface/profiles/<id>/input-mapping.json → Shell UCI (see uDOS-shell/docs/surface-input-and-uci.md)."
    )
    return "\n".join(lines)


def render_auto(data: dict) -> str:
    if data.get("runtime") == "thinui" or "entryView" in data:
        return render_thinui(data)
    return render_workstation(data)


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("path", type=Path, help="Path to JSON file")
    ap.add_argument(
        "--kind",
        choices=("auto", "workstation", "thinui"),
        default="auto",
        help="Scaffold type (default: infer from JSON)",
    )
    args = ap.parse_args()
    raw = args.path.read_text(encoding="utf-8")
    data = json.loads(raw)
    if args.kind == "workstation":
        print(render_workstation(data))
    elif args.kind == "thinui":
        print(render_thinui(data))
    else:
        print(render_auto(data))


if __name__ == "__main__":
    main()
