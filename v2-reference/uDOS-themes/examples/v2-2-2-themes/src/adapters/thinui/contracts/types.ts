export type ThinUiMode = "windowed" | "fullscreen" | "recovery";
export type ThinUiStatus = "idle" | "running" | "warning" | "error" | "complete";

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

export type ThinUiPalette = {
  background: string;
  foreground: string;
  accent: string;
  accentMuted: string;
  border: string;
  danger: string;
  warning: string;
  success: string;
};

export type ThinUiPanelStyle = {
  borderStyle: "single" | "double" | "ascii" | "none";
  radius: "none" | "sm" | "md";
  shadow: boolean;
  padding: "tight" | "normal" | "wide";
};

export type ThinUiThemeDefinition = {
  id: string;
  label: string;
  family: "c64" | "nes" | "safe" | "custom";
  surface: "thinui";
  description: string;
  upstream?: {
    name: string;
    repo: string;
    strategy: "fork" | "reference" | "ported";
  };
  defaultFontId: string;
  defaultLoaderId: string;
  palettes: {
    normal: ThinUiPalette;
    recovery?: ThinUiPalette;
  };
  panel: ThinUiPanelStyle;
  cssClasses: {
    app: string;
    panel: string;
    title: string;
    subtitle: string;
    status: Record<ThinUiStatus, string>;
    actionPrimary: string;
    actionSecondary: string;
    actionDanger: string;
  };
  capabilities: {
    animation: boolean;
    gamepadHints: boolean;
    lowResourceSafe: boolean;
    fullscreenRecommended: boolean;
  };
};

export type ThinUiResolvedTheme = {
  theme: ThinUiThemeDefinition;
  font: ThinUiFontDefinition;
  loader: ThinUiLoaderDefinition;
  mode: ThinUiMode;
};
