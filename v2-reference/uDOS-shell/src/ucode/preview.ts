import type { ParsedCommand } from "./types.js";
import fs from "node:fs";
import path from "node:path";

type RuntimeService = {
  key: string;
  owner: string;
  route: string;
  stability: string;
  consumers: string[];
  notes: string;
};

type RuntimeServiceManifest = {
  version: string;
  extends: string;
  count: number;
  services: RuntimeService[];
};

export function renderCommandPreview(command: ParsedCommand) {
  const runtimeManifest = loadRuntimeServiceManifest();
  const route = inferRoute(command);
  const service = runtimeManifest.services.find((item) => item.key === route.runtimeService);

  return {
    shell: "uDOS-shell",
    version: runtimeManifest.version,
    foundationVersion: runtimeManifest.extends,
    command: `${command.namespace}.${command.action}`,
    args: command.args,
    route: route.route,
    owner: route.owner,
    lane: route.lane,
    adapter: route.adapter,
    runtimeService: route.runtimeService,
    runtimeServiceSource: runtimeServiceSourcePath(),
    runtimeServiceRoute: service?.route ?? "unknown",
    sourceVersion: runtimeManifest.version,
    note: "starter preview only"
  };
}

function loadRuntimeServiceManifest(): RuntimeServiceManifest {
  return JSON.parse(fs.readFileSync(runtimeServiceSourcePath(), "utf8")) as RuntimeServiceManifest;
}

function runtimeServiceSourcePath(): string {
  return path.resolve(process.cwd(), "..", "uDOS-core", "contracts", "runtime-services.json");
}

function wizardOrchestrationRoute() {
  return {
    route: "uDOS-wizard",
    owner: "uDOS-wizard",
    lane: "orchestration",
    adapter: "wizard-service",
    runtimeService: "runtime.capability-registry"
  };
}

function inferRoute(command: ParsedCommand): {
  route: string;
  owner: string;
  lane: string;
  adapter: string;
  runtimeService: string;
} {
  if (command.namespace === "system" && command.action === "mcp") {
    return wizardOrchestrationRoute();
  }

  if (command.namespace === "wizard" || command.namespace === "beacon") {
    return wizardOrchestrationRoute();
  }

  if (command.namespace === "ok") {
    return wizardOrchestrationRoute();
  }

  if (command.namespace === "home") {
    return {
      route: "uHOME-server",
      owner: "uHOME-server",
      lane: "service",
      adapter: "uhome-runtime",
      runtimeService: "runtime.command-registry"
    };
  }

  if (command.namespace === "empire") {
    return {
      route: "uDOS-empire",
      owner: "uDOS-empire",
      lane: "sync",
      adapter: "empire-service",
      runtimeService: "runtime.capability-registry"
    };
  }

  if (command.namespace === "theme") {
    return {
      route: "uDOS-themes",
      owner: "uDOS-themes",
      lane: "presentation",
      adapter: "theme-bridge",
      runtimeService: "runtime.command-registry"
    };
  }

  return {
    route: "uDOS-core",
    owner: "uDOS-core",
    lane: "develop",
    adapter: "core-runtime",
    runtimeService: "runtime.command-registry"
  };
}
