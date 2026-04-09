import type { ThinUiStatePacket } from "../contracts/state";
import type { ThinUiRenderFrame, ThinUiView } from "../runtime/types";

export function createSyncStatusView(): ThinUiView {
  return {
    id: "sync-status",
    render(state: ThinUiStatePacket): ThinUiRenderFrame {
      const offline = state.diagnostics?.offline ?? false;
      const low = state.diagnostics?.lowResource ?? false;

      const lines = [
        "  SYNC & CONNECTIVITY",
        "  " + "─".repeat(36),
        `  Mesh link:     ${offline ? "OFFLINE (local)" : "ONLINE"}`,
        `  Resource mode: ${low ? "LOW (reduced FX)" : "NORMAL"}`,
        `  Last pull:     ${offline ? "—" : "2m ago"}`,
        `  Queue depth:   ${offline ? "0 (paused)" : "3 tasks"}`,
        "",
        "  Spool: idle   Feeds: stub OK   Wizard: reachable",
      ];

      return {
        view: "sync-status",
        mode: state.mode,
        themeId: state.themeId,
        title: state.title ?? "Sync status",
        subtitle: state.subtitle ?? "Operator readout",
        status: state.status ?? "idle",
        lines,
      };
    },
  };
}
