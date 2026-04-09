package surface

import "github.com/fredporter/uDOS-shell/internal/tui/keymap"

// KeyBindingsFromInputMapping turns profile intents into help-overlay rows.
// Implemented is false: these are host / ThinUI targets until wired into dispatch.
func KeyBindingsFromInputMapping(m *InputMapping) []keymap.Binding {
	if m == nil {
		return nil
	}
	var out []keymap.Binding
	if cp := m.Keyboard.CommandPalette; cp != nil {
		for _, k := range cp.Open {
			desc := "Surface: command palette (profile " + m.ProfileID + ")"
			if cp.Note != "" {
				desc = desc + " — " + cp.Note
			}
			out = append(out, keymap.Binding{Key: k, Description: desc, Implemented: false})
		}
	}
	if nav := m.Keyboard.Navigation; nav != nil {
		if nav.FocusNextPanel != "" {
			out = append(out, keymap.Binding{
				Key:         nav.FocusNextPanel,
				Description: "Surface: focus next panel (ThinUI host)",
				Implemented: false,
			})
		}
		if nav.FocusPreviousPanel != "" {
			out = append(out, keymap.Binding{
				Key:         nav.FocusPreviousPanel,
				Description: "Surface: focus previous panel (ThinUI host)",
				Implemented: false,
			})
		}
		if nav.ToggleThinUIFullscreen != "" {
			out = append(out, keymap.Binding{
				Key:         nav.ToggleThinUIFullscreen,
				Description: "Surface: toggle ThinUI fullscreen",
				Implemented: false,
			})
		}
	}
	if tu := m.Keyboard.ThinUI; tu != nil && tu.EscapeToHost != "" {
		desc := "Surface: escape to host (GNOME handoff)"
		if tu.Note != "" {
			desc += " — " + tu.Note
		}
		out = append(out, keymap.Binding{
			Key:         tu.EscapeToHost,
			Description: desc,
			Implemented: false,
		})
	}
	if c := m.Controller; c != nil && c.Enabled {
		label := "Surface: controller → UCI (" + c.UCIAlignment + ")"
		if c.Note != "" {
			label = label + " — " + c.Note
		}
		out = append(out, keymap.Binding{Key: "(controller)", Description: label, Implemented: false})
	}
	return out
}
