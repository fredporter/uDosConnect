package demo_test

// Demo integration test — exercises the full non-TUI stack end to end.
// Run: go test ./tests/... -v
// Tags: @dev/ucode-selector-filter-mode @dev/ucode-focused-actions

import (
	"fmt"
	"strings"
	"testing"

	"github.com/fredporter/uDOS-shell/internal/contracts"
	"github.com/fredporter/uDOS-shell/internal/dispatch"
	"github.com/fredporter/uDOS-shell/internal/tui/selector"
	"github.com/fredporter/uDOS-shell/internal/ucode"
)

// ── Parser ─────────────────────────────────────────────────────────────────────

func TestParseHashNamespacedCommands(t *testing.T) {
	cases := []struct{ input, ns, action string }{
		{"#wizard assist topic:shell", "wizard", "assist"},
		{"#binder create shell-activation", "binder", "create"},
		{"#ok route class:summarize", "ok", "route"},
		{"#beacon ping", "beacon", "ping"},
	}
	for _, c := range cases {
		t.Run(c.ns+"."+c.action, func(t *testing.T) {
			cmd := ucode.Parse(c.input)
			if cmd.Namespace != c.ns {
				t.Fatalf("namespace: want %q got %q", c.ns, cmd.Namespace)
			}
			if cmd.Action != c.action {
				t.Fatalf("action: want %q got %q", c.action, cmd.Action)
			}
		})
	}
}

func TestParseArgs(t *testing.T) {
	cmd := ucode.Parse("#wizard assist topic:shell mode:draft")
	if cmd.Args["topic"] != "shell" {
		t.Fatalf("want topic=shell, got %q", cmd.Args["topic"])
	}
	if cmd.Args["mode"] != "draft" {
		t.Fatalf("want mode=draft, got %q", cmd.Args["mode"])
	}
}

func TestParseSystemDefault(t *testing.T) {
	cmd := ucode.Parse("open workspace")
	if cmd.Namespace != "system" || cmd.Action != "open" {
		t.Fatalf("want system.open, got %s.%s", cmd.Namespace, cmd.Action)
	}
}

func TestParseEmpty(t *testing.T) {
	cmd := ucode.Parse("")
	if cmd.Namespace != "system" || cmd.Action != "noop" {
		t.Fatalf("want system.noop, got %s.%s", cmd.Namespace, cmd.Action)
	}
}

func TestParseUppercaseScriptRun(t *testing.T) {
	cmd := ucode.Parse("SCRIPT RUN ./startup-script.md")
	if cmd.Namespace != "script" || cmd.Action != "run" {
		t.Fatalf("want script.run, got %s.%s", cmd.Namespace, cmd.Action)
	}
	if cmd.Args["path"] != "./startup-script.md" {
		t.Fatalf("want path, got %q", cmd.Args["path"])
	}
}

// ── Dispatch preview ───────────────────────────────────────────────────────────

func TestDispatchWizard(t *testing.T) {
	preview, err := dispatch.RenderPreview(ucode.Parse("#wizard assist topic:shell"))
	if err != nil {
		t.Fatalf("RenderPreview: %v", err)
	}
	if preview.Route != "uDOS-wizard" {
		t.Fatalf("want uDOS-wizard, got %q", preview.Route)
	}
	if preview.Shell != "uDOS-shell" {
		t.Fatalf("want shell=uDOS-shell, got %q", preview.Shell)
	}
}

func TestDispatchSystem(t *testing.T) {
	preview, err := dispatch.RenderPreview(ucode.Parse("open workspace"))
	if err != nil {
		t.Fatalf("RenderPreview: %v", err)
	}
	if preview.Route == "" {
		t.Fatal("expected non-empty route")
	}
}

func TestDispatchHome(t *testing.T) {
	preview, err := dispatch.RenderPreview(ucode.Parse("#home device.lights toggle"))
	if err != nil {
		t.Fatalf("RenderPreview: %v", err)
	}
	if !strings.Contains(preview.Route, "uHOME") {
		t.Fatalf("expected uHOME in route, got %q", preview.Route)
	}
}

func TestDispatchRequiredFields(t *testing.T) {
	inputs := []string{"#wizard assist", "#binder create x", "open workspace", "#ok route"}
	for _, input := range inputs {
		t.Run(input, func(t *testing.T) {
			p, err := dispatch.RenderPreview(ucode.Parse(input))
			if err != nil {
				t.Fatalf("RenderPreview: %v", err)
			}
			if p.Shell == "" || p.Route == "" || p.Owner == "" || p.Version == "" {
				t.Errorf("missing required field in preview for %q", input)
			}
		})
	}
}

