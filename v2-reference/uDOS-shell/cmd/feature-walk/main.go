package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"strings"

	"github.com/fredporter/uDOS-shell/internal/dispatch"
	"github.com/fredporter/uDOS-shell/internal/ucode"
)

// Fixed command list exercises parsing + dispatch preview (no network I/O).
var walkCommands = []string{
	"open workspace",
	"contract workflow-state",
	"contract grid-place",
	"grid seed places",
	"workflow state demo-workflow",
	"workflow action demo-workflow advance",
	"automation queue runtime.command-registry",
	"automation result <job-id>",
	"session workflows",
	"session jobs",
	"session history",
	"ls missing-directory",
	"help",
	"commands list",
	"status",
	"#wizard assist topic:shell",
	"#binder create shell-activation",
	"#ok route class:summarize topic:shell budgets:tier0_free,tier1_economy",
	"mcp tools",
	"mcp call ok.route task:summarize-changelog class:summarize budgets:tier0_free,tier1_economy",
	"mcp call ok.providers.list capability:summarize enabled_only:true",
}

// operatorBlurb is plain-language copy for demos; routing still comes from RenderPreview.
func operatorBlurb(input string) string {
	switch input {
	case "open workspace":
		return "You asked to open the workspace.\n" +
			"The shell previews this as a local Core action: binders, paths, and scripts resolve against your checkout.\n" +
			"(This walk does not open files or call HTTP.)"
	case "contract workflow-state":
		return "You asked for the workflow-state contract.\n" +
			"Core’s develop lane supplies the schema version the TUI can show in a preview block."
	case "contract grid-place":
		return "You asked for the grid / place-ref contract.\n" +
			"Core publishes this for spatial tooling; the preview pins it to the develop lane."
	case "grid seed places":
		return "You asked to seed grid places.\n" +
			"Routing stays on Core so grid identity stays aligned with the family contract."
	case "workflow state demo-workflow":
		return "You asked for workflow state (demo-workflow).\n" +
			"The shell keeps session memory for this run; Core remains the system of record when synced."
	case "workflow action demo-workflow advance":
		return "You advanced the demo workflow.\n" +
			"Interactive step here; durable workflow story still lives in Core when you sync out."
	case "automation queue runtime.command-registry":
		return "You queued automation against the runtime command registry.\n" +
			"The preview shows where that job class would run (Core develop)."
	case "automation result <job-id>":
		return "You asked for an automation result (placeholder job id in this walk).\n" +
			"Routing shows which family repo would answer a real lookup."
	case "session workflows":
		return "You listed workflows in the current session.\n" +
			"Useful for “what did I start?” without leaving the TUI."
	case "session jobs":
		return "You listed background jobs for this session — queued or running automation previews."
	case "session history":
		return "You asked for recent history — the ring of commands and outcomes this shell remembers."
	case "ls missing-directory":
		return "You listed a path (intentionally missing here).\n" +
			"Routing still goes through Core so error shaping matches a real operator run."
	case "help":
		return "You opened help — catalog text and hints route through Core’s develop lane in this model."
	case "commands list":
		return "You listed commands — indexed verbs and namespaces you can type or pick from the menu."
	case "status":
		return "You asked for status — versions, lanes, and health snippets for the prompt row."
	case "#wizard assist topic:shell":
		return "You invoked Wizard assist on the shell topic.\n" +
			"A full run would call Wizard’s orchestration lane (HTTP/MCP) for guided help."
	case "#binder create shell-activation":
		return "You created a binder (shell-activation).\n" +
			"Core owns binder contracts; creation previews on Core before any broker steps."
	case "#ok route class:summarize topic:shell budgets:tier0_free,tier1_economy":
		return "You asked OK to route a summarize request under explicit budgets.\n" +
			"Wizard picks providers; you would see the chosen path and caps in a live response."
	case "mcp tools":
		return "You listed MCP tools.\n" +
			"The shell routes MCP through Wizard orchestration — same lane as the VS Code bridge."
	case "mcp call ok.route task:summarize-changelog class:summarize budgets:tier0_free,tier1_economy":
		return "You called ok.route through MCP with a concrete task.\n" +
			"A full run returns JSON; this walk only prints stable routing metadata."
	case "mcp call ok.providers.list capability:summarize enabled_only:true":
		return "You listed OK providers for “summarize” (enabled only).\n" +
			"Wizard’s registry answers; the preview confirms orchestration routing."
	default:
		return "Parsed and routed through the shell preview (see hand-off below)."
	}
}

func main() {
	compact := flag.Bool("compact", false, "machine-readable routing lines (stable for release notes and diffs)")
	jsonOut := flag.Bool("json", false, "JSON array: preview structs plus illustrative_response samples (offline)")
	flag.Parse()

	if *compact && *jsonOut {
		fmt.Fprintln(os.Stderr, "feature-walk: use only one of -compact and -json")
		os.Exit(2)
	}

	if *jsonOut {
		emitJSON()
		return
	}

	if !*compact {
		fmt.Println("uDOS-shell — feature walk (preview only, no live HTTP)")
		fmt.Println()
		fmt.Println("Below is demo copy for humans: what you might type in the Go TUI, what it means,")
		fmt.Println("and which family repo/lane the preview assigns. No services are contacted.")
		fmt.Println()
	}

	for i, input := range walkCommands {
		cmd := ucode.Parse(input)
		preview, err := dispatch.RenderPreview(cmd)
		if err != nil {
			fmt.Printf("%s => ERROR: %v\n", input, err)
			continue
		}

		if *compact {
			fmt.Printf("%s => %s.%s route=%q owner=%q lane=%q\n",
				input,
				cmd.Namespace,
				cmd.Action,
				preview.Route,
				preview.Owner,
				preview.Lane,
			)
			continue
		}

		n := i + 1
		fmt.Printf("┌─ %d · %q\n", n, input)
		fmt.Println("│")
		for _, line := range strings.Split(operatorBlurb(input), "\n") {
			if line != "" {
				fmt.Printf("│  %s\n", line)
			}
		}
		fmt.Println("│")
		fmt.Printf("│  Hand-off:  %s  ·  %s lane  ·  service %s\n",
			preview.Owner, preview.Lane, preview.Route)
		if preview.Adapter != "" {
			fmt.Printf("│  Adapter:   %s\n", preview.Adapter)
		}
		fmt.Printf("│  Command:   %s.%s\n", cmd.Namespace, cmd.Action)
		fmt.Println("└" + strings.Repeat("─", 76))
		fmt.Println()
	}
}

func emitJSON() {
	var rows []walkJSONRecord
	for i, input := range walkCommands {
		cmd := ucode.Parse(input)
		preview, err := dispatch.RenderPreview(cmd)
		if err != nil {
			fmt.Fprintf(os.Stderr, "feature-walk json: %q: %v\n", input, err)
			os.Exit(1)
		}
		rows = append(rows, walkJSONRecord{
			Index:        i + 1,
			Input:        input,
			Namespace:    cmd.Namespace,
			Action:       cmd.Action,
			Preview:      previewForJSON(preview),
			Illustrative: illustrativeResponse(input, preview),
		})
	}
	enc := json.NewEncoder(os.Stdout)
	enc.SetIndent("", "  ")
	if err := enc.Encode(rows); err != nil {
		fmt.Fprintf(os.Stderr, "feature-walk json encode: %v\n", err)
		os.Exit(1)
	}
}
