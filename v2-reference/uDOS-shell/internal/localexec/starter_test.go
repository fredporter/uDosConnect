package localexec

import "testing"

func TestListFamilyTestTargetsIncludesShellCoreWizard(t *testing.T) {
	targets := ListFamilyTestTargets()
	found := map[string]bool{}
	for _, target := range targets {
		found[target.ID] = true
	}

	for _, id := range []string{"shell", "core", "wizard"} {
		if !found[id] {
			t.Fatalf("expected %s target", id)
		}
	}
}

func TestListWizardLaunchTargetsIncludesDefaultAndDev(t *testing.T) {
	targets := ListWizardLaunchTargets()
	found := map[string]bool{}
	for _, target := range targets {
		found[target.ID] = true
	}

	for _, id := range []string{"default", "dev"} {
		if !found[id] {
			t.Fatalf("expected %s wizard launch target", id)
		}
	}
}

func TestDoctorChecksIncludeLaunchers(t *testing.T) {
	checks := DoctorChecks()
	found := map[string]bool{}
	for _, check := range checks {
		found[check.Name] = true
	}

	for _, name := range []string{"node", "npm", "go", "shell-launcher", "shell-launcher-macos"} {
		if !found[name] {
			t.Fatalf("expected doctor check %s", name)
		}
	}
}
