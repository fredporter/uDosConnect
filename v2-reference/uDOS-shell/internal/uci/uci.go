package uci

import "strings"

type Mode string

const (
	ModeNav     Mode = "nav"
	ModeText    Mode = "text"
	ModeCommand Mode = "command"
	ModeEdit    Mode = "edit"
	ModeGame    Mode = "game"
	ModeMedia   Mode = "media"
)

type SemanticAction string

const (
	ActionConfirm          SemanticAction = "confirm"
	ActionCancel           SemanticAction = "cancel"
	ActionBack             SemanticAction = "back"
	ActionMenu             SemanticAction = "menu"
	ActionPalette          SemanticAction = "palette"
	ActionNextTab          SemanticAction = "next_tab"
	ActionPreviousTab      SemanticAction = "previous_tab"
	ActionNextPanel        SemanticAction = "next_panel"
	ActionPreviousPanel    SemanticAction = "previous_panel"
	ActionAcceptPrediction SemanticAction = "accept_prediction"
	ActionDeleteBackward   SemanticAction = "delete_backward"
	ActionSubmit           SemanticAction = "submit"
)

type Mapping struct {
	Control        string
	Mode           Mode
	SemanticAction SemanticAction
}

type Prediction struct {
	Value  string
	Source string
}

type Session struct {
	mode          Mode
	paletteOpen   bool
	activePanel   int
	input         string
	predictions   []Prediction
	submitted     []string
	radialVisible bool
}

type Snapshot struct {
	Mode          Mode
	PaletteOpen   bool
	ActivePanel   int
	Input         string
	Predictions   []Prediction
	Submitted     []string
	RadialVisible bool
}

type RadialKey struct {
	ID     string
	Label  string
	Action SemanticAction
}

func ValidModes() []Mode {
	return []Mode{ModeNav, ModeText, ModeCommand, ModeEdit, ModeGame, ModeMedia}
}

func ReservedSemanticActions() []SemanticAction {
	return []SemanticAction{
		ActionConfirm,
		ActionCancel,
		ActionBack,
		ActionMenu,
		ActionPalette,
		ActionNextTab,
		ActionPreviousTab,
		ActionNextPanel,
		ActionPreviousPanel,
		ActionAcceptPrediction,
		ActionDeleteBackward,
		ActionSubmit,
	}
}

func IsValidMode(mode Mode) bool {
	for _, candidate := range ValidModes() {
		if candidate == mode {
			return true
		}
	}
	return false
}

func IsReservedSemanticAction(action SemanticAction) bool {
	for _, candidate := range ReservedSemanticActions() {
		if candidate == action {
			return true
		}
	}
	return false
}

func ShellPrototypeMappings() []Mapping {
	return []Mapping{
		{Control: "button-menu", Mode: ModeNav, SemanticAction: ActionPalette},
		{Control: "button-b", Mode: ModeNav, SemanticAction: ActionBack},
		{Control: "button-a", Mode: ModeCommand, SemanticAction: ActionConfirm},
		{Control: "dpad-right", Mode: ModeCommand, SemanticAction: ActionAcceptPrediction},
		{Control: "button-x", Mode: ModeText, SemanticAction: ActionDeleteBackward},
		{Control: "button-start", Mode: ModeCommand, SemanticAction: ActionSubmit},
	}
}

func RadialKeyboardLayout() []RadialKey {
	return []RadialKey{
		{ID: "north", Label: "Confirm", Action: ActionConfirm},
		{ID: "east", Label: "Predict", Action: ActionAcceptPrediction},
		{ID: "south", Label: "Back", Action: ActionBack},
		{ID: "west", Label: "Palette", Action: ActionPalette},
	}
}

func NewSession() *Session {
	return &Session{
		mode:        ModeNav,
		activePanel: 0,
	}
}

func (s *Session) SetMode(mode Mode) bool {
	if !IsValidMode(mode) {
		return false
	}
	s.mode = mode
	return true
}

func (s *Session) SetInput(input string) {
	s.input = input
}

func (s *Session) SetPredictions(predictions []Prediction) {
	s.predictions = append([]Prediction{}, predictions...)
}

func (s *Session) Apply(action SemanticAction) bool {
	if !IsReservedSemanticAction(action) {
		return false
	}

	switch action {
	case ActionPalette:
		s.paletteOpen = true
		s.mode = ModeCommand
		s.radialVisible = true
	case ActionBack, ActionCancel:
		s.paletteOpen = false
		s.radialVisible = false
		s.mode = ModeNav
	case ActionNextPanel:
		s.activePanel++
	case ActionPreviousPanel:
		if s.activePanel > 0 {
			s.activePanel--
		}
	case ActionAcceptPrediction:
		if len(s.predictions) > 0 {
			if s.input != "" && !strings.HasSuffix(s.input, " ") {
				s.input += " "
			}
			s.input += s.predictions[0].Value
		}
	case ActionDeleteBackward:
		if len(s.input) > 0 {
			s.input = s.input[:len(s.input)-1]
		}
	case ActionSubmit, ActionConfirm:
		if strings.TrimSpace(s.input) != "" {
			s.submitted = append(s.submitted, s.input)
		}
		s.paletteOpen = false
		s.radialVisible = false
		s.mode = ModeNav
	}

	return true
}

func (s *Session) Snapshot() Snapshot {
	return Snapshot{
		Mode:          s.mode,
		PaletteOpen:   s.paletteOpen,
		ActivePanel:   s.activePanel,
		Input:         s.input,
		Predictions:   append([]Prediction{}, s.predictions...),
		Submitted:     append([]string{}, s.submitted...),
		RadialVisible: s.radialVisible,
	}
}
