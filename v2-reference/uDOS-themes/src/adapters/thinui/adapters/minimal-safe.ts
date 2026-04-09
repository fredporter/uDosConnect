import type {
  ThinUiRenderFrame,
  ThinUiRenderTokens,
  ThinUiStatePacket,
  ThinUiThemeAdapter,
  ThinUiThemeDefinition,
} from "../contracts/types";
import { systemMonoFont } from "../fonts/system-mono";
import { minimalSafeLoader } from "../loaders/minimal-safe";

export const minimalSafeTheme: ThinUiThemeDefinition = {
  id: "minimal-safe",
  label: "Minimal Safe",
  family: "safe",
  description: "Fallback theme for degraded devices and recovery mode.",
  defaultFontId: "system-mono",
  defaultLoaderId: "minimal-safe",
  lowResourceSafe: true,
  tokens: {
    palette: {
      background: "#000000",
      foreground: "#ffffff",
      accent: "#ffffff",
      border: "#ffffff",
      warning: "#ffcc66",
      danger: "#ff6666",
      success: "#66ff99",
    },
    classes: {
      app: "theme-safe thinui-app",
      panel: "thinui-panel thinui-panel-safe",
      title: "thinui-title",
      subtitle: "thinui-subtitle",
      actionPrimary: "btn-safe-primary",
      actionSecondary: "btn-safe-secondary",
      actionDanger: "btn-safe-danger",
    },
  },
};

export class MinimalSafeThemeAdapter implements ThinUiThemeAdapter {
  id = minimalSafeTheme.id;
  label = minimalSafeTheme.label;

  getName(): string {
    return this.id;
  }

  getLoader() {
    return minimalSafeLoader;
  }

  getFont() {
    return systemMonoFont;
  }

  getRenderTokens(_mode: ThinUiStatePacket["mode"]): ThinUiRenderTokens {
    return minimalSafeTheme.tokens;
  }

  getTokens(mode: ThinUiStatePacket["mode"]): ThinUiRenderTokens {
    return this.getRenderTokens(mode);
  }

  renderState(state: ThinUiStatePacket, baseFrame: ThinUiRenderFrame): ThinUiRenderFrame {
    return {
      ...baseFrame,
      themeLabel: this.label,
      fontFamily: this.getFont().family,
      loaderLabel: this.getLoader().label,
      renderTokens: this.getRenderTokens(state.mode),
    };
  }
}

export const minimalSafeAdapter = new MinimalSafeThemeAdapter();
