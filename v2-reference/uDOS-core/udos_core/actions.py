from __future__ import annotations
from .models import ParsedCommand, ActionResult

def to_action_frame(cmd: ParsedCommand) -> dict:
    return {
        "kind": f"{cmd.namespace}.{cmd.action}",
        "args": cmd.args,
        "raw": cmd.raw,
    }

def success(cmd: ParsedCommand, **data) -> ActionResult:
    return ActionResult(ok=True, command=f"{cmd.namespace}.{cmd.action}", data=data)

def failure(cmd: ParsedCommand, *errors: str) -> ActionResult:
    return ActionResult(ok=False, command=f"{cmd.namespace}.{cmd.action}", errors=list(errors))
