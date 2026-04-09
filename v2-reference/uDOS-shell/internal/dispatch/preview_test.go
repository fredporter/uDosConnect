package dispatch

import (
	"testing"

	"github.com/fredporter/uDOS-shell/internal/ucode"
)

func TestRenderPreviewWizardRoute(t *testing.T) {
	preview, err := RenderPreview(ucode.Parse("#wizard assist topic:shell"))
	if err != nil {
		t.Fatalf("render preview failed: %v", err)
	}

	if preview.Route != "uDOS-wizard" {
		t.Fatalf("expected wizard route, got %s", preview.Route)
	}

	if preview.RuntimeService != "runtime.capability-registry" {
		t.Fatalf("expected capability registry, got %s", preview.RuntimeService)
	}
}

func TestRenderPreviewCoreRoute(t *testing.T) {
	preview, err := RenderPreview(ucode.Parse("open workspace"))
	if err != nil {
		t.Fatalf("render preview failed: %v", err)
	}

	if preview.Route != "uDOS-core" {
		t.Fatalf("expected core route, got %s", preview.Route)
	}

	if preview.Adapter != "core-runtime" {
		t.Fatalf("expected core adapter, got %s", preview.Adapter)
	}
}

func TestRenderPreviewOkRoute(t *testing.T) {
	preview, err := RenderPreview(ucode.Parse("#ok route class:summarize topic:shell budgets:tier0_free,tier1_economy"))
	if err != nil {
		t.Fatalf("render preview failed: %v", err)
	}

	if preview.Route != "uDOS-wizard" {
		t.Fatalf("expected wizard route for ok namespace, got %s", preview.Route)
	}

	if preview.RuntimeService != "runtime.capability-registry" {
		t.Fatalf("expected capability registry, got %s", preview.RuntimeService)
	}
}

func TestRenderPreviewMcpRoute(t *testing.T) {
	preview, err := RenderPreview(ucode.Parse("mcp tools"))
	if err != nil {
		t.Fatalf("render preview failed: %v", err)
	}

	if preview.Route != "uDOS-wizard" {
		t.Fatalf("expected wizard route for mcp command, got %s", preview.Route)
	}

	if preview.RuntimeService != "runtime.capability-registry" {
		t.Fatalf("expected capability registry, got %s", preview.RuntimeService)
	}
}
