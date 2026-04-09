package demoux

import (
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/fredporter/uDOS-shell/demo/components"
	"github.com/fredporter/uDOS-shell/demo/patterns"
	"github.com/fredporter/uDOS-shell/demo/screens"
)

func TestGoldenScreensMatchDisk(t *testing.T) {
	root, err := RepoRoot()
	if err != nil {
		t.Fatalf("RepoRoot: %v", err)
	}

	entries, err := screens.Golden.ReadDir(".")
	if err != nil {
		t.Fatalf("embed screens: %v", err)
	}

	for _, e := range entries {
		if e.IsDir() {
			continue
		}
		name := e.Name()
		if filepath.Ext(name) != ".txt" {
			continue
		}
		emb, err := screens.Golden.ReadFile(name)
		if err != nil {
			t.Fatalf("read embed %s: %v", name, err)
		}
		disk, err := ReadScreen(root, name)
		if err != nil {
			t.Fatalf("read disk %s: %v", name, err)
		}
		if string(emb) != string(disk) {
			t.Fatalf("screen %s: embedded bytes differ from demo/screens (regenerate or sync fixtures)", name)
		}
	}
}

func TestGoldenComponentsMatchDisk(t *testing.T) {
	root, err := RepoRoot()
	if err != nil {
		t.Fatalf("RepoRoot: %v", err)
	}

	entries, err := components.Golden.ReadDir(".")
	if err != nil {
		t.Fatalf("embed components: %v", err)
	}

	for _, e := range entries {
		if e.IsDir() {
			continue
		}
		name := e.Name()
		if filepath.Ext(name) != ".txt" {
			continue
		}
		emb, err := components.Golden.ReadFile(name)
		if err != nil {
			t.Fatalf("read embed %s: %v", name, err)
		}
		path := filepath.Join(root, RelComponentsDir, name)
		disk, err := os.ReadFile(path)
		if err != nil {
			t.Fatalf("read disk %s: %v", name, err)
		}
		if string(emb) != string(disk) {
			t.Fatalf("component %s: embedded bytes differ from demo/components", name)
		}
	}
}

func TestGoldenPatternsGalleryMatchDisk(t *testing.T) {
	root, err := RepoRoot()
	if err != nil {
		t.Fatalf("RepoRoot: %v", err)
	}
	disk, err := ReadPatternsGallery(root)
	if err != nil {
		t.Fatalf("ReadPatternsGallery: %v", err)
	}
	emb, err := patterns.Golden.ReadFile("gallery.txt")
	if err != nil {
		t.Fatalf("embed gallery: %v", err)
	}
	if string(emb) != string(disk) {
		t.Fatal("patterns gallery: embedded bytes differ from demo/patterns/gallery.txt")
	}
}

func TestScreenScenesCoverAllFixtureFiles(t *testing.T) {
	root, err := RepoRoot()
	if err != nil {
		t.Fatalf("RepoRoot: %v", err)
	}
	dir := filepath.Join(root, RelScreensDir)
	files, err := filepath.Glob(filepath.Join(dir, "*.txt"))
	if err != nil {
		t.Fatal(err)
	}
	seen := map[string]bool{}
	for _, sc := range ScreenScenes {
		seen[sc.Filename] = true
	}
	for _, full := range files {
		base := filepath.Base(full)
		if !seen[base] {
			t.Errorf("demo/screens/%s is not listed in ScreenScenes — add scene or remove orphan", base)
		}
	}
	if len(files) != len(ScreenScenes) {
		t.Errorf("screen count mismatch: glob=%d ScreenScenes=%d", len(files), len(ScreenScenes))
	}
}

func TestCanonicalScreenLayoutMarkers(t *testing.T) {
	root, err := RepoRoot()
	if err != nil {
		t.Fatalf("RepoRoot: %v", err)
	}

	for _, sc := range ScreenScenes {
		t.Run(sc.ID, func(t *testing.T) {
			data, err := ReadScreen(root, sc.Filename)
			if err != nil {
				t.Fatal(err)
			}
			s := string(data)
			if !strings.Contains(s, "| MENU") {
				t.Error("expected | MENU column header")
			}
			if !strings.Contains(s, "| WORKSPACE") {
				t.Error("expected | WORKSPACE column header")
			}
			if !strings.Contains(s, "| CONTEXT") {
				t.Error("expected | CONTEXT column header")
			}
			if !strings.Contains(s, "| PROMPT") {
				t.Error("expected | PROMPT bar")
			}
			if !strings.Contains(s, "+--") {
				t.Error("expected box-drawing frame (+--)")
			}
		})
	}
}
