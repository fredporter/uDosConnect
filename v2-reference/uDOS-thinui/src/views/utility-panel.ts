import type { ThinUiStatePacket } from "../contracts/state";
import type { ThinUiRenderFrame, ThinUiView } from "../runtime/types";

export function createUtilityPanelView(): ThinUiView {
  return {
    id: "utility-panel",
    render(state: ThinUiStatePacket): ThinUiRenderFrame {
      const lines = [
        "+======== SONIC UTILITY PANEL ========+",
        "| NES-style compact diagnostics       |",
        "+-------------------------------------+",
        "| * Peripheral check      [stub OK]   |",
        "| * Theme token probe     [stub OK]   |",
        "| * MCP registry peek     [via Wizard]|",
        "| * Grid place inspector  [optional]  |",
        "+-------------------------------------+",
        "| A: run probe   B: back   SEL: menu  |",
        "+=====================================+",
      ];

      return {
        view: "utility-panel",
        mode: state.mode,
        themeId: state.themeId,
        title: state.title ?? "Utilities",
        subtitle: state.subtitle ?? "Sonic screwdriver lane",
        status: state.status ?? "idle",
        lines,
      };
    },
  };
}
