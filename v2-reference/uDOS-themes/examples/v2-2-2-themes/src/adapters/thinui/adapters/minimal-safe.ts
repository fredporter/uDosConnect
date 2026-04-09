import type { ThinUiThemeDefinition } from "../contracts/types";

export const minimalSafeTheme: ThinUiThemeDefinition = {
  id: "minimal-safe",
  label: "Minimal Safe",
  family: "safe",
  surface: "thinui",
  description: "Fallback theme for degraded devices, recovery mode, and missing packs.",
  defaultFontId: "system-mono",
  defaultLoaderId: "minimal-safe",
  palettes: {
    normal: {
      background: "#000000",
      foreground: "#ffffff",
      accent: "#ffffff",
      accentMuted: "#cccccc",
      border: "#ffffff",
      danger: "#ff6666",
      warning: "#ffcc66",
      success: "#66ff99",
    },
  },
  panel: {
    borderStyle: "ascii",
    radius: "none",
    shadow: false,
    padding: "tight",
  },
  cssClasses: {
    app: "theme-safe thinui-app",
    panel: "thinui-panel thinui-panel-safe",
    title: "thinui-title",
    subtitle: "thinui-subtitle",
    status: {
      idle: "status-idle",
      running: "status-running",
      warning: "status-warning",
      error: "status-error",
      complete: "status-complete",
    },
    actionPrimary: "btn-safe-primary",
    actionSecondary: "btn-safe-secondary",
    actionDanger: "btn-safe-danger",
  },
  capabilities: {
    animation: false,
    gamepadHints: false,
    lowResourceSafe: true,
    fullscreenRecommended: false,
  },
};
