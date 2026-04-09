from udos_core.render import RenderEngine, split_frontmatter
from udos_core.runtime import RuntimeKernel
from pathlib import Path
import os


def test_split_frontmatter_extracts_metadata_and_body():
    metadata, body = split_frontmatter(
        "---\n"
        "title: Demo Page\n"
        "prose_preset: prose-reference\n"
        "---\n"
        "# Heading\n\n"
        "Hello world.\n"
    )
    assert metadata["title"] == "Demo Page"
    assert metadata["prose_preset"] == "prose-reference"
    assert body.startswith("# Heading")


def test_render_engine_preview_resolves_thinui_shell_themes():
    engine = RenderEngine()
    preview = engine.preview(
        "---\n"
        "title: Thin Theme\n"
        "prose_preset: prose-default\n"
        "theme_adapter: thinui-c64\n"
        "---\n"
        "# Thin lane\n\n"
        "Body.\n",
        target="gui-preview",
    )
    assert preview["theme_adapter"] == "thinui-c64"
    assert preview["theme_tokens"]["background"] == "#4040a0"


def test_render_engine_preview_uses_frontmatter_and_semantic_html():
    engine = RenderEngine()

    preview = engine.preview(
        "---\n"
        "title: Demo Preview\n"
        "prose_preset: prose-reference\n"
        "---\n"
        "# Heading\n\n"
        "Paragraph copy.\n\n"
        "- one\n"
        "- two\n",
        target="web-prose",
    )

    assert preview["title"] == "Demo Preview"
    assert preview["prose_preset"] == "prose-reference"
    assert preview["theme_adapter"] == "public-sunset-prose"
    assert "<h1>Heading</h1>" in preview["html"]
    assert "<ul><li>one</li><li>two</li></ul>" in preview["html"]


def test_runtime_kernel_exposes_render_contract_and_preview_commands():
    kernel = RuntimeKernel()

    contract = kernel.execute("#render contract")
    assert contract["ok"] is True
    assert contract["data"]["render_contract"]["version"] == "v2.0.3"

    preview = kernel.execute(
        "#render preview target:gui-preview title:Preview body:Hello"
    )
    assert preview["ok"] is True
    payload = preview["data"]["preview"]
    assert payload["target"] == "gui-preview"
    assert payload["theme_adapter"] == "public-sunset"
    assert "<h1>Preview</h1>" in payload["html"]


def test_render_engine_export_writes_html_and_manifest():
    temp_root = Path.cwd() / ".tmp-render-test"
    os.environ["UDOS_RENDER_ROOT"] = str(temp_root)
    try:
        engine = RenderEngine()
        result = engine.export(
            "---\n"
            "title: Export Demo\n"
            "prose_preset: prose-default\n"
            "---\n"
            "# Export Demo\n\n"
            "Saved output.\n",
            target="web-prose",
        )
    finally:
        os.environ.pop("UDOS_RENDER_ROOT", None)

    manifest = result["manifest"]
    html_path = Path(manifest["output_path"])
    manifest_path = Path(manifest["manifest_path"])
    assert html_path.exists()
    assert manifest_path.exists()
    assert "Export Demo" in html_path.read_text(encoding="utf-8")
    assert manifest["target"] == "web-prose"


def test_runtime_kernel_exposes_exports_command():
    kernel = RuntimeKernel()
    result = kernel.execute("#render exports")
    assert result["ok"] is True
    assert isinstance(result["data"]["exports"], list)


def test_render_engine_export_uses_configured_render_root(tmp_path: Path):
    os.environ["UDOS_RENDER_ROOT"] = str(tmp_path / "render-root")
    try:
        engine = RenderEngine()
        result = engine.export("# Export Demo\n\nSaved output.\n", target="web-prose")
    finally:
        os.environ.pop("UDOS_RENDER_ROOT", None)

    html_path = Path(result["manifest"]["output_path"])
    assert html_path.is_relative_to((tmp_path / "render-root").resolve())
