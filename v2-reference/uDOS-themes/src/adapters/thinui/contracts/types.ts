export type ThinUiMode = "windowed" | "fullscreen" | "recovery";
export type ThinUiStatus = "idle" | "running" | "warning" | "error" | "complete";

export type ThinUiAction = {
  id: string;
  label: string;
  kind?: "primary" | "secondary" | "danger" | "nav";
  disabled?: boolean;
};

export type ThinUiPanelItem = {
  id: string;
  label: string;
  value?: string;
};

export type ThinUiPanel = {
  id: string;
  kind: string;
  title?: string;
  body?: string;
  items?: ThinUiPanelItem[];
};

export type ThinUiStatePacket = {
  view: string;
  mode: ThinUiMode;
  themeId: string;
  loaderId?: string;
  title?: string;
  subtitle?: string;
  status?: ThinUiStatus;
  progress?: {
    current?: number;
    total?: number;
    label?: string;
  };
  actions: ThinUiAction[];
  panels?: ThinUiPanel[];
  diagnostics?: {
    safeMode?: boolean;
    offline?: boolean;
    lowResource?: boolean;
  };
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
  mode: ThinUiMode;
  themeId: string;
  loaderId?: string;
  title?: string;
  subtitle?: string;
  status?: ThinUiStatus;
  themeLabel?: string;
  fontFamily?: string;
  loaderLabel?: string;
  renderTokens?: ThinUiRenderTokens;
  lines: string[];
};

export type ThinUiLoaderFrame = {
  text: string;
  durationMs: number;
};

export type ThinUiLoaderDefinition = {
  id: string;
  label: string;
  loop: boolean;
  frames: ThinUiLoaderFrame[];
};

export type ThinUiFontDefinition = {
  id: string;
  label: string;
  family: string;
  source: "bundled" | "system" | "optional";
  fallbackFamily: string;
  monospace: boolean;
};

export type ThinUiThemeDefinition = {
  id: string;
  label: string;
  family: "c64" | "nes" | "teletext" | "safe" | "custom";
  description: string;
  defaultFontId: string;
  defaultLoaderId: string;
  lowResourceSafe: boolean;
  tokens: ThinUiRenderTokens;
};

export interface ThinUiThemeAdapter {
  id: string;
  label: string;
  getName(): string;
  getLoader(): ThinUiLoaderDefinition;
  getFont(): ThinUiFontDefinition;
  getTokens(mode: ThinUiMode): ThinUiRenderTokens;
  getRenderTokens(mode: ThinUiMode): ThinUiRenderTokens;
  renderState(state: ThinUiStatePacket, baseFrame: ThinUiRenderFrame): ThinUiRenderFrame;
}
