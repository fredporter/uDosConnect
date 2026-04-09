package localexec

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"strings"
	"time"
)

type FamilyScriptCheck struct {
	Name       string
	Repo       string
	ScriptPath string
	Present    bool
}

type FamilyDemo struct {
	ID          string
	Label       string
	Description string
	Command     []string
}

type FamilyTestTarget struct {
	ID          string
	Label       string
	Description string
	Command     []string
}

type WizardLaunchTarget struct {
	ID          string
	Label       string
	URL         string
	Description string
	CommandHint string
}

type DoctorCheck struct {
	Name    string
	Status  string
	Details string
}

func StartupHealthChecks() []FamilyScriptCheck {
	checks := []FamilyScriptCheck{
		{Name: "shell-checks", Repo: "uDOS-shell", ScriptPath: filepath.Join(repoRoot(), "scripts", "run-shell-checks.sh")},
		{Name: "thinui-checks", Repo: "uDOS-thinui", ScriptPath: filepath.Join(repoRoot(), "..", "uDOS-thinui", "scripts", "run-thinui-checks.sh")},
		{Name: "alpine-checks", Repo: "uDOS-alpine", ScriptPath: filepath.Join(repoRoot(), "..", "uDOS-alpine", "scripts", "run-alpine-checks.sh")},
		{Name: "ubuntu-checks", Repo: "uDOS-host", ScriptPath: filepath.Join(repoRoot(), "..", "uDOS-host", "scripts", "run-ubuntu-checks.sh")},
		{Name: "wizard-checks", Repo: "uDOS-wizard", ScriptPath: filepath.Join(repoRoot(), "..", "uDOS-wizard", "scripts", "run-wizard-checks.sh")},
		{Name: "sonic-checks", Repo: "sonic-screwdriver", ScriptPath: filepath.Join(repoRoot(), "..", "sonic-screwdriver", "scripts", "run-sonic-checks.sh")},
	}

	for index := range checks {
		_, err := os.Stat(checks[index].ScriptPath)
		checks[index].Present = err == nil
	}
	return checks
}

func ListFamilyDemos() []FamilyDemo {
	return []FamilyDemo{
		{
			ID:          "thinui-c64",
			Label:       "ThinUI C64",
			Description: "Render the Alpine-linked ThinUI C64 startup demo.",
			Command:     []string{"node", filepath.Join(repoRoot(), "..", "uDOS-thinui", "scripts", "demo-thinui.js"), "--theme", "thinui-c64", "--view", "boot-loader"},
		},
		{
			ID:          "thinui-nes-sonic",
			Label:       "ThinUI NES Sonic",
			Description: "Render the Sonic-linked ThinUI NES utility demo.",
			Command:     []string{"node", filepath.Join(repoRoot(), "..", "uDOS-thinui", "scripts", "demo-thinui.js"), "--theme", "thinui-nes-sonic", "--view", "boot-loader"},
		},
		{
			ID:          "thinui-teletext",
			Label:       "ThinUI Teletext",
			Description: "Render the teletext block-graphic ThinUI demo page.",
			Command:     []string{"node", filepath.Join(repoRoot(), "..", "uDOS-thinui", "scripts", "demo-thinui.js"), "--theme", "thinui-teletext", "--view", "teletext-display"},
		},
		{
			ID:          "alpine-c64",
			Label:       "Alpine C64 Launcher",
			Description: "Run the Alpine ThinUI C64 launcher handoff demo.",
			Command:     []string{"bash", filepath.Join(repoRoot(), "..", "uDOS-alpine", "scripts", "demo-thinui-launch.sh")},
		},
		{
			ID:          "ubuntu-setup",
			Label:       "Ubuntu Setup Story",
			Description: "Run the Ubuntu first-run setup and ThinUI handoff story.",
			Command:     []string{"bash", filepath.Join(repoRoot(), "..", "uDOS-host", "scripts", "demo-first-run-setup.sh")},
		},
		{
			ID:          "sonic-nes",
			Label:       "Sonic NES Launcher",
			Description: "Run the Sonic ThinUI NES launcher demo.",
			Command:     []string{"bash", filepath.Join(repoRoot(), "..", "sonic-screwdriver", "scripts", "demo-thinui-launch.sh")},
		},
	}
}

func ListFamilyTestTargets() []FamilyTestTarget {
	return []FamilyTestTarget{
		{
			ID:          "shell",
			Label:       "Shell",
			Description: "Run the local uDOS-shell validation suite.",
			Command:     []string{"bash", filepath.Join(repoRoot(), "scripts", "run-shell-checks.sh")},
		},
		{
			ID:          "core",
			Label:       "Core",
			Description: "Run the sibling uDOS-core validation suite.",
			Command:     []string{"bash", filepath.Join(repoRoot(), "..", "uDOS-core", "scripts", "run-core-checks.sh")},
		},
		{
			ID:          "wizard",
			Label:       "Wizard",
			Description: "Run the sibling uDOS-wizard validation suite.",
			Command:     []string{"bash", filepath.Join(repoRoot(), "..", "uDOS-wizard", "scripts", "run-wizard-checks.sh")},
		},
	}
}

