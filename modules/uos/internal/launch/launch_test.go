package launch

import (
	"os"
	"path/filepath"
	"testing"
)

func TestResolveFilePlaceholder_underWorkspace(t *testing.T) {
	t.Parallel()
	root := t.TempDir()
	if err := os.WriteFile(filepath.Join(root, "pic.png"), []byte("x"), 0o644); err != nil {
		t.Fatal(err)
	}
	extra, cref, err := resolveFilePlaceholder(root, filepath.Join(root, "pic.png"))
	if err != nil {
		t.Fatal(err)
	}
	if len(extra) != 0 {
		t.Fatalf("expected no extra binds, got %+v", extra)
	}
	if want := "/workspace/pic.png"; cref != want {
		t.Fatalf("cref: got %q want %q", cref, want)
	}
}

func TestResolveFilePlaceholder_outsideWorkspace_file(t *testing.T) {
	t.Parallel()
	wd := t.TempDir()
	out := t.TempDir()
	f := filepath.Join(out, "x.png")
	if err := os.WriteFile(f, []byte("x"), 0o644); err != nil {
		t.Fatal(err)
	}
	extra, cref, err := resolveFilePlaceholder(wd, f)
	if err != nil {
		t.Fatal(err)
	}
	if len(extra) != 1 {
		t.Fatalf("expected 1 extra bind, got %+v", extra)
	}
	if extra[0].host != f || extra[0].container != "/workspace/.uos-outside" || !extra[0].readonly {
		t.Fatalf("unexpected bind %+v", extra[0])
	}
	if cref != "/workspace/.uos-outside" {
		t.Fatalf("cref: got %q", cref)
	}
}

func TestResolveFilePlaceholder_cwdDot(t *testing.T) {
	t.Parallel()
	root := t.TempDir()
	extra, cref, err := resolveFilePlaceholder(root, root)
	if err != nil {
		t.Fatal(err)
	}
	if len(extra) != 0 {
		t.Fatalf("expected no extra binds, got %+v", extra)
	}
	if cref != "/workspace" {
		t.Fatalf("cref: got %q want /workspace", cref)
	}
}

func TestResolveFilePlaceholder_missingOutsideWorkspace(t *testing.T) {
	t.Parallel()
	wd := t.TempDir()
	missing := filepath.Join(t.TempDir(), "nope.png")
	extra, cref, err := resolveFilePlaceholder(wd, missing)
	if err != nil {
		t.Fatal(err)
	}
	if len(extra) != 1 || extra[0].host != missing {
		t.Fatalf("expected bind for missing path, got %+v", extra)
	}
	if cref != "/workspace/.uos-outside" {
		t.Fatalf("cref: got %q", cref)
	}
}
