package app

import (
	"testing"

	tea "github.com/charmbracelet/bubbletea"
)

func TestSubmitStarterHelp(t *testing.T) {
	m := newModel()
	m.input = "help"

	next := m.submit()

	if next.status != "starter help shown" {
		t.Fatalf("expected starter help shown, got %q", next.status)
	}
	if len(next.blocks) < 2 {
		t.Fatalf("expected starter help blocks")
	}
	if next.blocks[1].Title != "uDOS Shell Help" {
		t.Fatalf("expected help block, got %q", next.blocks[1].Title)
	}
}

func TestSubmitStarterCommandsList(t *testing.T) {
	m := newModel()
	m.input = "commands list"

	next := m.submit()

	if next.status != "command registry shown" {
		t.Fatalf("expected command registry shown, got %q", next.status)
	}
	if next.blocks[1].Title != "Full Command Registry" {
		t.Fatalf("expected full registry block, got %q", next.blocks[1].Title)
	}
}

func TestUnknownCommandShowsGuidance(t *testing.T) {
	m := newModel()
	m.input = "definitely-not-a-shell-command"

	next := m.submit()

	if next.status != "unknown command" {
		t.Fatalf("expected unknown command status, got %q", next.status)
	}
	if next.blocks[1].Title != "Unknown Command" {
		t.Fatalf("expected unknown command block, got %q", next.blocks[1].Title)
	}
}

func TestExitSetsQuitFlag(t *testing.T) {
	m := newModel()
	m.input = "exit"

	next := m.submit()

	if !next.quitting {
		t.Fatal("expected quitting flag")
	}
}

func TestUpdateInsertsSpaceInPromptInput(t *testing.T) {
	m := newModel()
	m.input = "open"
	m.cursor = len([]rune(m.input))

	next, _ := m.Update(tea.KeyMsg{Type: tea.KeySpace})
	updated := next.(model)

	if updated.input != "open " {
		t.Fatalf("expected input %q, got %q", "open ", updated.input)
	}
	if updated.cursor != len([]rune("open ")) {
		t.Fatalf("expected cursor %d, got %d", len([]rune("open ")), updated.cursor)
	}
}

func TestUpdateInsertsSpaceInFilterMode(t *testing.T) {
	m := newModel()
	m.lastMode = modeMenu
	m.menu.EnterFilter()

	next, _ := m.Update(tea.KeyMsg{Type: tea.KeySpace})
	updated := next.(model)

	if updated.menu.Filter != " " {
		t.Fatalf("expected filter %q, got %q", " ", updated.menu.Filter)
	}
}
