package main

import (
	"path/filepath"
	"strings"

	"github.com/fredporter/uDOS-shell/internal/dispatch"
)

// previewForJSON returns a copy of p with paths normalized for stable goldens / CI snapshots.
func previewForJSON(p dispatch.Preview) dispatch.Preview {
	c := p
	c.RuntimeServiceSource = stableRuntimeServiceRef(p.RuntimeServiceSource)
	return c
}

// stableRuntimeServiceRef maps absolute manifest paths to a family-stable ref (…/uDOS-core/…).
// If "uDOS-core" is not in the path, returns a minimal suffix ending in runtime-services.json when present.
func stableRuntimeServiceRef(abs string) string {
	if abs == "" {
		return ""
	}
	norm := filepath.ToSlash(filepath.Clean(abs))
	parts := strings.Split(norm, "/")
	for i, seg := range parts {
		if seg == "uDOS-core" {
			return strings.Join(parts[i:], "/")
		}
	}
	const tail = "contracts/runtime-services.json"
	if strings.HasSuffix(norm, tail) {
		return "uDOS-core/" + tail
	}
	return "runtime-services.json"
}

// walkJSONRecord is offline demo JSON for tooling and docs; not a wire contract.
type walkJSONRecord struct {
	Index        int              `json:"index"`
	Input        string           `json:"input"`
	Namespace    string           `json:"namespace"`
	Action       string           `json:"action"`
	Preview      dispatch.Preview `json:"preview"`
	Illustrative map[string]any   `json:"illustrative_response"`
}

// illustrativeResponse is fake payload shape for demos only — never sent on the wire by feature-walk.
func illustrativeResponse(input string, p dispatch.Preview) map[string]any {
	if p.Owner == "uDOS-wizard" {
		switch input {
		case "#wizard assist topic:shell":
			return map[string]any{
				"status":  "ok",
				"topic":   "shell",
				"summary": "Wizard assist stub: link operator to shell activation and health checks.",
				"hints":   []string{"Run health startup", "Open docs/tui-keybindings.md"},
			}
		case "#ok route class:summarize topic:shell budgets:tier0_free,tier1_economy":
			return map[string]any{
				"status":        "routed",
				"task_class":    "summarize",
				"chosen_budget": "tier1_economy",
				"provider_hint": "local.preview",
				"note":          "Illustrative only — live Wizard returns provider registry data.",
			}
		case "mcp tools":
			return map[string]any{
				"count": 3,
				"tools": []map[string]any{
					{"name": "ok.route", "description": "Route task under OK policy"},
					{"name": "ok.providers.list", "description": "List providers for a capability"},
					{"name": "ok.google_mvp.bundle", "description": "Google MVP lane bundle"},
				},
				"note": "Shapes mirror GET /mcp/tools; counts may differ in a live server.",
			}
		case "mcp call ok.route task:summarize-changelog class:summarize budgets:tier0_free,tier1_economy":
			return map[string]any{
				"status": "ok",
				"invocation": map[string]any{
					"tool": map[string]string{"name": "ok.route"},
					"result": map[string]any{
						"status":  "routed",
						"task":    "summarize-changelog",
						"message": "Illustrative MCP invoke result.",
					},
				},
			}
		case "mcp call ok.providers.list capability:summarize enabled_only:true":
			return map[string]any{
				"status": "ok",
				"invocation": map[string]any{
					"tool": map[string]string{"name": "ok.providers.list"},
					"result": map[string]any{
						"capability": "summarize",
						"providers": []map[string]any{
							{"id": "local.preview", "enabled": true},
						},
					},
				},
			}
		default:
			return map[string]any{
				"status": "ok",
				"lane":   p.Lane,
				"note":   "Wizard orchestration stub for " + input,
			}
		}
	}

	return map[string]any{
		"status":  "preview",
		"lane":    p.Lane,
		"owner":   p.Owner,
		"message": "Core-local preview only — no HTTP from feature-walk.",
	}
}
