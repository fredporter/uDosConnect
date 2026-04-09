package localexec

import (
	"bytes"
	"context"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"time"
)

type Result struct {
	Command  string
	Stdout   string
	Stderr   string
	ExitCode int
}

func Run(raw string) (Result, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
	defer cancel()

	cmd := exec.CommandContext(ctx, "sh", "-lc", raw)
	var stdout bytes.Buffer
	var stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr

	err := cmd.Run()
	result := Result{
		Command: raw,
		Stdout:  stdout.String(),
		Stderr:  stderr.String(),
	}

	if err == nil {
		return result, nil
	}

	if ctx.Err() == context.DeadlineExceeded {
		result.ExitCode = 124
		return result, fmt.Errorf("command timed out after 3s")
	}

	var exitErr *exec.ExitError
	if ok := errorAs(err, &exitErr); ok {
		result.ExitCode = exitErr.ExitCode()
		return result, fmt.Errorf("command failed with exit code %d", result.ExitCode)
	}

	return result, err
}

func runCommandParts(timeout time.Duration, dir string, parts ...string) (Result, error) {
	if len(parts) == 0 {
		return Result{}, fmt.Errorf("missing command")
	}

	ctx, cancel := context.WithTimeout(context.Background(), timeout)
	defer cancel()

	cmd := exec.CommandContext(ctx, parts[0], parts[1:]...)
	if dir != "" {
		cmd.Dir = dir
	}

	var stdout bytes.Buffer
	var stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr

	err := cmd.Run()
	result := Result{
		Command: stringsJoin(parts, " "),
		Stdout:  stdout.String(),
		Stderr:  stderr.String(),
	}

	if err == nil {
		return result, nil
	}

	if ctx.Err() == context.DeadlineExceeded {
		result.ExitCode = 124
		return result, fmt.Errorf("command timed out after %s", timeout)
	}

	var exitErr *exec.ExitError
	if ok := errorAs(err, &exitErr); ok {
		result.ExitCode = exitErr.ExitCode()
		return result, fmt.Errorf("command failed with exit code %d", result.ExitCode)
	}

	return result, err
}

func RunCoreScript(path string) (Result, error) {
	return runCoreCommand("run-script", path)
}

func RunCoreCommand(command string) (Result, error) {
	return runCoreCommand("run", command)
}

func runCoreCommand(args ...string) (Result, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	coreRoot := filepath.Join(repoRoot(), "..", "uDOS-core")
	cmdArgs := append([]string{"-m", "udos_core.cli"}, args...)
	cmd := exec.CommandContext(ctx, "python3", cmdArgs...)
	cmd.Dir = coreRoot
	cmd.Env = append(os.Environ(), "PYTHONPATH="+coreRoot)

	var stdout bytes.Buffer
	var stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr

	err := cmd.Run()
	result := Result{
		Command:  "python3 " + stringsJoin(cmdArgs, " "),
		Stdout:   stdout.String(),
		Stderr:   stderr.String(),
		ExitCode: 0,
	}

	if err == nil {
		return result, nil
	}

	if ctx.Err() == context.DeadlineExceeded {
		result.ExitCode = 124
		return result, fmt.Errorf("core command timed out after 5s")
	}

	var exitErr *exec.ExitError
	if ok := errorAs(err, &exitErr); ok {
		result.ExitCode = exitErr.ExitCode()
		return result, fmt.Errorf("core command failed with exit code %d", result.ExitCode)
	}

	return result, err
}

func repoRoot() string {
	_, filename, _, ok := runtime.Caller(0)
	if !ok {
		dir, err := os.Getwd()
		if err != nil {
			return "."
		}
		return dir
	}
	return filepath.Clean(filepath.Join(filepath.Dir(filename), "..", ".."))
}

func stringsJoin(items []string, sep string) string {
	if len(items) == 0 {
		return ""
	}
	out := items[0]
	for _, item := range items[1:] {
		out += sep + item
	}
	return out
}

func errorAs(err error, target any) bool {
	return execErrorAs(err, target)
}
