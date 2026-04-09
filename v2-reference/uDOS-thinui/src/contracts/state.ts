export type ThinUiMode = "windowed" | "fullscreen" | "recovery";
export type ThinUiStatus = "idle" | "running" | "warning" | "error" | "complete";

/** uDOS-surface profile context attached to the state packet (orchestration → ThinUI). */
export type ThinUiSurfaceContext = {
  profileId: string;
  layout: string;
  navigation: string;
  /** Mode after boot → home when profile prefers a desktop shell. */
  homeMode: ThinUiMode;
  thinuiTheme: string;
  density: string;
};

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
  surface?: ThinUiSurfaceContext;
};
