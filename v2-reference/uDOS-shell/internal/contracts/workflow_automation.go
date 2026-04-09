package contracts

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
)

type MinimalContract struct {
	Version        string         `json:"version"`
	Owner          string         `json:"owner"`
	Schema         string         `json:"schema"`
	Summary        string         `json:"summary"`
	RequiredFields []string       `json:"required_fields"`
	StatusValues   []string       `json:"status_values,omitempty"`
	ActionValues   []string       `json:"action_values,omitempty"`
	Owners         map[string]any `json:"owners"`
}

func LoadNamedContract(name string) (MinimalContract, string, error) {
	filename, ok := contractFilenames[name]
	if !ok {
		return MinimalContract{}, "", fmt.Errorf("unknown contract %q", name)
	}

	wd, err := os.Getwd()
	if err != nil {
		return MinimalContract{}, "", fmt.Errorf("resolve working directory: %w", err)
	}

	repoRoot, err := findRepoRoot(wd)
	if err != nil {
		return MinimalContract{}, "", err
	}

	sourcePath := filepath.Join(repoRoot, "..", "uDOS-core", "contracts", filename)
	buf, err := os.ReadFile(sourcePath)
	if err != nil {
		return MinimalContract{}, sourcePath, fmt.Errorf("read contract: %w", err)
	}

	var contract MinimalContract
	if err := json.Unmarshal(buf, &contract); err != nil {
		return MinimalContract{}, sourcePath, fmt.Errorf("parse contract: %w", err)
	}

	return contract, sourcePath, nil
}

var contractFilenames = map[string]string{
	"workflow-state":    "workflow-state-contract.json",
	"workflow-action":   "workflow-action-contract.json",
	"automation-job":    "automation-job-contract.json",
	"automation-result": "automation-result-contract.json",
}
