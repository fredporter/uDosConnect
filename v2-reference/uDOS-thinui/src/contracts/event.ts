export type ThinUiEventType =
  | "action"
  | "select"
  | "navigate"
  | "dismiss"
  | "launch-browser"
  | "request-refresh";

export type ThinUiEvent = {
  type: ThinUiEventType;
  targetId?: string;
  value?: string;
  meta?: Record<string, string | number | boolean>;
};
