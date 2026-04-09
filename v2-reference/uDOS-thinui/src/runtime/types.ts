import type { ThinUiEvent } from "../contracts/event";
import type { ThinUiStatePacket } from "../contracts/state";

export type ThinUiLoaderFrame = {
  text: string;
  durationMs: number;
};

export type ThinUiThemeLoader = {
  id: string;
  label: string;
  loop: boolean;
  frames: ThinUiLoaderFrame[];
};

export type ThinUiThemeFont = {
  id: string;
  label: string;
  family: string;
  source: "bundled" | "system" | "optional";
  fallbackFamily: string;
  monospace: boolean;
};

export type ThinUiRenderTokens = {
  palette: {
    background: string;
    foreground: string;
    accent: string;
    border: string;
    warning: string;
    danger: string;
    success: string;
  };
  classes: {
    app: string;
    panel: string;
    title: string;
    subtitle: string;
    actionPrimary: string;
    actionSecondary: string;
    actionDanger: string;
  };
};

export type ThinUiRenderFrame = {
  view: string;
  mode: ThinUiStatePacket["mode"];
  themeId: string;
  loaderId?: string;
  title?: string;
  subtitle?: string;
  status?: ThinUiStatePacket["status"];
  themeLabel?: string;
  fontFamily?: string;
  loaderLabel?: string;
  renderTokens?: ThinUiRenderTokens;
  lines: string[];
};

export interface ThinUiThemeAdapter {
  id: string;
  label: string;
  getName(): string;
  getLoader(): ThinUiThemeLoader;
  getFont(): ThinUiThemeFont;
  getTokens(mode: ThinUiStatePacket["mode"]): ThinUiRenderTokens;
  getRenderTokens(mode: ThinUiStatePacket["mode"]): ThinUiRenderTokens;
  renderState(state: ThinUiStatePacket, baseFrame: ThinUiRenderFrame): ThinUiRenderFrame;
}

export interface ThinUiThemeResolver {
  resolveThinUiTheme(themeId: string, mode: ThinUiStatePacket["mode"]): ThinUiThemeAdapter;
}

export interface ThinUiCoreBridge {
  getState(): ThinUiStatePacket;
  dispatchEvent(event: ThinUiEvent): ThinUiStatePacket;
}

export interface ThinUiView {
  id: string;
  render(state: ThinUiStatePacket): ThinUiRenderFrame;
}
