from udos_core.ucode import parse_ucode

def test_parse_binder_create():
    parsed = parse_ucode("#binder create client-acme")
    assert parsed.namespace == "binder"
    assert parsed.action == "create"
    assert parsed.args["items"] == "client-acme"


def test_parse_set_uppercase_verb():
    parsed = parse_ucode("SET system.status startup")
    assert parsed.namespace == "state"
    assert parsed.action == "set"
    assert parsed.args["target"] == "system.status"
    assert parsed.args["value"] == "startup"


def test_parse_draw_pat_text_uppercase_verb():
    parsed = parse_ucode('DRAW PAT TEXT "Startup ready"')
    assert parsed.namespace == "draw"
    assert parsed.action == "render"
    assert parsed.args["mode"] == "pat"
    assert parsed.args["pattern_type"] == "text"
    assert parsed.args["value"] == "Startup ready"


def test_parse_script_run_uppercase_verb():
    parsed = parse_ucode("SCRIPT RUN ./startup-script.md")
    assert parsed.namespace == "script"
    assert parsed.action == "run"
    assert parsed.args["path"] == "./startup-script.md"
