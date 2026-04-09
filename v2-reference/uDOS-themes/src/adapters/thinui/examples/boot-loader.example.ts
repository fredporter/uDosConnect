import type { ThinUiRenderFrame, ThinUiStatePacket } from "../contracts/types";
import { resolveThinUiTheme } from "../utils/resolve-thinui-theme";

const state: ThinUiStatePacket = {
  view: "boot-loader",
  mode: "fullscreen",
  themeId: "thinui-c64",
  title: "uDOS ThinUI",
  subtitle: "Runtime scaffold ready",
  status: "running",
  progress: {
    current: 2,
    total: 3,
    label: "Loading services",
  },
  actions: [
    { id: "continue", label: "Continue", kind: "primary" },
    { id: "refresh", label: "Refresh", kind: "secondary" },
  ],
};

const baseFrame: ThinUiRenderFrame = {
  view: state.view,
  mode: state.mode,
  themeId: state.themeId,
  title: state.title,
  subtitle: state.subtitle,
  status: state.status,
  lines: [
    "ThinUI base frame",
    `title: ${state.title}`,
    `status: ${state.status}`,
    `progress: ${state.progress?.label}`,
  ],
};

const adapter = resolveThinUiTheme(state.themeId, state.mode);
const themedFrame = adapter.renderState(state, baseFrame);

console.log(themedFrame.lines.join("\n"));
