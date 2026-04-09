package demoux

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

// RepoRoot returns the uDOS-shell module directory (contains go.mod).
func RepoRoot() (string, error) {
	wd, err := os.Getwd()
	if err != nil {
		return "", err
	}
	dir := wd
	for {
		if _, statErr := os.Stat(filepath.Join(dir, "go.mod")); statErr == nil {
			// Require this module name to avoid picking a parent monorepo go.mod.
			data, readErr := os.ReadFile(filepath.Join(dir, "go.mod"))
			if readErr == nil && strings.Contains(string(data), "module github.com/fredporter/uDOS-shell") {
				return dir, nil
			}
		}
		parent := filepath.Dir(dir)
		if parent == dir {
			break
		}
		dir = parent
	}
	return "", fmt.Errorf("uDOS-shell go.mod not found from %s", wd)
}

// ReadScreen loads a canonical screen fixture from demo/screens.
func ReadScreen(root, filename string) ([]byte, error) {
	path := filepath.Join(root, RelScreensDir, filename)
	return os.ReadFile(path)
}

// ReadComponent loads a component fixture from demo/components.
func ReadComponent(root, filename string) ([]byte, error) {
	path := filepath.Join(root, RelComponentsDir, filename)
	return os.ReadFile(path)
}

// ReadPatternsGallery loads the ASCII pattern gallery.
func ReadPatternsGallery(root string) ([]byte, error) {
	path := filepath.Join(root, RelPatternsDir, "gallery.txt")
	return os.ReadFile(path)
}
