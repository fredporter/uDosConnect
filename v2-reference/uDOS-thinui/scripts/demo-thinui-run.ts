#!/usr/bin/env npx tsx
/**
 * ThinUI runtime demo — uses the real TypeScript loop (views + theme resolver + mock core).
 *
 *   npm run demo -- --theme thinui-c64
 *   npm run demo -- --profile ubuntu-gnome
 *   npm run demo -- --surface-profile-file ../uDOS-surface/profiles/ubuntu-gnome/surface.json
 *   npm run demo -- --theme thinui-nes-sonic --view boot-loader
 *   npm run demo:tour
 */

import { readFileSync } from "node:fs";

import type { ThinUiEvent } from "../src/contracts/event";
import type { ThinUiStatePacket } from "../src/contracts/state";
import { createThinUiRuntime } from "../src/runtime/bootstrap";
import {
  parseSurfaceProfileThinUiV01FromJson,
  resolveBuiltinSurfaceProfile,
  type SurfaceProfileThinUiV01,
} from "../src/surface/surface-profile";

function parseArgs(): Map<string, string> {
  const args = new Map<string, string>();
  const argv = process.argv.slice(2);
  for (let i = 0; i < argv.length; i += 1) {
    const item = argv[i];
    if (!item.startsWith("--")) {
      continue;
    }
    const key = item.slice(2);
    const next = argv[i + 1];
    const value = next && !next.startsWith("--") ? (argv[++i] as string) : "true";
    args.set(key, value);
  }
  return args;
}

function defaultTitle(themeId: string): string {
  if (themeId === "thinui-nes-sonic") {
    return "uDOS Sonic Utility";
  }
  if (themeId === "thinui-teletext") {
    return "uDOS Teletext";
  }
  if (themeId === "udos-default") {
    return "uDOS ThinUI";
  }
  return "uDOS ThinUI";
}

function defaultSubtitle(themeId: string): string {
  if (themeId === "thinui-nes-sonic") {
    return "NES-style launcher panel";
  }
  if (themeId === "thinui-teletext") {
    return "Block graphic service display";
  }
  if (themeId === "udos-default") {
    return "ubuntu-gnome surface · Classic Modern";
  }
  return "C64-style startup handoff";
}

function printBanner(label: string): void {
  process.stdout.write(`\n── ${label} ──\n`);
}

type SurfaceRuntimeOpts = {
  surfaceProfileId?: string;
  surfaceProfileData?: SurfaceProfileThinUiV01;
};

function runTour(themeId: string, surfaceOpts: SurfaceRuntimeOpts): void {
  const steps: ThinUiEvent[] = [
    { type: "action", targetId: "continue" },
    { type: "action", targetId: "open-binder" },
    { type: "navigate", targetId: "back" },
    { type: "action", targetId: "open-progress" },
    { type: "action", targetId: "tick-progress" },
    { type: "action", targetId: "tick-progress" },
    { type: "navigate", targetId: "back" },
    { type: "action", targetId: "open-handoff" },
    { type: "launch-browser" },
    { type: "navigate", targetId: "back" },
    { type: "action", targetId: "open-teletext" },
    { type: "navigate", targetId: "back" },
    { type: "navigate", targetId: "back" },
  ];

  const runtime = createThinUiRuntime({
    ...surfaceOpts,
    seedState: { themeId },
    renderFrame: (frame) => {
      process.stdout.write(`${frame.lines.join("\n")}\n`);
    },
  });

  printBanner("boot");
  runtime.start();
  for (const ev of steps) {
    printBanner(JSON.stringify(ev));
    runtime.handleEvent(ev);
  }
}

function loadSurfaceProfileFile(path: string): SurfaceProfileThinUiV01 {
  const raw = readFileSync(path, "utf-8");
  return parseSurfaceProfileThinUiV01FromJson(JSON.parse(raw));
}

function main(): void {
  const args = parseArgs();
  const profileId = args.get("profile");
  const surfaceProfileId =
    profileId === "ubuntu-gnome" || profileId === "ubuntu_gnome" ? "ubuntu-gnome" : undefined;
  const spFile = args.get("surface-profile-file");
  let surfaceProfileData: SurfaceProfileThinUiV01 | undefined;
  if (spFile) {
    surfaceProfileData = loadSurfaceProfileFile(spFile);
  }
  const profileBuiltin = surfaceProfileId ? resolveBuiltinSurfaceProfile(surfaceProfileId) : undefined;
  const themeFromProfile = surfaceProfileData?.thinui.theme ?? profileBuiltin?.thinui.theme;
  const themeId = args.get("theme") ?? themeFromProfile ?? "thinui-c64";
  const view =
    args.get("view") ??
    (themeId === "thinui-teletext" ? "teletext-display" : "boot-loader");
  const title = args.get("title") ?? defaultTitle(themeId);
  const subtitle = args.get("subtitle") ?? defaultSubtitle(themeId);

  const surfaceOpts: SurfaceRuntimeOpts = {
    surfaceProfileId: surfaceProfileData ? undefined : surfaceProfileId,
    surfaceProfileData,
  };

  if (args.has("tour")) {
    runTour(themeId, surfaceOpts);
    return;
  }

  const seed: Partial<ThinUiStatePacket> = {
    view,
    themeId,
    title,
    subtitle,
    status: "running",
    progress: { current: 2, total: 3, label: "Demo frame ready" },
    actions: [
      { id: "continue", label: "Continue", kind: "primary" },
      { id: "refresh", label: "Refresh", kind: "secondary" },
      { id: "open-binder", label: "Jump: binders", kind: "nav" },
    ],
  };

  const runtime = createThinUiRuntime({
    ...surfaceOpts,
    seedState: seed,
    renderFrame: (frame) => {
      process.stdout.write(`${frame.lines.join("\n")}\n`);
    },
  });

  runtime.start();
}

main();
