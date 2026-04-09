import type { ThinUiStatePacket } from "../contracts/state";
import type { ThinUiRenderFrame, ThinUiView } from "../runtime/types";

export function createHomeLauncherView(): ThinUiView {
  return {
    id: "home-launcher",
    render(state: ThinUiStatePacket): ThinUiRenderFrame {
      const title = state.title ?? "uDOS ThinUI";
      const subtitle = state.subtitle ?? "Local takeover GUI — pick a lane";

      const lines = [
        "╔════════════════════════════════════════╗",
        "║           HOME LAUNCHER                ║",
        "╠════════════════════════════════════════╣",
        `║  ${title.slice(0, 34).padEnd(34)}  ║`,
        `║  ${subtitle.slice(0, 34).padEnd(34)}  ║`,
        "╠════════════════════════════════════════╣",
        "║  [1] Binder vault & session pick       ║",
        "║  [2] Operation progress                ║",
        "║  [3] Sync & connectivity status        ║",
        "║  [4] Recovery / safe mode              ║",
        "║  [5] Hand off to browser (Wizard)      ║",
        "║  [6] Sonic utility panel               ║",
        "║  [7] Teletext service display          ║",
        "╚════════════════════════════════════════╝",
      ];

      return {
        view: "home-launcher",
        mode: state.mode,
        themeId: state.themeId,
        title,
        subtitle,
        status: state.status ?? "idle",
        lines,
      };
    },
  };
}
