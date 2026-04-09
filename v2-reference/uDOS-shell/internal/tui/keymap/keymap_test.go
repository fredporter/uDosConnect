package keymap

import "testing"

func TestGlobalBindingsAvoidCommandKeyShortcuts(t *testing.T) {
	for _, binding := range GlobalBindings() {
		if binding.Key == "Cmd" || binding.Key == "Command" {
			t.Fatalf("unexpected command-key binding entry: %s", binding.Key)
		}
	}
}

func TestCoreBindingsAreMarkedImplemented(t *testing.T) {
	required := map[string]bool{
		"Ctrl+C":    false,
		"Esc":       false,
		"Enter":     false,
		"Ctrl+L":    false,
		"?":         false,
		":":         false,
		"Up/Down":   false,
		"Backspace": false,
	}

	allBindings := append([]Binding{}, GlobalBindings()...)
	allBindings = append(allBindings, NavigationBindings()...)
	allBindings = append(allBindings, InputBindings()...)

	for _, binding := range allBindings {
		if _, ok := required[binding.Key]; ok && binding.Implemented {
			required[binding.Key] = true
		}
	}

	for key, seen := range required {
		if !seen {
			t.Fatalf("expected %s to be marked implemented", key)
		}
	}
}

func TestControllerSemanticBindingsAreImplemented(t *testing.T) {
	required := map[string]bool{
		"button-menu":  false,
		"button-b":     false,
		"button-a":     false,
		"dpad-right":   false,
		"dpad-left":    false,
		"dpad-down":    false,
		"button-start": false,
	}

	for _, binding := range ControllerSemanticBindings() {
		if _, ok := required[binding.Key]; ok && binding.Implemented {
			required[binding.Key] = true
		}
	}

	for key, seen := range required {
		if !seen {
			t.Fatalf("expected controller binding %s to be marked implemented", key)
		}
	}
}