func RunFamilyTestTarget(id string) (Result, FamilyTestTarget, error) {
	for _, target := range ListFamilyTestTargets() {
		if target.ID != id {
			continue
		}
		result, err := runCommandParts(90*time.Second, repoRoot(), target.Command...)
		return result, target, err
	}
	return Result{}, FamilyTestTarget{}, fmt.Errorf("unknown test target %q", id)
}

func RunFamilyTestSuite(ids ...string) (Result, error) {
	if len(ids) == 0 {
		return Result{}, fmt.Errorf("missing test suite ids")
	}

	combined := Result{Command: stringsJoin(ids, ",")}
	for _, id := range ids {
		result, target, err := RunFamilyTestTarget(id)
		combined.Stdout += fmt.Sprintf("== %s ==\n%s\n", target.Label, strings.TrimSpace(result.Stdout))
		if strings.TrimSpace(result.Stderr) != "" {
			combined.Stderr += fmt.Sprintf("== %s ==\n%s\n", target.Label, strings.TrimSpace(result.Stderr))
		}
		if err != nil {
			combined.ExitCode = result.ExitCode
			return combined, err
		}
	}
	return combined, nil
}

func ListWizardLaunchTargets() []WizardLaunchTarget {
	return []WizardLaunchTarget{
		{
			ID:          "default",
			Label:       "Wizard App",
			URL:         "http://127.0.0.1:8787/app",
			Description: "Open the Wizard-served browser app.",
			CommandHint: "cd ../uDOS-wizard && python3 -m wizard.main",
		},
		{
			ID:          "dev",
			Label:       "Wizard Dev App",
			URL:         "http://127.0.0.1:4173",
			Description: "Open the Svelte/Tailwind dev workbench.",
			CommandHint: "cd ../uDOS-wizard/apps/wizard-ui && npm install && npm run dev",
		},
	}
}

func OpenWizardLaunchTarget(id string) (Result, WizardLaunchTarget, error) {
	for _, target := range ListWizardLaunchTargets() {
		if target.ID != id {
			continue
		}

		opener := "xdg-open"
		if runtime.GOOS == "darwin" {
			opener = "open"
		}
		if _, err := exec.LookPath(opener); err != nil {
			return Result{}, target, fmt.Errorf("missing opener command %q", opener)
		}

		result, err := runCommandParts(5*time.Second, repoRoot(), opener, target.URL)
		return result, target, err
	}
	return Result{}, WizardLaunchTarget{}, fmt.Errorf("unknown wizard launch target %q", id)
}

func DoctorChecks() []DoctorCheck {
	checks := []DoctorCheck{
		commandDoctorCheck("node"),
		commandDoctorCheck("npm"),
		commandDoctorCheck("go"),
		pathDoctorCheck("shell-repo", repoRoot()),
		pathDoctorCheck("shell-launcher", filepath.Join(repoRoot(), "scripts", "first-run-launch.sh")),
		pathDoctorCheck("shell-launcher-macos", filepath.Join(repoRoot(), "scripts", "first-run-launch.command")),
		pathDoctorCheck("core-repo", filepath.Join(repoRoot(), "..", "uDOS-core")),
		pathDoctorCheck("wizard-repo", filepath.Join(repoRoot(), "..", "uDOS-wizard")),
		pathDoctorCheck("wizard-ui", filepath.Join(repoRoot(), "..", "uDOS-wizard", "apps", "wizard-ui")),
	}
	return checks
}

func commandDoctorCheck(name string) DoctorCheck {
	if path, err := exec.LookPath(name); err == nil {
		return DoctorCheck{Name: name, Status: "ready", Details: path}
	}
	return DoctorCheck{Name: name, Status: "missing", Details: "not found in PATH"}
}

func pathDoctorCheck(name string, path string) DoctorCheck {
	if _, err := os.Stat(path); err == nil {
		return DoctorCheck{Name: name, Status: "ready", Details: path}
	}
	return DoctorCheck{Name: name, Status: "missing", Details: path}
}

func RunFamilyDemo(id string) (Result, error) {
	for _, demo := range ListFamilyDemos() {
		if demo.ID != id {
			continue
		}
		return runCommand(demo.Command...)
	}
	return Result{}, fmt.Errorf("unknown demo %q", id)
}

func HasSeenSetupStory() bool {
	_, err := os.Stat(setupStoryMarkerPath())
	return err == nil
}

func MarkSetupStorySeen() error {
	path := setupStoryMarkerPath()
	if err := os.MkdirAll(filepath.Dir(path), 0o755); err != nil {
		return err
	}
	return os.WriteFile(path, []byte("seen\n"), 0o644)
}

func setupStoryMarkerPath() string {
	home, err := os.UserHomeDir()
	if err != nil || home == "" {
		return filepath.Join(repoRoot(), ".udos-shell-first-run")
	}
	return filepath.Join(home, ".udos-shell", "setup-story-seen")
}

func runCommand(parts ...string) (Result, error) {
	if len(parts) == 0 {
		return Result{}, fmt.Errorf("missing command")
	}

	return Run(stringsJoin(parts, " "))
}
