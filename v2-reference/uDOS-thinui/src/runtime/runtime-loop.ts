import type { ThinUiEvent } from "../contracts/event";
import type { ThinUiStatePacket } from "../contracts/state";
import { createDefaultThinUiThemeResolver } from "./default-theme-resolver";
import { resolveThinUiView } from "./view-resolver";
import { ThinUiViewRegistry } from "./view-registry";
import type {
  ThinUiCoreBridge,
  ThinUiRenderFrame,
  ThinUiThemeResolver,
} from "./types";

export type ThinUiFrameRenderer = (frame: ThinUiRenderFrame) => void;

function createFallbackFrame(state: ThinUiStatePacket): ThinUiRenderFrame {
  return {
    view: "fallback",
    mode: state.mode,
    themeId: state.themeId,
    loaderId: state.loaderId,
    title: "Missing ThinUI view",
    subtitle: `No view registered for '${state.view}'`,
    status: "error",
    lines: [
      "ThinUI runtime fallback",
      `requested view: ${state.view}`,
      "Register the view in ThinUiViewRegistry before runtime start.",
    ],
  };
}

export function renderThinUiState(
  state: ThinUiStatePacket,
  views: ThinUiViewRegistry,
  themeResolver: ThinUiThemeResolver,
): ThinUiRenderFrame {
  const view = resolveThinUiView(state.view, views);
  const baseFrame = view ? view.render(state) : createFallbackFrame(state);
  const adapter = themeResolver.resolveThinUiTheme(state.themeId, state.mode);
  return adapter.renderState(state, baseFrame);
}

export class ThinUiRuntimeLoop {
  constructor(
    private readonly coreBridge: ThinUiCoreBridge,
    private readonly views: ThinUiViewRegistry,
    private readonly renderFrame: ThinUiFrameRenderer,
    private readonly themeResolver: ThinUiThemeResolver = createDefaultThinUiThemeResolver(),
  ) {}

  start(): ThinUiRenderFrame {
    return this.renderCurrentState();
  }

  /** Snapshot of the last Core → ThinUI state packet (for demos and tests). */
  getState(): ThinUiStatePacket {
    return this.coreBridge.getState();
  }

  handleEvent(event: ThinUiEvent): ThinUiRenderFrame {
    this.coreBridge.dispatchEvent(event);
    return this.renderCurrentState();
  }

  private renderCurrentState(): ThinUiRenderFrame {
    const state = this.coreBridge.getState();
    const frame = renderThinUiState(state, this.views, this.themeResolver);
    this.renderFrame(frame);
    return frame;
  }
}
