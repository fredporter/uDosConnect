package localexec

import (
	"encoding/json"
	"fmt"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestWizardBaseURLUsesDefaults(t *testing.T) {
	t.Setenv("UDOS_WIZARD_BASE_URL", "")
	t.Setenv("UDOS_WIZARD_HOST", "")
	t.Setenv("UDOS_WIZARD_PORT", "")

	if got := WizardBaseURL(); got != "http://127.0.0.1:8787" {
		t.Fatalf("expected default base url, got %q", got)
	}
}

func TestWizardBaseURLPrefersExplicitBaseURL(t *testing.T) {
	t.Setenv("UDOS_WIZARD_BASE_URL", "http://127.0.0.1:58008/")
	t.Setenv("UDOS_WIZARD_HOST", "192.0.2.10")
	t.Setenv("UDOS_WIZARD_PORT", "9999")

	if got := WizardBaseURL(); got != "http://127.0.0.1:58008" {
		t.Fatalf("expected explicit base url, got %q", got)
	}
}

func TestWizardAssistFetchesDispatchEnvelope(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if got := r.URL.Path; got != "/assist" {
			t.Fatalf("expected /assist path, got %q", got)
		}
		if got := r.URL.Query().Get("task"); got != "shell" {
			t.Fatalf("expected task shell, got %q", got)
		}
		if got := r.URL.Query().Get("mode"); got != "auto" {
			t.Fatalf("expected mode auto, got %q", got)
		}

		w.Header().Set("Content-Type", "application/json")
		fmt.Fprint(w, `{"dispatch_id":"dispatch:assist:shell:auto","provider":"wizard-provider","executor":"provider-router","transport":"https","status":"queued","task":"shell","mode":"auto","surface":"assist"}`)
	}))
	defer server.Close()

	t.Setenv("UDOS_WIZARD_BASE_URL", server.URL)

	result, err := WizardAssist("shell", "auto")
	if err != nil {
		t.Fatalf("expected success, got %v", err)
	}

	if result.BaseURL != server.URL {
		t.Fatalf("expected base url %q, got %q", server.URL, result.BaseURL)
	}
	if got := result.Payload["dispatch_id"]; got != "dispatch:assist:shell:auto" {
		t.Fatalf("expected dispatch id, got %#v", got)
	}
	if got := result.Payload["provider"]; got != "wizard-provider" {
		t.Fatalf("expected provider wizard-provider, got %#v", got)
	}
}

func TestWizardAssistReturnsErrorOnNon200Status(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		http.Error(w, "upstream unavailable", http.StatusBadGateway)
	}))
	defer server.Close()

	t.Setenv("UDOS_WIZARD_BASE_URL", server.URL)

	_, err := WizardAssist("shell", "auto")
	if err == nil {
		t.Fatal("expected error from non-200 response")
	}

	if got := err.Error(); got != "wizard assist returned 502: upstream unavailable" {
		t.Fatalf("unexpected error %q", got)
	}
}

func TestWizardWorkflowActionPostsLivePayload(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if got := r.Method; got != http.MethodPost {
			t.Fatalf("expected POST, got %q", got)
		}
		if got := r.URL.Path; got != "/workflow/actions" {
			t.Fatalf("expected /workflow/actions, got %q", got)
		}

		var payload map[string]any
		if err := json.NewDecoder(r.Body).Decode(&payload); err != nil {
			t.Fatalf("decode payload: %v", err)
		}
		if got := payload["workflow_id"]; got != "mission-alpha" {
			t.Fatalf("expected workflow_id mission-alpha, got %#v", got)
		}
		if got := payload["action"]; got != "advance" {
			t.Fatalf("expected action advance, got %#v", got)
		}

		w.Header().Set("Content-Type", "application/json")
		fmt.Fprint(w, `{"action":{"workflow_id":"mission-alpha","action":"advance","requested_by":"uCODE-TUI"},"state":{"workflow_id":"mission-alpha","step_id":"step-2","status":"running","awaiting_user_action":false,"last_transition_at":"2026-03-15T20:40:00Z","origin_surface":"uCODE-TUI"}}`)
	}))
	defer server.Close()

	t.Setenv("UDOS_WIZARD_BASE_URL", server.URL)

	result, err := WizardWorkflowAction("mission-alpha", "advance")
	if err != nil {
		t.Fatalf("expected success, got %v", err)
	}

	actionPayload, _ := result.Payload["action"].(map[string]any)
	statePayload, _ := result.Payload["state"].(map[string]any)
	if got := actionPayload["action"]; got != "advance" {
		t.Fatalf("expected action advance, got %#v", got)
	}
	if got := statePayload["status"]; got != "running" {
		t.Fatalf("expected state status running, got %#v", got)
	}
}

