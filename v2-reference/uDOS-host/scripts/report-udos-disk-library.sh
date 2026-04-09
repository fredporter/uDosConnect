#!/usr/bin/env bash
# Read-only snapshot of disk headroom and ~/.udos library-related dirs for Wizard
# family health. Prints a single JSON object to stdout.
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
export REPO_ROOT
exec python3 - <<'PY'
import json
import os
import shutil
import subprocess
from pathlib import Path
from typing import Optional

home = Path(os.environ.get("HOME") or os.path.expanduser("~")).resolve()
udos = home / ".udos"


def du_sk(path: Path) -> Optional[int]:
    if not path.exists():
        return None
    try:
        cp = subprocess.run(
            ["du", "-sk", str(path)],
            capture_output=True,
            text=True,
            timeout=120,
            check=False,
        )
        if cp.returncode != 0 or not cp.stdout.strip():
            return None
        return int(cp.stdout.split()[0])
    except (OSError, ValueError, subprocess.TimeoutExpired):
        return None


try:
    du_home = shutil.disk_usage(home)
    disk_home = {"total": du_home.total, "used": du_home.used, "free": du_home.free}
except OSError:
    disk_home = None

dirs = ("library", "cache", "state", "vault", "logs", "sync", "tmp")
udos_dirs_kb = {name: du_sk(udos / name) for name in dirs}

report = {
    "schema": "udos.ubuntu.wizard-family-health-disk.v1",
    "home": str(home),
    "udos_root": str(udos),
    "udos_exists": udos.is_dir(),
    "disk_usage_home": disk_home,
    "udos_dirs_kb": udos_dirs_kb,
    "ubuntu_repo": os.environ.get("REPO_ROOT", ""),
}
print(json.dumps(report))
PY
