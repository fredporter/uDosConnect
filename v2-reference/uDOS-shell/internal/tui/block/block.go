package block

import (
	"strings"

	"github.com/charmbracelet/lipgloss"
	"github.com/fredporter/uDOS-shell/internal/tui/theme"
)

type Variant string

const (
	VariantPlain        Variant = "plain"
	VariantInfo         Variant = "info"
	VariantSuccess      Variant = "success"
	VariantWarn         Variant = "warn"
	VariantError        Variant = "error"
	VariantPrompt       Variant = "prompt"
	VariantAssistLocal  Variant = "assist-local"
	VariantAssistWizard Variant = "assist-wizard"
)

type Block struct {
	Title   string
	Body    string
	Variant Variant
}

type Field struct {
	Label string
	Value string
}

func Render(t theme.Theme, item Block, width int) string {
	style := t.BlockBase.Copy().Width(width)

	switch item.Variant {
	case VariantInfo:
		style = style.BorderForeground(t.AccentInfo)
	case VariantSuccess:
		style = style.BorderForeground(t.AccentSuccess)
	case VariantWarn:
		style = style.BorderForeground(t.AccentWarn)
	case VariantError:
		style = style.BorderForeground(t.AccentError)
	case VariantPrompt:
		style = style.BorderForeground(t.AccentPrompt)
	case VariantAssistLocal:
		style = style.BorderForeground(t.AccentAssistLocal)
	case VariantAssistWizard:
		style = style.BorderForeground(t.AccentAssistWizard)
	default:
		style = style.BorderForeground(t.AccentPlain)
	}

	parts := make([]string, 0, 2)
	if item.Title != "" {
		parts = append(parts, t.BlockTitle.Render(item.Title))
	}
	if item.Body != "" {
		parts = append(parts, item.Body)
	}

	return style.Render(strings.Join(parts, "\n"))
}

func RenderStack(t theme.Theme, items []Block, width int) string {
	rendered := make([]string, 0, len(items))
	for _, item := range items {
		rendered = append(rendered, Render(t, item, width))
	}

	return lipgloss.JoinVertical(lipgloss.Left, rendered...)
}

func RenderFields(t theme.Theme, fields []Field, width int) string {
	if len(fields) == 0 {
		return ""
	}

	columnCount := 1
	if width >= 64 {
		columnCount = 2
	}

	rows := make([]string, 0, (len(fields)+columnCount-1)/columnCount)
	labelWidth := 12
	columnWidth := max(width/columnCount, 20)

	for index := 0; index < len(fields); index += columnCount {
		columns := make([]string, 0, columnCount)
		for offset := 0; offset < columnCount; offset++ {
			current := index + offset
			if current >= len(fields) {
				break
			}

			field := fields[current]
			cell := lipgloss.NewStyle().
				Width(columnWidth).
				Render(
					lipgloss.JoinHorizontal(
						lipgloss.Top,
						t.Label.Copy().Width(labelWidth).Render(field.Label),
						t.Value.Copy().Width(max(columnWidth-labelWidth, 8)).Render(field.Value),
					),
				)
			columns = append(columns, cell)
		}
		rows = append(rows, lipgloss.JoinHorizontal(lipgloss.Top, columns...))
	}

	return lipgloss.JoinVertical(lipgloss.Left, rows...)
}