func TestWizardAutomationJobPostsWorkflowContext(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if got := r.Method; got != http.MethodPost {
			t.Fatalf("expected POST, got %q", got)
		}
		if got := r.URL.Path; got != "/workflow/handoff/automation-job" {
			t.Fatalf("expected /workflow/handoff/automation-job, got %q", got)
		}

		var payload map[string]any
		if err := json.NewDecoder(r.Body).Decode(&payload); err != nil {
			t.Fatalf("decode payload: %v", err)
		}
		if got := payload["workflow_id"]; got != "mission-alpha" {
			t.Fatalf("expected workflow_id mission-alpha, got %#v", got)
		}
		if got := payload["step_id"]; got != "step-4" {
			t.Fatalf("expected step_id step-4, got %#v", got)
		}
		if got := payload["requested_capability"]; got != "render-export" {
			t.Fatalf("expected requested_capability render-export, got %#v", got)
		}

		w.Header().Set("Content-Type", "application/json")
		fmt.Fprint(w, `{"job_id":"job:mission-alpha:step-4:render-export","requested_capability":"render-export","payload_ref":"workflow://mission-alpha/step-4","origin_surface":"uCODE-TUI","policy_flags":{"workflow_id":"mission-alpha","step_id":"step-4"},"queued_at":"2026-03-15T20:41:00Z"}`)
	}))
	defer server.Close()

	t.Setenv("UDOS_WIZARD_BASE_URL", server.URL)

	result, err := WizardAutomationJob("mission-alpha", "step-4", "render-export")
	if err != nil {
		t.Fatalf("expected success, got %v", err)
	}

	if got := result.Payload["job_id"]; got != "job:mission-alpha:step-4:render-export" {
		t.Fatalf("expected job id, got %#v", got)
	}
	policyFlags, _ := result.Payload["policy_flags"].(map[string]any)
	if got := policyFlags["workflow_id"]; got != "mission-alpha" {
		t.Fatalf("expected workflow_id mission-alpha, got %#v", got)
	}
}

func TestWizardOKRoutePostsRoutingRequest(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if got := r.Method; got != http.MethodPost {
			t.Fatalf("expected POST, got %q", got)
		}
		if got := r.URL.Path; got != "/ok/route" {
			t.Fatalf("expected /ok/route, got %q", got)
		}

		var payload map[string]any
		if err := json.NewDecoder(r.Body).Decode(&payload); err != nil {
			t.Fatalf("decode payload: %v", err)
		}
		if got := payload["task_class"]; got != "summarize" {
			t.Fatalf("expected task_class summarize, got %#v", got)
		}

		w.Header().Set("Content-Type", "application/json")
		fmt.Fprint(w, `{"request":{"task_class":"summarize"},"decision":{"status":"routed","provider_id":"wizard.mistral","budget_group":"tier0_free"}}`)
	}))
	defer server.Close()

	t.Setenv("UDOS_WIZARD_BASE_URL", server.URL)

	result, err := WizardOKRoute(map[string]any{"task_class": "summarize"})
	if err != nil {
		t.Fatalf("expected success, got %v", err)
	}

	decision, _ := result.Payload["decision"].(map[string]any)
	if got := decision["status"]; got != "routed" {
		t.Fatalf("expected status routed, got %#v", got)
	}
	if got := decision["provider_id"]; got != "wizard.mistral" {
		t.Fatalf("expected provider wizard.mistral, got %#v", got)
	}
}

