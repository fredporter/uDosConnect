from __future__ import annotations

import shlex

from .models import ParsedCommand


def _parse_uppercase_ucode(raw: str) -> ParsedCommand | None:
    try:
        parts = shlex.split(raw)
    except ValueError:
        return ParsedCommand(namespace="system", action="invalid", args={}, raw=raw)

    if not parts:
        return ParsedCommand(namespace="system", action="noop", args={}, raw=raw)

    head = parts[0]
    if head != head.upper():
        return None

    args: dict[str, str] = {}

    if head == "SET":
        if len(parts) >= 2:
            args["target"] = parts[1]
        if len(parts) >= 3:
            args["value"] = " ".join(parts[2:])
        return ParsedCommand(namespace="state", action="set", args=args, raw=raw)

    if head == "STATUS":
        if len(parts) >= 2:
            args["target"] = parts[1]
        return ParsedCommand(namespace="status", action="show", args=args, raw=raw)

    if head == "WORKFLOW":
        action = parts[1].lower() if len(parts) >= 2 else "status"
        if len(parts) >= 3:
            args["target"] = " ".join(parts[2:])
        return ParsedCommand(namespace="workflow", action=action, args=args, raw=raw)

    if head == "DRAW":
        if len(parts) >= 2:
            subverb = parts[1].upper()
            args["mode"] = subverb.lower()
            if subverb == "PAT" and len(parts) >= 3:
                pattern_type = parts[2].upper()
                args["pattern_type"] = pattern_type.lower()
                if len(parts) >= 4:
                    args["value"] = " ".join(parts[3:])
            elif len(parts) >= 3:
                args["target"] = " ".join(parts[2:])
        return ParsedCommand(namespace="draw", action="render", args=args, raw=raw)

    if head == "SCRIPT":
        action = parts[1].lower() if len(parts) >= 2 else "run"
        if len(parts) >= 3:
            args["path"] = " ".join(parts[2:])
        return ParsedCommand(namespace="script", action=action, args=args, raw=raw)

    if head == "RUN":
        if len(parts) >= 2:
            args["path"] = " ".join(parts[1:])
        return ParsedCommand(namespace="script", action="run", args=args, raw=raw)

    return ParsedCommand(
        namespace="system",
        action=head.lower(),
        args={"items": " ".join(parts[1:])},
        raw=raw,
    )


def parse_ucode(command: str) -> ParsedCommand:
    raw = command.strip()
    if not raw:
        return ParsedCommand(namespace="system", action="noop", args={}, raw=raw)

    uppercase = _parse_uppercase_ucode(raw)
    if uppercase is not None:
        return uppercase

    # Supports:
    # #binder create client-acme
    # #task add "Send proposal" due:tomorrow
    # compile binder:client-acme
    parts = raw.split()
    head = parts[0]

    if head.startswith("#"):
        namespace = head[1:]
        action = parts[1] if len(parts) > 1 else "run"
        rest = parts[2:] if len(parts) > 2 else []
    else:
        namespace = "system"
        action = head
        rest = parts[1:]

    args: dict[str, str] = {}
    positional: list[str] = []

    for item in rest:
        if ":" in item and not item.startswith('"'):
            key, value = item.split(":", 1)
            args[key] = value.strip('"')
        else:
            positional.append(item.strip('"'))

    if positional:
        args["items"] = " ".join(positional)

    return ParsedCommand(namespace=namespace, action=action, args=args, raw=raw)
