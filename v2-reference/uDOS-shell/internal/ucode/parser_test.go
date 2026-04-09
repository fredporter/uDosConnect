package ucode

import "testing"

func TestParseNamespaceCommand(t *testing.T) {
	command := Parse(`#wizard assist topic:shell "hello world"`)

	if command.Namespace != "wizard" {
		t.Fatalf("expected namespace wizard, got %s", command.Namespace)
	}

	if command.Action != "assist" {
		t.Fatalf("expected action assist, got %s", command.Action)
	}

	if command.Args["topic"] != "shell" {
		t.Fatalf("expected topic arg shell, got %s", command.Args["topic"])
	}

	if command.Args["items"] != "hello world" {
		t.Fatalf("expected positional items, got %s", command.Args["items"])
	}
}

func TestParsePlainCommand(t *testing.T) {
	command := Parse("open workspace")

	if command.Namespace != "system" {
		t.Fatalf("expected namespace system, got %s", command.Namespace)
	}

	if command.Action != "open" {
		t.Fatalf("expected action open, got %s", command.Action)
	}

	if command.Args["items"] != "workspace" {
		t.Fatalf("expected positional workspace, got %s", command.Args["items"])
	}
}

func TestParseUppercaseRunScriptCommand(t *testing.T) {
	command := Parse("RUN ./startup-script.md")

	if command.Namespace != "script" {
		t.Fatalf("expected namespace script, got %s", command.Namespace)
	}
	if command.Action != "run" {
		t.Fatalf("expected action run, got %s", command.Action)
	}
	if command.Args["path"] != "./startup-script.md" {
		t.Fatalf("expected script path, got %q", command.Args["path"])
	}
}
