from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path

from .render import split_frontmatter


@dataclass
class ScriptBlock:
    language: str
    content: str


@dataclass
class ScriptDocument:
    path: str
    metadata: dict[str, object]
    blocks: list[ScriptBlock]


class ScriptDocumentError(ValueError):
    pass


def _validate_script_metadata(path: Path, metadata: dict[str, object]) -> None:
    required = ("id", "type", "version", "runtime")
    missing = [key for key in required if key not in metadata]
    if missing:
        raise ScriptDocumentError(f"missing frontmatter fields: {', '.join(missing)}")

    if str(metadata["type"]) != "script":
        raise ScriptDocumentError("frontmatter type must be 'script'")

    if str(metadata["version"]) != "2":
        raise ScriptDocumentError("frontmatter version must be 2")

    runtime = str(metadata["runtime"])
    if runtime not in {"tui", "web"}:
        raise ScriptDocumentError("frontmatter runtime must be one of: tui, web")

    if path.suffix != ".md":
        raise ScriptDocumentError("script path must end with .md")


def _parse_blocks(body: str) -> list[ScriptBlock]:
    blocks: list[ScriptBlock] = []
    lines = body.splitlines()
    in_block = False
    language = ""
    current: list[str] = []

    for line in lines:
        stripped = line.strip()
        if stripped.startswith("```"):
            if not in_block:
                in_block = True
                language = stripped[3:].strip().lower()
                current = []
                continue
            blocks.append(ScriptBlock(language=language, content="\n".join(current).strip()))
            in_block = False
            language = ""
            current = []
            continue

        if in_block:
            current.append(line)

    if in_block:
        raise ScriptDocumentError("unterminated fenced code block")

    return blocks


def load_script_document(path: str) -> ScriptDocument:
    script_path = Path(path).expanduser().resolve()
    if not script_path.exists():
        raise ScriptDocumentError(f"script not found: {script_path}")

    metadata, body = split_frontmatter(script_path.read_text(encoding="utf-8"))
    _validate_script_metadata(script_path, metadata)
    blocks = [block for block in _parse_blocks(body) if block.language == "ucode"]

    if not blocks:
        raise ScriptDocumentError("script must contain at least one ```ucode``` block")

    return ScriptDocument(
        path=str(script_path),
        metadata=metadata,
        blocks=blocks,
    )
