package contracts

import "testing"

func TestLoadKnowledgeStamp(t *testing.T) {
	stamp, err := LoadKnowledgeStamp()
	if err != nil {
		t.Fatalf("load knowledge stamp failed: %v", err)
	}

	if stamp.RuntimeServicesVersion == "" {
		t.Fatal("expected runtime services version")
	}

	if stamp.Contracts["workflow-state"] == "" {
		t.Fatal("expected workflow-state contract version")
	}
}
