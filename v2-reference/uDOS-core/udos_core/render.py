from __future__ import annotations

import html
import json
import re
from pathlib import Path

from .dev_config import core_repo_root, render_root


def _core_memory_root() -> Path:
    return render_root(repo_root=core_repo_root())


def _load_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


def _load_theme_maps() -> dict[str, dict]:
    themes_root = core_repo_root() / "config" / "render"
    return {
        "shell": _load_json(themes_root / "shell-theme-map.json"),
        "publishing": _load_json(themes_root / "publishing-theme-map.json"),
        "prose": _load_json(themes_root / "prose-preset-map.json"),
        "gameplay": _load_json(themes_root / "gameplay-skin-map.json"),
    }


def _parse_frontmatter_value(raw: str):
    value = raw.strip()
    if value.startswith("[") and value.endswith("]"):
        inner = value[1:-1].strip()
        if not inner:
            return []
        return [item.strip().strip('"').strip("'") for item in inner.split(",")]
    if value.lower() in {"true", "false"}:
        return value.lower() == "true"
    return value.strip('"').strip("'")


def split_frontmatter(markdown_text: str) -> tuple[dict, str]:
    raw = markdown_text.lstrip()
    if not raw.startswith("---\n"):
        return {}, markdown_text

    lines = raw.splitlines()
    metadata: dict[str, object] = {}
    closing_index = None
    for index, line in enumerate(lines[1:], start=1):
        if line.strip() == "---":
            closing_index = index
            break
        if ":" not in line:
            continue
        key, value = line.split(":", 1)
        metadata[key.strip()] = _parse_frontmatter_value(value)

    if closing_index is None:
        return {}, markdown_text

    body = "\n".join(lines[closing_index + 1 :]).lstrip("\n")
    return metadata, body


def _slugify(text: str) -> str:
    slug = re.sub(r"[^a-z0-9]+", "-", text.lower()).strip("-")
    return slug or "untitled"


def _strip_markdown(text: str) -> str:
    plain = re.sub(r"[#*_`>\[\]\(\)-]", " ", text)
    return re.sub(r"\s+", " ", plain).strip()


def markdown_to_semantic_html(markdown_text: str) -> str:
    lines = markdown_text.splitlines()
    html_parts: list[str] = []
    paragraph: list[str] = []
    list_items: list[str] = []

    def flush_paragraph() -> None:
        if not paragraph:
            return
        content = " ".join(item.strip() for item in paragraph if item.strip())
        if content:
            html_parts.append(f"<p>{html.escape(content)}</p>")
        paragraph.clear()

    def flush_list() -> None:
        if not list_items:
            return
        items = "".join(f"<li>{html.escape(item)}</li>" for item in list_items)
        html_parts.append(f"<ul>{items}</ul>")
        list_items.clear()

    for raw_line in lines:
        line = raw_line.rstrip()
        stripped = line.strip()
        if not stripped:
            flush_paragraph()
            flush_list()
            continue

        if stripped.startswith("#"):
            flush_paragraph()
            flush_list()
            level = min(len(stripped) - len(stripped.lstrip("#")), 6)
            content = stripped[level:].strip()
            html_parts.append(f"<h{level}>{html.escape(content)}</h{level}>")
            continue

        if stripped.startswith("- "):
            flush_paragraph()
            list_items.append(stripped[2:].strip())
            continue

        paragraph.append(stripped)

    flush_paragraph()
    flush_list()
    return "\n".join(html_parts)


