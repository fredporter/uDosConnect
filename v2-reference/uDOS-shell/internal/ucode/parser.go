package ucode

import (
	"strings"
	"unicode"
)

type Command struct {
	Namespace string            `json:"namespace"`
	Action    string            `json:"action"`
	Args      map[string]string `json:"args"`
	Raw       string            `json:"raw"`
}

func Parse(input string) Command {
	raw := strings.TrimSpace(input)

	if raw == "" {
		return Command{
			Namespace: "system",
			Action:    "noop",
			Args:      map[string]string{},
			Raw:       raw,
		}
	}

	if command, ok := parseUppercase(raw); ok {
		return command
	}

	parts := strings.Fields(raw)
	head := parts[0]

	namespace := "system"
	action := head
	rest := parts[1:]

	if strings.HasPrefix(head, "#") {
		namespace = strings.TrimPrefix(head, "#")
		if len(parts) > 1 {
			action = parts[1]
		} else {
			action = "run"
		}
		if len(parts) > 2 {
			rest = parts[2:]
		} else {
			rest = []string{}
		}
	}

	args := map[string]string{}
	positional := make([]string, 0, len(rest))

	for _, item := range rest {
		if strings.Contains(item, ":") && !strings.HasPrefix(item, "\"") {
			key, value, ok := strings.Cut(item, ":")
			if ok {
				args[key] = strings.Trim(value, "\"")
				continue
			}
		}

		positional = append(positional, strings.Trim(item, "\""))
	}

	if len(positional) > 0 {
		args["items"] = strings.Join(positional, " ")
	}

	return Command{
		Namespace: namespace,
		Action:    action,
		Args:      args,
		Raw:       raw,
	}
}

func parseUppercase(raw string) (Command, bool) {
	parts := strings.Fields(raw)
	if len(parts) == 0 {
		return Command{}, false
	}

	head := parts[0]
	if !isUpperToken(head) {
		return Command{}, false
	}

	args := map[string]string{}
	switch head {
	case "SET":
		if len(parts) > 1 {
			args["target"] = parts[1]
		}
		if len(parts) > 2 {
			args["value"] = strings.Join(parts[2:], " ")
		}
		return Command{Namespace: "state", Action: "set", Args: args, Raw: raw}, true
	case "STATUS":
		if len(parts) > 1 {
			args["target"] = strings.Join(parts[1:], " ")
		}
		return Command{Namespace: "status", Action: "show", Args: args, Raw: raw}, true
	case "WORKFLOW":
		action := "status"
		if len(parts) > 1 {
			action = strings.ToLower(parts[1])
		}
		if len(parts) > 2 {
			args["target"] = strings.Join(parts[2:], " ")
		}
		return Command{Namespace: "workflow", Action: action, Args: args, Raw: raw}, true
	case "DRAW":
		if len(parts) > 1 {
			args["mode"] = strings.ToLower(parts[1])
		}
		if len(parts) > 2 && strings.EqualFold(parts[1], "PAT") {
			args["pattern_type"] = strings.ToLower(parts[2])
			if len(parts) > 3 {
				args["value"] = strings.Join(parts[3:], " ")
			}
		} else if len(parts) > 2 {
			args["target"] = strings.Join(parts[2:], " ")
		}
		return Command{Namespace: "draw", Action: "render", Args: args, Raw: raw}, true
	case "SCRIPT":
		action := "run"
		if len(parts) > 1 {
			action = strings.ToLower(parts[1])
		}
		if len(parts) > 2 {
			args["path"] = strings.Join(parts[2:], " ")
		}
		return Command{Namespace: "script", Action: action, Args: args, Raw: raw}, true
	case "RUN":
		if len(parts) > 1 {
			args["path"] = strings.Join(parts[1:], " ")
		}
		return Command{Namespace: "script", Action: "run", Args: args, Raw: raw}, true
	default:
		return Command{}, false
	}
}

func isUpperToken(input string) bool {
	hasLetter := false
	for _, r := range input {
		if unicode.IsLetter(r) {
			hasLetter = true
			if !unicode.IsUpper(r) {
				return false
			}
		}
	}
	return hasLetter
}
