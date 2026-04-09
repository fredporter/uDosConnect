package app

import (
	"encoding/json"
	"fmt"
	"slices"
	"strings"
	"time"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/fredporter/uDOS-shell/internal/contracts"
	"github.com/fredporter/uDOS-shell/internal/dispatch"
	"github.com/fredporter/uDOS-shell/internal/localexec"
	"github.com/fredporter/uDOS-shell/internal/surface"
	"github.com/fredporter/uDOS-shell/internal/tui/block"
	"github.com/fredporter/uDOS-shell/internal/tui/keymap"
	"github.com/fredporter/uDOS-shell/internal/tui/selector"
	"github.com/fredporter/uDOS-shell/internal/tui/theme"
	"github.com/fredporter/uDOS-shell/internal/tui/viewport"
	"github.com/fredporter/uDOS-shell/internal/ucode"
)

type mode string

const (
	modePrompt mode = "prompt"
	modeHelp   mode = "help"
	modeMenu   mode = "menu"
)

type model struct {
	width       int
	height      int
	input       string
	cursor      int
	blocks      []block.Block
	th          theme.Theme
	status      string
	lastRoute   string
	lastMode    mode
	menu        selector.Model
	workflows   map[string]workflowState
	jobs        map[string]automationJob
	history     []sessionEvent
	latestIDs   latestRefs
	menuContext string
	quitting    bool
}

type workflowState struct {
	WorkflowID         string
	StepID             string
	Status             string
	AwaitingUserAction bool
	LastTransitionAt   string
	OriginSurface      string
}

type automationJob struct {
	JobID                   string
	RequestedCapability     string
	PayloadRef              string
	OriginSurface           string
	PolicyFlags             []string
	QueuedAt                string
	Status                  string
	OutputRefs              []string
	EventRefs               []string
	CompletedAt             string
	SuggestedWorkflowAction string
}

type latestRefs struct {
	WorkflowID string
	JobID      string
}

type sessionEvent struct {
	Kind      string
	TargetID  string
	Status    string
	Action    string
	Timestamp string
	Note      string
}

const (
	devTagLocalGPT4AllUpdate = "@dev/local-gpt4all-update"
	devTagCLIFallback        = "@dev/ucode-cli-fallback"
)

func Run() error {
	p := tea.NewProgram(
		newModel(),
		tea.WithAltScreen(),
	)

	_, err := p.Run()
	return err
}

func newModel() model {
	blocks := defaultStartupBlocks()
	if !localexec.HasSeenSetupStory() {
		blocks = append([]block.Block{
			{
				Title: "First Run",
				Body: strings.Join([]string{
					"uDOS-shell detected a first-run session.",
					"Run `setup story` for the family setup sequence.",
					"Run `health startup` for sibling repo validation entrypoints.",
					"Run `demo list` to see executable family demos.",
				}, "\n"),
				Variant: block.VariantWarn,
			},
		}, blocks...)
	}

	return model{
		blocks:    blocks,
		th:        theme.NewFromEnv(),
		status:    "ready",
		lastMode:  modePrompt,
		menu:      commandMenu(),
		workflows: map[string]workflowState{},
		jobs:      map[string]automationJob{},
		history:   []sessionEvent{},
	}
}

func commandMenu() selector.Model {
	return selector.Model{
		Title: "uCODE Menu",
		Items: []selector.Item{
			{
				Label:       "Insert wizard example",
				Description: "Load a Wizard command into the prompt.",
				Value:       "#wizard assist topic:shell",
			},
			{
				Label:       "Ask local model",
				Description: "Load a Core GPT4All local assist prompt.",
				Value:       "? summarize the current workflow state",
			},
			{
				Label:       "Ask Wizard",
				Description: "Load a Wizard assist prompt for online/API lanes.",
				Value:       "#wizard assist topic:shell",
			},
			{
				Label:       "Route OK provider decision",
				Description: "Load an OK routing command against Wizard /ok/route.",
				Value:       "#ok route class:summarize topic:shell budgets:tier0_free,tier1_economy",
			},
			{
				Label:       "List MCP tools",
				Description: "Query Wizard MCP tools through the JSON-RPC bridge.",
				Value:       "mcp tools",
			},
			{
				Label:       "Call MCP ok.route",
				Description: "Call Wizard MCP tool routing from Shell.",
				Value:       "mcp call ok.route task:summarize-changelog class:summarize budgets:tier0_free,tier1_economy",
			},
			{
				Label:       "Call MCP provider list",
				Description: "Inspect Wizard OK provider metadata through MCP.",
				Value:       "mcp call ok.providers.list capability:summarize enabled_only:true",
			},
			{
				Label:       "List dev ops docs",
				Description: "Show the built-in @dev operations references available in Shell.",
				Value:       "dev ops list",
			},
			{
				Label:       "Inspect dev ops MCP support",
				Description: "Load the @dev MCP operations support doc into the output stack.",
				Value:       "dev ops mcp-support",
			},
			{
				Label:       "Show startup health",
				Description: "Inspect family validation entrypoints detected at startup.",
				Value:       "health startup",
			},
			{
				Label:       "Show setup story",
				Description: "Open the first-run family setup and installer sequence.",
				Value:       "setup story",
			},
			{
				Label:       "List demos",
				Description: "Show executable family demo lanes exposed in the shell.",
				Value:       "demo list",
			},
			{
				Label:       "UX demo pack (visual layouts)",
				Description: "How to run ASCII shell UX fixtures — not parser/route preview.",
				Value:       "demo ux",
			},
			{
				Label:       "Run ThinUI teletext demo",
				Description: "Render the teletext block-graphic demo through ThinUI.",
				Value:       "demo run thinui-teletext",
			},
			{
				Label:       "Insert binder example",
				Description: "Load a Binder command into the prompt.",
				Value:       "#binder create shell-activation",
			},
			{
				Label:       "Insert open workspace",
				Description: "Load a plain system command into the prompt.",
				Value:       "open workspace",
			},
			{
				Label:       "Show keybinding summary",
				Description: "Add the current keybinding contract to the output stack.",
				Value:       "__show_help__",
			},
			{
				Label:       "Inspect workflow-state contract",
				Description: "Show the machine-readable workflow state contract from uDOS-core.",
				Value:       "contract workflow-state",
			},
			{
				Label:       "Inspect workflow-action contract",
				Description: "Show the machine-readable workflow action contract from uDOS-core.",
				Value:       "contract workflow-action",
			},
			{
				Label:       "Inspect automation-job contract",
				Description: "Show the machine-readable automation job contract from uDOS-core.",
				Value:       "contract automation-job",
			},
			{
				Label:       "Inspect automation-result contract",
				Description: "Show the machine-readable automation result contract from uDOS-core.",
				Value:       "contract automation-result",
			},
			{
				Label:       "Inspect grid place contract",
				Description: "Show the machine-readable place contract from uDOS-grid.",
				Value:       "contract grid-place",
			},
			{
				Label:       "Inspect grid layer contract",
				Description: "Show the machine-readable layer contract from uDOS-grid.",
				Value:       "contract grid-layer",
			},
			{
				Label:       "Inspect grid artifact contract",
				Description: "Show the machine-readable artifact contract from uDOS-grid.",
				Value:       "contract grid-artifact",
			},
			{
				Label:       "Inspect grid seed places",
				Description: "Show the starter place registry from uDOS-grid.",
				Value:       "grid seed places",
			},
			{
				Label:       "Inspect grid seed artifacts",
				Description: "Show the starter artifact registry from uDOS-grid.",
				Value:       "grid seed artifacts",
			},
			{
				Label:       "Show workflow state sample",
				Description: "Render a sample workflow-state envelope aligned to Core.",
				Value:       "workflow state demo-workflow",
			},
			{
				Label:       "Queue automation job sample",
				Description: "Render a sample automation-job envelope aligned to Core.",
				Value:       "automation queue runtime.command-registry",
			},
			{
				Label:       "Advance latest workflow",
				Description: "Apply advance to the latest in-session workflow.",
				Value:       "__latest_workflow_advance__",
			},
			{
				Label:       "Pause latest workflow",
				Description: "Apply pause to the latest in-session workflow.",
				Value:       "__latest_workflow_pause__",
			},
			{
				Label:       "Inspect latest job result",
				Description: "Render the current in-session result for the latest automation job.",
				Value:       "__latest_job_result__",
			},
			{
				Label:       "List workflow ledger",
				Description: "Show tracked workflow states for this TUI session.",
				Value:       "__show_workflow_ledger__",
			},
			{
				Label:       "List automation ledger",
				Description: "Show tracked automation jobs for this TUI session.",
				Value:       "__show_automation_ledger__",
			},
			{
				Label:       "Pick workflow from ledger",
				Description: "Open a selector of tracked workflows.",
				Value:       "__pick_workflow__",
			},
			{
				Label:       "Pick automation job from ledger",
				Description: "Open a selector of tracked jobs.",
				Value:       "__pick_job__",
			},
		},
	}
}

func (m model) Init() tea.Cmd {
	return nil
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.width = msg.Width
		m.height = msg.Height
		return m, nil
	case tea.KeyMsg:
		if m.lastMode == modeMenu {
			return m.updateMenu(msg), nil
		}

		switch msg.Type {
		case tea.KeyCtrlC:
			m.quitting = true
			return m, tea.Quit
		case tea.KeyCtrlL:
			m.status = "redrawn"
			return m, tea.ClearScreen
		case tea.KeySpace:
			// Bubble Tea emits Space as a dedicated key type (not a rune),
			// so handle it explicitly to keep command inputs token-separated.
			runes := []rune(m.input)
			ins := []rune{' '}
			m.input = string(runes[:m.cursor]) + string(ins) + string(runes[m.cursor:])
			m.cursor += len(ins)
			m.lastMode = modePrompt
			return m, nil
		case tea.KeyBackspace:
			if m.cursor > 0 {
				runes := []rune(m.input)
				m.input = string(runes[:m.cursor-1]) + string(runes[m.cursor:])
				m.cursor--
			}
			return m, nil
		case tea.KeyEnter:
			next := m.submit()
			if next.quitting {
				return next, tea.Quit
			}
			return next, nil
		case tea.KeyEsc:
			if m.lastMode == modeHelp {
				m.lastMode = modePrompt
				m.status = "help closed"
			}
			return m, nil
		case tea.KeyLeft:
			if m.cursor > 0 {
				m.cursor--
			}
			return m, nil
		case tea.KeyRight:
			if m.cursor < len([]rune(m.input)) {
				m.cursor++
			}
			return m, nil
		case tea.KeyHome:
			m.cursor = 0
			return m, nil
		case tea.KeyEnd:
			m.cursor = len([]rune(m.input))
			return m, nil
		case tea.KeyCtrlA:
			m.cursor = 0
			return m, nil
		case tea.KeyCtrlE:
			m.cursor = len([]rune(m.input))
			return m, nil
		case tea.KeyCtrlU:
			runes := []rune(m.input)
			m.input = string(runes[m.cursor:])
			m.cursor = 0
			return m, nil
		case tea.KeyCtrlK:
			runes := []rune(m.input)
			m.input = string(runes[:m.cursor])
			return m, nil
		case tea.KeyCtrlW:
			runes := []rune(m.input)
			end := m.cursor
			start := end
			for start > 0 && runes[start-1] == ' ' {
				start--
			}
			for start > 0 && runes[start-1] != ' ' {
				start--
			}
			m.input = string(runes[:start]) + string(runes[end:])
			m.cursor = start
			return m, nil
		case tea.KeyRunes:
			ch := msg.String()
			if ch == "?" && strings.TrimSpace(m.input) == "" {
				if m.lastMode == modeHelp {
					m.lastMode = modePrompt
					m.status = "help closed"
				} else {
					m.lastMode = modeHelp
					m.status = "help open"
				}
				return m, nil
			}
			if ch == ":" {
				m.lastMode = modeMenu
				m.status = "menu open"
				return m, nil
			}
			runes := []rune(m.input)
			ins := []rune(ch)
			m.input = string(runes[:m.cursor]) + string(ins) + string(runes[m.cursor:])
			m.cursor += len(ins)
			m.lastMode = modePrompt
			return m, nil
		}
	}

	return m, nil
}

