import type {
  ThinUiRenderFrame,
  ThinUiRenderTokens,
  ThinUiStatePacket,
  ThinUiThemeAdapter,
  ThinUiThemeDefinition,
} from "../contracts/types";
import { systemMonoFont } from "../fonts/system-mono";
import { nesPulseLoader } from "../loaders/nes-pulse";

export const thinUiNesSonicTheme: ThinUiThemeDefinition = {
  id: "thinui-nes-sonic",
  label: "ThinUI NES Sonic",
  family: "nes",
  description: "NES-inspired utility skin for Sonic-hosted ThinUI launch surfaces.",
  defaultFontId: "system-mono",
  defaultLoaderId: "nes-pulse",
  lowResourceSafe: true,
  tokens: {
    palette: {
      background: "#1f1f1f",
      foreground: "#f8f8f8",
      accent: "#ff5f5f",
      border: "#8bac0f",
      warning: "#ffd166",
      danger: "#ef476f",
      success: "#06d6a0",
    },
    classes: {
      app: "theme-nes thinui-app",
      panel: "thinui-panel thinui-panel-nes",
      title: "thinui-title thinui-title-nes",
      subtitle: "thinui-subtitle thinui-subtitle-nes",
      actionPrimary: "btn-nes-primary",
      actionSecondary: "btn-nes-secondary",
      actionDanger: "btn-nes-danger",
    },
  },
};

function loaderFrameForProgress(state: ThinUiStatePacket): string {
  if (!nesPulseLoader.frames.length) {
    return "";
  }

  const current = Math.max((state.progress?.current ?? 1) - 1, 0);
  return nesPulseLoader.frames[current % nesPulseLoader.frames.length]?.text ?? nesPulseLoader.frames[0].text;
}

export class ThinUiNesSonicThemeAdapter implements ThinUiThemeAdapter {
  id = thinUiNesSonicTheme.id;
  label = thinUiNesSonicTheme.label;

  getName(): string {
    return this.id;
  }

  getLoader() {
    return nesPulseLoader;
  }

  getFont() {
    return systemMonoFont;
  }

  getRenderTokens(_mode: ThinUiStatePacket["mode"]): ThinUiRenderTokens {
    return thinUiNesSonicTheme.tokens;
  }

  getTokens(mode: ThinUiStatePacket["mode"]): ThinUiRenderTokens {
    return this.getRenderTokens(mode);
  }

  renderState(state: ThinUiStatePacket, baseFrame: ThinUiRenderFrame): ThinUiRenderFrame {
    const lines = [
      "+======================================+",
      "|   UDOS SONIC THINUI :: NES UTILITY   |",
      "+======================================+",
      ...baseFrame.lines.map((line) => `| ${line.padEnd(36)} |`),
      "+--------------------------------------+",
      `  pulse: ${loaderFrameForProgress(state)}`,
      "  pad: A=launch  B=back  START=menu",
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

export const thinUiNesSonicAdapter = new ThinUiNesSonicThemeAdapter();
