package contracts

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
)

type GridContract struct {
	Version        string   `json:"version"`
	Owner          string   `json:"owner"`
	Summary        string   `json:"summary"`
	RequiredFields []string `json:"required_fields"`
	OptionalFields []string `json:"optional_fields,omitempty"`
	Consumers      []string `json:"consumers,omitempty"`
}

type GridSeedRecord map[string]any

func LoadGridContract(name string) (GridContract, string, error) {
	filename, ok := gridContractFilenames[name]
	if !ok {
		return GridContract{}, "", fmt.Errorf("unknown grid contract %q", name)
	}

	sourcePath, err := gridSourcePath("contracts", filename)
	if err != nil {
		return GridContract{}, "", err
	}

	buf, err := os.ReadFile(sourcePath)
	if err != nil {
		return GridContract{}, sourcePath, fmt.Errorf("read grid contract: %w", err)
	}

	var contract GridContract
	if err := json.Unmarshal(buf, &contract); err != nil {
		return GridContract{}, sourcePath, fmt.Errorf("parse grid contract: %w", err)
	}

	return contract, sourcePath, nil
}

func LoadGridSeed(name string) ([]GridSeedRecord, string, error) {
	filename, ok := gridSeedFilenames[name]
	if !ok {
		return nil, "", fmt.Errorf("unknown grid seed %q", name)
	}

	sourcePath, err := gridSourcePath("seed", filename)
	if err != nil {
		return nil, "", err
	}

	buf, err := os.ReadFile(sourcePath)
	if err != nil {
		return nil, sourcePath, fmt.Errorf("read grid seed: %w", err)
	}

	var records []GridSeedRecord
	if err := json.Unmarshal(buf, &records); err != nil {
		return nil, sourcePath, fmt.Errorf("parse grid seed: %w", err)
	}

	return records, sourcePath, nil
}

func gridSourcePath(dir string, filename string) (string, error) {
	wd, err := os.Getwd()
	if err != nil {
		return "", fmt.Errorf("resolve working directory: %w", err)
	}

	repoRoot, err := findRepoRoot(wd)
	if err != nil {
		return "", err
	}

	return filepath.Join(repoRoot, "..", "uDOS-grid", dir, filename), nil
}

var gridContractFilenames = map[string]string{
	"grid-place":    "place-record.contract.json",
	"grid-layer":    "layer-record.contract.json",
	"grid-artifact": "artifact-record.contract.json",
}

var gridSeedFilenames = map[string]string{
	"layers":    "basic-layer-registry.json",
	"places":    "basic-place-registry.json",
	"artifacts": "basic-artifact-registry.json",
}
