// Package theme holds canonical lipgloss styles for uDOS-shell (see uDOS-dev
// @dev/v2-upgrade/ASCII-GFX.md §13).
package theme

import (
	"os"
	"strings"

	"github.com/charmbracelet/lipgloss"
)

// Options configures theme construction.
type Options struct {
	// NoColor forces bold/dim/reverse semantics and drops backgrounds (NO_COLOR).
	NoColor bool
}

// NoColorFromEnv is true when NO_COLOR or UDOS_NO_COLOR is set (non-empty).
func NoColorFromEnv() bool {
	return strings.TrimSpace(os.Getenv("NO_COLOR")) != "" ||
		strings.TrimSpace(os.Getenv("UDOS_NO_COLOR")) != ""
}

// NewFromEnv builds a theme; respects NO_COLOR / UDOS_NO_COLOR.
func NewFromEnv() Theme {
	return New(Options{NoColor: NoColorFromEnv()})
}

// Theme bundles lipgloss.Style values used across the shell TUI.
type Theme struct {
	FrameBorder, FrameBorderActive lipgloss.Style
	TitleBar, TitleBarMuted        lipgloss.Style
	StatusLine                     lipgloss.Style // bottom mode / route strip
	PanelHeader                    lipgloss.Style
	Label, Value, ValueEmphasis    lipgloss.Style
	Muted, Help, ShortcutKey       lipgloss.Style
	ListItem, ListItemSelected     lipgloss.Style
	BlockTitle                     lipgloss.Style
	Toolbar, Button, ButtonDisabled lipgloss.Style
	InputPrompt, InputText, InputCursor lipgloss.Style
	ProgressFill, ProgressEmpty, ProgressLabel lipgloss.Style
	BadgeOk, BadgeWarn, BadgeErr   lipgloss.Style
	ModalBorder, ErrorLine         lipgloss.Style
	MapCellEmpty, MapCellSolid, MapPath lipgloss.Style
	Divider                        lipgloss.Style
	MenuContainer                  lipgloss.Style // selector outer box

	// BlockBase has border + padding; Width set per render in block package.
	BlockBase lipgloss.Style

	// Variant border foregrounds (ANSI 256 indices as strings).
	AccentPlain, AccentInfo, AccentSuccess, AccentWarn, AccentError       lipgloss.Color
	AccentPrompt, AccentAssistLocal, AccentAssistWizard lipgloss.Color
}

