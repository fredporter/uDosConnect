from pathlib import Path

from udos_core.runtime import RuntimeKernel


def test_set_happy_path_updates_runtime_state():
    kernel = RuntimeKernel()

    result = kernel.execute("SET system.status startup")

    assert result["ok"] is True
    assert result["data"]["state"]["target"] == "system.status"
    assert result["data"]["state"]["value"] == "startup"


def test_set_error_path_requires_target_and_value():
    kernel = RuntimeKernel()

    result = kernel.execute("SET")

    assert result["ok"] is False
    assert "missing state target" in result["errors"]


def test_status_happy_path_reports_snapshot():
    kernel = RuntimeKernel()
    kernel.execute("SET system.status startup")

    result = kernel.execute("STATUS")

    assert result["ok"] is True
    assert result["data"]["status"]["state"]["system.status"] == "startup"


def test_status_error_path_invalid_syntax_is_rejected():
    kernel = RuntimeKernel()

    result = kernel.execute('STATUS "unterminated')

    assert result["ok"] is False
    assert "invalid ucode syntax" in result["errors"]


def test_workflow_run_happy_path_enqueues_running_workflow():
    kernel = RuntimeKernel()

    result = kernel.execute("WORKFLOW RUN onboarding")

    assert result["ok"] is True
    assert result["data"]["workflow"]["target"] == "onboarding"
    assert result["data"]["workflow"]["state"] == "running"


def test_workflow_run_error_path_requires_target():
    kernel = RuntimeKernel()

    result = kernel.execute("WORKFLOW RUN")

    assert result["ok"] is False
    assert "missing workflow target" in result["errors"]


def test_draw_block_happy_path_loads_ascii_asset(tmp_path: Path):
    asset = tmp_path / "boot.txt"
    asset.write_text("READY\n", encoding="utf-8")
    kernel = RuntimeKernel()

    result = kernel.execute(f"DRAW BLOCK {asset}")

    assert result["ok"] is True
    assert result["data"]["draw"]["content"] == "READY\n"


def test_draw_block_error_path_requires_existing_asset(tmp_path: Path):
    kernel = RuntimeKernel()

    result = kernel.execute(f"DRAW BLOCK {tmp_path / 'missing.txt'}")

    assert result["ok"] is False
    assert "draw block not found:" in result["errors"][0]


def test_draw_pat_text_happy_path_renders_ascii_box():
    kernel = RuntimeKernel()

    result = kernel.execute('DRAW PAT TEXT "Startup ready"')

    assert result["ok"] is True
    rendered = result["data"]["draw"]["rendered"]
    assert "Startup ready" in rendered
    assert rendered.startswith("+")


def test_draw_pat_text_error_path_requires_value():
    kernel = RuntimeKernel()

    result = kernel.execute("DRAW PAT TEXT")

    assert result["ok"] is False
    assert "missing draw pat text value" in result["errors"]


def test_run_script_happy_path_executes_ucode_blocks(tmp_path: Path):
    asset = tmp_path / "boot.txt"
    asset.write_text("READY\n", encoding="utf-8")
    script = tmp_path / "startup-script.md"
    script.write_text(
        "\n".join(
            [
                "---",
                "id: startup",
                "type: script",
                "version: 2",
                "runtime: tui",
                "---",
                "",
                "```ucode",
                "SET system.status startup",
                f"DRAW BLOCK {asset}",
                "WORKFLOW RUN onboarding",
                "STATUS",
                "```",
                "",
            ]
        ),
        encoding="utf-8",
    )
    kernel = RuntimeKernel()

    result = kernel.execute(f"RUN {script}")

    assert result["ok"] is True
    executed = result["data"]["script"]["executed"]
    assert [step["statement"] for step in executed] == [
        "SET system.status startup",
        f"DRAW BLOCK {asset}",
        "WORKFLOW RUN onboarding",
        "STATUS",
    ]


def test_run_script_error_path_requires_valid_frontmatter(tmp_path: Path):
    script = tmp_path / "broken-script.md"
    script.write_text(
        "\n".join(
            [
                "---",
                "id: broken",
                "type: note",
                "version: 2",
                "runtime: tui",
                "---",
                "",
                "```ucode",
                "STATUS",
                "```",
                "",
            ]
        ),
        encoding="utf-8",
    )
    kernel = RuntimeKernel()

    result = kernel.execute(f"RUN {script}")

    assert result["ok"] is False
    assert "frontmatter type must be 'script'" in result["errors"]