class RenderEngine:
    def __init__(self) -> None:
        self._contract = _load_json(core_repo_root() / "contracts" / "render-contract.json")
        self._theme_maps = _load_theme_maps()
        self._export_root = _core_memory_root()

    def contract(self) -> dict:
        return self._contract

    def prose_presets(self) -> list[dict]:
        return list(self._theme_maps["prose"]["presets"])

    def theme_adapters(self) -> dict[str, list[dict]]:
        return {
            "shell": list(self._theme_maps["shell"]["themes"]),
            "publishing": list(self._theme_maps["publishing"]["themes"]),
        }

    def gameplay_skins(self) -> list[dict]:
        return list(self._theme_maps["gameplay"]["skins"])

    def preview(
        self,
        markdown_text: str,
        metadata: dict | None = None,
        target: str = "gui-preview",
    ) -> dict:
        frontmatter, body = split_frontmatter(markdown_text)
        merged_metadata = {**frontmatter, **(metadata or {})}
        title = str(merged_metadata.get("title", "Untitled"))
        prose_preset = str(merged_metadata.get("prose_preset", "prose-default"))
        skin_id = str(merged_metadata.get("skin_id", "") or "")
        lens_id = str(merged_metadata.get("lens_id", "") or "")
        theme = self._select_theme_adapter(target=target, metadata=merged_metadata)
        html_output = markdown_to_semantic_html(body)
        summary = self._extract_summary(body)
        preset = self._find_prose_preset(prose_preset)

        return {
            "target": target,
            "title": title,
            "slug": _slugify(title),
            "summary": summary,
            "metadata": merged_metadata,
            "prose_preset": preset["id"],
            "theme_adapter": theme["theme"],
            "theme_tokens": theme["tokens"],
            "skin_id": skin_id,
            "lens_id": lens_id,
            "viewer_controls": self._theme_maps["prose"]["viewer_controls"],
            "html": html_output,
        }

    def export(
        self,
        markdown_text: str,
        metadata: dict | None = None,
        target: str = "web-prose",
    ) -> dict:
        preview = self.preview(markdown_text=markdown_text, metadata=metadata, target=target)
        export_dir = self._export_root / target / preview["slug"]
        export_dir.mkdir(parents=True, exist_ok=True)

        html_path = export_dir / "index.html"
        manifest_path = export_dir / "manifest.json"
        document = self._wrap_html_document(preview)
        html_path.write_text(document, encoding="utf-8")

        manifest = {
            "target": preview["target"],
            "title": preview["title"],
            "slug": preview["slug"],
            "theme_adapter": preview["theme_adapter"],
            "prose_preset": preview["prose_preset"],
            "summary": preview["summary"],
            "content_type": "text/html",
            "output_path": str(html_path),
            "manifest_path": str(manifest_path),
            "skin_id": preview["skin_id"],
            "lens_id": preview["lens_id"],
        }
        manifest_path.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")

        return {
            "preview": preview,
            "manifest": manifest,
        }

    def list_exports(self) -> list[dict]:
        if not self._export_root.exists():
            return []

        exports: list[dict] = []
        for manifest_path in sorted(self._export_root.glob("*/*/manifest.json")):
            payload = _load_json(manifest_path)
            html_path = Path(payload["output_path"])
            exports.append(
                {
                    **payload,
                    "exists": html_path.exists(),
                    "relative_html_path": html_path.relative_to(self._export_root).as_posix(),
                }
            )
        return exports

    def export_detail(self, target: str, slug: str) -> dict:
        manifest_path = self._export_root / target / slug / "manifest.json"
        if not manifest_path.exists():
            return {"found": False, "target": target, "slug": slug}
        payload = _load_json(manifest_path)
        html_path = Path(payload["output_path"])
        return {
            "found": True,
            "manifest": {
                **payload,
                "exists": html_path.exists(),
                "relative_html_path": html_path.relative_to(self._export_root).as_posix() if html_path.exists() else "",
            },
        }

    def _find_prose_preset(self, preset_id: str) -> dict:
        for preset in self._theme_maps["prose"]["presets"]:
            if preset["id"] == preset_id:
                return preset
        return self._theme_maps["prose"]["presets"][0]

    def _select_theme_adapter(self, target: str, metadata: dict) -> dict:
        explicit = metadata.get("theme_adapter")
        if explicit:
            for lane in ("publishing", "shell"):
                for theme in self._theme_maps[lane]["themes"]:
                    if theme["theme"] == explicit:
                        return theme

        if target == "email-html":
            for theme in self._theme_maps["publishing"]["themes"]:
                if theme.get("adapter") == "email-safe":
                    return theme

        if target == "web-prose" or target == "beacon-library":
            return self._theme_maps["publishing"]["themes"][0]

        return self._theme_maps["shell"]["themes"][0]

    def _extract_summary(self, markdown_text: str) -> str:
        for line in markdown_text.splitlines():
            stripped = line.strip()
            if not stripped or stripped.startswith("#") or stripped.startswith("- "):
                continue
            return _strip_markdown(stripped)
        return ""

    def _wrap_html_document(self, preview: dict) -> str:
        fonts = self._find_prose_preset(preview["prose_preset"])
        tokens = preview["theme_tokens"]
        return f"""<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>{html.escape(preview["title"])}</title>
    <style>
      :root {{
        --accent: {tokens.get("accent", "#b84a2c")};
        --background: {tokens.get("background", "#fff8ef")};
        --foreground: {tokens.get("foreground", "#2b241f")};
        --border: {tokens.get("border", "#ddc4a6")};
      }}
      body {{
        margin: 0 auto;
        max-width: 760px;
        padding: 48px 20px 64px;
        background: var(--background);
        color: var(--foreground);
        font-family: {fonts["body_font_family"]};
        line-height: 1.7;
      }}
      h1, h2, h3, h4, h5, h6 {{
        font-family: {fonts["heading_font_family"]};
        line-height: 1.15;
      }}
      a {{
        color: var(--accent);
      }}
      .udos-meta {{
        margin-bottom: 24px;
        padding-bottom: 16px;
        border-bottom: 1px solid var(--border);
        color: var(--accent);
        font: 12px "IBM Plex Sans", sans-serif;
        letter-spacing: 0.08em;
        text-transform: uppercase;
      }}
    </style>
  </head>
  <body>
    <div class="udos-meta">{html.escape(preview["target"])} / {html.escape(preview["theme_adapter"])}</div>
    {preview["html"]}
  </body>
</html>
"""
