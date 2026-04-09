package uci

import "testing"

func TestValidModesContainShellFirstModes(t *testing.T) {
	required := map[Mode]bool{
		ModeNav:     false,
		ModeText:    false,
		ModeCommand: false,
	}

	for _, mode := range ValidModes() {
		if _, ok := required[mode]; ok {
			required[mode] = true
		}
	}

	for mode, seen := range required {
		if !seen {
			t.Fatalf("expected mode %s in valid mode set", mode)
		}
	}
}

func TestReservedSemanticActionsIncludePaletteAndPrediction(t *testing.T) {
	if !IsReservedSemanticAction(ActionPalette) {
		t.Fatal("expected palette to be reserved")
	}
	if !IsReservedSemanticAction(ActionAcceptPrediction) {
		t.Fatal("expected accept_prediction to be reserved")
	}
	if IsReservedSemanticAction(SemanticAction("unknown")) {
		t.Fatal("did not expect unknown action to be reserved")
	}
}

func TestShellPrototypeMappingsStayWithinReservedContract(t *testing.T) {
	for _, mapping := range ShellPrototypeMappings() {
		if !IsValidMode(mapping.Mode) {
			t.Fatalf("invalid mode in mapping: %s", mapping.Mode)
		}
		if !IsReservedSemanticAction(mapping.SemanticAction) {
			t.Fatalf("invalid semantic action in mapping: %s", mapping.SemanticAction)
		}
		if mapping.Control == "" {
			t.Fatal("expected mapping control to be populated")
		}
	}
}

func TestSessionHandlesPalettePredictionAndSubmitFlow(t *testing.T) {
	session := NewSession()
	session.SetInput("publish")
	session.SetPredictions([]Prediction{{Value: "campaign-dashboard", Source: "local"}})

	if !session.Apply(ActionPalette) {
		t.Fatal("expected palette action to succeed")
	}
	if !session.Apply(ActionAcceptPrediction) {
		t.Fatal("expected prediction acceptance to succeed")
	}
	if !session.Apply(ActionSubmit) {
		t.Fatal("expected submit to succeed")
	}

	snapshot := session.Snapshot()
	if snapshot.Mode != ModeNav {
		t.Fatalf("expected nav mode after submit, got %s", snapshot.Mode)
	}
	if snapshot.PaletteOpen {
		t.Fatal("expected palette to close after submit")
	}
	if len(snapshot.Submitted) != 1 {
		t.Fatalf("expected one submitted entry, got %d", len(snapshot.Submitted))
	}
	if snapshot.Submitted[0] != "publish campaign-dashboard" {
		t.Fatalf("unexpected submitted command: %s", snapshot.Submitted[0])
	}
}

func TestRadialKeyboardLayoutUsesReservedActions(t *testing.T) {
	layout := RadialKeyboardLayout()
	if len(layout) != 4 {
		t.Fatalf("expected 4 radial keys, got %d", len(layout))
	}
	for _, key := range layout {
		if key.ID == "" || key.Label == "" {
			t.Fatal("expected radial key identifiers and labels")
		}
		if !IsReservedSemanticAction(key.Action) {
			t.Fatalf("unexpected radial key action: %s", key.Action)
		}
	}
}