// ── Contracts ──────────────────────────────────────────────────────────────────

func TestRuntimeServiceManifest(t *testing.T) {
	manifest, src, err := contracts.LoadRuntimeServiceManifest()
	if err != nil {
		t.Fatalf("LoadRuntimeServiceManifest: %v", err)
	}
	if src == "" || manifest.Version == "" || len(manifest.Services) == 0 {
		t.Fatal("manifest missing required data")
	}
	t.Logf("services: version=%s count=%d", manifest.Version, len(manifest.Services))
}

func TestWorkflowContract(t *testing.T) {
	c, src, err := contracts.LoadNamedContract("workflow-state")
	if err != nil {
		t.Fatalf("LoadNamedContract: %v", err)
	}
	if src == "" || c.Schema == "" {
		t.Fatal("contract missing schema or source")
	}
	t.Logf("workflow-state: schema=%s version=%s", c.Schema, c.Version)
}

func TestAutomationContract(t *testing.T) {
	c, _, err := contracts.LoadNamedContract("automation-job")
	if err != nil {
		t.Fatalf("LoadNamedContract(automation-job): %v", err)
	}
	t.Logf("automation-job: schema=%s", c.Schema)
}

func TestKnowledgeStamp(t *testing.T) {
	stamp, err := contracts.LoadKnowledgeStamp()
	if err != nil {
		t.Fatalf("LoadKnowledgeStamp: %v", err)
	}
	if stamp.RuntimeServicesVersion == "" {
		t.Fatal("expected non-empty RuntimeServicesVersion")
	}
	t.Logf("stamp: runtime=%s foundation=%s", stamp.RuntimeServicesVersion, stamp.FoundationVersion)
}

// ── Selector filter ────────────────────────────────────────────────────────────

func TestSelectorFilterNarrows(t *testing.T) {
	m := selector.Model{
		Items: []selector.Item{
			{Label: "Inspect workflow-state contract", Description: "Show workflow state."},
			{Label: "Show workflow state sample", Description: "Render workflow envelope."},
			{Label: "Ask local model", Description: "GPT4All local assist."},
			{Label: "Route OK provider", Description: "OK routing command."},
		},
	}
	m.EnterFilter()
	m.AppendFilter("workflow")
	items := m.FilteredItems()
	if len(items) != 2 {
		t.Fatalf("expected 2 for workflow filter, got %d", len(items))
	}
	m.ExitFilter()
	if len(m.FilteredItems()) != 4 {
		t.Fatalf("expected all 4 after ExitFilter, got %d", len(m.FilteredItems()))
	}
}

func TestSelectorFilterByDescription(t *testing.T) {
	m := selector.Model{
		Items: []selector.Item{
			{Label: "Command A", Description: "GPT4All local assist."},
			{Label: "Command B", Description: "Wizard assist for online lanes."},
		},
	}
	m.EnterFilter()
	m.AppendFilter("gpt4all")
	items := m.FilteredItems()
	if len(items) != 1 || items[0].Label != "Command A" {
		t.Fatalf("expected Command A, got %v", labelList(items))
	}
}

func TestSelectorFilterCurrent(t *testing.T) {
	m := selector.Model{
		Items: []selector.Item{
			{Label: "Workflow Alpha", Value: "alpha"},
			{Label: "Workflow Beta", Value: "beta"},
			{Label: "Automation Job", Value: "job"},
		},
	}
	m.EnterFilter()
	m.AppendFilter("beta")
	item, ok := m.Current()
	if !ok {
		t.Fatal("expected a current item after filter")
	}
	if item.Value != "beta" {
		t.Fatalf("expected value=beta, got %q", item.Value)
	}
}

// ── Full pipeline walk ─────────────────────────────────────────────────────────

func TestFullPipelineWalk(t *testing.T) {
	commands := []string{
		"#binder create shell-activation",
		"#wizard assist topic:shell",
		"#ok route class:summarize topic:shell",
		"open workspace",
	}
	for _, input := range commands {
		label := trunc(input, 36)
		t.Run(fmt.Sprintf("pipeline/%s", label), func(t *testing.T) {
			preview, err := dispatch.RenderPreview(ucode.Parse(input))
			if err != nil {
				t.Fatalf("pipeline: %v", err)
			}
			t.Logf("%s => route=%s owner=%s", trunc(input, 40), preview.Route, preview.Owner)
		})
	}
}

// ── Helpers ────────────────────────────────────────────────────────────────────

func labelList(items []selector.Item) []string {
	out := make([]string, len(items))
	for i, item := range items {
		out[i] = item.Label
	}
	return out
}

func trunc(s string, n int) string {
	if len(s) <= n {
		return s
	}
	return s[:n]
}