// New builds a Theme. Dark-terminal defaults; NoColor strips backgrounds.
func New(opts Options) Theme {
	nc := opts.NoColor
	t := Theme{
		AccentPlain:        lipgloss.Color("241"),
		AccentInfo:         lipgloss.Color("39"),
		AccentSuccess:      lipgloss.Color("42"),
		AccentWarn:         lipgloss.Color("214"),
		AccentError:        lipgloss.Color("196"),
		AccentPrompt:       lipgloss.Color("69"),
		AccentAssistLocal:  lipgloss.Color("111"),
		AccentAssistWizard: lipgloss.Color("171"),
	}

	if nc {
		t.FrameBorder = lipgloss.NewStyle()
		t.FrameBorderActive = lipgloss.NewStyle().Bold(true)
		t.TitleBar = lipgloss.NewStyle().Bold(true).Padding(0, 1)
		t.TitleBarMuted = lipgloss.NewStyle().Faint(true).Padding(0, 1)
		t.StatusLine = lipgloss.NewStyle().Faint(true).Padding(0, 1)
		t.PanelHeader = lipgloss.NewStyle().Bold(true)
		t.Label = lipgloss.NewStyle()
		t.Value = lipgloss.NewStyle().Bold(true)
		t.ValueEmphasis = lipgloss.NewStyle().Bold(true).Reverse(true)
		t.Muted = lipgloss.NewStyle().Faint(true)
		t.Help = lipgloss.NewStyle().
			Border(lipgloss.NormalBorder()).
			BorderForeground(lipgloss.Color("7")).
			Padding(0, 1)
		t.ShortcutKey = lipgloss.NewStyle().Bold(true)
		t.ListItem = lipgloss.NewStyle()
		t.ListItemSelected = lipgloss.NewStyle().Bold(true).Reverse(true)
		t.BlockTitle = lipgloss.NewStyle().Bold(true)
		t.Toolbar = lipgloss.NewStyle()
		t.Button = lipgloss.NewStyle().Underline(true)
		t.ButtonDisabled = lipgloss.NewStyle().Faint(true)
		t.InputPrompt = lipgloss.NewStyle().Bold(true).Padding(0, 1)
		t.InputText = lipgloss.NewStyle().Padding(0, 1)
		t.InputCursor = lipgloss.NewStyle().Reverse(true)
		t.ProgressFill = lipgloss.NewStyle().Bold(true)
		t.ProgressEmpty = lipgloss.NewStyle().Faint(true)
		t.ProgressLabel = lipgloss.NewStyle().Faint(true)
		t.BadgeOk = lipgloss.NewStyle().Bold(true)
		t.BadgeWarn = lipgloss.NewStyle().Bold(true)
		t.BadgeErr = lipgloss.NewStyle().Bold(true)
		t.ModalBorder = lipgloss.NewStyle().Bold(true).
			Border(lipgloss.NormalBorder()).
			BorderForeground(lipgloss.Color("7"))
		t.ErrorLine = lipgloss.NewStyle().Bold(true)
		t.MapCellEmpty = lipgloss.NewStyle().Faint(true)
		t.MapCellSolid = lipgloss.NewStyle().Bold(true)
		t.MapPath = lipgloss.NewStyle().Bold(true)
		t.Divider = lipgloss.NewStyle().Faint(true)
		t.MenuContainer = lipgloss.NewStyle().
			Border(lipgloss.ThickBorder()).
			BorderForeground(lipgloss.Color("7")).
			Padding(0, 1)
		t.BlockBase = lipgloss.NewStyle().
			Border(lipgloss.RoundedBorder()).
			BorderForeground(lipgloss.Color("7")).
			Padding(0, 1)
		return t
	}

	t.FrameBorder = lipgloss.NewStyle().Foreground(lipgloss.Color("240"))
	t.FrameBorderActive = lipgloss.NewStyle().Foreground(lipgloss.Color("86"))
	t.TitleBar = lipgloss.NewStyle().
		Bold(true).
		Padding(0, 1).
		Foreground(lipgloss.Color("252")).
		Background(lipgloss.Color("24"))
	t.TitleBarMuted = lipgloss.NewStyle().
		Foreground(lipgloss.Color("241")).
		Background(lipgloss.Color("24"))
	t.StatusLine = lipgloss.NewStyle().
		Padding(0, 1).
		Foreground(lipgloss.Color("230")).
		Background(lipgloss.Color("59"))
	t.PanelHeader = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("252"))
	t.Label = lipgloss.NewStyle().Foreground(lipgloss.Color("245"))
	t.Value = lipgloss.NewStyle().Foreground(lipgloss.Color("86"))
	t.ValueEmphasis = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("255"))
	t.Muted = lipgloss.NewStyle().Foreground(lipgloss.Color("242"))
	t.Help = lipgloss.NewStyle().
		Border(lipgloss.NormalBorder()).
		BorderForeground(lipgloss.Color("241")).
		Padding(0, 1)
	t.ShortcutKey = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("214"))
	t.ListItem = lipgloss.NewStyle().Foreground(lipgloss.Color("252"))
	t.ListItemSelected = lipgloss.NewStyle().
		Bold(true).
		Foreground(lipgloss.Color("230")).
		Background(lipgloss.Color("237"))
	t.BlockTitle = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("252"))
	t.Toolbar = lipgloss.NewStyle().Foreground(lipgloss.Color("252"))
	t.Button = lipgloss.NewStyle().Foreground(lipgloss.Color("252")).Underline(true)
	t.ButtonDisabled = lipgloss.NewStyle().Foreground(lipgloss.Color("238")).Strikethrough(true)
	t.InputPrompt = lipgloss.NewStyle().
		Bold(true).
		Foreground(lipgloss.Color("86")).
		Background(lipgloss.Color("236")).
		Padding(0, 1)
	t.InputText = lipgloss.NewStyle().
		Foreground(lipgloss.Color("252")).
		Background(lipgloss.Color("236")).
		Padding(0, 1)
	t.InputCursor = lipgloss.NewStyle().Reverse(true)
	t.ProgressFill = lipgloss.NewStyle().Foreground(lipgloss.Color("86"))
	t.ProgressEmpty = lipgloss.NewStyle().Foreground(lipgloss.Color("238"))
	t.ProgressLabel = lipgloss.NewStyle().Foreground(lipgloss.Color("241"))
	t.BadgeOk = lipgloss.NewStyle().Foreground(lipgloss.Color("42"))
	t.BadgeWarn = lipgloss.NewStyle().Foreground(lipgloss.Color("214"))
	t.BadgeErr = lipgloss.NewStyle().Foreground(lipgloss.Color("196"))
	t.ModalBorder = lipgloss.NewStyle().
		Border(lipgloss.NormalBorder()).
		BorderForeground(lipgloss.Color("86"))
	t.ErrorLine = lipgloss.NewStyle().Foreground(lipgloss.Color("203"))
	t.MapCellEmpty = lipgloss.NewStyle().Foreground(lipgloss.Color("238"))
	t.MapCellSolid = lipgloss.NewStyle().Foreground(lipgloss.Color("86"))
	t.MapPath = lipgloss.NewStyle().Foreground(lipgloss.Color("39"))
	t.Divider = lipgloss.NewStyle().Foreground(lipgloss.Color("238"))
	t.MenuContainer = lipgloss.NewStyle().
		Width(0).
		Border(lipgloss.ThickBorder()).
		BorderForeground(lipgloss.Color("69")).
		Padding(0, 1).
		Background(lipgloss.Color("235"))
	t.BlockBase = lipgloss.NewStyle().
		Border(lipgloss.RoundedBorder()).
		Padding(0, 1)

	return t
}
