import type {
  ThinUiRenderFrame,
  ThinUiRenderTokens,
  ThinUiStatePacket,
  ThinUiThemeAdapter,
  ThinUiThemeDefinition,
} from "../contracts/types";
import { petmeFont } from "../fonts/petme";
import { c64BootLoader } from "../loaders/c64-boot";

export const thinUiC64Theme: ThinUiThemeDefinition = {
  id: "thinui-c64",
  label: "ThinUI C64",
  family: "c64",
  description: "Commodore-inspired thinui skin for low-resource startup panels.",
  defaultFontId: "petme-default",
  defaultLoaderId: "c64-boot-seq",
  lowResourceSafe: true,
  tokens: {
    palette: {
      background: "#40318d",
      foreground: "#a7a7ff",
      accent: "#8cf0ff",
      border: "#a7a7ff",
      warning: "#ffd37a",
      danger: "#ff8ca1",
      success: "#90ff90",
    },
    classes: {
      app: "theme-c64 thinui-app",
      panel: "thinui-panel thinui-panel-c64",
      title: "thinui-title thinui-title-c64",
      subtitle: "thinui-subtitle thinui-subtitle-c64",
      actionPrimary: "btn-c64-primary",
      actionSecondary: "btn-c64-secondary",
      actionDanger: "btn-c64-danger",
    },
  },
};

function loaderFrameForProgress(state: ThinUiStatePacket): string {
  if (!c64BootLoader.frames.length) {
    return "";
  }

  const current = Math.max((state.progress?.current ?? 1) - 1, 0);
  return c64BootLoader.frames[current % c64BootLoader.frames.length]?.text ?? c64BootLoader.frames[0].text;
}

export class ThinUiC64ThemeAdapter implements ThinUiThemeAdapter {
  id = thinUiC64Theme.id;
  label = thinUiC64Theme.label;

  getName(): string {
    return this.id;
  }

  getLoader() {
    return c64BootLoader;
  }

  getFont() {
    return petmeFont;
  }

  getRenderTokens(mode: ThinUiStatePacket["mode"]): ThinUiRenderTokens {
    if (mode === "recovery") {
      return {
        ...thinUiC64Theme.tokens,
        palette: {
          ...thinUiC64Theme.tokens.palette,
          background: "#1a1a40",
          foreground: "#d8d8ff",
          border: "#d8d8ff",
        },
      };
    }

    return thinUiC64Theme.tokens;
  }

  getTokens(mode: ThinUiStatePacket["mode"]): ThinUiRenderTokens {
    return this.getRenderTokens(mode);
  }

  renderState(state: ThinUiStatePacket, baseFrame: ThinUiRenderFrame): ThinUiRenderFrame {
    const lines = [
      "****************************************",
      "*      UDOS THINUI C64 RENDER PASS     *",
      "****************************************",
      ...baseFrame.lines.map((line) => `  ${line}`),
      "",
      `loader: ${loaderFrameForProgress(state)}`,
      `font: ${this.getFont().family}`,
    ];

    return {
      ...baseFrame,
      lines,
      themeLabel: this.label,
      fontFamily: this.getFont().family,
      loaderLabel: this.getLoader().label,
      renderTokens: this.getRenderTokens(state.mode),
    };
  }
}

export const thinUiC64Adapter = new ThinUiC64ThemeAdapter();