func TestWizardMCPInitializePostsJSONRPCRequest(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if got := r.Method; got != http.MethodPost {
			t.Fatalf("expected POST, got %q", got)
		}
		if got := r.URL.Path; got != "/mcp" {
			t.Fatalf("expected /mcp, got %q", got)
		}

		var payload map[string]any
		if err := json.NewDecoder(r.Body).Decode(&payload); err != nil {
			t.Fatalf("decode payload: %v", err)
		}
		if got := payload["method"]; got != "initialize" {
			t.Fatalf("expected initialize method, got %#v", got)
		}

		w.Header().Set("Content-Type", "application/json")
		fmt.Fprint(w, `{"jsonrpc":"2.0","id":"uDOS-shell","result":{"serverInfo":{"name":"uDOS Wizard MCP","version":"v2.2"}}}`)
	}))
	defer server.Close()

	t.Setenv("UDOS_WIZARD_BASE_URL", server.URL)

	result, err := WizardMCPInitialize("uDOS-shell")
	if err != nil {
		t.Fatalf("expected success, got %v", err)
	}

	response := mapValue(result.Payload["result"])
	serverInfo := mapValue(response["serverInfo"])
	if got := serverInfo["name"]; got != "uDOS Wizard MCP" {
		t.Fatalf("expected server name, got %#v", got)
	}
}

func TestWizardMCPListToolsReturnsToolResult(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		var payload map[string]any
		if err := json.NewDecoder(r.Body).Decode(&payload); err != nil {
			t.Fatalf("decode payload: %v", err)
		}
		if got := payload["method"]; got != "tools/list" {
			t.Fatalf("expected tools/list method, got %#v", got)
		}

		w.Header().Set("Content-Type", "application/json")
		fmt.Fprint(w, `{"jsonrpc":"2.0","id":"uDOS-shell","result":{"count":1,"tools":[{"name":"ok.route"}]}}`)
	}))
	defer server.Close()

	t.Setenv("UDOS_WIZARD_BASE_URL", server.URL)

	result, err := WizardMCPListTools()
	if err != nil {
		t.Fatalf("expected success, got %v", err)
	}

	response := mapValue(result.Payload["result"])
	if got := response["count"]; got != float64(1) {
		t.Fatalf("expected tool count, got %#v", got)
	}
}

func TestWizardMCPCallPostsArguments(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		var payload map[string]any
		if err := json.NewDecoder(r.Body).Decode(&payload); err != nil {
			t.Fatalf("decode payload: %v", err)
		}

		params := mapValue(payload["params"])
		if got := params["name"]; got != "ok.route" {
			t.Fatalf("expected tool name ok.route, got %#v", got)
		}
		arguments := mapValue(params["arguments"])
		if got := arguments["task"]; got != "summarize changelog" {
			t.Fatalf("expected task payload, got %#v", got)
		}

		w.Header().Set("Content-Type", "application/json")
		fmt.Fprint(w, `{"jsonrpc":"2.0","id":"uDOS-shell","result":{"tool_name":"ok.route","result":{"status":"routed"}}}`)
	}))
	defer server.Close()

	t.Setenv("UDOS_WIZARD_BASE_URL", server.URL)

	result, err := WizardMCPCall("ok.route", map[string]any{"task": "summarize changelog"})
	if err != nil {
		t.Fatalf("expected success, got %v", err)
	}

	response := mapValue(result.Payload["result"])
	if got := response["tool_name"]; got != "ok.route" {
		t.Fatalf("expected tool name ok.route, got %#v", got)
	}
}

func TestWizardMCPCallReturnsRPCError(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		fmt.Fprint(w, `{"jsonrpc":"2.0","id":"uDOS-shell","error":{"code":-32000,"message":"unknown tool: nope"}}`)
	}))
	defer server.Close()

	t.Setenv("UDOS_WIZARD_BASE_URL", server.URL)

	_, err := WizardMCPCall("nope", nil)
	if err == nil {
		t.Fatal("expected rpc error")
	}
	if got := err.Error(); got != "wizard mcp tool call: unknown tool: nope" {
		t.Fatalf("unexpected error %q", got)
	}
}
