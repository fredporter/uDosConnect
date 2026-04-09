package localexec

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"os"
	"strings"
	"time"
)

const (
	defaultWizardHost = "127.0.0.1"
	defaultWizardPort = "8787"
)

type WizardResponse struct {
	BaseURL string
	Payload map[string]any
}

func wizardRequest(method string, path string, query url.Values, payload map[string]any, label string) (WizardResponse, error) {
	baseURL := WizardBaseURL()
	endpoint, err := url.Parse(baseURL + path)
	if err != nil {
		return WizardResponse{}, fmt.Errorf("invalid wizard base url %q: %w", baseURL, err)
	}
	if query != nil {
		endpoint.RawQuery = query.Encode()
	}

	var body io.Reader
	if payload != nil {
		buf, err := json.Marshal(payload)
		if err != nil {
			return WizardResponse{BaseURL: baseURL}, fmt.Errorf("marshal %s request: %w", label, err)
		}
		body = bytes.NewReader(buf)
	}

	request, err := http.NewRequest(method, endpoint.String(), body)
	if err != nil {
		return WizardResponse{BaseURL: baseURL}, fmt.Errorf("build %s request: %w", label, err)
	}
	if payload != nil {
		request.Header.Set("Content-Type", "application/json")
	}

	client := &http.Client{Timeout: 3 * time.Second}
	response, err := client.Do(request)
	if err != nil {
		return WizardResponse{BaseURL: baseURL}, fmt.Errorf("request %s: %w", label, err)
	}
	defer response.Body.Close()

	if response.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(io.LimitReader(response.Body, 2048))
		message := strings.TrimSpace(string(body))
		if message == "" {
			message = http.StatusText(response.StatusCode)
		}
		return WizardResponse{BaseURL: baseURL}, fmt.Errorf(
			"%s returned %d: %s",
			label,
			response.StatusCode,
			message,
		)
	}

	var decoded map[string]any
	if err := json.NewDecoder(response.Body).Decode(&decoded); err != nil {
		return WizardResponse{BaseURL: baseURL}, fmt.Errorf("decode %s response: %w", label, err)
	}

	return WizardResponse{BaseURL: baseURL, Payload: decoded}, nil
}

func WizardBaseURL() string {
	if baseURL := strings.TrimSpace(os.Getenv("UDOS_WIZARD_BASE_URL")); baseURL != "" {
		return strings.TrimRight(baseURL, "/")
	}

	host := strings.TrimSpace(os.Getenv("UDOS_WIZARD_HOST"))
	if host == "" {
		host = defaultWizardHost
	}

	port := strings.TrimSpace(os.Getenv("UDOS_WIZARD_PORT"))
	if port == "" {
		port = defaultWizardPort
	}

	return fmt.Sprintf("http://%s:%s", host, port)
}

func WizardAssist(task string, mode string) (WizardResponse, error) {
	trimmedTask := strings.TrimSpace(task)
	if trimmedTask == "" {
		trimmedTask = "assist"
	}

	trimmedMode := strings.TrimSpace(mode)
	if trimmedMode == "" {
		trimmedMode = "auto"
	}

	baseURL := WizardBaseURL()
	endpoint, err := url.Parse(baseURL + "/assist")
	if err != nil {
		return WizardResponse{}, fmt.Errorf("invalid wizard base url %q: %w", baseURL, err)
	}

	query := endpoint.Query()
	query.Set("task", trimmedTask)
	query.Set("mode", trimmedMode)
	return wizardRequest(http.MethodGet, "/assist", query, nil, "wizard assist")
}

func WizardWorkflowAction(workflowID string, action string) (WizardResponse, error) {
	trimmedWorkflowID := strings.TrimSpace(workflowID)
	if trimmedWorkflowID == "" {
		trimmedWorkflowID = "wizard-default"
	}

	trimmedAction := strings.TrimSpace(action)
	if trimmedAction == "" {
		trimmedAction = "advance"
	}

	return wizardRequest(
		http.MethodPost,
		"/workflow/actions",
		nil,
		map[string]any{
			"workflow_id":    trimmedWorkflowID,
			"action":         trimmedAction,
			"requested_by":   "uCODE-TUI",
			"origin_surface": "uCODE-TUI",
			"policy_flags": map[string]any{
				"requires_wizard_policy": true,
			},
		},
		"wizard workflow action",
	)
}

func WizardAutomationJob(workflowID string, stepID string, capability string) (WizardResponse, error) {
	trimmedWorkflowID := strings.TrimSpace(workflowID)
	if trimmedWorkflowID == "" {
		trimmedWorkflowID = "wizard-default"
	}

	trimmedStepID := strings.TrimSpace(stepID)
	if trimmedStepID == "" {
		trimmedStepID = "step-1"
	}

	trimmedCapability := strings.TrimSpace(capability)
	if trimmedCapability == "" {
		trimmedCapability = "local-task"
	}

	return wizardRequest(
		http.MethodPost,
		"/workflow/handoff/automation-job",
		nil,
		map[string]any{
			"workflow_id":          trimmedWorkflowID,
			"step_id":              trimmedStepID,
			"requested_capability": trimmedCapability,
			"payload_ref":          fmt.Sprintf("workflow://%s/%s", trimmedWorkflowID, trimmedStepID),
			"origin_surface":       "uCODE-TUI",
			"policy_flags": map[string]any{
				"local_only_preferred": true,
			},
		},
		"wizard automation handoff",
	)
}

func WizardOKRoute(payload map[string]any) (WizardResponse, error) {
	requestPayload := payload
	if requestPayload == nil {
		requestPayload = map[string]any{}
	}

	return wizardRequest(
		http.MethodPost,
		"/ok/route",
		nil,
		requestPayload,
		"wizard ok route",
	)
}

func WizardMCPInitialize(clientName string) (WizardResponse, error) {
	name := strings.TrimSpace(clientName)
	if name == "" {
		name = "uDOS-shell"
	}

	return wizardRPC(
		"initialize",
		map[string]any{
			"clientInfo": map[string]any{
				"name":    name,
				"version": "v2.2",
			},
		},
		"wizard mcp initialize",
	)
}

func WizardMCPListTools() (WizardResponse, error) {
	return wizardRPC("tools/list", map[string]any{}, "wizard mcp tools list")
}

func WizardMCPCall(toolName string, arguments map[string]any) (WizardResponse, error) {
	name := strings.TrimSpace(toolName)
	if name == "" {
		return WizardResponse{}, fmt.Errorf("wizard mcp call requires a tool name")
	}
	if arguments == nil {
		arguments = map[string]any{}
	}

	return wizardRPC(
		"tools/call",
		map[string]any{
			"name":      name,
			"arguments": arguments,
		},
		"wizard mcp tool call",
	)
}

func wizardRPC(method string, params map[string]any, label string) (WizardResponse, error) {
	response, err := wizardRequest(
		http.MethodPost,
		"/mcp",
		nil,
		map[string]any{
			"jsonrpc": "2.0",
			"id":      "uDOS-shell",
			"method":  method,
			"params":  params,
		},
		label,
	)
	if err != nil {
		return response, err
	}

	if rpcError := mapValue(response.Payload["error"]); len(rpcError) > 0 {
		message := strings.TrimSpace(stringValue(rpcError["message"]))
		if message == "" {
			message = "unknown mcp error"
		}
		return response, fmt.Errorf("%s: %s", label, message)
	}

	return response, nil
}

func mapValue(value any) map[string]any {
	item, _ := value.(map[string]any)
	if item == nil {
		return map[string]any{}
	}
	return item
}

func stringValue(value any) string {
	text, _ := value.(string)
	return text
}
