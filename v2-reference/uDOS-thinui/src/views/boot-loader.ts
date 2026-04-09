import type { ThinUiStatePacket } from "../contracts/state";
import type { ThinUiRenderFrame, ThinUiView } from "../runtime/types";

function progressLine(state: ThinUiStatePacket): string {
  if (!state.progress?.label) {
    return "";
  }

  const current = state.progress.current ?? 0;
  const total = state.progress.total ?? 0;
  if (!total) {
    return state.progress.label;
  }

  return `${state.progress.label} (${current}/${total})`;
}

export function createBootLoaderView(): ThinUiView {
  return {
    id: "boot-loader",
    render(state: ThinUiStatePacket): ThinUiRenderFrame {
      const header = state.title ?? "uDOS ThinUI";
      const subtitle = state.subtitle ?? "Booting local runtime lane";
      const status = state.status ?? "idle";

      const lines = [
        "========================================",
        ` ${header}`,
        "========================================",
        subtitle,
        `mode: ${state.mode}`,
        `theme: ${state.themeId}`,
        `status: ${status}`,
      ];

      const progress = progressLine(state);
      if (progress) {
        lines.push(progress);
      }

      if (state.actions.length) {
        lines.push("actions:");
        for (const action of state.actions) {
          const disabled = action.disabled ? " [disabled]" : "";
          lines.push(`- ${action.label}${disabled}`);
        }
      }

      return {
        view: "boot-loader",
        mode: state.mode,
        themeId: state.themeId,
        loaderId: state.loaderId,
        title: header,
        subtitle,
        status,
        lines,
      };
    },
  };
}
