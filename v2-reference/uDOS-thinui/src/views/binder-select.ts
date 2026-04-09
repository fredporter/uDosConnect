import type { ThinUiStatePacket } from "../contracts/state";
import type { ThinUiRenderFrame, ThinUiView } from "../runtime/types";

export function createBinderSelectView(): ThinUiView {
  return {
    id: "binder-select",
    render(state: ThinUiStatePacket): ThinUiRenderFrame {
      const title = state.title ?? "Binder vault";
      const items =
        state.panels?.find((p) => p.id === "binders")?.items ??
        [
          { id: "binder-alpha", label: "Alpha (local dev)", value: "idle" },
          { id: "binder-beta", label: "Beta (staging)", value: "syncing" },
          { id: "binder-gamma", label: "Gamma (offline cache)", value: "offline" },
        ];

      const lines = [
        "┌────────────────────────────────────────┐",
        "│ BINDER SELECT                          │",
        "├────────────────────────────────────────┤",
        ...items.map((it) => {
          const row = ` ○ ${it.label}  [${it.value ?? "—"}]`;
          return `│${row.slice(0, 38).padEnd(38)}│`;
        }),
        "├────────────────────────────────────────┤",
        "│ Select a binder, or Back to home.      │",
        "└────────────────────────────────────────┘",
      ];

      return {
        view: "binder-select",
        mode: state.mode,
        themeId: state.themeId,
        title,
        subtitle: state.subtitle ?? "Choose vault context",
        status: state.status ?? "idle",
        lines,
      };
    },
  };
}
