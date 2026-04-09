#!/usr/bin/env node

const args = new Map();
for (let index = 2; index < process.argv.length; index += 1) {
  const item = process.argv[index];
  if (!item.startsWith("--")) {
    continue;
  }
  const key = item.slice(2);
  const value = process.argv[index + 1] && !process.argv[index + 1].startsWith("--")
    ? process.argv[++index]
    : "true";
  args.set(key, value);
}

const themeId = args.get("theme") || "thinui-c64";
const view = args.get("view") || (themeId === "thinui-teletext" ? "teletext-display" : "boot-loader");
const title = args.get("title") || defaultTitle(themeId);
const subtitle = args.get("subtitle") || defaultSubtitle(themeId);

const state = {
  view,
  themeId,
  title,
  subtitle,
  status: "running",
  progress: { current: 2, total: 3, label: "Demo frame ready" },
  actions: ["continue", "refresh", themeId === "thinui-teletext" ? "page-101" : "launch"],
};

const frame = renderTheme(state);
process.stdout.write(`${frame.join("\n")}\n`);

function defaultTitle(currentThemeId) {
  if (currentThemeId === "thinui-nes-sonic") {
    return "uDOS Sonic Utility";
  }
  if (currentThemeId === "thinui-teletext") {
    return "uDOS Teletext";
  }
  return "uDOS ThinUI";
}

function defaultSubtitle(currentThemeId) {
  if (currentThemeId === "thinui-nes-sonic") {
    return "NES-style launcher panel";
  }
  if (currentThemeId === "thinui-teletext") {
    return "Block graphic service display";
  }
  return "C64-style startup handoff";
}

function baseBootLines(statePacket) {
  return [
    "========================================",
    ` ${statePacket.title}`,
    "========================================",
    statePacket.subtitle,
    `theme: ${statePacket.themeId}`,
    `status: ${statePacket.status}`,
    `${statePacket.progress.label} (${statePacket.progress.current}/${statePacket.progress.total})`,
    "actions:",
    ...statePacket.actions.map((action) => `- ${action}`),
  ];
}

function teletextLines() {
  return [
    "╔══════════════════════════════════════╗",
    "║ UDOS TELETEXT 100  LOCAL SERVICE    ║",
    "╠══════════════════════════════════════╣",
    "║ 101 STARTUP SUMMARY     READY       ║",
    "║ 102 SHELL QUICKSTART    ONLINE      ║",
    "║ 103 WIZARD MCP STATUS   LOCAL       ║",
    "║ 104 SONIC NES PANEL     READY       ║",
    "║ 105 ALPINE C64 PANEL    READY       ║",
    "╠══════════════════════════════════════╣",
    "║ ███▀▀▀███  ██▀▀██  ███  ███  ▄▄▄     ║",
    "║ █  ▄▄  █  ██  ██  █ █  █ █  █▄█     ║",
    "║ ███▄▄▄██  ▀███▀  ███  ███  ▀▀▀     ║",
    "╚══════════════════════════════════════╝",
  ];
}

function renderTheme(statePacket) {
  const baseLines = statePacket.view === "teletext-display" ? teletextLines() : baseBootLines(statePacket);
  if (statePacket.themeId === "thinui-nes-sonic") {
    return [
      "+======================================+",
      "|   UDOS SONIC THINUI :: NES UTILITY   |",
      "+======================================+",
      ...baseLines.map((line) => `| ${line.padEnd(36)} |`),
      "+--------------------------------------+",
      "  pulse: [■■■] BOOTING SONIC UTILITY",
      "  pad: A=launch  B=back  START=menu",
    ];
  }
  if (statePacket.themeId === "thinui-teletext") {
    return [
      "P100 NEWSDESK (terminal preview)",
      "101 HEADLINE  102 WX  103 SPORT",
      "---------------------------------",
      ...baseLines,
      "",
      "CAST P102 DISPLAY ONLINE",
      "KEYS RED/GRN/YEL/BLU = actions",
    ];
  }
  return [
    "****************************************",
    "*      UDOS THINUI C64 RENDER PASS     *",
    "****************************************",
    ...baseLines.map((line) => `  ${line}`),
    "",
    "loader: READY.",
    "font: C64 User Mono (browser demo loads woff)",
  ];
}