func (m model) updateMenu(msg tea.KeyMsg) model {
	// When filter mode is active, all input is routed to the filter.
	if m.menu.Filtering {
		switch msg.Type {
		case tea.KeyEsc:
			m.menu.ExitFilter()
			m.status = "filter cleared"
		case tea.KeyBackspace:
			m.menu.BackspaceFilter()
			if m.menu.Filter == "" {
				m.status = "filter cleared"
			} else {
				m.status = "filter: " + m.menu.Filter
			}
		case tea.KeySpace:
			m.menu.AppendFilter(" ")
			m.status = "filter: " + m.menu.Filter
		case tea.KeyRunes:
			m.menu.AppendFilter(msg.String())
			m.status = "filter: " + m.menu.Filter
		}
		return m
	}

	switch msg.Type {
	case tea.KeyEsc:
		m.lastMode = modePrompt
		m.menuContext = ""
		m.status = "menu closed"
	case tea.KeyUp:
		m.menu.MoveUp()
		m.status = "menu move"
	case tea.KeyDown:
		m.menu.MoveDown()
		m.status = "menu move"
	case tea.KeyRunes:
		switch msg.String() {
		case "/":
			m.menu.EnterFilter()
			m.status = "filter mode"
		case "a":
			if m.menuContext == "workflow" {
				item, ok := m.menu.Current()
				if ok {
					selected := strings.TrimPrefix(item.Value, "__workflow_select__:")
					m.menuContext = ""
					m = m.submitWorkflowAction("workflow action "+selected+" advance", selected, "advance")
				}
			}
		case "p":
			if m.menuContext == "workflow" {
				item, ok := m.menu.Current()
				if ok {
					selected := strings.TrimPrefix(item.Value, "__workflow_select__:")
					m.menuContext = ""
					m = m.submitWorkflowAction("workflow action "+selected+" pause", selected, "pause")
				}
			}
		case "r":
			if m.menuContext == "job" {
				item, ok := m.menu.Current()
				if ok {
					selected := strings.TrimPrefix(item.Value, "__job_select__:")
					m.menuContext = ""
					m = m.submitAutomationResult("automation result "+selected, selected)
				}
			}
		}
		return m
	case tea.KeyEnter:
		item, ok := m.menu.Current()
		if !ok {
			m.lastMode = modePrompt
			m.status = "menu empty"
			return m
		}

		switch item.Value {
		case "__show_help__":
			m.blocks = append([]block.Block{
				{
					Title:   "Keybinding Summary",
					Body:    helpText(),
					Variant: block.VariantInfo,
				},
			}, m.blocks...)
			m.status = "help block added"
		case "__latest_workflow_advance__":
			if m.latestIDs.WorkflowID == "" {
				m = m.pushErrorPrompt("menu latest workflow advance", "no workflow in session")
			} else {
				m = m.submitWorkflowAction("workflow action "+m.latestIDs.WorkflowID+" advance", m.latestIDs.WorkflowID, "advance")
			}
		case "__latest_workflow_pause__":
			if m.latestIDs.WorkflowID == "" {
				m = m.pushErrorPrompt("menu latest workflow pause", "no workflow in session")
			} else {
				m = m.submitWorkflowAction("workflow action "+m.latestIDs.WorkflowID+" pause", m.latestIDs.WorkflowID, "pause")
			}
		case "__latest_job_result__":
			if m.latestIDs.JobID == "" {
				m = m.pushErrorPrompt("menu latest automation result", "no automation job in session")
			} else {
				m = m.submitAutomationResult("automation result "+m.latestIDs.JobID, m.latestIDs.JobID)
			}
		case "__show_workflow_ledger__":
			m = m.showWorkflowLedger("menu workflow ledger")
		case "__show_automation_ledger__":
			m = m.showAutomationLedger("menu automation ledger")
		case "__pick_workflow__":
			m = m.openWorkflowSelector()
		case "__pick_job__":
			m = m.openJobSelector()
		default:
			if strings.HasPrefix(item.Value, "__workflow_select__:") {
				selected := strings.TrimPrefix(item.Value, "__workflow_select__:")
				m.latestIDs.WorkflowID = selected
				m = m.showWorkflowStateFromLedger("menu workflow select "+selected, selected)
			} else if strings.HasPrefix(item.Value, "__job_select__:") {
				selected := strings.TrimPrefix(item.Value, "__job_select__:")
				m.latestIDs.JobID = selected
				m = m.showAutomationResultFromLedger("menu automation select "+selected, selected)
			} else {
				m.input = item.Value
				m.cursor = len([]rune(item.Value))
				m.status = "menu inserted command"
			}
		}

		m.lastMode = modePrompt
	}

	return m
}

func (m model) submit() model {
	raw := strings.TrimSpace(m.input)
	if handled, next := m.submitStarter(raw); handled {
		return next
	}
	if strings.HasPrefix(raw, "contract ") {
		return m.submitContract(raw)
	}
	if strings.HasPrefix(raw, "grid seed ") {
		return m.submitGridSeed(raw)
	}
	if strings.HasPrefix(raw, "? ") {
		return m.submitLocalAssist(raw)
	}
	if strings.HasPrefix(raw, "#wizard assist ") {
		return m.submitWizardAssist(raw)
	}
	if strings.HasPrefix(raw, "#ok route") {
		return m.submitOKRoute(raw)
	}
	if strings.HasPrefix(raw, "mcp ") {
		return m.submitMCP(raw)
	}
	if raw == "dev ops" || strings.HasPrefix(raw, "dev ops ") {
		return m.submitDevOps(raw)
	}
	if raw == "health startup" || raw == "health family" {
		return m.showStartupHealth(raw)
	}
	if raw == "setup story" {
		return m.showSetupStory(raw)
	}
	if strings.HasPrefix(raw, "demo ") {
		return m.submitDemo(raw)
	}
	if strings.HasPrefix(raw, "workflow ") {
		return m.submitWorkflow(raw)
	}
	if strings.HasPrefix(raw, "automation ") {
		return m.submitAutomation(raw)
	}
	if raw == "session workflows" {
		return m.showWorkflowLedger(raw)
	}
	if raw == "session jobs" {
		return m.showAutomationLedger(raw)
	}
	if raw == "session history" {
		return m.showSessionHistory(raw)
	}
	if isCoreScriptCommand(raw) {
		return m.submitCoreScript(raw)
	}

	if isPlainCLICommand(raw) {
		return m.submitCLI(raw)
	}

	parsed := ucode.Parse(raw)
	preview, err := dispatch.RenderPreview(parsed)

	promptBody := raw
	if promptBody == "" {
		promptBody = "<empty>"
	}

	newBlocks := []block.Block{
		{
			Title:   "Prompt",
			Body:    "uCODE> " + promptBody,
			Variant: block.VariantPrompt,
		},
	}

	if err != nil {
		newBlocks = append(newBlocks, block.Block{
			Title:   "Error",
			Body:    err.Error(),
			Variant: block.VariantError,
		})
		m.blocks = append(newBlocks, m.blocks...)
		m.status = "preview failed"
		m.lastRoute = "unresolved"
		m.input = ""
		m.cursor = 0
		m.lastMode = modePrompt
		return m
	}

	buf, err := json.MarshalIndent(preview, "", "  ")
	if err != nil {
		newBlocks = append(newBlocks, block.Block{
			Title:   "Error",
			Body:    fmt.Sprintf("marshal preview: %v", err),
			Variant: block.VariantError,
		})
		m.blocks = append(newBlocks, m.blocks...)
		m.status = "render failed"
		m.lastRoute = preview.Route
		m.input = ""
		m.cursor = 0
		m.lastMode = modePrompt
		return m
	}

	newBlocks = append(newBlocks,
		block.Block{
			Title: "Route Summary",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "owner", Value: preview.Owner},
				{Label: "route", Value: preview.Route},
				{Label: "lane", Value: preview.Lane},
				{Label: "adapter", Value: preview.Adapter},
				{Label: "runtime", Value: preview.RuntimeService},
				{Label: "version", Value: preview.Version},
			}, 72),
			Variant: block.VariantSuccess,
		},
		block.Block{
			Title:   "Preview",
			Body:    string(buf),
			Variant: block.VariantPlain,
		},
	)

	m.blocks = append(newBlocks, m.blocks...)
	if len(m.blocks) > 8 {
		m.blocks = m.blocks[:8]
	}
	m.status = "preview updated"
	m.lastRoute = preview.Route
	m.lastMode = modePrompt
	m.input = ""
	m.cursor = 0
	return m
}

func (m model) submitStarter(raw string) (bool, model) {
	switch {
	case raw == "help":
		return true, m.showStarterHelp(raw, "")
	case strings.HasPrefix(raw, "help "):
		return true, m.showStarterHelp(raw, strings.TrimSpace(strings.TrimPrefix(raw, "help ")))
	case raw == "commands":
		return true, m.showStarterCommands(raw, false)
	case raw == "commands list":
		return true, m.showStarterCommands(raw, true)
	case raw == "wizard" || raw == "wizard open":
		return true, m.launchWizard(raw, "default")
	case raw == "wizard dev":
		return true, m.launchWizard(raw, "dev")
	case raw == "status":
		return true, m.showStarterStatus(raw)
	case raw == "routes":
		return true, m.showStarterRoutes(raw)
	case raw == "test":
		return true, m.showStarterTests(raw)
	case raw == "test shell":
		return true, m.runStarterTest(raw, "shell")
	case raw == "test core":
		return true, m.runStarterTest(raw, "core")
	case raw == "test all":
		return true, m.runStarterTestSuite(raw, "shell", "core", "wizard")
	case raw == "doctor":
		return true, m.showDoctor(raw)
	case raw == "clear":
		m.blocks = defaultStartupBlocks()
		m.status = "screen cleared"
		m.lastRoute = "uCODE-TUI"
		m.lastMode = modePrompt
		m.input = ""
		m.cursor = 0
		return true, m
	case raw == "exit":
		m.quitting = true
		m.status = "session closed"
		m.lastRoute = "uCODE-TUI"
		m.lastMode = modePrompt
		m.input = ""
		m.cursor = 0
		return true, m
	default:
		return false, m
	}
}

func (m model) submitCoreScript(raw string) model {
	parsed := ucode.Parse(raw)
	scriptPath := strings.TrimSpace(parsed.Args["path"])
	if scriptPath == "" {
		return m.pushErrorPrompt(raw, "script usage: RUN <path-to-script.md> or SCRIPT RUN <path-to-script.md>")
	}

	result, err := localexec.RunCoreScript(scriptPath)
	if err != nil {
		m.appendHistory("script", scriptPath, "failed", "core-script-run", err.Error())
		return m.pushBlocks(raw, "uDOS-core", "core script run failed",
			block.Block{
				Title: "Core Script",
				Body: block.RenderFields(m.th, []block.Field{
					{Label: "path", Value: scriptPath},
					{Label: "owner", Value: "uDOS-core"},
					{Label: "status", Value: "failed"},
					{Label: "error", Value: err.Error()},
				}, 72),
				Variant: block.VariantError,
			},
			block.Block{
				Title:   "Core Output",
				Body:    strings.TrimSpace(result.Stdout + "\n" + result.Stderr),
				Variant: block.VariantPlain,
			},
		)
	}

	m.appendHistory("script", scriptPath, "completed", "core-script-run", "markdown script executed through core")
	body := strings.TrimSpace(result.Stdout)
	if body == "" {
		body = "<no stdout>"
	}

	return m.pushBlocks(raw, "uDOS-core", "core script run completed",
		block.Block{
			Title: "Core Script",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "path", Value: scriptPath},
				{Label: "owner", Value: "uDOS-core"},
				{Label: "status", Value: "completed"},
				{Label: "lane", Value: "core-runtime"},
			}, 72),
			Variant: block.VariantSuccess,
		},
		block.Block{
			Title:   "Core Output",
			Body:    body,
			Variant: block.VariantPlain,
		},
	)
}

func (m model) submitCLI(raw string) model {
	result, err := localexec.Run(raw)
	if err == nil {
		m.appendHistory("cli", raw, "completed", "execute", "local command executed")
		body := strings.TrimSpace(result.Stdout)
		if body == "" {
			body = "<no stdout>"
		}

		return m.pushBlocks(raw, "uDOS-core", "cli command completed",
			block.Block{
				Title: "CLI Result",
				Body: block.RenderFields(m.th, []block.Field{
					{Label: "command", Value: raw},
					{Label: "status", Value: "completed"},
					{Label: "lane", Value: "local-cli"},
				}, 72),
				Variant: block.VariantSuccess,
			},
			block.Block{
				Title:   "CLI Output",
				Body:    body,
				Variant: block.VariantPlain,
			},
		)
	}

	if result.ExitCode == 127 {
		return m.showUnknownCommand(raw)
	}

	m.appendHistory("cli", raw, "failed", "execute", err.Error())
	return m.submitLocalAssistFallback(raw, result, err)
}

func (m model) showUnknownCommand(raw string) model {
	m.appendHistory("starter", raw, "unknown", "guide", "starter guidance shown for unknown command")
	return m.pushBlocks(raw, "uCODE-TUI", "unknown command",
		block.Block{
			Title: "Unknown Command",
			Body: strings.Join([]string{
				fmt.Sprintf("Unknown command: %s", raw),
				"",
				"Try:",
				"  help",
				"  commands",
				"  help <command>",
			}, "\n"),
			Variant: block.VariantWarn,
		},
	)
}

