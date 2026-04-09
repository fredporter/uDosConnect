package localexec

import "testing"

func TestStartupHealthChecksIncludesThinUi(t *testing.T) {
	checks := StartupHealthChecks()
	if len(checks) == 0 {
		t.Fatal("expected startup checks")
	}

	found := false
	for _, check := range checks {
		if check.Repo == "uDOS-thinui" {
			found = true
			break
		}
	}
	if !found {
		t.Fatal("expected uDOS-thinui startup check")
	}
}

func TestListFamilyDemosIncludesTeletext(t *testing.T) {
	demos := ListFamilyDemos()
	found := false
	for _, demo := range demos {
		if demo.ID == "thinui-teletext" {
			found = true
			break
		}
	}
	if !found {
		t.Fatal("expected thinui-teletext demo")
	}
}
