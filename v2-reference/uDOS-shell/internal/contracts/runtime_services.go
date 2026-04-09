package contracts

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
)

type RuntimeService struct {
	Key       string   `json:"key"`
	Owner     string   `json:"owner"`
	Route     string   `json:"route"`
	Stability string   `json:"stability"`
	Consumers []string `json:"consumers"`
	Notes     string   `json:"notes"`
}

type RuntimeServiceManifest struct {
	Version  string           `json:"version"`
	Extends  string           `json:"extends"`
	Count    int              `json:"count"`
	Services []RuntimeService `json:"services"`
}

func LoadRuntimeServiceManifest() (RuntimeServiceManifest, string, error) {
	sourcePath, err := runtimeServiceSourcePath()
	if err != nil {
		return RuntimeServiceManifest{}, "", err
	}

	buf, err := os.ReadFile(sourcePath)
	if err != nil {
		return RuntimeServiceManifest{}, sourcePath, fmt.Errorf("read runtime services: %w", err)
	}

	var manifest RuntimeServiceManifest
	if err := json.Unmarshal(buf, &manifest); err != nil {
		return RuntimeServiceManifest{}, sourcePath, fmt.Errorf("parse runtime services: %w", err)
	}

	return manifest, sourcePath, nil
}

func runtimeServiceSourcePath() (string, error) {
	wd, err := os.Getwd()
	if err != nil {
		return "", fmt.Errorf("resolve working directory: %w", err)
	}

	repoRoot, err := findRepoRoot(wd)
	if err != nil {
		return "", err
	}

	return filepath.Join(repoRoot, "..", "uDOS-core", "contracts", "runtime-services.json"), nil
}

func findRepoRoot(start string) (string, error) {
	current := start

	for {
		candidate := filepath.Join(current, "go.mod")
		if _, err := os.Stat(candidate); err == nil {
			return current, nil
		}

		parent := filepath.Dir(current)
		if parent == current {
			return "", fmt.Errorf("could not find uDOS-shell repo root from %s", start)
		}

		current = parent
	}
}