func (m model) submitLocalAssist(raw string) model {
	question := strings.TrimSpace(strings.TrimPrefix(raw, "?"))
	if question == "" {
		return m.pushErrorPrompt(raw, "local assist usage: ? <question>")
	}

	envelope := map[string]any{
		"task":                question,
		"mode":                "offline",
		"surface":             "assist",
		"owner":               "uDOS-core",
		"assist_lane":         "local-gpt4all",
		"model_adapter":       "gpt4all-clone",
		"wizard_handoff_mode": "not-used",
		"status":              "preview-only",
	}

	buf, err := json.MarshalIndent(envelope, "", "  ")
	if err != nil {
		return m.pushErrorPrompt(raw, fmt.Sprintf("marshal local assist request: %v", err))
	}

	m.appendHistory("assist", "local-gpt4all", "prepared", "ask-local", question)

	return m.pushBlocks(raw, "uDOS-core", "local assist prepared",
		block.Block{
			Title: "Local Assist",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "question", Value: question},
				{Label: "owner", Value: "uDOS-core"},
				{Label: "lane", Value: "local-gpt4all"},
				{Label: "adapter", Value: "gpt4all-clone"},
				{Label: "wizard", Value: "other assist/API lanes"},
				{Label: "status", Value: "preview-only"},
			}, 72),
			Variant: block.VariantAssistLocal,
		},
		block.Block{
			Title:   "Local Assist Envelope",
			Body:    string(buf),
			Variant: block.VariantPlain,
		},
	)
}

func (m model) submitLocalAssistFallback(raw string, cliResult localexec.Result, cliErr error) model {
	stamp, err := contracts.LoadKnowledgeStamp()
	if err != nil {
		return m.pushErrorPrompt(raw, fmt.Sprintf("load knowledge stamp: %v", err))
	}

	envelope := map[string]any{
		"task":          "consider failed cli command",
		"question":      raw,
		"mode":          "offline",
		"surface":       "assist",
		"owner":         "uDOS-core",
		"assist_lane":   "local-gpt4all",
		"model_adapter": "gpt4all-clone",
		"status":        "fallback-preview",
		"dev_tags":      []string{devTagLocalGPT4AllUpdate, devTagCLIFallback},
		"failed_cli": map[string]any{
			"command":   cliResult.Command,
			"stdout":    strings.TrimSpace(cliResult.Stdout),
			"stderr":    strings.TrimSpace(cliResult.Stderr),
			"exit_code": cliResult.ExitCode,
			"error":     cliErr.Error(),
		},
		"knowledge_stamp": stamp,
	}

	buf, err := json.MarshalIndent(envelope, "", "  ")
	if err != nil {
		return m.pushErrorPrompt(raw, fmt.Sprintf("marshal local assist fallback: %v", err))
	}

	m.appendHistory("assist", "local-gpt4all", "prepared", "cli-fallback", devTagCLIFallback+" "+devTagLocalGPT4AllUpdate+" "+raw)

	return m.pushBlocks(raw, "uDOS-core", "cli failed, routed to local assist",
		block.Block{
			Title: "CLI Failure",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "command", Value: raw},
				{Label: "exit", Value: fmt.Sprintf("%d", cliResult.ExitCode)},
				{Label: "error", Value: cliErr.Error()},
			}, 72),
			Variant: block.VariantError,
		},
		block.Block{
			Title: "Local Assist Fallback",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "owner", Value: "uDOS-core"},
				{Label: "lane", Value: "local-gpt4all"},
				{Label: "clone", Value: "version-locked"},
				{Label: "runtime", Value: stamp.RuntimeServicesVersion},
				{Label: "workflow", Value: stamp.Contracts["workflow-state"]},
				{Label: "automation", Value: stamp.Contracts["automation-job"]},
			}, 72),
			Variant: block.VariantAssistLocal,
		},
		block.Block{
			Title:   "Fallback Envelope",
			Body:    string(buf),
			Variant: block.VariantPlain,
		},
	)
}

func (m model) submitWizardAssist(raw string) model {
	parsed := ucode.Parse(raw)
	preview, err := dispatch.RenderPreview(parsed)
	if err != nil {
		return m.pushErrorPrompt(raw, err.Error())
	}

	question := parsed.Args["topic"]
	if question == "" {
		question = "assist"
	}

	result, liveErr := localexec.WizardAssist(question, "auto")
	if liveErr != nil {
		envelope := map[string]any{
			"task":           question,
			"mode":           "auto",
			"surface":        "assist",
			"owner":          "uDOS-wizard",
			"executor":       "provider-router",
			"assist_lane":    "wizard-online",
			"status":         "preview-fallback",
			"route":          preview.Route,
			"runtimeService": preview.RuntimeService,
			"base_url":       localexec.WizardBaseURL(),
			"error":          liveErr.Error(),
		}
		buf, err := json.MarshalIndent(envelope, "", "  ")
		if err != nil {
			return m.pushErrorPrompt(raw, fmt.Sprintf("marshal wizard assist fallback: %v", err))
		}

		m.appendHistory("assist", "wizard-online", "preview-fallback", "ask-wizard", question)

		return m.pushBlocks(raw, "uDOS-wizard", "wizard assist preview fallback",
			block.Block{
				Title: "Wizard Assist",
				Body: block.RenderFields(m.th, []block.Field{
					{Label: "task", Value: question},
					{Label: "owner", Value: "uDOS-wizard"},
					{Label: "lane", Value: "wizard-online"},
					{Label: "executor", Value: "provider-router"},
					{Label: "status", Value: "preview-fallback"},
					{Label: "base url", Value: localexec.WizardBaseURL()},
					{Label: "error", Value: liveErr.Error()},
				}, 72),
				Variant: block.VariantAssistWizard,
			},
			block.Block{
				Title:   "Wizard Assist Envelope",
				Body:    string(buf),
				Variant: block.VariantPlain,
			},
		)
	}

	result.Payload["base_url"] = result.BaseURL
	result.Payload["route"] = preview.Route
	result.Payload["runtimeService"] = preview.RuntimeService
	buf, err := json.MarshalIndent(result.Payload, "", "  ")
	if err != nil {
		return m.pushErrorPrompt(raw, fmt.Sprintf("marshal wizard assist response: %v", err))
	}

	dispatchID := emptyFallback(stringValue(result.Payload["dispatch_id"]), "wizard-online")
	status := emptyFallback(stringValue(result.Payload["status"]), "queued")
	m.appendHistory("assist", dispatchID, status, "ask-wizard", question)

	return m.pushBlocks(raw, "uDOS-wizard", fmt.Sprintf("wizard assist %s", status),
		block.Block{
			Title: "Wizard Assist",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "task", Value: question},
				{Label: "owner", Value: "uDOS-wizard"},
				{Label: "lane", Value: "wizard-online"},
				{Label: "executor", Value: emptyFallback(stringValue(result.Payload["executor"]), "provider-router")},
				{Label: "transport", Value: emptyFallback(stringValue(result.Payload["transport"]), "https")},
				{Label: "status", Value: status},
				{Label: "dispatch id", Value: dispatchID},
				{Label: "base url", Value: result.BaseURL},
			}, 72),
			Variant: block.VariantAssistWizard,
		},
		block.Block{
			Title:   "Wizard Assist Envelope",
			Body:    string(buf),
			Variant: block.VariantPlain,
		},
	)
}

func (m model) submitOKRoute(raw string) model {
	parsed := ucode.Parse(raw)
	if parsed.Namespace != "ok" || parsed.Action != "route" {
		return m.pushErrorPrompt(raw, "ok route usage: #ok route class:<task-class> topic:<task> budgets:<group1,group2>")
	}

	taskClass := strings.TrimSpace(parsed.Args["class"])
	if taskClass == "" {
		taskClass = strings.TrimSpace(parsed.Args["task"])
	}
	if taskClass == "" {
		taskClass = "analysis"
	}

	task := strings.TrimSpace(parsed.Args["topic"])
	if task == "" {
		task = strings.TrimSpace(parsed.Args["items"])
	}
	if task == "" {
		task = "assist"
	}

	payload := map[string]any{
		"task_class": taskClass,
		"task":       task,
	}

	if complexity := strings.ToUpper(strings.TrimSpace(parsed.Args["complexity"])); complexity != "" {
		payload["complexity"] = complexity
	}

	budgetText := strings.TrimSpace(parsed.Args["budgets"])
	if budgetText == "" {
		budgetText = strings.TrimSpace(parsed.Args["budget"])
	}
	if budgetText != "" {
		groups := parseCSVArg(budgetText)
		if len(groups) > 0 {
			payload["allowed_budget_groups"] = groups
		}
	}

	if parseBoolArg(parsed.Args["offline"]) {
		payload["offline_sufficient"] = true
	}
	if parseBoolArg(parsed.Args["cache"]) {
		payload["cache_hit"] = true
	}

	result, liveErr := localexec.WizardOKRoute(payload)
	if liveErr != nil {
		envelope := map[string]any{
			"surface":        "ok-route",
			"owner":          "uDOS-wizard",
			"status":         "preview-fallback",
			"base_url":       localexec.WizardBaseURL(),
			"request":        payload,
			"runtimeService": "runtime.capability-registry",
			"error":          liveErr.Error(),
		}
		buf, err := json.MarshalIndent(envelope, "", "  ")
		if err != nil {
			return m.pushErrorPrompt(raw, fmt.Sprintf("marshal ok route fallback: %v", err))
		}

		m.appendHistory("ok-route", "wizard-ok-route", "preview-fallback", "route", taskClass+" "+task)

		return m.pushBlocks(raw, "uDOS-wizard", "ok route preview fallback",
			block.Block{
				Title: "OK Route",
				Body: block.RenderFields(m.th, []block.Field{
					{Label: "task-class", Value: taskClass},
					{Label: "task", Value: task},
					{Label: "status", Value: "preview-fallback"},
					{Label: "base url", Value: localexec.WizardBaseURL()},
					{Label: "error", Value: liveErr.Error()},
				}, 72),
				Variant: block.VariantWarn,
			},
			block.Block{
				Title:   "OK Route Envelope",
				Body:    string(buf),
				Variant: block.VariantPlain,
			},
		)
	}

	decision := mapValue(result.Payload["decision"])
	request := mapValue(result.Payload["request"])
	if len(request) == 0 {
		request = payload
	}

	status := emptyFallback(rawStringValue(decision["status"]), "routed")
	providerID := emptyFallback(rawStringValue(decision["provider_id"]), "n/a")
	result.Payload["base_url"] = result.BaseURL
	buf, err := json.MarshalIndent(result.Payload, "", "  ")
	if err != nil {
		return m.pushErrorPrompt(raw, fmt.Sprintf("marshal ok route response: %v", err))
	}

	m.appendHistory("ok-route", providerID, status, "route", taskClass+" "+task)

	return m.pushBlocks(raw, "uDOS-wizard", fmt.Sprintf("ok route %s", status),
		block.Block{
			Title: "OK Route",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "task-class", Value: emptyFallback(rawStringValue(request["task_class"]), taskClass)},
				{Label: "task", Value: emptyFallback(rawStringValue(request["task"]), task)},
				{Label: "complexity", Value: emptyFallback(rawStringValue(decision["complexity"]), "n/a")},
				{Label: "provider", Value: providerID},
				{Label: "budget", Value: emptyFallback(rawStringValue(decision["budget_group"]), "n/a")},
				{Label: "status", Value: status},
				{Label: "reason", Value: emptyFallback(rawStringValue(decision["reason"]), "n/a")},
				{Label: "base url", Value: result.BaseURL},
			}, 72),
			Variant: block.VariantSuccess,
		},
		block.Block{
			Title:   "OK Route Envelope",
			Body:    string(buf),
			Variant: block.VariantPlain,
		},
	)
}

func (m model) submitMCP(raw string) model {
	parts := strings.Fields(raw)
	if len(parts) < 2 {
		return m.pushErrorPrompt(raw, "mcp usage: mcp init | mcp tools | mcp call <tool-name> key:value")
	}

	switch parts[1] {
	case "init", "initialize":
		return m.submitMCPInitialize(raw)
	case "tools", "list":
		return m.submitMCPTools(raw)
	case "call":
		if len(parts) < 3 {
			return m.pushErrorPrompt(raw, "mcp call usage: mcp call <tool-name> key:value")
		}
		return m.submitMCPCall(raw, parts[2], parts[3:])
	default:
		return m.pushErrorPrompt(raw, "unknown mcp command")
	}
}

func (m model) submitMCPInitialize(raw string) model {
	result, err := localexec.WizardMCPInitialize("uDOS-shell")
	if err != nil {
		m.appendHistory("mcp", "initialize", "failed", "initialize", err.Error())
		return m.pushBlocks(raw, "uDOS-wizard", "mcp initialize failed",
			block.Block{
				Title: "MCP Initialize",
				Body: block.RenderFields(m.th, []block.Field{
					{Label: "client", Value: "uDOS-shell"},
					{Label: "status", Value: "failed"},
					{Label: "base url", Value: localexec.WizardBaseURL()},
					{Label: "error", Value: err.Error()},
				}, 72),
				Variant: block.VariantError,
			},
		)
	}

	response := mapValue(result.Payload["result"])
	serverInfo := mapValue(response["serverInfo"])
	capabilities := mapValue(response["capabilities"])
	toolsCapability := mapValue(capabilities["tools"])
	buf, err := json.MarshalIndent(result.Payload, "", "  ")
	if err != nil {
		return m.pushErrorPrompt(raw, fmt.Sprintf("marshal mcp initialize response: %v", err))
	}

	m.appendHistory("mcp", "initialize", "connected", "initialize", "wizard mcp handshake completed")

	return m.pushBlocks(raw, "uDOS-wizard", "mcp initialize completed",
		block.Block{
			Title: "MCP Initialize",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "client", Value: "uDOS-shell"},
				{Label: "server", Value: emptyFallback(rawStringValue(serverInfo["name"]), "uDOS Wizard MCP")},
				{Label: "version", Value: emptyFallback(rawStringValue(serverInfo["version"]), "v2.2")},
				{Label: "tools.listChanged", Value: fmt.Sprintf("%t", boolValue(toolsCapability["listChanged"], false))},
				{Label: "base url", Value: result.BaseURL},
			}, 72),
			Variant: block.VariantSuccess,
		},
		block.Block{
			Title:   "MCP Initialize Envelope",
			Body:    string(buf),
			Variant: block.VariantPlain,
		},
	)
}

