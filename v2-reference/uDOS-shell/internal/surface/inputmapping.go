// Package surface loads uDOS-surface profile artifacts for Shell (input intents).
package surface

import (
	"encoding/json"
	"os"
	"path/filepath"
)

// InputMapping mirrors uDOS-surface profiles/.../input-mapping.json (v0.1).
type InputMapping struct {
	ProfileID       string   `json:"profileId"`
	SchemaVersion   string   `json:"schemaVersion"`
	Description     string   `json:"description,omitempty"`
	PrimaryInput    string   `json:"primaryInput"`
	SecondaryInput  []string `json:"secondaryInput,omitempty"`
	Keyboard   keyboardBlock
	Controller *controllerBlock `json:"controller,omitempty"`
}

type keyboardBlock struct {
	CommandPalette *struct {
		Open []string `json:"open,omitempty"`
		Note string   `json:"note,omitempty"`
	} `json:"commandPalette,omitempty"`
	Navigation *struct {
		FocusNextPanel         string `json:"focusNextPanel,omitempty"`
		FocusPreviousPanel     string `json:"focusPreviousPanel,omitempty"`
		ToggleThinUIFullscreen string `json:"toggleThinUIFullscreen,omitempty"`
	} `json:"navigation,omitempty"`
	ThinUI *struct {
		EscapeToHost string `json:"escapeToHost,omitempty"`
		Note         string `json:"note,omitempty"`
	} `json:"thinui,omitempty"`
}

type controllerBlock struct {
	Enabled      bool   `json:"enabled,omitempty"`
	UCIAlignment string `json:"uciAlignment,omitempty"`
	Note         string `json:"note,omitempty"`
}

type inputMappingWire struct {
	ProfileID      string                     `json:"profileId"`
	SchemaVersion  string                     `json:"schemaVersion"`
	Description    string                     `json:"description,omitempty"`
	PrimaryInput   string                     `json:"primaryInput"`
	SecondaryInput []string                   `json:"secondaryInput,omitempty"`
	Keyboard       json.RawMessage            `json:"keyboard,omitempty"`
	Controller     json.RawMessage            `json:"controller,omitempty"`
}

// ResolveInputMappingPath returns a path to input-mapping.json from environment, or "".
// Precedence: UDOS_SURFACE_INPUT_MAPPING → UDOS_SURFACE_REPO + profiles/<id>/input-mapping.json
// (profile id from UDOS_SURFACE_PROFILE_ID, default ubuntu-gnome).
func ResolveInputMappingPath() string {
	if p := os.Getenv("UDOS_SURFACE_INPUT_MAPPING"); p != "" {
		return p
	}
	repo := os.Getenv("UDOS_SURFACE_REPO")
	if repo == "" {
		return ""
	}
	pid := os.Getenv("UDOS_SURFACE_PROFILE_ID")
	if pid == "" {
		pid = "ubuntu-gnome"
	}
	return filepath.Join(repo, "profiles", pid, "input-mapping.json")
}

// LoadInputMapping reads and parses path.
func LoadInputMapping(path string) (*InputMapping, error) {
	raw, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	var wire inputMappingWire
	if err := json.Unmarshal(raw, &wire); err != nil {
		return nil, err
	}
	out := &InputMapping{
		ProfileID:      wire.ProfileID,
		SchemaVersion: wire.SchemaVersion,
		Description:    wire.Description,
		PrimaryInput:   wire.PrimaryInput,
		SecondaryInput: wire.SecondaryInput,
	}
	if len(wire.Keyboard) > 0 {
		if err := json.Unmarshal(wire.Keyboard, &out.Keyboard); err != nil {
			return nil, err
		}
	}
	if len(wire.Controller) > 0 {
		var c controllerBlock
		if err := json.Unmarshal(wire.Controller, &c); err != nil {
			return nil, err
		}
		out.Controller = &c
	}
	return out, nil
}
