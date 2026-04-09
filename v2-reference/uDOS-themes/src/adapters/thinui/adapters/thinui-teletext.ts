import type {
  ThinUiRenderFrame,
  ThinUiRenderTokens,
  ThinUiStatePacket,
  ThinUiThemeAdapter,
  ThinUiThemeDefinition,
} from "../contracts/types";
import { systemMonoFont } from "../fonts/system-mono";
import { teletextCastLoader } from "../loaders/teletext-cast";

export const thinUiTeletextTheme: ThinUiThemeDefinition = {
  id: "thinui-teletext",
  label: "ThinUI Teletext",
  family: "teletext",
  description: "Teletext-style status and block-graphic display surface for ThinUI.",
  defaultFontId: "system-mono",
  defaultLoaderId: "teletext-cast",
  lowResourceSafe: true,
  tokens: {
    palette: {
      background: "#111111",
      foreground: "#f2f2f2",
      accent: "#00d0ff",
      border: "#f2f2f2",
      warning: "#f7d354",
      danger: "#ff5f87",
      success: "#6be675",
    },
    classes: {
      app: "theme-teletext thinui-app",
      panel: "thinui-panel thinui-panel-teletext",
      title: "thinui-title thinui-title-teletext",
      subtitle: "thinui-subtitle thinui-subtitle-teletext",
      actionPrimary: "btn-teletext-primary",
      actionSecondary: "btn-teletext-secondary",
      actionDanger: "btn-teletext-danger",
    },
  },
};

function loaderFrameForProgress(state: ThinUiStatePacket): string {
  if (!teletextCastLoader.frames.length) {
    return "";
  }

  const current = Math.max((state.progress?.current ?? 1) - 1, 0);
  return teletextCastLoader.frames[current % teletextCastLoader.frames.length]?.text ?? teletextCastLoader.frames[0].text;
}

export class ThinUiTeletextThemeAdapter implements ThinUiThemeAdapter {
  id = thinUiTeletextTheme.id;
  label = thinUiTeletextTheme.label;

  getName(): string {
    return this.id;
  }

  getLoader() {
    return teletextCastLoader;
  }

  getFont() {
    return systemMonoFont;
  }

  getRenderTokens(_mode: ThinUiStatePacket["mode"]): ThinUiRenderTokens {
    return thinUiTeletextTheme.tokens;
  }

  getTokens(mode: ThinUiStatePacket["mode"]): ThinUiRenderTokens {
    return this.getRenderTokens(mode);
  }

  renderState(state: ThinUiStatePacket, baseFrame: ThinUiRenderFrame): ThinUiRenderFrame {
    const lines = [
      "P100  uDOS TELETEXT",
      "===================",
      ...baseFrame.lines,
      "",
      `CAST ${loaderFrameForProgress(state)}`,
      "KEYS RED/GRN/YEL/BLU = actions",
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

export const thinUiTeletextAdapter = new ThinUiTeletextThemeAdapter();