func (m model) submitMCPTools(raw string) model {
	result, err := localexec.WizardMCPListTools()
	if err != nil {
		m.appendHistory("mcp", "tools/list", "failed", "tools-list", err.Error())
		return m.pushBlocks(raw, "uDOS-wizard", "mcp tools failed",
			block.Block{
				Title: "MCP Tools",
				Body: block.RenderFields(m.th, []block.Field{
					{Label: "status", Value: "failed"},
					{Label: "base url", Value: localexec.WizardBaseURL()},
					{Label: "error", Value: err.Error()},
				}, 72),
				Variant: block.VariantError,
			},
		)
	}

	response := mapValue(result.Payload["result"])
	tools := sliceValue(response["tools"])
	buf, err := json.MarshalIndent(result.Payload, "", "  ")
	if err != nil {
		return m.pushErrorPrompt(raw, fmt.Sprintf("marshal mcp tools response: %v", err))
	}

	m.appendHistory("mcp", "tools/list", "completed", "tools-list", fmt.Sprintf("%d tools discovered", len(tools)))

	return m.pushBlocks(raw, "uDOS-wizard", "mcp tools loaded",
		block.Block{
			Title: "MCP Tools",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "count", Value: fmt.Sprintf("%d", len(tools))},
				{Label: "base url", Value: result.BaseURL},
				{Label: "surface", Value: "wizard-jsonrpc"},
			}, 72),
			Variant: block.VariantSuccess,
		},
		block.Block{
			Title:   "MCP Tool List",
			Body:    renderMCPToolList(tools),
			Variant: block.VariantInfo,
		},
		block.Block{
			Title:   "MCP Tool Artifact",
			Body:    string(buf),
			Variant: block.VariantPlain,
		},
	)
}

func (m model) submitMCPCall(raw string, toolName string, items []string) model {
	arguments := parseMCPArguments(items)
	result, err := localexec.WizardMCPCall(toolName, arguments)
	if err != nil {
		m.appendHistory("mcp", toolName, "failed", "tools-call", err.Error())
		return m.pushBlocks(raw, "uDOS-wizard", "mcp call failed",
			block.Block{
				Title: "MCP Tool Call",
				Body: block.RenderFields(m.th, []block.Field{
					{Label: "tool", Value: toolName},
					{Label: "status", Value: "failed"},
					{Label: "base url", Value: localexec.WizardBaseURL()},
					{Label: "error", Value: err.Error()},
				}, 72),
				Variant: block.VariantError,
			},
		)
	}

	response := mapValue(result.Payload["result"])
	tool := mapValue(response["tool"])
	invocationResult := mapValue(response["result"])
	status := emptyFallback(rawStringValue(invocationResult["status"]), "completed")
	buf, err := json.MarshalIndent(result.Payload, "", "  ")
	if err != nil {
		return m.pushErrorPrompt(raw, fmt.Sprintf("marshal mcp call response: %v", err))
	}

	m.appendHistory("mcp", toolName, status, "tools-call", summarizeMCPArguments(arguments))

	return m.pushBlocks(raw, "uDOS-wizard", fmt.Sprintf("mcp call %s", status),
		block.Block{
			Title: "MCP Tool Call",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "tool", Value: emptyFallback(rawStringValue(tool["name"]), toolName)},
				{Label: "status", Value: status},
				{Label: "owner", Value: emptyFallback(rawStringValue(mapValue(tool["annotations"])["owner"]), "uDOS-wizard")},
				{Label: "surface", Value: emptyFallback(rawStringValue(mapValue(tool["annotations"])["surface"]), "managed-mcp")},
				{Label: "base url", Value: result.BaseURL},
			}, 72),
			Variant: block.VariantSuccess,
		},
		block.Block{
			Title:   "MCP Arguments",
			Body:    renderPrettyJSON(arguments),
			Variant: block.VariantPlain,
		},
		block.Block{
			Title:   "MCP Result",
			Body:    renderPrettyJSON(invocationResult),
			Variant: block.VariantInfo,
		},
		block.Block{
			Title:   "MCP Call Artifact",
			Body:    string(buf),
			Variant: block.VariantPlain,
		},
	)
}

func (m model) submitDevOps(raw string) model {
	parts := strings.Fields(raw)
	if len(parts) == 2 || (len(parts) >= 3 && parts[2] == "list") {
		return m.showDevOpsDocs(raw)
	}

	name := normalizeDevOpsDocName(parts[2:])
	if name == "" {
		return m.pushErrorPrompt(raw, "dev ops usage: dev ops list | dev ops <overview|mcp-support|runbook|operation-modes>")
	}

	body, sourcePath, err := contracts.LoadDevOperationsDoc(name)
	if err != nil {
		return m.pushErrorPrompt(raw, err.Error())
	}

	m.appendHistory("dev-ops", name, "loaded", "inspect", "operations reference loaded")

	return m.pushBlocks(raw, "uDOS-dev", "dev operations loaded",
		block.Block{
			Title: "Dev Operations",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "document", Value: name},
				{Label: "owner", Value: "uDOS-dev"},
				{Label: "mode", Value: "read-only"},
				{Label: "source", Value: sourcePath},
			}, 72),
			Variant: block.VariantInfo,
		},
		block.Block{
			Title:   "Operations Document",
			Body:    body,
			Variant: block.VariantPlain,
		},
	)
}

func (m model) showDevOpsDocs(raw string) model {
	names := contracts.ListDevOperationsDocs()
	lines := make([]string, 0, len(names))
	for _, name := range names {
		lines = append(lines, name)
	}

	m.appendHistory("dev-ops", "index", "loaded", "list", fmt.Sprintf("%d documents available", len(lines)))

	return m.pushBlocks(raw, "uDOS-dev", "dev operations index loaded",
		block.Block{
			Title: "Dev Operations Docs",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "owner", Value: "uDOS-dev"},
				{Label: "count", Value: fmt.Sprintf("%d", len(lines))},
				{Label: "hint", Value: "dev ops <name>"},
			}, 72),
			Variant: block.VariantInfo,
		},
		block.Block{
			Title:   "Available Documents",
			Body:    strings.Join(lines, "\n"),
			Variant: block.VariantPlain,
		},
	)
}

func (m model) showStartupHealth(raw string) model {
	checks := localexec.StartupHealthChecks()
	lines := make([]string, 0, len(checks))
	presentCount := 0
	for _, check := range checks {
		status := "missing"
		if check.Present {
			status = "ready"
			presentCount++
		}
		lines = append(lines, fmt.Sprintf("%s  %s  %s", check.Repo, status, check.ScriptPath))
	}

	m.appendHistory("health", "startup", "loaded", "inspect", fmt.Sprintf("%d/%d scripts detected", presentCount, len(checks)))

	return m.pushBlocks(raw, "uCODE-TUI", "startup health loaded",
		block.Block{
			Title: "Startup Health",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "family checks", Value: fmt.Sprintf("%d/%d", presentCount, len(checks))},
				{Label: "shell", Value: "uDOS-shell"},
				{Label: "focus", Value: "validation entrypoints"},
			}, 72),
			Variant: block.VariantInfo,
		},
		block.Block{
			Title:   "Detected Scripts",
			Body:    strings.Join(lines, "\n"),
			Variant: block.VariantPlain,
		},
	)
}

func (m model) showSetupStory(raw string) model {
	steps := []string{
		"1. Run `health startup` to inspect sibling validation entrypoints.",
		"2. Run `demo list` and start with `demo run thinui-c64` or `demo run ubuntu-setup`.",
		"3. Validate `uDOS-shell` with `bash scripts/run-shell-checks.sh`.",
		"4. Validate `uDOS-thinui` with `bash ../uDOS-thinui/scripts/run-thinui-checks.sh`.",
		"5. Validate launcher repos with Alpine, Ubuntu, and Sonic demo/check scripts.",
	}
	_ = localexec.MarkSetupStorySeen()
	m.appendHistory("setup", "story", "shown", "guide", "first-run setup story shown")

	return m.pushBlocks(raw, "uCODE-TUI", "setup story shown",
		block.Block{
			Title:   "Setup Story",
			Body:    strings.Join(steps, "\n"),
			Variant: block.VariantWarn,
		},
		block.Block{
			Title: "Installers",
			Body: strings.Join([]string{
				"shell: npm install",
				"sonic: bash ../sonic-screwdriver/installers/setup/install-sonic-editable.sh",
				"wizard: bash ../uDOS-wizard/scripts/run-wizard-checks.sh",
			}, "\n"),
			Variant: block.VariantPlain,
		},
	)
}

func (m model) submitDemo(raw string) model {
	parts := strings.Fields(raw)
	if len(parts) < 2 {
		return m.pushErrorPrompt(raw, "demo usage: demo list | demo ux | demo run <id>")
	}

	switch parts[1] {
	case "list":
		return m.showDemoList(raw)
	case "ux":
		return m.showUXDemoLaunch(raw)
	case "run":
		if len(parts) < 3 {
			return m.pushErrorPrompt(raw, "demo run usage: demo run <id>")
		}
		return m.runDemo(raw, parts[2])
	default:
		return m.pushErrorPrompt(raw, "unknown demo command")
	}
}

func (m model) showUXDemoLaunch(raw string) model {
	m.appendHistory("demo", "ux", "hint", "launch", "visual UX demo pack")

	body := strings.Join([]string{
		"Visual shell UX demo: ASCII layouts and components — not parser or route preview.",
		"",
		"Interactive (cycle scenes, Tab simulates focus regions):",
		"  go run ./cmd/demo-ux",
		"  bash scripts/demo-ux-walk.sh",
		"",
		"Static walk (terminal-friendly, stakeholder review):",
		"  go run ./cmd/demo-ux --static",
		"  bash scripts/demo-ux-walk.sh --static",
		"",
		"Golden fixtures:",
		"  demo/screens/*.txt  demo/components/*.txt  demo/patterns/gallery.txt",
	}, "\n")

	return m.pushBlocks(raw, "uCODE-TUI", "ux demo",
		block.Block{
			Title:   "UX demo pack",
			Body:    body,
			Variant: block.VariantInfo,
		},
	)
}

func (m model) showDemoList(raw string) model {
	demos := localexec.ListFamilyDemos()
	lines := make([]string, 0, len(demos))
	for _, demo := range demos {
		lines = append(lines, fmt.Sprintf("%s  %s", demo.ID, demo.Description))
	}
	m.appendHistory("demo", "catalog", "loaded", "list", fmt.Sprintf("%d demos available", len(demos)))

	return m.pushBlocks(raw, "uCODE-TUI", "demo catalog loaded",
		block.Block{
			Title: "Demo Catalog",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "count", Value: fmt.Sprintf("%d", len(demos))},
				{Label: "hint", Value: "demo run <id>"},
			}, 72),
			Variant: block.VariantInfo,
		},
		block.Block{
			Title:   "Available Demos",
			Body:    strings.Join(lines, "\n"),
			Variant: block.VariantPlain,
		},
	)
}

func (m model) runDemo(raw string, id string) model {
	result, err := localexec.RunFamilyDemo(id)
	if err != nil {
		m.appendHistory("demo", id, "failed", "run", err.Error())
		return m.pushBlocks(raw, "uCODE-TUI", "demo failed",
			block.Block{
				Title: "Demo Run",
				Body: block.RenderFields(m.th, []block.Field{
					{Label: "demo", Value: id},
					{Label: "status", Value: "failed"},
					{Label: "error", Value: err.Error()},
				}, 72),
				Variant: block.VariantError,
			},
		)
	}

	m.appendHistory("demo", id, "completed", "run", "family demo executed")
	body := strings.TrimSpace(result.Stdout)
	if body == "" {
		body = "<no stdout>"
	}

	return m.pushBlocks(raw, "uCODE-TUI", "demo completed",
		block.Block{
			Title: "Demo Run",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "demo", Value: id},
				{Label: "status", Value: "completed"},
				{Label: "command", Value: result.Command},
			}, 72),
			Variant: block.VariantSuccess,
		},
		block.Block{
			Title:   "Demo Output",
			Body:    body,
			Variant: block.VariantPlain,
		},
	)
}

func (m model) submitWorkflow(raw string) model {
	parts := strings.Fields(raw)
	if len(parts) < 3 {
		return m.pushErrorPrompt(raw, "workflow usage: workflow state <workflow-id> | workflow action <workflow-id> <action>")
	}

	switch parts[1] {
	case "state":
		return m.submitWorkflowState(raw, parts[2])
	case "action":
		if len(parts) < 4 {
			return m.pushErrorPrompt(raw, "workflow action usage: workflow action <workflow-id> <action>")
		}
		return m.submitWorkflowAction(raw, parts[2], parts[3])
	default:
		return m.pushErrorPrompt(raw, "unknown workflow command")
	}
}

