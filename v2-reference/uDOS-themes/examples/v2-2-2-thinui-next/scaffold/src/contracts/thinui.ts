export type ThinUiMode = "windowed" | "fullscreen" | "recovery";

export type ThinUiStatePacket = {
  view: string;
  mode: ThinUiMode;
  themeId: string;
  loaderId?: string;
  title?: string;
  subtitle?: string;
  status?: "idle" | "running" | "warning" | "error" | "complete";
  actions: Array<{
    id: string;
    label: string;
    kind?: "primary" | "secondary" | "danger" | "nav";
    disabled?: boolean;
  }>;
};

export type ThinUiEvent = {
  type: "action" | "select" | "navigate" | "dismiss" | "launch-browser" | "request-refresh";
  targetId?: string;
  value?: string;
};
