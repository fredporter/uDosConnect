import type { ThinUiStatePacket } from "../contracts/state";

export function createDefaultThinUiState(): ThinUiStatePacket {
  return {
    view: "boot-loader",
    mode: "fullscreen",
    themeId: "thinui-c64",
    loaderId: "default-loader",
    title: "uDOS ThinUI",
    subtitle: "Runtime scaffold ready",
    status: "running",
    progress: {
      current: 1,
      total: 3,
      label: "Loading services",
    },
    actions: [
      { id: "continue", label: "Continue", kind: "primary" },
      { id: "refresh", label: "Refresh", kind: "secondary" },
    ],
    diagnostics: {
      offline: true,
      lowResource: true,
    },
  };
}

export function hydrateThinUiState(seedState?: Partial<ThinUiStatePacket>): ThinUiStatePacket {
  return {
    ...createDefaultThinUiState(),
    ...seedState,
  };
}