func (m model) submitWorkflowState(raw string, workflowID string) model {
	contract, sourcePath, err := contracts.LoadNamedContract("workflow-state")
	if err != nil {
		return m.pushErrorPrompt(raw, err.Error())
	}

	state := m.workflows[workflowID]
	if state.WorkflowID == "" {
		state = workflowState{
			WorkflowID:         workflowID,
			StepID:             "inspect-contracts",
			Status:             "ready",
			AwaitingUserAction: true,
			LastTransitionAt:   time.Now().UTC().Format(time.RFC3339),
			OriginSurface:      "uCODE-TUI",
		}
	}
	m.workflows[workflowID] = state
	m.latestIDs.WorkflowID = workflowID
	m.appendHistory("workflow", workflowID, state.Status, "state", "workflow state inspected")

	envelope := map[string]any{
		"workflow_id":          state.WorkflowID,
		"step_id":              state.StepID,
		"status":               state.Status,
		"awaiting_user_action": state.AwaitingUserAction,
		"last_transition_at":   state.LastTransitionAt,
		"origin_surface":       state.OriginSurface,
	}

	buf, err := json.MarshalIndent(envelope, "", "  ")
	if err != nil {
		return m.pushErrorPrompt(raw, fmt.Sprintf("marshal workflow-state: %v", err))
	}

	return m.pushBlocks(raw, "uDOS-core", "workflow-state ready",
		block.Block{
			Title: "Workflow State",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "workflow", Value: workflowID},
				{Label: "status", Value: state.Status},
				{Label: "step", Value: state.StepID},
				{Label: "origin", Value: state.OriginSurface},
				{Label: "authority", Value: ownerString(contract.Owners["policy"])},
				{Label: "runtime", Value: ownerString(contract.Owners["durable_execution_consumer"])},
				{Label: "source", Value: sourcePath},
			}, 72),
			Variant: block.VariantInfo,
		},
		block.Block{
			Title:   "Workflow State Envelope",
			Body:    string(buf),
			Variant: block.VariantPlain,
		},
	)
}

func (m model) submitWorkflowAction(raw string, workflowID string, action string) model {
	contract, sourcePath, err := contracts.LoadNamedContract("workflow-action")
	if err != nil {
		return m.pushErrorPrompt(raw, err.Error())
	}
	if !slices.Contains(contract.ActionValues, action) {
		return m.pushErrorPrompt(raw, fmt.Sprintf("unsupported workflow action %q", action))
	}

	preview, err := dispatch.RenderPreview(ucode.Parse("#wizard assist topic:workflow"))
	if err != nil {
		return m.pushErrorPrompt(raw, err.Error())
	}

	state := m.workflows[workflowID]
	if state.WorkflowID == "" {
		state = workflowState{
			WorkflowID:    workflowID,
			StepID:        "prompt-action",
			Status:        "draft",
			OriginSurface: "uCODE-TUI",
		}
	}

	result, liveErr := localexec.WizardWorkflowAction(workflowID, action)
	if liveErr == nil {
		actionPayload := mapValue(result.Payload["action"])
		statePayload := mapValue(result.Payload["state"])
		liveState := workflowState{
			WorkflowID:         emptyFallback(rawStringValue(statePayload["workflow_id"]), workflowID),
			StepID:             emptyFallback(rawStringValue(statePayload["step_id"]), emptyFallback(state.StepID, "step-1")),
			Status:             emptyFallback(rawStringValue(statePayload["status"]), emptyFallback(state.Status, "draft")),
			AwaitingUserAction: boolValue(statePayload["awaiting_user_action"], state.AwaitingUserAction),
			LastTransitionAt:   emptyFallback(rawStringValue(statePayload["last_transition_at"]), time.Now().UTC().Format(time.RFC3339)),
			OriginSurface:      emptyFallback(rawStringValue(statePayload["origin_surface"]), "uCODE-TUI"),
		}
		m.workflows[liveState.WorkflowID] = liveState
		m.latestIDs.WorkflowID = liveState.WorkflowID
		m.appendHistory("workflow", liveState.WorkflowID, liveState.Status, action, "workflow action handed to wizard")

		result.Payload["base_url"] = result.BaseURL
		result.Payload["route"] = "/workflow/actions"
		result.Payload["runtimeService"] = preview.RuntimeService
		buf, err := json.MarshalIndent(result.Payload, "", "  ")
		if err != nil {
			return m.pushErrorPrompt(raw, fmt.Sprintf("marshal live workflow-action: %v", err))
		}

		return m.pushBlocks(raw, "uDOS-wizard", fmt.Sprintf("workflow action %s", liveState.Status),
			block.Block{
				Title: "Workflow Action",
				Body: block.RenderFields(m.th, []block.Field{
					{Label: "workflow", Value: liveState.WorkflowID},
					{Label: "action", Value: emptyFallback(rawStringValue(actionPayload["action"]), action)},
					{Label: "requested", Value: emptyFallback(rawStringValue(actionPayload["requested_by"]), "uCODE-TUI")},
					{Label: "executor", Value: "wizard workflow store"},
					{Label: "transport", Value: "http"},
					{Label: "base url", Value: result.BaseURL},
					{Label: "policy", Value: ownerString(contract.Owners["policy"])},
					{Label: "source", Value: sourcePath},
				}, 72),
				Variant: block.VariantSuccess,
			},
			block.Block{
				Title:   "Workflow Action Envelope",
				Body:    string(buf),
				Variant: block.VariantPlain,
			},
			block.Block{
				Title: "Updated Workflow State",
				Body: block.RenderFields(m.th, []block.Field{
					{Label: "workflow", Value: liveState.WorkflowID},
					{Label: "step", Value: liveState.StepID},
					{Label: "status", Value: liveState.Status},
					{Label: "awaiting-user", Value: fmt.Sprintf("%t", liveState.AwaitingUserAction)},
					{Label: "transition", Value: liveState.LastTransitionAt},
					{Label: "origin", Value: liveState.OriginSurface},
				}, 72),
				Variant: block.VariantInfo,
			},
		)
	}

	state.LastTransitionAt = time.Now().UTC().Format(time.RFC3339)
	switch action {
	case "advance", "resume", "approve":
		state.Status = "running"
		state.AwaitingUserAction = false
	case "pause":
		state.Status = "paused"
		state.AwaitingUserAction = true
	case "reject":
		state.Status = "blocked"
		state.AwaitingUserAction = true
	case "request-assist", "replan":
		state.Status = "blocked"
		state.AwaitingUserAction = false
	}
	m.workflows[workflowID] = state
	m.latestIDs.WorkflowID = workflowID
	m.appendHistory("workflow", workflowID, state.Status, action, "workflow action applied")

	envelope := map[string]any{
		"workflow_id":  workflowID,
		"action":       action,
		"requested_by": "uCODE-TUI",
		"requested_at": time.Now().UTC().Format(time.RFC3339),
		"policy_flags": []string{"requires-wizard-policy"},
	}

	buf, err := json.MarshalIndent(envelope, "", "  ")
	if err != nil {
		return m.pushErrorPrompt(raw, fmt.Sprintf("marshal workflow-action: %v", err))
	}

	return m.pushBlocks(raw, "uDOS-wizard", "workflow action preview fallback",
		block.Block{
			Title: "Workflow Action",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "workflow", Value: workflowID},
				{Label: "action", Value: action},
				{Label: "new-status", Value: state.Status},
				{Label: "requested", Value: "uCODE-TUI"},
				{Label: "transport", Value: "preview-fallback"},
				{Label: "base url", Value: localexec.WizardBaseURL()},
				{Label: "error", Value: liveErr.Error()},
				{Label: "policy", Value: ownerString(contract.Owners["policy"])},
				{Label: "source", Value: sourcePath},
			}, 72),
			Variant: block.VariantSuccess,
		},
		block.Block{
			Title:   "Workflow Action Envelope",
			Body:    string(buf),
			Variant: block.VariantPlain,
		},
		block.Block{
			Title: "Updated Workflow State",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "workflow", Value: state.WorkflowID},
				{Label: "step", Value: state.StepID},
				{Label: "status", Value: state.Status},
				{Label: "awaiting-user", Value: fmt.Sprintf("%t", state.AwaitingUserAction)},
				{Label: "transition", Value: state.LastTransitionAt},
			}, 72),
			Variant: block.VariantInfo,
		},
	)
}

func (m model) submitAutomation(raw string) model {
	parts := strings.Fields(raw)
	if len(parts) < 3 {
		return m.pushErrorPrompt(raw, "automation usage: automation queue <capability> | automation result <job-id>")
	}

	switch parts[1] {
	case "queue":
		return m.submitAutomationQueue(raw, parts[2])
	case "result":
		return m.submitAutomationResult(raw, parts[2])
	default:
		return m.pushErrorPrompt(raw, "unknown automation command")
	}
}

func (m model) submitAutomationQueue(raw string, capability string) model {
	contract, sourcePath, err := contracts.LoadNamedContract("automation-job")
	if err != nil {
		return m.pushErrorPrompt(raw, err.Error())
	}

	workflowID := emptyFallback(m.latestIDs.WorkflowID, "wizard-default")
	currentWorkflow := m.workflows[workflowID]
	if currentWorkflow.WorkflowID == "" {
		currentWorkflow = workflowState{
			WorkflowID:    workflowID,
			StepID:        "step-1",
			Status:        "draft",
			OriginSurface: "uCODE-TUI",
		}
	}

	jobID := "job-" + strings.ReplaceAll(capability, ".", "-")
	job := automationJob{
		JobID:               jobID,
		RequestedCapability: capability,
		PayloadRef:          "memory://queue/" + jobID,
		OriginSurface:       "uCODE-TUI",
		PolicyFlags:         []string{"local-only-preferred"},
		QueuedAt:            time.Now().UTC().Format(time.RFC3339),
		Status:              "queued",
	}

	result, liveErr := localexec.WizardAutomationJob(currentWorkflow.WorkflowID, currentWorkflow.StepID, capability)
	if liveErr == nil {
		policyFlags := mapValue(result.Payload["policy_flags"])
		liveJob := automationJob{
			JobID:               emptyFallback(rawStringValue(result.Payload["job_id"]), jobID),
			RequestedCapability: emptyFallback(rawStringValue(result.Payload["requested_capability"]), capability),
			PayloadRef:          emptyFallback(rawStringValue(result.Payload["payload_ref"]), fmt.Sprintf("workflow://%s/%s", currentWorkflow.WorkflowID, currentWorkflow.StepID)),
			OriginSurface:       emptyFallback(rawStringValue(result.Payload["origin_surface"]), "uDOS-wizard"),
			PolicyFlags: []string{
				"workflow_id=" + emptyFallback(rawStringValue(policyFlags["workflow_id"]), currentWorkflow.WorkflowID),
				"step_id=" + emptyFallback(rawStringValue(policyFlags["step_id"]), currentWorkflow.StepID),
			},
			QueuedAt: emptyFallback(rawStringValue(result.Payload["queued_at"]), time.Now().UTC().Format(time.RFC3339)),
			Status:   "queued",
		}
		m.jobs[liveJob.JobID] = liveJob
		m.latestIDs.JobID = liveJob.JobID
		m.appendHistory("automation", liveJob.JobID, liveJob.Status, "queue", "automation job handed to wizard")

		result.Payload["base_url"] = result.BaseURL
		result.Payload["route"] = "/workflow/handoff/automation-job"
		buf, err := json.MarshalIndent(result.Payload, "", "  ")
		if err != nil {
			return m.pushErrorPrompt(raw, fmt.Sprintf("marshal live automation-job: %v", err))
		}

		return m.pushBlocks(raw, "uDOS-wizard", "wizard automation handoff queued",
			block.Block{
				Title: "Automation Job",
				Body: block.RenderFields(m.th, []block.Field{
					{Label: "job", Value: liveJob.JobID},
					{Label: "capability", Value: liveJob.RequestedCapability},
					{Label: "workflow", Value: emptyFallback(rawStringValue(policyFlags["workflow_id"]), currentWorkflow.WorkflowID)},
					{Label: "step", Value: emptyFallback(rawStringValue(policyFlags["step_id"]), currentWorkflow.StepID)},
					{Label: "status", Value: liveJob.Status},
					{Label: "handoff", Value: "uDOS-wizard"},
					{Label: "fulfill", Value: ownerString(contract.Owners["fulfillment_owner"])},
					{Label: "base url", Value: result.BaseURL},
					{Label: "source", Value: sourcePath},
				}, 72),
				Variant: block.VariantWarn,
			},
			block.Block{
				Title:   "Automation Job Envelope",
				Body:    string(buf),
				Variant: block.VariantPlain,
			},
		)
	}

	m.jobs[jobID] = job
	m.latestIDs.JobID = jobID
	m.appendHistory("automation", jobID, job.Status, "queue", "automation job queued")

	envelope := map[string]any{
		"job_id":               job.JobID,
		"requested_capability": job.RequestedCapability,
		"payload_ref":          job.PayloadRef,
		"origin_surface":       job.OriginSurface,
		"policy_flags":         job.PolicyFlags,
		"queued_at":            job.QueuedAt,
	}

	buf, err := json.MarshalIndent(envelope, "", "  ")
	if err != nil {
		return m.pushErrorPrompt(raw, fmt.Sprintf("marshal automation-job: %v", err))
	}

	return m.pushBlocks(raw, "uDOS-wizard", "automation handoff preview fallback",
		block.Block{
			Title: "Automation Job",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "job", Value: jobID},
				{Label: "capability", Value: capability},
				{Label: "status", Value: job.Status},
				{Label: "handoff", Value: "uDOS-wizard"},
				{Label: "transport", Value: "preview-fallback"},
				{Label: "base url", Value: localexec.WizardBaseURL()},
				{Label: "error", Value: liveErr.Error()},
				{Label: "dispatch", Value: ownerString(contract.Owners["dispatching_consumers"])},
				{Label: "fulfill", Value: ownerString(contract.Owners["fulfillment_owner"])},
				{Label: "source", Value: sourcePath},
			}, 72),
			Variant: block.VariantWarn,
		},
		block.Block{
			Title:   "Automation Job Envelope",
			Body:    string(buf),
			Variant: block.VariantPlain,
		},
	)
}

