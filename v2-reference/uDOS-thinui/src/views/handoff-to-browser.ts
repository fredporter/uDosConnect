import type { ThinUiStatePacket } from "../contracts/state";
import type { ThinUiRenderFrame, ThinUiView } from "../runtime/types";

export function createHandoffToBrowserView(): ThinUiView {
  return {
    id: "handoff-to-browser",
    render(state: ThinUiStatePacket): ThinUiRenderFrame {
      const url =
        state.panels?.find((p) => p.id === "handoff")?.body ??
        "http://127.0.0.1:8787/app";

      const lines = [
        "  HANDOFF → BROWSER (WIZARD / SURFACE)",
        "  " + "─".repeat(36),
        "",
        "  ThinUI ends here; Wizard owns workflow UI.",
        "",
        `  Target:`,
        `  ${url}`,
        "",
        "  [ Launch browser ] uses host integration when wired.",
        "  (Demo: event type launch-browser)",
      ];

      return {
        view: "handoff-to-browser",
        mode: state.mode,
        themeId: state.themeId,
        title: state.title ?? "Browser handoff",
        subtitle: state.subtitle ?? "Leave ThinUI lane",
        status: state.status ?? "complete",
        lines,
      };
    },
  };
}
