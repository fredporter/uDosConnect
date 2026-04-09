package keymap

type Binding struct {
	Key         string
	Description string
	Implemented bool
}

func GlobalBindings() []Binding {
	return []Binding{
		{Key: "Ctrl+C", Description: "Exit the shell immediately", Implemented: true},
		{Key: "Esc", Description: "Cancel overlay, mode, or focused action", Implemented: true},
		{Key: "Enter", Description: "Confirm, submit, or execute", Implemented: true},
		{Key: "Tab", Description: "Move to the next pane or field", Implemented: false},
		{Key: "Shift+Tab", Description: "Move to the previous pane or field", Implemented: false},
		{Key: "Ctrl+L", Description: "Redraw the screen", Implemented: true},
		{Key: "?", Description: "Toggle help overlay", Implemented: true},
		{Key: ":", Description: "Open command palette", Implemented: true},
		{Key: "/", Description: "Enter search or filter mode", Implemented: true},
	}
}

func NavigationBindings() []Binding {
	return []Binding{
		{Key: "Up/Down", Description: "Move selection", Implemented: true},
		{Key: "Left/Right", Description: "Move cursor or change pane", Implemented: true},
		{Key: "Home", Description: "Jump to start / cursor to line start", Implemented: true},
		{Key: "End", Description: "Jump to end / cursor to line end", Implemented: true},
		{Key: "PgUp/PgDn", Description: "Page through longer views", Implemented: false},
	}
}

func InputBindings() []Binding {
	return []Binding{
		{Key: "Backspace", Description: "Delete the previous character", Implemented: true},
		{Key: "Ctrl+A", Description: "Move to the start of the line", Implemented: true},
		{Key: "Ctrl+E", Description: "Move to the end of the line", Implemented: true},
		{Key: "Ctrl+U", Description: "Delete from start to cursor", Implemented: true},
		{Key: "Ctrl+W", Description: "Delete the previous word", Implemented: true},
		{Key: "Ctrl+K", Description: "Delete to the end of the line", Implemented: true},
		{Key: "Ctrl+Y", Description: "Paste buffer", Implemented: false},
		{Key: "Ctrl+D", Description: "Delete character under cursor", Implemented: false},
	}
}

func ControllerSemanticBindings() []Binding {
	return []Binding{
		{Key: "button-menu", Description: "Open command palette via UCI palette action", Implemented: true},
		{Key: "button-b", Description: "Back or cancel via UCI back action", Implemented: true},
		{Key: "button-a", Description: "Confirm current command or selection", Implemented: true},
		{Key: "dpad-right", Description: "Accept the active prediction", Implemented: true},
		{Key: "dpad-left", Description: "Move focus to the previous panel", Implemented: true},
		{Key: "dpad-down", Description: "Move focus to the next panel", Implemented: true},
		{Key: "button-start", Description: "Submit the active command palette entry", Implemented: true},
	}
}