func (m model) submitAutomationResult(raw string, jobID string) model {
	contract, sourcePath, err := contracts.LoadNamedContract("automation-result")
	if err != nil {
		return m.pushErrorPrompt(raw, err.Error())
	}

	job := m.jobs[jobID]
	if job.JobID == "" {
		job = automationJob{
			JobID:               jobID,
			RequestedCapability: "unknown",
			PayloadRef:          "memory://queue/" + jobID,
			OriginSurface:       "uCODE-TUI",
			PolicyFlags:         []string{"local-only-preferred"},
			QueuedAt:            time.Now().UTC().Format(time.RFC3339),
		}
	}
	job.Status = "completed"
	job.OutputRefs = []string{"memory://outputs/" + jobID}
	job.EventRefs = []string{"memory://events/" + jobID}
	job.CompletedAt = time.Now().UTC().Format(time.RFC3339)
	job.SuggestedWorkflowAction = "advance"
	m.jobs[jobID] = job
	m.latestIDs.JobID = jobID
	m.appendHistory("automation", jobID, job.Status, "result", "automation result inspected")

	envelope := map[string]any{
		"job_id":                    job.JobID,
		"status":                    job.Status,
		"output_refs":               job.OutputRefs,
		"event_refs":                job.EventRefs,
		"completed_at":              job.CompletedAt,
		"suggested_workflow_action": job.SuggestedWorkflowAction,
	}

	buf, err := json.MarshalIndent(envelope, "", "  ")
	if err != nil {
		return m.pushErrorPrompt(raw, fmt.Sprintf("marshal automation-result: %v", err))
	}

	return m.pushBlocks(raw, "uHOME-server", "automation result inspected",
		block.Block{
			Title: "Automation Result",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "job", Value: jobID},
				{Label: "status", Value: job.Status},
				{Label: "fulfill", Value: ownerString(contract.Owners["fulfillment_owner"])},
				{Label: "consume", Value: ownerString(contract.Owners["workflow_consumer"])},
				{Label: "suggested", Value: job.SuggestedWorkflowAction},
				{Label: "source", Value: sourcePath},
			}, 72),
			Variant: block.VariantSuccess,
		},
		block.Block{
			Title:   "Automation Result Envelope",
			Body:    string(buf),
			Variant: block.VariantPlain,
		},
		block.Block{
			Title: "Job Session State",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "job", Value: job.JobID},
				{Label: "capability", Value: job.RequestedCapability},
				{Label: "queued", Value: job.QueuedAt},
				{Label: "completed", Value: job.CompletedAt},
			}, 72),
			Variant: block.VariantInfo,
		},
	)
}

func (m model) submitContract(raw string) model {
	name := strings.TrimSpace(strings.TrimPrefix(raw, "contract "))

	if strings.HasPrefix(name, "grid-") {
		return m.submitGridContract(raw, name)
	}

	contract, sourcePath, err := contracts.LoadNamedContract(name)
	promptBody := raw
	if promptBody == "" {
		promptBody = "<empty>"
	}

	newBlocks := []block.Block{
		{
			Title:   "Prompt",
			Body:    "uCODE> " + promptBody,
			Variant: block.VariantPrompt,
		},
	}

	if err != nil {
		newBlocks = append(newBlocks, block.Block{
			Title:   "Contract Error",
			Body:    err.Error(),
			Variant: block.VariantError,
		})
		m.blocks = append(newBlocks, m.blocks...)
		m.status = "contract load failed"
		m.lastRoute = "uDOS-core"
		m.input = ""
		m.cursor = 0
		m.lastMode = modePrompt
		return m
	}

	buf, err := json.MarshalIndent(contract, "", "  ")
	if err != nil {
		newBlocks = append(newBlocks, block.Block{
			Title:   "Contract Error",
			Body:    fmt.Sprintf("marshal contract: %v", err),
			Variant: block.VariantError,
		})
		m.blocks = append(newBlocks, m.blocks...)
		m.status = "contract render failed"
		m.lastRoute = "uDOS-core"
		m.input = ""
		m.cursor = 0
		m.lastMode = modePrompt
		return m
	}

	valueSummary := ""
	if len(contract.StatusValues) > 0 {
		valueSummary = strings.Join(contract.StatusValues, ", ")
	} else if len(contract.ActionValues) > 0 {
		valueSummary = strings.Join(contract.ActionValues, ", ")
	} else {
		valueSummary = "n/a"
	}

	newBlocks = append(newBlocks,
		block.Block{
			Title: "Contract Summary",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "name", Value: name},
				{Label: "version", Value: contract.Version},
				{Label: "owner", Value: contract.Owner},
				{Label: "schema", Value: contract.Schema},
				{Label: "values", Value: valueSummary},
				{Label: "source", Value: sourcePath},
			}, 72),
			Variant: block.VariantInfo,
		},
		block.Block{
			Title:   "Required Fields",
			Body:    strings.Join(contract.RequiredFields, "\n"),
			Variant: block.VariantSuccess,
		},
		block.Block{
			Title:   "Contract Artifact",
			Body:    string(buf),
			Variant: block.VariantPlain,
		},
	)

	if name == "automation-job" || name == "automation-result" {
		newBlocks = append(newBlocks, block.Block{
			Title: "Runtime Split",
			Body: strings.Join([]string{
				"uDOS-wizard defines workflow policy and approval semantics.",
				"uHOME-server owns durable automation fulfillment.",
				"Prompt and app surfaces consume the contracts without becoming the authority.",
			}, "\n"),
			Variant: block.VariantWarn,
		})
	}

	m.blocks = append(newBlocks, m.blocks...)
	if len(m.blocks) > 8 {
		m.blocks = m.blocks[:8]
	}
	m.status = "contract loaded"
	m.lastRoute = "uDOS-core"
	m.lastMode = modePrompt
	m.input = ""
	m.cursor = 0
	return m
}

func (m model) submitGridContract(raw string, name string) model {
	contract, sourcePath, err := contracts.LoadGridContract(name)
	if err != nil {
		return m.pushErrorPrompt(raw, err.Error())
	}

	buf, err := json.MarshalIndent(contract, "", "  ")
	if err != nil {
		return m.pushErrorPrompt(raw, fmt.Sprintf("marshal grid contract: %v", err))
	}

	return m.pushBlocks(raw, "uDOS-grid", "grid contract loaded",
		block.Block{
			Title: "Grid Contract Summary",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "name", Value: name},
				{Label: "version", Value: contract.Version},
				{Label: "owner", Value: contract.Owner},
				{Label: "consumers", Value: strings.Join(contract.Consumers, ", ")},
				{Label: "source", Value: sourcePath},
			}, 72),
			Variant: block.VariantInfo,
		},
		block.Block{
			Title:   "Required Fields",
			Body:    strings.Join(contract.RequiredFields, "\n"),
			Variant: block.VariantSuccess,
		},
		block.Block{
			Title:   "Optional Fields",
			Body:    strings.Join(contract.OptionalFields, "\n"),
			Variant: block.VariantPlain,
		},
		block.Block{
			Title:   "Grid Contract Artifact",
			Body:    string(buf),
			Variant: block.VariantPlain,
		},
		block.Block{
			Title: "Consumption Rule",
			Body: strings.Join([]string{
				"uDOS-grid owns canonical spatial truth.",
				"uDOS-shell inspects and navigates Grid records without owning persistence.",
				"@dev/grid-core-support remains a future-round peg, not a current merge target.",
			}, "\n"),
			Variant: block.VariantWarn,
		},
	)
}

func (m model) submitGridSeed(raw string) model {
	name := strings.TrimSpace(strings.TrimPrefix(raw, "grid seed "))

	records, sourcePath, err := contracts.LoadGridSeed(name)
	if err != nil {
		return m.pushErrorPrompt(raw, err.Error())
	}

	buf, err := json.MarshalIndent(records, "", "  ")
	if err != nil {
		return m.pushErrorPrompt(raw, fmt.Sprintf("marshal grid seed: %v", err))
	}

	count := fmt.Sprintf("%d", len(records))
	first := "n/a"
	if len(records) > 0 {
		switch name {
		case "layers":
			first = stringValue(records[0]["layer_id"])
		case "places":
			first = stringValue(records[0]["place_id"])
		case "artifacts":
			first = stringValue(records[0]["artifact_id"])
		}
	}

	return m.pushBlocks(raw, "uDOS-grid", "grid seed inspected",
		block.Block{
			Title: "Grid Seed Summary",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "seed", Value: name},
				{Label: "count", Value: count},
				{Label: "first", Value: first},
				{Label: "source", Value: sourcePath},
			}, 72),
			Variant: block.VariantInfo,
		},
		block.Block{
			Title:   "Grid Seed Artifact",
			Body:    string(buf),
			Variant: block.VariantPlain,
		},
	)
}

func (m model) View() string {
	if m.quitting {
		return "Shell closed.\n"
	}

	w := max(m.width, 80)
	h := max(m.height, 24)
	vp := viewport.Match(w, h)

	header := m.th.TitleBar.Width(w).Render("uDOS-shell / uCODE")
	status := m.th.StatusLine.Width(w).Render(fmt.Sprintf(
		"mode:%s route:%s viewport:%s status:%s",
		m.lastMode,
		emptyFallback(m.lastRoute, "none"),
		vp.Label,
		m.status,
	))

	bodyWidth := max(w-2, 40)
	body := block.RenderStack(m.th, m.blocks, bodyWidth)
	promptLine := "uCODE> " + cursorDisplay(m.input, m.cursor)
	prompt := m.th.InputPrompt.Width(w).Render(promptLine)

	view := lipgloss.JoinVertical(lipgloss.Left, header, body, prompt, status)
	if m.lastMode == modeHelp {
		view = lipgloss.JoinVertical(lipgloss.Left, header, body, m.th.Help.Width(bodyWidth).Render(helpText()), prompt, status)
	}

	if m.lastMode == modeMenu {
		menuWidth := min(max(w-16, 40), 72)
		menuView := m.menu.View(menuWidth, m.th)
		return lipgloss.Place(w, h, lipgloss.Center, lipgloss.Center, menuView)
	}

	return view
}

func helpText() string {
	lines := []string{
		"Help",
		"Global",
	}

	for _, binding := range keymap.GlobalBindings() {
		status := "reserved"
		if binding.Implemented {
			status = "active"
		}
		lines = append(lines, fmt.Sprintf("%s  %s [%s]", binding.Key, binding.Description, status))
	}

	lines = append(lines, "", "Input")
	for _, binding := range keymap.InputBindings() {
		status := "reserved"
		if binding.Implemented {
			status = "active"
		}
		lines = append(lines, fmt.Sprintf("%s  %s [%s]", binding.Key, binding.Description, status))
	}

	lines = append(lines, "", "Navigation")
	for _, binding := range keymap.NavigationBindings() {
		status := "reserved"
		if binding.Implemented {
			status = "active"
		}
		lines = append(lines, fmt.Sprintf("%s  %s [%s]", binding.Key, binding.Description, status))
	}

	if p := surface.ResolveInputMappingPath(); p != "" {
		if im, err := surface.LoadInputMapping(p); err == nil {
			sb := surface.KeyBindingsFromInputMapping(im)
			if len(sb) > 0 {
				lines = append(lines, "", "Surface profile (uDOS-surface input-mapping)")
				for _, binding := range sb {
					status := "reserved"
					if binding.Implemented {
						status = "active"
					}
					lines = append(lines, fmt.Sprintf("%s  %s [%s]", binding.Key, binding.Description, status))
				}
			}
		}
	}

	lines = append(lines, "", "No custom Command-key shortcuts.")
	return strings.Join(lines, "\n")
}

func emptyFallback(value string, fallback string) string {
	if value == "" {
		return fallback
	}

	return value
}

func cursorDisplay(input string, cursor int) string {
	runes := []rune(input)
	if cursor >= len(runes) {
		return input + "█"
	}
	return string(runes[:cursor]) + "█" + string(runes[cursor:])
}

