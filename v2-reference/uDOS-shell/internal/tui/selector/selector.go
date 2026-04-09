package selector

import (
	"fmt"
	"strings"

	"github.com/fredporter/uDOS-shell/internal/tui/theme"
)

type Item struct {
	Label       string
	Description string
	Value       string
}

type Model struct {
	Title     string
	Items     []Item
	Selected  int
	Filter    string
	Filtering bool
}

// FilteredItems returns items matching the current filter (case-insensitive
// substring on Label and Description). Returns all items when filter is empty.
func (m Model) FilteredItems() []Item {
	if m.Filter == "" {
		return m.Items
	}

	query := strings.ToLower(m.Filter)
	result := make([]Item, 0, len(m.Items))
	for _, item := range m.Items {
		if strings.Contains(strings.ToLower(item.Label), query) ||
			strings.Contains(strings.ToLower(item.Description), query) {
			result = append(result, item)
		}
	}
	return result
}

// EnterFilter activates filter mode and clears any previous filter text.
func (m *Model) EnterFilter() {
	m.Filtering = true
	m.Filter = ""
	m.Selected = 0
}

// ExitFilter deactivates filter mode and clears filter text.
func (m *Model) ExitFilter() {
	m.Filtering = false
	m.Filter = ""
	m.Selected = 0
}

// AppendFilter adds a character to the filter string and resets the selection.
func (m *Model) AppendFilter(ch string) {
	m.Filter += ch
	m.Selected = 0
}

// BackspaceFilter removes the last character from the filter string.
func (m *Model) BackspaceFilter() {
	if len(m.Filter) > 0 {
		m.Filter = m.Filter[:len(m.Filter)-1]
	}
	m.Selected = 0
}

func (m *Model) MoveUp() {
	items := m.FilteredItems()
	if len(items) == 0 {
		return
	}
	if m.Selected > 0 {
		m.Selected--
	}
}

func (m *Model) MoveDown() {
	items := m.FilteredItems()
	if len(items) == 0 {
		return
	}
	if m.Selected < len(items)-1 {
		m.Selected++
	}
}

func (m Model) Current() (Item, bool) {
	items := m.FilteredItems()
	if len(items) == 0 || m.Selected < 0 || m.Selected >= len(items) {
		return Item{}, false
	}
	return items[m.Selected], true
}

func (m Model) View(width int, th theme.Theme) string {
	items := m.FilteredItems()
	lines := []string{th.PanelHeader.Render(m.Title), ""}

	if m.Filtering {
		lines = append(lines, th.ShortcutKey.Render("/ "+m.Filter+"_"), "")
	}

	for index, item := range items {
		prefix := "  "
		lineStyle := th.ListItem
		if index == m.Selected {
			prefix = "> "
			lineStyle = th.ListItemSelected
		}

		lines = append(lines, lineStyle.Render(fmt.Sprintf("%s%s", prefix, item.Label)))
		if item.Description != "" {
			lines = append(lines, th.Muted.Render("  "+item.Description))
		}
	}

	if len(items) == 0 && m.Filtering {
		lines = append(lines, th.Muted.Render("  (no matches)"))
	}

	return th.MenuContainer.Copy().Width(width).Render(strings.Join(lines, "\n"))
}
