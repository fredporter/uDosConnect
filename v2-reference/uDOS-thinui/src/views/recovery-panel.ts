import type { ThinUiStatePacket } from "../contracts/state";
import type { ThinUiRenderFrame, ThinUiView } from "../runtime/types";

export function createRecoveryPanelView(): ThinUiView {
  return {
    id: "recovery-panel",
    render(state: ThinUiStatePacket): ThinUiRenderFrame {
      const safe = state.diagnostics?.safeMode ?? true;

      const lines = [
        " !!!!!  RECOVERY / SAFE MODE  !!!!! ",
        "",
        "  Core semantics are authoritative.",
        "  ThinUI is display-only in this lane.",
        "",
        `  Safe mode flag: ${safe ? "ON" : "OFF"}`,
        "  Actions are limited to refresh and back.",
        "",
        "  ┌──────────────────────────────────┐",
        "  │ If problems persist: TUI shell   │",
        "  │ and host logs remain canonical.  │",
        "  └──────────────────────────────────┘",
      ];

      return {
        view: "recovery-panel",
        mode: state.mode,
        themeId: state.themeId,
        title: state.title ?? "Recovery",
        subtitle: state.subtitle ?? "Degraded graphical surface",
        status: state.status ?? "warning",
        lines,
      };
    },
  };
}