func (m model) pushErrorPrompt(raw string, message string) model {
	return m.pushBlocks(raw, "uCODE-TUI", "command failed",
		block.Block{
			Title:   "Error",
			Body:    message,
			Variant: block.VariantError,
		},
	)
}

func (m model) pushBlocks(raw string, route string, status string, extra ...block.Block) model {
	promptBody := raw
	if promptBody == "" {
		promptBody = "<empty>"
	}

	newBlocks := []block.Block{
		{
			Title:   "Prompt",
			Body:    "uCODE> " + promptBody,
			Variant: block.VariantPrompt,
		},
	}
	newBlocks = append(newBlocks, extra...)

	m.blocks = append(newBlocks, m.blocks...)
	if len(m.blocks) > 8 {
		m.blocks = m.blocks[:8]
	}
	m.status = status
	m.lastRoute = route
	m.lastMode = modePrompt
	m.input = ""
	m.cursor = 0
	return m
}

func ownerString(value any) string {
	switch typed := value.(type) {
	case string:
		return typed
	case []any:
		values := make([]string, 0, len(typed))
		for _, item := range typed {
			values = append(values, fmt.Sprintf("%v", item))
		}
		return strings.Join(values, ", ")
	default:
		return fmt.Sprintf("%v", value)
	}
}

func (m model) showWorkflowLedger(raw string) model {
	if len(m.workflows) == 0 {
		return m.pushErrorPrompt(raw, "no workflows in session")
	}

	lines := make([]string, 0, len(m.workflows))
	for _, state := range sortedWorkflowStates(m.workflows) {
		lines = append(lines, fmt.Sprintf("%s  %s  %s", state.WorkflowID, state.Status, state.StepID))
	}

	return m.pushBlocks(raw, "uCODE-TUI", "workflow ledger shown",
		block.Block{
			Title:   "Workflow Ledger",
			Body:    strings.Join(lines, "\n"),
			Variant: block.VariantInfo,
		},
	)
}

func (m model) showAutomationLedger(raw string) model {
	if len(m.jobs) == 0 {
		return m.pushErrorPrompt(raw, "no automation jobs in session")
	}

	lines := make([]string, 0, len(m.jobs))
	for _, job := range sortedAutomationJobs(m.jobs) {
		lines = append(lines, fmt.Sprintf("%s  %s  %s", job.JobID, job.Status, job.RequestedCapability))
	}

	return m.pushBlocks(raw, "uCODE-TUI", "automation ledger shown",
		block.Block{
			Title:   "Automation Ledger",
			Body:    strings.Join(lines, "\n"),
			Variant: block.VariantInfo,
		},
	)
}

func (m model) showSessionHistory(raw string) model {
	if len(m.history) == 0 {
		return m.pushErrorPrompt(raw, "no session history yet")
	}

	lines := make([]string, 0, len(m.history))
	for _, event := range m.history {
		lines = append(lines, fmt.Sprintf("%s  %s  %s  %s  %s  %s", event.Timestamp, event.Kind, event.TargetID, event.Action, event.Status, event.Note))
	}

	return m.pushBlocks(raw, "uCODE-TUI", "session history shown",
		block.Block{
			Title:   "Session History",
			Body:    strings.Join(lines, "\n"),
			Variant: block.VariantPlain,
		},
	)
}

func (m model) openWorkflowSelector() model {
	items := make([]selector.Item, 0, len(m.workflows))
	for _, state := range sortedWorkflowStates(m.workflows) {
		items = append(items, selector.Item{
			Label:       state.WorkflowID,
			Description: fmt.Sprintf("%s / %s", state.Status, state.StepID),
			Value:       "__workflow_select__:" + state.WorkflowID,
		})
	}
	if len(items) == 0 {
		return m.pushErrorPrompt("menu pick workflow", "no workflows in session")
	}

	m.menu = selector.Model{
		Title: "Workflow Ledger  · a=advance  p=pause  /=filter",
		Items: items,
	}
	m.menuContext = "workflow"
	m.lastMode = modeMenu
	m.status = "workflow selector open"
	return m
}

func (m model) openJobSelector() model {
	items := make([]selector.Item, 0, len(m.jobs))
	for _, job := range sortedAutomationJobs(m.jobs) {
		items = append(items, selector.Item{
			Label:       job.JobID,
			Description: fmt.Sprintf("%s / %s", job.Status, job.RequestedCapability),
			Value:       "__job_select__:" + job.JobID,
		})
	}
	if len(items) == 0 {
		return m.pushErrorPrompt("menu pick automation job", "no automation jobs in session")
	}

	m.menu = selector.Model{
		Title: "Automation Ledger  · r=result  /=filter",
		Items: items,
	}
	m.menuContext = "job"
	m.lastMode = modeMenu
	m.status = "automation selector open"
	return m
}

func (m model) showWorkflowStateFromLedger(raw string, workflowID string) model {
	state, ok := m.workflows[workflowID]
	if !ok {
		return m.pushErrorPrompt(raw, "workflow not found in session")
	}

	return m.pushBlocks(raw, "uCODE-TUI", "workflow ledger item shown",
		block.Block{
			Title: "Workflow State",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "workflow", Value: state.WorkflowID},
				{Label: "step", Value: state.StepID},
				{Label: "status", Value: state.Status},
				{Label: "awaiting-user", Value: fmt.Sprintf("%t", state.AwaitingUserAction)},
				{Label: "transition", Value: state.LastTransitionAt},
			}, 72),
			Variant: block.VariantInfo,
		},
	)
}

func (m model) showAutomationResultFromLedger(raw string, jobID string) model {
	job, ok := m.jobs[jobID]
	if !ok {
		return m.pushErrorPrompt(raw, "automation job not found in session")
	}

	return m.pushBlocks(raw, "uCODE-TUI", "automation ledger item shown",
		block.Block{
			Title: "Automation Job",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "job", Value: job.JobID},
				{Label: "status", Value: job.Status},
				{Label: "capability", Value: job.RequestedCapability},
				{Label: "queued", Value: job.QueuedAt},
				{Label: "completed", Value: emptyFallback(job.CompletedAt, "pending")},
			}, 72),
			Variant: block.VariantInfo,
		},
	)
}

func (m *model) appendHistory(kind string, targetID string, status string, action string, note string) {
	m.history = append([]sessionEvent{
		{
			Kind:      kind,
			TargetID:  targetID,
			Status:    status,
			Action:    action,
			Timestamp: time.Now().UTC().Format(time.RFC3339),
			Note:      note,
		},
	}, m.history...)

	if len(m.history) > 20 {
		m.history = m.history[:20]
	}
}

func isPlainCLICommand(raw string) bool {
	if raw == "" {
		return false
	}

	if strings.HasPrefix(raw, "#") {
		return false
	}

	if strings.HasPrefix(raw, "? ") {
		return false
	}

	if strings.HasPrefix(raw, "contract ") || strings.HasPrefix(raw, "workflow ") || strings.HasPrefix(raw, "automation ") || strings.HasPrefix(raw, "grid seed ") || strings.HasPrefix(raw, "mcp ") || raw == "dev ops" || strings.HasPrefix(raw, "dev ops ") || raw == "health startup" || raw == "health family" || raw == "setup story" || strings.HasPrefix(raw, "demo ") {
		return false
	}

	if raw == "session workflows" || raw == "session jobs" || raw == "session history" {
		return false
	}

	return true
}

func isCoreScriptCommand(raw string) bool {
	parsed := ucode.Parse(raw)
	return parsed.Namespace == "script" && parsed.Action == "run"
}

func sortedWorkflowStates(items map[string]workflowState) []workflowState {
	states := make([]workflowState, 0, len(items))
	for _, item := range items {
		states = append(states, item)
	}
	slices.SortFunc(states, func(a, b workflowState) int {
		return strings.Compare(a.WorkflowID, b.WorkflowID)
	})
	return states
}

func sortedAutomationJobs(items map[string]automationJob) []automationJob {
	jobs := make([]automationJob, 0, len(items))
	for _, item := range items {
		jobs = append(jobs, item)
	}
	slices.SortFunc(jobs, func(a, b automationJob) int {
		return strings.Compare(a.JobID, b.JobID)
	})
	return jobs
}

func parseCSVArg(raw string) []string {
	trimmed := strings.TrimSpace(raw)
	if trimmed == "" {
		return nil
	}

	parts := strings.Split(trimmed, ",")
	items := make([]string, 0, len(parts))
	for _, part := range parts {
		item := strings.TrimSpace(part)
		if item == "" {
			continue
		}
		items = append(items, item)
	}
	return items
}

func parseBoolArg(raw string) bool {
	switch strings.ToLower(strings.TrimSpace(raw)) {
	case "1", "true", "yes", "y", "on":
		return true
	default:
		return false
	}
}

func parseLooseBoolArg(raw string) (bool, bool) {
	switch strings.ToLower(strings.TrimSpace(raw)) {
	case "1", "true", "yes", "y", "on":
		return true, true
	case "0", "false", "no", "n", "off":
		return false, true
	default:
		return false, false
	}
}

func rawStringValue(value any) string {
	text, _ := value.(string)
	return text
}

func mapValue(value any) map[string]any {
	item, _ := value.(map[string]any)
	if item == nil {
		return map[string]any{}
	}
	return item
}

func sliceValue(value any) []any {
	items, _ := value.([]any)
	if items == nil {
		return []any{}
	}
	return items
}

func boolValue(value any, fallback bool) bool {
	flag, ok := value.(bool)
	if !ok {
		return fallback
	}
	return flag
}

func stringValue(value any) string {
	text := rawStringValue(value)
	if text == "" {
		return "n/a"
	}
	return text
}

func renderPrettyJSON(value any) string {
	buf, err := json.MarshalIndent(value, "", "  ")
	if err != nil {
		return fmt.Sprintf("%v", value)
	}
	return string(buf)
}

func defaultStartupBlocks() []block.Block {
	checks := localexec.StartupHealthChecks()
	lines := make([]string, 0, len(checks))
	available := 0
	for _, check := range checks {
		status := "missing"
		if check.Present {
			status = "ready"
			available++
		}
		lines = append(lines, fmt.Sprintf("%s  %s", check.Repo, status))
	}

	return []block.Block{
		{
			Title: "Welcome to uDOS-shell",
			Body: strings.Join([]string{
				"This shell is the local operator entrypoint for Shell, Core, and Wizard handoff.",
				"",
				"Try:",
				"  help           Show starter help",
				"  commands       List available commands",
				"  wizard         Launch Wizard GUI",
				"  test           Show test options",
				"  status         Show runtime status",
				"  exit           Quit shell",
			}, "\n"),
			Variant: block.VariantInfo,
		},
		{
			Title: "First Steps",
			Body: strings.Join([]string{
				"Type a command and press Enter.",
				"Press : to open the menu.",
				"Press ? for keybinding help.",
				"Tip: type `help wizard` or `help test` for focused guidance.",
			}, "\n"),
			Variant: block.VariantWarn,
		},
		{
			Title: "Startup Health",
			Body: block.RenderFields(theme.NewFromEnv(), []block.Field{
				{Label: "detected", Value: fmt.Sprintf("%d/%d", available, len(checks))},
				{Label: "status", Value: "status"},
				{Label: "doctor", Value: "doctor"},
				{Label: "tests", Value: "test"},
			}, 72),
			Variant: block.VariantSuccess,
		},
		{
			Title:   "Family Entry Points",
			Body:    strings.Join(lines, "\n"),
			Variant: block.VariantPlain,
		},
	}
}

