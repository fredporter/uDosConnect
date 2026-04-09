from pathlib import Path

from udos_core.mdc import MdcEngine, classify_path
from udos_core.runtime import RuntimeKernel


def test_classify_path_recognizes_web_category(tmp_path: Path):
    path = tmp_path / "demo.html"
    path.write_text("<h1>Hello</h1>", encoding="utf-8")

    result = classify_path(path)

    assert result["category"] == "web"
    assert result["markdown_generated"] is True
    assert result["source_modified"] is False


def test_normalize_small_csv_routes_structured_output_to_json(tmp_path: Path):
    path = tmp_path / "people.csv"
    path.write_text("name,role\nAda,Engineer\nBob,Ops\n", encoding="utf-8")
    engine = MdcEngine()

    normalized = engine.normalize(path)

    assert normalized["classifier"] == "data"
    assert normalized["outputs"][0]["kind"] == "markdown"
    assert normalized["outputs"][1]["kind"] == "json"
    assert normalized["metadata"]["row_count"] == 2
    assert normalized["metadata"]["column_count"] == 2
    assert normalized["vault_routing"]["persist_original"] is True


def test_normalize_large_csv_routes_structured_output_to_sqlite(tmp_path: Path):
    path = tmp_path / "large.csv"
    rows = ["name,role"] + [f"user-{index},ops" for index in range(5001)]
    path.write_text("\n".join(rows) + "\n", encoding="utf-8")
    engine = MdcEngine()

    normalized = engine.normalize(path)

    assert normalized["outputs"][1]["kind"] == "sqlite"


def test_normalize_html_strips_tags_into_markdown_body(tmp_path: Path):
    path = tmp_path / "page.html"
    path.write_text("<h1>Heading</h1><p>Hello world</p>", encoding="utf-8")
    engine = MdcEngine()

    normalized = engine.normalize(path)

    assert normalized["markdown"] == "Heading Hello world"


def test_normalize_json_generates_summary_markdown_and_keys(tmp_path: Path):
    path = tmp_path / "binder.json"
    path.write_text('{"title":"Launch","status":"active"}', encoding="utf-8")
    engine = MdcEngine()

    normalized = engine.normalize(path)

    assert normalized["markdown"].startswith("# JSON Document")
    assert normalized["metadata"]["top_level_keys"] == ["status", "title"]


def test_normalize_xml_flattens_tags_into_text(tmp_path: Path):
    path = tmp_path / "binder.xml"
    path.write_text("<binder><title>Launch</title><status>active</status></binder>", encoding="utf-8")
    engine = MdcEngine()

    normalized = engine.normalize(path)

    assert normalized["markdown"] == "Launch active"


def test_normalize_pdf_uses_text_only_extraction(tmp_path: Path):
    path = tmp_path / "brief.pdf"
    path.write_text("Line one\n\nLine two", encoding="utf-8")
    engine = MdcEngine()

    normalized = engine.normalize(path)

    assert normalized["classifier"] == "document"
    assert normalized["markdown"] == "Line one Line two"


def test_normalize_rtf_strips_control_markup(tmp_path: Path):
    path = tmp_path / "brief.rtf"
    path.write_text(r"{\rtf1\ansi Launch \b active \b0 plan}", encoding="utf-8")
    engine = MdcEngine()

    normalized = engine.normalize(path)

    assert normalized["markdown"] == "Launch active plan"


def test_normalize_docx_flattens_xml_like_text(tmp_path: Path):
    path = tmp_path / "brief.docx"
    path.write_text("<w:document><w:p>Launch</w:p><w:p>Active</w:p></w:document>", encoding="utf-8")
    engine = MdcEngine()

    normalized = engine.normalize(path)

    assert normalized["markdown"] == "Launch Active"


def test_runtime_kernel_exposes_mdc_contract_and_normalize_commands(tmp_path: Path):
    path = tmp_path / "notes.log"
    path.write_text("hello\nworld\n", encoding="utf-8")
    kernel = RuntimeKernel()

    contract = kernel.execute("#mdc contract")
    assert contract["ok"] is True
    assert contract["data"]["mdc"]["sqlite_threshold_rows"] == 5000

    classify = kernel.execute(f"#mdc classify source:{path}")
    assert classify["ok"] is True
    assert classify["data"]["classification"]["category"] == "code-log"

    normalized = kernel.execute(f"#mdc normalize source:{path}")
    assert normalized["ok"] is True
    assert normalized["data"]["normalized"]["outputs"][0]["kind"] == "markdown"
