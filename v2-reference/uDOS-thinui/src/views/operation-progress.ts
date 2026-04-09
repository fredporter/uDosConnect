import type { ThinUiStatePacket } from "../contracts/state";
import type { ThinUiRenderFrame, ThinUiView } from "../runtime/types";

function asciiBar(current: number, total: number, width = 28): string {
  if (total <= 0) {
    return "[" + "░".repeat(width) + "]";
  }
  const filled = Math.round((current / total) * width);
  const safe = Math.min(width, Math.max(0, filled));
  return "[" + "█".repeat(safe) + "░".repeat(width - safe) + "]";
}

export function createOperationProgressView(): ThinUiView {
  return {
    id: "operation-progress",
    render(state: ThinUiStatePacket): ThinUiRenderFrame {
      const current = state.progress?.current ?? 0;
      const total = state.progress?.total ?? 5;
      const label = state.progress?.label ?? "Running pipeline";

      const lines = [
        "  OPERATION PROGRESS",
        "  " + "─".repeat(36),
        `  ${label}`,
        "",
        `  ${asciiBar(current, total)}`,
        `  ${current} / ${total} steps`,
        "",
        "  Status: " + (state.status ?? "running"),
        "",
        "  Cancel returns when core allows (demo: use Back).",
      ];

      return {
        view: "operation-progress",
        mode: state.mode,
        themeId: state.themeId,
        title: state.title ?? "Operation",
        subtitle: state.subtitle ?? "Progress surface",
        status: state.status ?? "running",
        lines,
      };
    },
  };
}
