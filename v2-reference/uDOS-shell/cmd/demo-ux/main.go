// Command demo-ux is an interactive visual UX walk through canonical ASCII shell layouts.
// It does not print parser or route-preview diagnostics.
package main

import (
	"fmt"
	"os"
	"strings"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/fredporter/uDOS-shell/internal/demoux"
	"github.com/fredporter/uDOS-shell/internal/tui/theme"
)

func main() {
	if len(os.Args) > 1 && (os.Args[1] == "--static" || os.Args[1] == "-static") {
		if err := printStaticWalk(); err != nil {
			fmt.Fprintln(os.Stderr, "Error:", err)
			os.Exit(1)
		}
		return
	}

	p := tea.NewProgram(newModel(), tea.WithAltScreen())
	if _, err := p.Run(); err != nil {
		fmt.Println("Error:", err)
	}
}

func printStaticWalk() error {
	root, err := demoux.RepoRoot()
	if err != nil {
		return err
	}
	fmt.Println("uDOS-shell visual UX demo (static fixtures — not parser/route preview)")
	fmt.Println()
	for i, sc := range demoux.ScreenScenes {
		fmt.Println(strings.Repeat("=", 82))
		fmt.Printf("Scene %d/%d  %s  (%s)\n", i+1, len(demoux.ScreenScenes), sc.Title, sc.ID)
		fmt.Println(strings.Repeat("=", 82))
		data, err := demoux.ReadScreen(root, sc.Filename)
		if err != nil {
			return err
		}
		fmt.Print(string(data))
		if len(data) > 0 && data[len(data)-1] != '\n' {
			fmt.Println()
		}
		fmt.Println()
	}

	fmt.Println(strings.Repeat("=", 82))
	fmt.Println("Component showcase (demo/components/)")
	fmt.Println(strings.Repeat("=", 82))
	for _, name := range demoux.ComponentFiles {
		b, err := demoux.ReadComponent(root, name)
		if err != nil {
			return err
		}
		fmt.Println("--- " + name + " ---")
		fmt.Print(string(b))
		if len(b) > 0 && b[len(b)-1] != '\n' {
			fmt.Println()
		}
		fmt.Println()
	}

	fmt.Println(strings.Repeat("=", 82))
	fmt.Println("ASCII pattern gallery (demo/patterns/gallery.txt)")
	fmt.Println(strings.Repeat("=", 82))
	g, err := demoux.ReadPatternsGallery(root)
	if err != nil {
		return err
	}
	fmt.Print(string(g))
	return nil
}

type model struct {
	root   string
	scenes []demoux.Scene
	idx    int
	scroll int
	focus  int
	lines  []string
	w, h   int
	err    string
	th     theme.Theme
}

var focusLabels = []string{"MENU", "WORKSPACE", "CONTEXT", "PROMPT"}

func newModel() model {
	root, err := demoux.RepoRoot()
	if err != nil {
		return model{err: err.Error()}
	}
	m := model{
		root:   root,
		scenes: demoux.ScreenScenes,
		th:     theme.NewFromEnv(),
	}
	m.reload()
	return m
}

func (m *model) reload() {
	if m.err != "" || len(m.scenes) == 0 {
		return
	}
	data, err := demoux.ReadScreen(m.root, m.scenes[m.idx].Filename)
	if err != nil {
		m.err = err.Error()
		m.lines = nil
		return
	}
	raw := strings.TrimSuffix(string(data), "\n")
	if raw == "" {
		m.lines = nil
		return
	}
	m.lines = strings.Split(raw, "\n")
	m.scroll = 0
}

func (m model) Init() tea.Cmd {
	return nil
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	if m.err != "" {
		switch msg := msg.(type) {
		case tea.KeyMsg:
			if msg.String() == "ctrl+c" || msg.String() == "q" || msg.String() == "esc" {
				return m, tea.Quit
			}
		}
		return m, nil
	}

	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.w = msg.Width
		m.h = msg.Height
		return m, nil

	case tea.KeyMsg:
		switch msg.String() {
		case "ctrl+c", "q", "esc":
			return m, tea.Quit
		case "n", "right":
			if m.idx < len(m.scenes)-1 {
				m.idx++
				m.reload()
			}
		case "p", "left":
			if m.idx > 0 {
				m.idx--
				m.reload()
			}
		case "tab":
			m.focus = (m.focus + 1) % len(focusLabels)
		case "shift+tab":
			m.focus = (m.focus - 1 + len(focusLabels)) % len(focusLabels)
		case "down", "j":
			m.scroll++
			if ms := maxBodyScroll(m); m.scroll > ms {
				m.scroll = ms
			}
		case "up", "k":
			if m.scroll > 0 {
				m.scroll--
			}
		case "g":
			m.scroll = 0
		case "G":
			m.scroll = maxBodyScroll(m)
		}
	}
	return m, nil
}

func maxBodyScroll(m model) int {
	reserved := 5 // title + focus bar + help + padding
	if m.h <= reserved {
		return 0
	}
	maxScroll := len(m.lines) - (m.h - reserved)
	if maxScroll < 0 {
		return 0
	}
	return maxScroll
}

func (m model) View() string {
	if m.err != "" {
		return "uDOS-shell UX demo\n\n" + m.err + "\n\nPress q to quit.\n"
	}
	if len(m.scenes) == 0 {
		return "No scenes defined.\n"
	}

	sc := m.scenes[m.idx]
	title := fmt.Sprintf("uDOS-shell UX demo  —  %d/%d  %s  (%s)", m.idx+1, len(m.scenes), sc.Title, sc.ID)
	focusBar := fmt.Sprintf("simulated focus: %s  (Tab / Shift+Tab cycle)", focusLabels[m.focus])

	if m.h == 0 {
		help := "n/→ next   p/← prev   Tab focus   j/k scroll   g top   G bottom   q quit"
		return strings.Join([]string{title, strings.Repeat("─", 40), focusBar, strings.Join(m.lines, "\n"), "", help}, "\n")
	}

	reserved := 5
	bodyH := m.h - reserved
	if bodyH < 6 {
		bodyH = 6
	}
	scroll := m.scroll
	maxS := maxBodyScroll(m)
	if scroll > maxS {
		scroll = maxS
	}
	end := scroll + bodyH
	if end > len(m.lines) {
		end = len(m.lines)
	}
	var body string
	if scroll < len(m.lines) {
		body = strings.Join(m.lines[scroll:end], "\n")
	}

	help := "n/→ next   p/← prev   Tab focus   j/k scroll   g top   G bottom   q quit"
	sepW := min(80, maxInt(2, m.w-2))
	return strings.Join([]string{title, strings.Repeat("─", sepW), focusBar, body, "", help}, "\n")
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

func maxInt(a, b int) int {
	if a > b {
		return a
	}
	return b
}
