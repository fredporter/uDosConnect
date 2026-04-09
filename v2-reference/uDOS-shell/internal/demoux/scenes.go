package demoux

// Scene is one full-screen UX fixture (ASCII layout demo).
type Scene struct {
	ID       string
	Title    string
	Filename string
}

// ScreenScenes is the canonical order for the interactive UX walk.
var ScreenScenes = []Scene{
	{ID: "home", Title: "Home shell", Filename: "home.txt"},
	{ID: "binder-workspace", Title: "Binder / workspace", Filename: "binder-workspace.txt"},
	{ID: "runtime-queue", Title: "Runtime block queue", Filename: "runtime-queue.txt"},
	{ID: "settings-sheet", Title: "Settings / config sheet", Filename: "settings-sheet.txt"},
	{ID: "scheduler-autonomy", Title: "Scheduler / autonomy (open-box)", Filename: "scheduler-autonomy.txt"},
	{ID: "grid-map", Title: "Grid / map view", Filename: "grid-map.txt"},
	{ID: "block-inspector-md", Title: "Markdown-backed block inspector", Filename: "block-inspector-md.txt"},
	{ID: "prompt-menu-hybrid", Title: "Prompt + menu hybrid", Filename: "prompt-menu-hybrid.txt"},
	{ID: "help-palette", Title: "Help / command palette", Filename: "help-palette.txt"},
	{ID: "error-blocked", Title: "Error / blocked condition", Filename: "error-blocked.txt"},
}

// ComponentFiles are primitive layout references for designers and tests.
var ComponentFiles = []string{
	"blocks.txt",
	"toolbars.txt",
	"menus.txt",
	"sheets.txt",
	"maps.txt",
	"prompt-bar.txt",
}

const (
	RelScreensDir    = "demo/screens"
	RelComponentsDir = "demo/components"
	RelPatternsDir   = "demo/patterns"
	PatternsGallery  = "demo/patterns/gallery.txt"
)
