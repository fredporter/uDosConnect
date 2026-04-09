import type { ThinUiThemeDefinition } from "../contracts/types";

export const thinUiNesSonicTheme: ThinUiThemeDefinition = {
  id: "thinui-nes-sonic",
  label: "Thinui NES Sonic",
  family: "nes",
  surface: "thinui",
  description: "NES.css-inspired utility skin for sonic-screwdriver hosted graphical tools.",
  upstream: {
    name: "NES.css",
    repo: "https://github.com/nostalgic-css/NES.css",
    strategy: "fork",
  },
  defaultFontId: "system-mono",
  defaultLoaderId: "nes-pulse",
  palettes: {
    normal: {
      background: "#f7f7f7",
      foreground: "#202020",
      accent: "#209cee",
      accentMuted: "#7fc7ff",
      border: "#202020",
      danger: "#e76e55",
      warning: "#f7d51d",
      success: "#92cc41",
    },
  },
  panel: {
    borderStyle: "single",
    radius: "sm",
    shadow: true,
    padding: "normal",
  },
  cssClasses: {
    app: "theme-nes thinui-app",
    panel: "thinui-panel nes-container is-rounded",
    title: "thinui-title nes-text is-primary",
    subtitle: "thinui-subtitle nes-text",
    status: {
      idle: "nes-text",
      running: "nes-text is-primary",
      warning: "nes-text is-warning",
      error: "nes-text is-error",
      complete: "nes-text is-success",
    },
    actionPrimary: "nes-btn is-primary",
    actionSecondary: "nes-btn",
    actionDanger: "nes-btn is-error",
  },
  capabilities: {
    animation: true,
    gamepadHints: true,
    lowResourceSafe: true,
    fullscreenRecommended: false,
  },
};
