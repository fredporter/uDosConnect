package contracts

import "testing"

func TestLoadNamedContractWorkflowState(t *testing.T) {
	contract, sourcePath, err := LoadNamedContract("workflow-state")
	if err != nil {
		t.Fatalf("load contract failed: %v", err)
	}

	if contract.Version != "v2.0.4" {
		t.Fatalf("expected v2.0.4, got %s", contract.Version)
	}

	if sourcePath == "" {
		t.Fatal("expected source path")
	}

	if len(contract.RequiredFields) == 0 {
		t.Fatal("expected required fields")
	}
}

func TestLoadNamedContractRejectsUnknownName(t *testing.T) {
	_, _, err := LoadNamedContract("unknown")
	if err == nil {
		t.Fatal("expected error for unknown contract")
	}
}
