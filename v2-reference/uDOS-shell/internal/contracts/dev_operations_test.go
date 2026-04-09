package contracts

import (
	"errors"
	"os"
	"strings"
	"testing"
)

func TestLoadDevOperationsDocOverview(t *testing.T) {
	body, sourcePath, err := LoadDevOperationsDoc("overview")
	if err != nil {
		if errors.Is(err, os.ErrNotExist) {
			t.Skipf("skip: dev operations doc missing at %s: %v", sourcePath, err)
		}
		t.Fatalf("LoadDevOperationsDoc(overview): %v", err)
	}
	if sourcePath == "" {
		t.Fatal("expected non-empty source path")
	}
	if !strings.Contains(body, "@dev Operations Module") {
		t.Fatalf("expected overview document body, got %q", body)
	}
}

func TestLoadDevOperationsDocRejectsUnknownName(t *testing.T) {
	_, _, err := LoadDevOperationsDoc("unknown")
	if err == nil {
		t.Fatal("expected unknown document error")
	}
}

func TestListDevOperationsDocs(t *testing.T) {
	docs := ListDevOperationsDocs()
	if len(docs) == 0 {
		t.Fatal("expected built-in dev operations docs")
	}
	if docs[0] != "overview" {
		t.Fatalf("expected overview first, got %q", docs[0])
	}
}
