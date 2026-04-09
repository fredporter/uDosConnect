package contracts

import (
	"fmt"
	"os"
	"path/filepath"
)

func LoadDevOperationsDoc(name string) (string, string, error) {
	relativePath, ok := devOperationsDocs[name]
	if !ok {
		return "", "", fmt.Errorf("unknown dev operations document %q", name)
	}

	wd, err := os.Getwd()
	if err != nil {
		return "", "", fmt.Errorf("resolve working directory: %w", err)
	}

	repoRoot, err := findRepoRoot(wd)
	if err != nil {
		return "", "", err
	}

	sourcePath := filepath.Join(repoRoot, "..", "uDOS-dev", relativePath)
	buf, err := os.ReadFile(sourcePath)
	if err != nil {
		return "", sourcePath, fmt.Errorf("read dev operations document: %w", err)
	}

	return string(buf), sourcePath, nil
}

func ListDevOperationsDocs() []string {
	return []string{
		"overview",
		"mcp-support",
		"runbook",
		"resilience-runbook",
		"operation-modes",
		"launch-matrix",
		"archive-gate",
		"container-patterns",
	}
}

var devOperationsDocs = map[string]string{
	"overview":           "@dev/operations/README.md",
	"mcp-support":        "@dev/operations/mcp/ok-assist-mcp-support.md",
	"runbook":            "@dev/operations/runbooks/v2.1-operations-runbook.md",
	"resilience-runbook": "@dev/operations/runbooks/v2.0.8-dev-resilience-runbook.md",
	"operation-modes":    "@dev/operations/checklists/v2.1-ok-assist-operation-modes.md",
	"launch-matrix":      "@dev/operations/checklists/v2.1-launch-and-capability-matrix.md",
	"archive-gate":       "@dev/operations/checklists/v2.1-archive-decommission-gate.md",
	"container-patterns": "@dev/operations/checklists/v2.1-container-run-patterns.md",
}
