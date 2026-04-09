package localexec

import (
	"os"
	"path/filepath"
	"testing"
)

func TestRunSuccess(t *testing.T) {
	result, err := Run("printf 'ok'")
	if err != nil {
		t.Fatalf("expected success, got %v", err)
	}

	if result.Stdout != "ok" {
		t.Fatalf("expected stdout ok, got %q", result.Stdout)
	}
}

func TestRunFailure(t *testing.T) {
	result, err := Run("exit 7")
	if err == nil {
		t.Fatal("expected failure")
	}

	if result.ExitCode != 7 {
		t.Fatalf("expected exit code 7, got %d", result.ExitCode)
	}
}

func TestRunCoreScript(t *testing.T) {
	tmp := t.TempDir()
	scriptPath := filepath.Join(tmp, "startup-script.md")
	body := []byte("---\nid: startup\ntype: script\nversion: 2\nruntime: tui\n---\n\n```ucode\nSTATUS\n```\n")
	if err := os.WriteFile(scriptPath, body, 0o644); err != nil {
		t.Fatalf("write script: %v", err)
	}

	result, err := RunCoreScript(scriptPath)
	if err != nil {
		t.Fatalf("expected success, got %v, stderr=%s", err, result.Stderr)
	}
	if result.Stdout == "" {
		t.Fatal("expected stdout from core script run")
	}
}
