from __future__ import annotations
from dataclasses import dataclass, field
from typing import Any

@dataclass
class ParsedCommand:
    namespace: str
    action: str
    args: dict[str, Any] = field(default_factory=dict)
    raw: str = ""

@dataclass
class ActionResult:
    ok: bool
    command: str
    data: dict[str, Any] = field(default_factory=dict)
    errors: list[str] = field(default_factory=list)
