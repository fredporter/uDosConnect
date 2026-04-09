from __future__ import annotations
from dataclasses import asdict, dataclass
from pathlib import Path
import json

from .dev_config import get_path

@dataclass
class VaultRecord:
    udos_id: str
    record_type: str
    title: str
    body: str

class VaultStore:
    def __init__(self, root: str | None = None) -> None:
        configured = Path(root).expanduser().resolve() if root else get_path("UDOS_VAULT_ROOT")
        self.root = configured or (Path.cwd() / "memory" / "vault").resolve()
        self.root.mkdir(parents=True, exist_ok=True)

    def save_record(self, record: VaultRecord) -> str:
        path = self.root / f"{record.udos_id}.json"
        path.write_text(json.dumps(asdict(record), indent=2), encoding="utf-8")
        return str(path)

    def health(self) -> dict:
        return {"vault_root": str(self.root), "exists": self.root.exists()}
