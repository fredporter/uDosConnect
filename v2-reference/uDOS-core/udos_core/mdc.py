from __future__ import annotations

import csv
import json
import re
from pathlib import Path
from typing import Any


NATIVE_EXTENSIONS = {".md", ".mdc"}
DATA_EXTENSIONS = {".csv", ".tsv", ".json", ".xml", ".yaml", ".yml"}
SPREADSHEET_EXTENSIONS = {".xls", ".xlsx"}
DOCUMENT_EXTENSIONS = {".docx", ".pdf", ".rtf", ".ppt", ".pptx"}
WEB_EXTENSIONS = {".html", ".htm"}
CODE_LOG_EXTENSIONS = {".py", ".js", ".go", ".log"}

SQLITE_THRESHOLD_ROWS = 5000


def _extension_for(path: Path) -> str:
    return path.suffix.lower()


def _read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="ignore")


def _strip_html(text: str) -> str:
    return re.sub(r"\s+", " ", re.sub(r"<[^>]+>", " ", text)).strip()


def _row_count(path: Path) -> int:
    extension = _extension_for(path)
    delimiter = "\t" if extension == ".tsv" else ","
    with path.open("r", encoding="utf-8", errors="ignore", newline="") as handle:
        reader = csv.reader(handle, delimiter=delimiter)
        return sum(1 for _ in reader)


def classify_path(path: str | Path) -> dict[str, object]:
    file_path = Path(path)
    extension = _extension_for(file_path)

    if extension in NATIVE_EXTENSIONS:
        category = "native"
    elif extension in DATA_EXTENSIONS:
        category = "data"
    elif extension in SPREADSHEET_EXTENSIONS:
        category = "spreadsheet"
    elif extension in DOCUMENT_EXTENSIONS:
        category = "document"
    elif extension in WEB_EXTENSIONS:
        category = "web"
    elif extension in CODE_LOG_EXTENSIONS:
        category = "code-log"
    else:
        category = "unknown"

    return {
        "path": str(file_path),
        "extension": extension,
        "category": category,
        "markdown_generated": True,
        "source_modified": False,
    }


def _output_plan(path: Path, category: str) -> list[dict[str, object]]:
    outputs: list[dict[str, object]] = [
        {"kind": "markdown", "path": path.with_suffix(".md").name, "deterministic": True}
    ]

    extension = _extension_for(path)
    if category in {"data", "spreadsheet"}:
        if extension in {".csv", ".tsv"} and path.exists():
            rows = _row_count(path)
            kind = "sqlite" if rows > SQLITE_THRESHOLD_ROWS else "json"
        else:
            kind = "json"
        outputs.append({"kind": kind, "path": path.with_suffix(f".{kind}").name, "deterministic": True})

    return outputs


def _markdown_body(path: Path, category: str) -> str:
    text = _read_text(path)
    if category == "native":
        return text
    if _extension_for(path) == ".json":
        try:
            payload = json.loads(text)
        except json.JSONDecodeError:
            return text.strip()
        if isinstance(payload, dict):
            lines = ["# JSON Document", ""]
            for key, value in payload.items():
                lines.append(f"- **{key}**: {value}")
            return "\n".join(lines).strip()
        if isinstance(payload, list):
            return f"# JSON Array\n\nItems: {len(payload)}"
        return text.strip()
    if category == "web":
        return _strip_html(text)
    if _extension_for(path) == ".pdf":
        return re.sub(r"\s+", " ", text).strip()
    if _extension_for(path) == ".rtf":
        cleaned = re.sub(r"\\[a-z]+\d* ?", " ", text)
        cleaned = re.sub(r"[{}]", " ", cleaned)
        return re.sub(r"\s+", " ", cleaned).strip()
    if _extension_for(path) == ".docx":
        cleaned = re.sub(r"</w:p>", "\n", text)
        cleaned = re.sub(r"<[^>]+>", " ", cleaned)
        return re.sub(r"\s+", " ", cleaned).strip()
    if _extension_for(path) in {".ppt", ".pptx"}:
        sections = [part.strip() for part in text.split("\n\n") if part.strip()]
        return "\n\n".join(f"## Slide {index + 1}\n\n{section}" for index, section in enumerate(sections or [text.strip()]))
    if _extension_for(path) == ".xml":
        return re.sub(r"\s+", " ", re.sub(r"</?[^>]+>", " ", text)).strip()
    return text.strip()


def _structured_metadata(path: Path, category: str) -> dict[str, Any]:
    extension = _extension_for(path)
    metadata: dict[str, Any] = {
        "filename": path.name,
        "category": category,
        "extension": extension,
    }

    if category in {"data", "spreadsheet"} and path.exists():
        if extension in {".csv", ".tsv"}:
            delimiter = "\t" if extension == ".tsv" else ","
            with path.open("r", encoding="utf-8", errors="ignore", newline="") as handle:
                reader = list(csv.reader(handle, delimiter=delimiter))
            metadata["row_count"] = max(len(reader) - 1, 0) if reader else 0
            metadata["column_count"] = len(reader[0]) if reader else 0
        else:
            metadata["row_count"] = 0
            metadata["column_count"] = 0

    if extension == ".json":
        try:
            payload = json.loads(_read_text(path))
            if isinstance(payload, dict):
                metadata["top_level_keys"] = sorted(payload.keys())
            elif isinstance(payload, list):
                metadata["item_count"] = len(payload)
        except json.JSONDecodeError:
            metadata["json_valid"] = False

    return metadata


class MdcEngine:
    def classify(self, path: str | Path) -> dict[str, object]:
        return classify_path(path)

    def normalize(self, path: str | Path) -> dict[str, object]:
        file_path = Path(path)
        classification = self.classify(file_path)
        outputs = _output_plan(file_path, str(classification["category"]))
        markdown = _markdown_body(file_path, str(classification["category"]))

        return {
            "source_path": str(file_path),
            "source_type": classification["extension"],
            "classifier": classification["category"],
            "outputs": outputs,
            "markdown": markdown,
            "metadata": _structured_metadata(file_path, str(classification["category"])),
            "vault_routing": {
                "persist_original": True,
                "persist_derivatives_only": False,
                "source_archive": f"vault://intake/source/{file_path.name}",
                "derivative_root": f"vault://intake/normalized/{file_path.stem}",
            },
        }

    def contract_summary(self) -> dict[str, object]:
        return {
            "sqlite_threshold_rows": SQLITE_THRESHOLD_ROWS,
            "native_extensions": sorted(NATIVE_EXTENSIONS),
            "data_extensions": sorted(DATA_EXTENSIONS),
            "spreadsheet_extensions": sorted(SPREADSHEET_EXTENSIONS),
            "document_extensions": sorted(DOCUMENT_EXTENSIONS),
            "web_extensions": sorted(WEB_EXTENSIONS),
            "code_log_extensions": sorted(CODE_LOG_EXTENSIONS),
            "output_kinds": ["markdown", "json", "sqlite"],
        }


def load_mdc_output_schema(repo_root: Path) -> dict[str, object]:
    schema_path = repo_root / "schemas" / "mdc-output-contract.schema.json"
    return json.loads(schema_path.read_text(encoding="utf-8"))