func (m model) showStarterHelp(raw string, topic string) model {
	normalized := strings.ToLower(strings.TrimSpace(topic))
	if normalized == "" {
		m.appendHistory("starter", "help", "shown", "guide", "starter help opened")
		return m.pushBlocks(raw, "uCODE-TUI", "starter help shown",
			block.Block{
				Title: "uDOS Shell Help",
				Body: strings.Join([]string{
					"Core starter commands:",
					"  commands        List starter commands",
					"  commands list   Show full command registry",
					"  help <name>     Show help for one command",
					"  wizard          Launch Wizard GUI",
					"  test            Show test options",
					"  status          Show runtime status",
					"  routes          Show route summary",
					"  doctor          Check local environment",
					"  clear           Clear screen",
					"  exit            Quit shell",
					"",
					"Examples:",
					"  commands",
					"  help wizard",
					"  wizard",
					"  test all",
					"",
					"Lanes:",
					"  shell   Local operator surface and command UX",
					"  core    Runtime semantics and contract execution",
					"  wizard  GUI, orchestration, MCP, and external integration",
				}, "\n"),
				Variant: block.VariantInfo,
			},
		)
	}

	helpTopics := map[string]string{
		"commands": strings.Join([]string{
			"commands",
			"",
			"Use this to discover what the shell can do.",
			"",
			"Usage:",
			"  commands",
			"  commands list",
			"",
			"Behavior:",
			"  commands       Show the short grouped starter set",
			"  commands list  Show the full command registry",
		}, "\n"),
		"wizard": strings.Join([]string{
			"wizard",
			"",
			"Launch the Wizard GUI without needing to know internal route syntax.",
			"",
			"Usage:",
			"  wizard",
			"  wizard open",
			"  wizard dev",
			"",
			"Behavior:",
			"  wizard / wizard open   Open the default Wizard-served app",
			"  wizard dev             Open the Svelte dev workbench",
		}, "\n"),
		"test": strings.Join([]string{
			"test",
			"",
			"Discover and run validation lanes from the shell.",
			"",
			"Usage:",
			"  test",
			"  test shell",
			"  test core",
			"  test all",
			"",
			"Behavior:",
			"  test        Show available test targets",
			"  test shell  Run shell validation",
			"  test core   Run core validation if available",
			"  test all    Run the standard shell + core + wizard validation set",
		}, "\n"),
		"status": strings.Join([]string{
			"status",
			"",
			"Show current runtime and operator state.",
			"",
			"This reports:",
			"  shell readiness",
			"  sibling repo availability",
			"  Wizard launch targets",
			"  current route mode",
			"  active workspace root",
		}, "\n"),
		"routes": strings.Join([]string{
			"routes",
			"",
			"Show the current route model used by the shell.",
			"",
			"This explains:",
			"  local shell routes",
			"  core runtime routes",
			"  wizard handoff routes",
			"  which lane owns each route",
		}, "\n"),
		"doctor": strings.Join([]string{
			"doctor",
			"",
			"Check whether the local environment is ready.",
			"",
			"This verifies:",
			"  node",
			"  npm",
			"  go",
			"  repo root",
			"  sibling repos",
			"  launcher files",
			"  Wizard UI path",
		}, "\n"),
	}

	body, ok := helpTopics[normalized]
	if !ok {
		return m.pushErrorPrompt(raw, fmt.Sprintf("unknown help topic %q", topic))
	}

	m.appendHistory("starter", normalized, "shown", "help-topic", "starter help topic opened")
	return m.pushBlocks(raw, "uCODE-TUI", "starter help shown",
		block.Block{
			Title:   fmt.Sprintf("Help: %s", normalized),
			Body:    body,
			Variant: block.VariantInfo,
		},
	)
}

func (m model) showStarterCommands(raw string, full bool) model {
	title := "Starter Commands"
	body := strings.Join([]string{
		"Discovery:",
		"  help",
		"  help <command>",
		"  commands",
		"  commands list",
		"",
		"Wizard:",
		"  wizard",
		"  wizard open",
		"  wizard dev",
		"",
		"Validation:",
		"  test",
		"  test shell",
		"  test core",
		"  test all",
		"  doctor",
		"",
		"Runtime:",
		"  status",
		"  routes",
		"",
		"Session:",
		"  clear",
		"  exit",
	}, "\n")
	if full {
		title = "Full Command Registry"
		body = strings.Join([]string{
			body,
			"",
			"Deep runtime commands:",
			"  health startup",
			"  setup story",
			"  demo list",
			"  demo ux",
			"  demo run <id>",
			"  contract <name>",
			"  workflow state <id>",
			"  workflow action <id> <action>",
			"  automation queue <capability>",
			"  automation result <job-id>",
			"  mcp init",
			"  mcp tools",
			"  mcp call <tool> key:value",
			"  dev ops list",
			"  session workflows",
			"  session jobs",
			"  session history",
			"  ? <question>",
			"  #wizard assist topic:<topic>",
			"  #ok route class:<task-class> topic:<task>",
			"  RUN <script.md>",
		}, "\n")
	}

	m.appendHistory("starter", "commands", "shown", "list", title)
	return m.pushBlocks(raw, "uCODE-TUI", "command registry shown",
		block.Block{
			Title:   title,
			Body:    body,
			Variant: block.VariantInfo,
		},
	)
}

func (m model) showStarterStatus(raw string) model {
	checks := localexec.StartupHealthChecks()
	ready := 0
	for _, check := range checks {
		if check.Present {
			ready++
		}
	}

	m.appendHistory("starter", "status", "shown", "inspect", "runtime status shown")
	return m.pushBlocks(raw, "uCODE-TUI", "runtime status shown",
		block.Block{
			Title: "Runtime Status",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "shell", Value: "ready"},
				{Label: "family", Value: fmt.Sprintf("%d/%d entrypoints ready", ready, len(checks))},
				{Label: "wizard", Value: "default: http://127.0.0.1:8787/app"},
				{Label: "wizard dev", Value: "http://127.0.0.1:4173"},
				{Label: "workspace", Value: localexec.DoctorChecks()[3].Details},
				{Label: "route mode", Value: "shell + core + wizard"},
			}, 72),
			Variant: block.VariantSuccess,
		},
	)
}

func (m model) showStarterRoutes(raw string) model {
	m.appendHistory("starter", "routes", "shown", "inspect", "route summary shown")
	return m.pushBlocks(raw, "uCODE-TUI", "route summary shown",
		block.Block{
			Title: "Route Summary",
			Body: strings.Join([]string{
				"shell:",
				"  starter commands",
				"  local UI/session commands",
				"",
				"core:",
				"  runtime semantics",
				"  binder/runtime command handoff",
				"",
				"wizard:",
				"  GUI launch",
				"  MCP/orchestration handoff",
				"",
				"Vocabulary:",
				"  lane    execution ownership surface",
				"  route   destination repo/runtime",
				"  runtime backing contract or service",
			}, "\n"),
			Variant: block.VariantInfo,
		},
	)
}

func (m model) showStarterTests(raw string) model {
	targets := localexec.ListFamilyTestTargets()
	lines := make([]string, 0, len(targets)+2)
	for _, target := range targets {
		lines = append(lines, fmt.Sprintf("  test %s   %s", target.ID, target.Description))
	}
	lines = append(lines, "  test all   Run the standard shell + core + wizard validation set")

	m.appendHistory("starter", "test", "shown", "list", "starter test targets shown")
	return m.pushBlocks(raw, "uCODE-TUI", "test targets shown",
		block.Block{
			Title: "Test Commands",
			Body: strings.Join(append([]string{
				"Available targets:",
			}, append(lines, "", "Tip: use `doctor` first if the environment looks incomplete")...), "\n"),
			Variant: block.VariantInfo,
		},
	)
}

func (m model) runStarterTest(raw string, id string) model {
	result, target, err := localexec.RunFamilyTestTarget(id)
	status := "completed"
	variant := block.VariantSuccess
	body := strings.TrimSpace(result.Stdout)
	if body == "" {
		body = "<no stdout>"
	}
	if err != nil {
		status = "failed"
		variant = block.VariantError
		if strings.TrimSpace(result.Stderr) != "" {
			body = body + "\n\nstderr:\n" + strings.TrimSpace(result.Stderr)
		}
	}

	m.appendHistory("starter-test", id, status, "run", target.Description)
	return m.pushBlocks(raw, "uCODE-TUI", fmt.Sprintf("test %s %s", id, status),
		block.Block{
			Title: "Test Target",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "target", Value: target.Label},
				{Label: "status", Value: status},
				{Label: "command", Value: strings.Join(target.Command, " ")},
			}, 72),
			Variant: variant,
		},
		block.Block{
			Title:   "Test Output",
			Body:    body,
			Variant: block.VariantPlain,
		},
	)
}

func (m model) runStarterTestSuite(raw string, ids ...string) model {
	result, err := localexec.RunFamilyTestSuite(ids...)
	status := "completed"
	variant := block.VariantSuccess
	body := strings.TrimSpace(result.Stdout)
	if body == "" {
		body = "<no stdout>"
	}
	if err != nil {
		status = "failed"
		variant = block.VariantError
		if strings.TrimSpace(result.Stderr) != "" {
			body = body + "\n\nstderr:\n" + strings.TrimSpace(result.Stderr)
		}
	}

	m.appendHistory("starter-test", "all", status, "run-suite", strings.Join(ids, ","))
	return m.pushBlocks(raw, "uCODE-TUI", fmt.Sprintf("test suite %s", status),
		block.Block{
			Title: "Test Suite",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "targets", Value: strings.Join(ids, ", ")},
				{Label: "status", Value: status},
			}, 72),
			Variant: variant,
		},
		block.Block{
			Title:   "Suite Output",
			Body:    body,
			Variant: block.VariantPlain,
		},
	)
}

func (m model) launchWizard(raw string, id string) model {
	result, target, err := localexec.OpenWizardLaunchTarget(id)
	status := "opened"
	variant := block.VariantSuccess
	if err != nil {
		status = "launch-fallback"
		variant = block.VariantWarn
	}

	body := strings.Join([]string{
		target.Description,
		fmt.Sprintf("URL: %s", target.URL),
		fmt.Sprintf("Manual launch: %s", target.CommandHint),
	}, "\n")
	if err != nil {
		body += "\n\nOpen failed locally; use the manual launch command above."
	}

	m.appendHistory("starter", "wizard", status, "launch", target.URL)
	extra := []block.Block{
		{
			Title: "Wizard Launch",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "target", Value: target.Label},
				{Label: "status", Value: status},
				{Label: "url", Value: target.URL},
			}, 72),
			Variant: variant,
		},
		{
			Title:   "Wizard Route",
			Body:    body,
			Variant: block.VariantPlain,
		},
	}
	if strings.TrimSpace(result.Stderr) != "" {
		extra = append(extra, block.Block{
			Title:   "Launcher stderr",
			Body:    strings.TrimSpace(result.Stderr),
			Variant: block.VariantPlain,
		})
	}
	return m.pushBlocks(raw, "uDOS-wizard", fmt.Sprintf("wizard %s", status), extra...)
}

func (m model) showDoctor(raw string) model {
	checks := localexec.DoctorChecks()
	lines := make([]string, 0, len(checks))
	ready := 0
	for _, check := range checks {
		if check.Status == "ready" {
			ready++
		}
		lines = append(lines, fmt.Sprintf("%s  %s  %s", check.Name, check.Status, check.Details))
	}

	m.appendHistory("starter", "doctor", "shown", "inspect", fmt.Sprintf("%d/%d checks ready", ready, len(checks)))
	return m.pushBlocks(raw, "uCODE-TUI", "doctor checks shown",
		block.Block{
			Title: "Environment Doctor",
			Body: block.RenderFields(m.th, []block.Field{
				{Label: "ready", Value: fmt.Sprintf("%d/%d", ready, len(checks))},
				{Label: "shell", Value: "uDOS-shell"},
				{Label: "focus", Value: "commands, paths, launchers"},
			}, 72),
			Variant: block.VariantInfo,
		},
		block.Block{
			Title:   "Checks",
			Body:    strings.Join(lines, "\n"),
			Variant: block.VariantPlain,
		},
	)
}

func renderMCPToolList(tools []any) string {
	if len(tools) == 0 {
		return "<no tools>"
	}

	lines := make([]string, 0, len(tools))
	for _, item := range tools {
		tool := mapValue(item)
		annotations := mapValue(tool["annotations"])
		lines = append(lines, fmt.Sprintf(
			"%s  %s  %s",
			emptyFallback(rawStringValue(tool["name"]), "unknown"),
			emptyFallback(rawStringValue(annotations["route"]), "n/a"),
			emptyFallback(rawStringValue(annotations["owner"]), "n/a"),
		))
	}
	return strings.Join(lines, "\n")
}

func parseMCPArguments(items []string) map[string]any {
	arguments := map[string]any{}
	for _, item := range items {
		key, value, ok := strings.Cut(item, ":")
		if !ok {
			continue
		}

		key = normalizeMCPArgumentKey(key)
		value = strings.Trim(value, "\"")
		if key == "" || value == "" {
			continue
		}

		if boolean, ok := parseLooseBoolArg(value); ok {
			arguments[key] = boolean
			continue
		}
		if key == "allowed_budget_groups" || strings.Contains(value, ",") {
			arguments[key] = parseCSVArg(value)
			continue
		}
		arguments[key] = value
	}
	return arguments
}

func normalizeMCPArgumentKey(key string) string {
	switch strings.ToLower(strings.TrimSpace(key)) {
	case "class":
		return "task_class"
	case "budget", "budgets", "budget-groups":
		return "allowed_budget_groups"
	default:
		return strings.ReplaceAll(strings.TrimSpace(key), "-", "_")
	}
}

func summarizeMCPArguments(arguments map[string]any) string {
	if len(arguments) == 0 {
		return "no arguments"
	}
	return renderPrettyJSON(arguments)
}

func normalizeDevOpsDocName(parts []string) string {
	if len(parts) == 0 {
		return ""
	}

	switch strings.Join(parts, " ") {
	case "mcp", "mcp support":
		return "mcp-support"
	case "operation modes", "checklist operation-modes", "checklist operation modes":
		return "operation-modes"
	case "launch matrix", "checklist launch-matrix", "checklist launch matrix":
		return "launch-matrix"
	case "archive gate", "checklist archive-gate", "checklist archive gate":
		return "archive-gate"
	case "container patterns", "checklist container-patterns", "checklist container patterns":
		return "container-patterns"
	case "resilience", "resilience runbook":
		return "resilience-runbook"
	}

	name := strings.Join(parts, "-")
	switch name {
	case "overview", "mcp-support", "runbook", "resilience-runbook", "operation-modes", "launch-matrix", "archive-gate", "container-patterns":
		return name
	default:
		return ""
	}
}
