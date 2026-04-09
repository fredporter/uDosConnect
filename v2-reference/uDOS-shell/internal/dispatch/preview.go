package dispatch

import (
	"github.com/fredporter/uDOS-shell/internal/contracts"
	"github.com/fredporter/uDOS-shell/internal/ucode"
)

type Preview struct {
	Shell                string            `json:"shell"`
	Version              string            `json:"version"`
	FoundationVersion    string            `json:"foundationVersion"`
	Command              string            `json:"command"`
	Args                 map[string]string `json:"args"`
	Route                string            `json:"route"`
	Owner                string            `json:"owner"`
	Lane                 string            `json:"lane"`
	Adapter              string            `json:"adapter"`
	RuntimeService       string            `json:"runtimeService"`
	RuntimeServiceSource string            `json:"runtimeServiceSource"`
	RuntimeServiceRoute  string            `json:"runtimeServiceRoute"`
	SourceVersion        string            `json:"sourceVersion"`
	Note                 string            `json:"note"`
}

type route struct {
	Route          string
	Owner          string
	Lane           string
	Adapter        string
	RuntimeService string
}

func RenderPreview(command ucode.Command) (Preview, error) {
	manifest, sourcePath, err := contracts.LoadRuntimeServiceManifest()
	if err != nil {
		return Preview{}, err
	}

	selectedRoute := inferRoute(command)
	serviceRoute := "unknown"
	for _, service := range manifest.Services {
		if service.Key == selectedRoute.RuntimeService {
			serviceRoute = service.Route
			break
		}
	}

	return Preview{
		Shell:                "uDOS-shell",
		Version:              manifest.Version,
		FoundationVersion:    manifest.Extends,
		Command:              command.Namespace + "." + command.Action,
		Args:                 command.Args,
		Route:                selectedRoute.Route,
		Owner:                selectedRoute.Owner,
		Lane:                 selectedRoute.Lane,
		Adapter:              selectedRoute.Adapter,
		RuntimeService:       selectedRoute.RuntimeService,
		RuntimeServiceSource: sourcePath,
		RuntimeServiceRoute:  serviceRoute,
		SourceVersion:        manifest.Version,
		Note:                 "starter preview only",
	}, nil
}

func wizardOrchestrationRoute() route {
	return route{
		Route:          "uDOS-wizard",
		Owner:          "uDOS-wizard",
		Lane:           "orchestration",
		Adapter:        "wizard-service",
		RuntimeService: "runtime.capability-registry",
	}
}

func inferRoute(command ucode.Command) route {
	// Shell `mcp …` commands hit Wizard MCP / JSON-RPC surfaces.
	if command.Namespace == "system" && command.Action == "mcp" {
		return wizardOrchestrationRoute()
	}

	switch command.Namespace {
	case "wizard", "beacon":
		return wizardOrchestrationRoute()
	// OK routing is served by Wizard (`/ok/route`, provider registry).
	case "ok":
		return wizardOrchestrationRoute()
	case "home":
		return route{
			Route:          "uHOME-server",
			Owner:          "uHOME-server",
			Lane:           "service",
			Adapter:        "uhome-runtime",
			RuntimeService: "runtime.command-registry",
		}
	case "empire":
		return route{
			Route:          "uDOS-empire",
			Owner:          "uDOS-empire",
			Lane:           "sync",
			Adapter:        "empire-service",
			RuntimeService: "runtime.capability-registry",
		}
	case "theme":
		return route{
			Route:          "uDOS-themes",
			Owner:          "uDOS-themes",
			Lane:           "presentation",
			Adapter:        "theme-bridge",
			RuntimeService: "runtime.command-registry",
		}
	default:
		return route{
			Route:          "uDOS-core",
			Owner:          "uDOS-core",
			Lane:           "develop",
			Adapter:        "core-runtime",
			RuntimeService: "runtime.command-registry",
		}
	}
}
