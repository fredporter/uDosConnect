package contracts

import "testing"

func TestLoadGridContractPlace(t *testing.T) {
	contract, sourcePath, err := LoadGridContract("grid-place")
	if err != nil {
		t.Fatalf("load grid contract failed: %v", err)
	}

	if contract.Owner != "uDOS-grid" {
		t.Fatalf("expected owner uDOS-grid, got %s", contract.Owner)
	}

	if sourcePath == "" {
		t.Fatal("expected source path")
	}

	if len(contract.RequiredFields) == 0 {
		t.Fatal("expected required fields")
	}
}

func TestLoadGridSeedPlaces(t *testing.T) {
	records, sourcePath, err := LoadGridSeed("places")
	if err != nil {
		t.Fatalf("load grid seed failed: %v", err)
	}

	if sourcePath == "" {
		t.Fatal("expected source path")
	}

	if len(records) == 0 {
		t.Fatal("expected seed records")
	}
}

func TestLoadGridContractRejectsUnknownName(t *testing.T) {
	_, _, err := LoadGridContract("unknown")
	if err == nil {
		t.Fatal("expected error for unknown grid contract")
	}
}

func TestLoadGridSeedRejectsUnknownName(t *testing.T) {
	_, _, err := LoadGridSeed("unknown")
	if err == nil {
		t.Fatal("expected error for unknown grid seed")
	}
}
