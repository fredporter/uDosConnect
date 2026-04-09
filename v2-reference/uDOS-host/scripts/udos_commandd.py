#!/usr/bin/env python3
"""Python wrapper for udos-commandd.sh.

This is a non-breaking adapter so family tooling can call a Python CLI while
the underlying shell implementation remains the lane-1 source of truth.
"""

from __future__ import annotations

import argparse
import os
import subprocess
import sys
from pathlib import Path


def _repo_root() -> Path:
    return Path(__file__).resolve().parent.parent


def _commandd_script() -> Path:
    return _repo_root() / "scripts" / "udos-commandd.sh"


def _run(args: list[str]) -> int:
    script = _commandd_script()
    if not script.is_file():
        print(f"missing commandd script: {script}", file=sys.stderr)
        return 1
    env = dict(os.environ)
    proc = subprocess.run(
        ["/usr/bin/env", "bash", str(script), *args],
        env=env,
        check=False,
    )
    return proc.returncode


def main() -> int:
    parser = argparse.ArgumentParser(description="Python wrapper for udos-commandd")
    sub = parser.add_subparsers(dest="command", required=True)

    sub.add_parser("serve", help="Run commandd HTTP listener")
    sub.add_parser("stub", help="Print one-shot status")
    sub.add_parser("policy-summary", help="Print policy summary")

    p_list = sub.add_parser("list-operations", help="List operations")
    p_list.add_argument("domain", nargs="?", default="")

    p_surface = sub.add_parser("surface-summary", help="Show surface contract summary")
    p_surface.add_argument("surface", nargs="?", default="git")

    p_repo = sub.add_parser("repo-op", help="Run bridged repo/runtime operation")
    p_repo.add_argument("operation_id")
    p_repo.add_argument("arguments", nargs="*")

    ns = parser.parse_args()

    if ns.command == "serve":
        return _run(["serve"])
    if ns.command == "stub":
        return _run(["stub"])
    if ns.command == "policy-summary":
        return _run(["policy-summary"])
    if ns.command == "list-operations":
        args = ["list-operations"]
        if ns.domain:
            args.append(ns.domain)
        return _run(args)
    if ns.command == "surface-summary":
        return _run(["surface-summary", ns.surface])
    if ns.command == "repo-op":
        return _run(["repo-op", ns.operation_id, *ns.arguments])

    print(f"unknown command: {ns.command}", file=sys.stderr)
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
