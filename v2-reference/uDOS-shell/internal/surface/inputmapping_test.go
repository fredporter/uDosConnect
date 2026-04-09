package surface

import (
	"os"
	"path/filepath"
	"testing"
)

func TestLoadInputMapping_ubuntuGnomeFixture(t *testing.T) {
	dir := t.TempDir()
	path := filepath.Join(dir, "input-mapping.json")
	const sample = `{
  "profileId": "ubuntu-gnome",
  "schemaVersion": "0.1",
  "primaryInput": "keyboard",
  "keyboard": {
    "commandPalette": { "open": ["Ctrl+Shift+P"], "note": "test" },
    "navigation": { "focusNextPanel": "Ctrl+Tab" }
  },
  "controller": { "enabled": true, "uciAlignment": "radial" }
}`
	if err := os.WriteFile(path, []byte(sample), 0o600); err != nil {
		t.Fatal(err)
	}
	m, err := LoadInputMapping(path)
	if err != nil {
		t.Fatal(err)
	}
	if m.ProfileID != "ubuntu-gnome" {
		t.Fatalf("profileId %q", m.ProfileID)
	}
	b := KeyBindingsFromInputMapping(m)
	if len(b) < 2 {
		t.Fatalf("expected bindings, got %d", len(b))
	}
}

func TestResolveInputMappingPath(t *testing.T) {
	t.Setenv("UDOS_SURFACE_INPUT_MAPPING", "/custom/path.json")
	if got := ResolveInputMappingPath(); got != "/custom/path.json" {
		t.Fatalf("got %q", got)
	}
	t.Setenv("UDOS_SURFACE_INPUT_MAPPING", "")
	t.Setenv("UDOS_SURFACE_REPO", "/repo")
	t.Setenv("UDOS_SURFACE_PROFILE_ID", "dev-console")
	if got := ResolveInputMappingPath(); got != filepath.Join("/repo", "profiles", "dev-console", "input-mapping.json") {
		t.Fatalf("got %q", got)
	}
}
