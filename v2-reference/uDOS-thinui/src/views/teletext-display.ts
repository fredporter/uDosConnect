import type { ThinUiStatePacket } from "../contracts/state";
import type { ThinUiRenderFrame, ThinUiView } from "../runtime/types";

function teletextDemoLines(): string[] {
  return [
    "╔══════════════════════════════════════╗",
    "║ UDOS TELETEXT 100  LOCAL SERVICE    ║",
    "╠══════════════════════════════════════╣",
    "║ 101 STARTUP SUMMARY     2026-03-21  ║",
    "║ 102 SHELL QUICKSTART    READY       ║",
    "║ 103 WIZARD MCP STATUS   LOCAL       ║",
    "║ 104 SONIC PANEL DEMO    NES         ║",
    "║ 105 ALPINE PANEL DEMO   C64         ║",
    "╠══════════════════════════════════════╣",
    "║ GRAPHIC BLOCK DEMO                    ║",
    "║ ███▀▀▀███  ██▀▀██  ███  ███  ▄▄▄     ║",
    "║ █  ▄▄  █  ██  ██  █ █  █ █  █▄█     ║",
    "║ ███▄▄▄██  ▀███▀  ███  ███  ▀▀▀     ║",
    "╚══════════════════════════════════════╝",
  ];
}

export function createTeletextDisplayView(): ThinUiView {
  return {
    id: "teletext-display",
    render(state: ThinUiStatePacket): ThinUiRenderFrame {
      const lines = teletextDemoLines();
      if (state.actions.length) {
        lines.push("");
        lines.push("Soft Keys:");
        for (const action of state.actions) {
          lines.push(`  ${action.id.toUpperCase()}  ${action.label}`);
        }
      }

      return {
        view: "teletext-display",
        mode: state.mode,
        themeId: state.themeId,
        loaderId: state.loaderId,
        title: state.title ?? "uDOS Teletext",
        subtitle: state.subtitle ?? "Block graphic demo set",
        status: state.status ?? "running",
        lines,
      };
    },
  };
}
