import type {
  ThinUiRenderFrame,
  ThinUiRenderTokens,
  ThinUiThemeAdapter,
  ThinUiThemeFont,
  ThinUiThemeLoader,
  ThinUiThemeResolver,
} from "./types";
import type { ThinUiStatePacket } from "../contracts/state";

const udosDefaultLoader: ThinUiThemeLoader = {
  id: "udos-default-loader",
  label: "Classic Modern calm",
  loop: false,
  frames: [{ text: "ready", durationMs: 400 }],
};

const minimalSafeLoader: ThinUiThemeLoader = {
  id: "minimal-safe",
  label: "Minimal Safe",
  loop: true,
  frames: [
    { text: "starting...", durationMs: 250 },
    { text: "starting.", durationMs: 250 },
    { text: "starting..", durationMs: 250 },
  ],
};

const c64BootLoader: ThinUiThemeLoader = {
  id: "c64-boot-seq",
  label: "C64 Boot Sequence",
  loop: true,
  frames: [
    { text: "**** UDOS BASIC V2 ****", durationMs: 420 },
    { text: "64K RAM SYSTEM  38911 BASIC BYTES FREE", durationMs: 420 },
    { text: "READY.", durationMs: 300 },
    { text: 'LOAD"UDOS",8,1', durationMs: 300 },
    { text: "SEARCHING FOR UDOS", durationMs: 320 },
    { text: "LOADING", durationMs: 320 },
    { text: "READY.", durationMs: 300 },
    { text: "RUN", durationMs: 260 },
  ],
};

const nesPulseLoader: ThinUiThemeLoader = {
  id: "nes-pulse",
  label: "NES Pulse",
  loop: true,
  frames: [
    { text: "[■□□] BOOTING SONIC UTILITY", durationMs: 180 },
    { text: "[■■□] BOOTING SONIC UTILITY", durationMs: 180 },
    { text: "[■■■] BOOTING SONIC UTILITY", durationMs: 180 },
  ],
};

const teletextCastLoader: ThinUiThemeLoader = {
  id: "teletext-cast",
  label: "Teletext Cast",
  loop: true,
  frames: [
    { text: "P100 LOADING", durationMs: 220 },
    { text: "P101 SERVICES READY", durationMs: 220 },
    { text: "P102 DISPLAY ONLINE", durationMs: 220 },
  ],
};

const systemMonoFont: ThinUiThemeFont = {
  id: "system-mono",
  label: "System Monospace",
  family: "ui-monospace, SFMono-Regular, Menlo, Consolas, monospace",
  source: "system",
  fallbackFamily: "monospace",
  monospace: true,
};

const c64UserMonoFont: ThinUiThemeFont = {
  id: "c64-user-mono",
  label: "C64 User Mono",
  family: '"C64 User Mono", ui-monospace, Menlo, Consolas, monospace',
  source: "optional",
  fallbackFamily: "monospace",
  monospace: true,
};

const pressStart2pFont: ThinUiThemeFont = {
  id: "press-start-2p",
  label: "Press Start 2P",
  family: '"Press Start 2P", ui-monospace, monospace',
  source: "optional",
  fallbackFamily: "monospace",
  monospace: true,
};

const teletext50Font: ThinUiThemeFont = {
  id: "teletext50",
  label: "Teletext50",
  family: "Teletext50, ui-monospace, monospace",
  source: "optional",
  fallbackFamily: "monospace",
  monospace: true,
};

/** Classic Modern token colours (uDOS-docs classic-modern-tokens.md). */
const udosDefaultTokens: ThinUiRenderTokens = {
  palette: {
    background: "#e8e8e8",
    foreground: "#111111",
    accent: "#3a7bd5",
    border: "#222222",
    warning: "#a56412",
    danger: "#8a2c2c",
    success: "#2f6b3c",
  },
  classes: {
    app: "theme-udos-default thinui-app",
    panel: "thinui-panel thinui-panel-udos-default",
    title: "thinui-title",
    subtitle: "thinui-subtitle",
    actionPrimary: "btn-udos-default-primary",
    actionSecondary: "btn-udos-default-secondary",
    actionDanger: "btn-udos-default-danger",
  },
};

const minimalSafeTokens: ThinUiRenderTokens = {
  palette: {
    background: "#000000",
    foreground: "#ffffff",
    accent: "#ffffff",
    border: "#ffffff",
    warning: "#ffcc66",
    danger: "#ff6666",
    success: "#66ff99",
  },
  classes: {
    app: "theme-safe thinui-app",
    panel: "thinui-panel thinui-panel-safe",
    title: "thinui-title",
    subtitle: "thinui-subtitle",
    actionPrimary: "btn-safe-primary",
    actionSecondary: "btn-safe-secondary",
    actionDanger: "btn-safe-danger",
  },
};

const c64Tokens: ThinUiRenderTokens = {
  palette: {
    background: "#3038d8",
    foreground: "#d8dcff",
    accent: "#5cf0ff",
    border: "#9cb8ff",
    warning: "#ffe855",
    danger: "#ff6b9d",
    success: "#6dff6d",
  },
  classes: {
    app: "theme-c64 thinui-app",
    panel: "thinui-panel thinui-panel-c64",
    title: "thinui-title thinui-title-c64",
    subtitle: "thinui-subtitle thinui-subtitle-c64",
    actionPrimary: "btn-c64-primary",
    actionSecondary: "btn-c64-secondary",
    actionDanger: "btn-c64-danger",
  },
};

const nesTokens: ThinUiRenderTokens = {
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
};

const teletextTokens: ThinUiRenderTokens = {
  palette: {
    background: "#111111",
    foreground: "#f2f2f2",
    accent: "#00d0ff",
    border: "#f2f2f2",
    warning: "#f7d354",
    danger: "#ff5f87",
    success: "#6be675",
  },
  classes: {
    app: "theme-teletext thinui-app",
    panel: "thinui-panel thinui-panel-teletext",
    title: "thinui-title thinui-title-teletext",
    subtitle: "thinui-subtitle thinui-subtitle-teletext",
    actionPrimary: "btn-teletext-primary",
    actionSecondary: "btn-teletext-secondary",
    actionDanger: "btn-teletext-danger",
  },
};

function frameLineForProgress(loader: ThinUiThemeLoader, state: ThinUiStatePacket): string {
  if (!loader.frames.length) {
    return "";
  }

  const current = Math.max((state.progress?.current ?? 1) - 1, 0);
  return loader.frames[current % loader.frames.length]?.text ?? loader.frames[0].text;
}

const udosDefaultSansFont: ThinUiThemeFont = {
  id: "udos-default-sans",
  label: "System UI sans",
  family: 'system-ui, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif',
  source: "system",
  fallbackFamily: "sans-serif",
  monospace: false,
};

class UdosDefaultThemeAdapter implements ThinUiThemeAdapter {
  id = "udos-default";
  label = "uDOS default (Classic Modern)";

  getName(): string {
    return this.id;
  }

  getLoader(): ThinUiThemeLoader {
    return udosDefaultLoader;
  }

  getFont(): ThinUiThemeFont {
    return udosDefaultSansFont;
  }

  getRenderTokens(mode: ThinUiStatePacket["mode"]): ThinUiRenderTokens {
    if (mode === "recovery") {
      return {
        ...udosDefaultTokens,
        palette: {
          ...udosDefaultTokens.palette,
          background: "#dddddd",
          foreground: "#111111",
        },
      };
    }
    return udosDefaultTokens;
  }

  getTokens(mode: ThinUiStatePacket["mode"]): ThinUiRenderTokens {
    return this.getRenderTokens(mode);
  }

  renderState(state: ThinUiStatePacket, baseFrame: ThinUiRenderFrame): ThinUiRenderFrame {
    const loader = this.getLoader();
    const loaderLine = loader.frames[0]?.text ?? "";
    const lines = [
      `surface: ${state.surface?.profileId ?? "—"} · layout ${state.surface?.layout ?? "—"}`,
      "",
      ...baseFrame.lines,
      "",
      `theme: ${this.label} · ${loaderLine}`,
    ];

    return {
      ...baseFrame,
      lines,
      themeLabel: this.label,
      fontFamily: this.getFont().family,
      loaderLabel: loader.label,
      renderTokens: this.getRenderTokens(state.mode),
    };
  }
}

class MinimalSafeThemeAdapter implements ThinUiThemeAdapter {
  id = "minimal-safe";
  label = "Minimal Safe";

  getName(): string {
    return this.id;
  }

  getLoader(): ThinUiThemeLoader {
    return minimalSafeLoader;
  }

  getFont(): ThinUiThemeFont {
    return systemMonoFont;
  }

  getRenderTokens(_mode: ThinUiStatePacket["mode"]): ThinUiRenderTokens {
    return minimalSafeTokens;
  }

  getTokens(mode: ThinUiStatePacket["mode"]): ThinUiRenderTokens {
    return this.getRenderTokens(mode);
  }

  renderState(_state: ThinUiStatePacket, baseFrame: ThinUiRenderFrame): ThinUiRenderFrame {
    return {
      ...baseFrame,
      themeLabel: this.label,
      fontFamily: this.getFont().family,
      loaderLabel: this.getLoader().label,
      renderTokens: this.getRenderTokens(_state.mode),
    };
  }
}

class ThinUiC64ThemeAdapter implements ThinUiThemeAdapter {
  id = "thinui-c64";
  label = "ThinUI C64";

  getName(): string {
    return this.id;
  }

  getLoader(): ThinUiThemeLoader {
    return c64BootLoader;
  }

  getFont(): ThinUiThemeFont {
    return c64UserMonoFont;
  }

  getRenderTokens(mode: ThinUiStatePacket["mode"]): ThinUiRenderTokens {
    if (mode === "recovery") {
      return {
        ...c64Tokens,
        palette: {
          ...c64Tokens.palette,
          background: "#202878",
          foreground: "#e8ecff",
          border: "#b0c4ff",
        },
      };
    }

    return c64Tokens;
  }

  getTokens(mode: ThinUiStatePacket["mode"]): ThinUiRenderTokens {
    return this.getRenderTokens(mode);
  }

  renderState(state: ThinUiStatePacket, baseFrame: ThinUiRenderFrame): ThinUiRenderFrame {
    const loader = this.getLoader();
    const loaderLine = frameLineForProgress(loader, state);

    const lines = [
      "****************************************",
      "*      UDOS THINUI C64 RENDER PASS     *",
      "****************************************",
      ...baseFrame.lines.map((line) => `  ${line}`),
      "",
      `loader: ${loaderLine}`,
      `font: ${this.getFont().family}`,
    ];

    return {
      ...baseFrame,
      lines,
      themeLabel: this.label,
      fontFamily: this.getFont().family,
      loaderLabel: loader.label,
      renderTokens: this.getRenderTokens(state.mode),
    };
  }
}

class ThinUiNesSonicThemeAdapter implements ThinUiThemeAdapter {
  id = "thinui-nes-sonic";
  label = "ThinUI NES Sonic";

  getName(): string {
    return this.id;
  }

  getLoader(): ThinUiThemeLoader {
    return nesPulseLoader;
  }

  getFont(): ThinUiThemeFont {
    return pressStart2pFont;
  }

  getRenderTokens(_mode: ThinUiStatePacket["mode"]): ThinUiRenderTokens {
    return nesTokens;
  }

  getTokens(mode: ThinUiStatePacket["mode"]): ThinUiRenderTokens {
    return this.getRenderTokens(mode);
  }

  renderState(state: ThinUiStatePacket, baseFrame: ThinUiRenderFrame): ThinUiRenderFrame {
    const loader = this.getLoader();
    const loaderLine = frameLineForProgress(loader, state);
    const lines = [
      "  UDOS SONIC THINUI :: NES UTILITY",
      "",
      ...baseFrame.lines.map((line) => `  ${line}`),
      "",
      `  pulse: ${loaderLine}`,
      "  pad: A=launch  B=back  START=menu",
    ];

    return {
      ...baseFrame,
      lines,
      themeLabel: this.label,
      fontFamily: this.getFont().family,
      loaderLabel: loader.label,
      renderTokens: this.getRenderTokens(state.mode),
    };
  }
}

class ThinUiTeletextThemeAdapter implements ThinUiThemeAdapter {
  id = "thinui-teletext";
  label = "ThinUI Teletext";

  getName(): string {
    return this.id;
  }

  getLoader(): ThinUiThemeLoader {
    return teletextCastLoader;
  }

  getFont(): ThinUiThemeFont {
    return teletext50Font;
  }

  getRenderTokens(_mode: ThinUiStatePacket["mode"]): ThinUiRenderTokens {
    return teletextTokens;
  }

  getTokens(mode: ThinUiStatePacket["mode"]): ThinUiRenderTokens {
    return this.getRenderTokens(mode);
  }

  renderState(state: ThinUiStatePacket, baseFrame: ThinUiRenderFrame): ThinUiRenderFrame {
    const loader = this.getLoader();
    const loaderLine = frameLineForProgress(loader, state);
    const lines = [
      ...baseFrame.lines,
      "",
      `CAST ${loaderLine}`,
      "KEYS RED/GRN/YEL/BLU = actions",
    ];

    return {
      ...baseFrame,
      lines,
      themeLabel: this.label,
      fontFamily: this.getFont().family,
      loaderLabel: loader.label,
      renderTokens: this.getRenderTokens(state.mode),
    };
  }
}

type AdapterEntry = {
  adapter: ThinUiThemeAdapter;
  lowResourceSafe: boolean;
};

type ThinUiSkinHint = {
  baseThemeId: string;
  loaderHint?: string;
};

const minimalSafeAdapter = new MinimalSafeThemeAdapter();
const udosDefaultAdapter = new UdosDefaultThemeAdapter();

const adapters: Record<string, AdapterEntry> = {
  "udos-default": {
    adapter: udosDefaultAdapter,
    lowResourceSafe: true,
  },
  "thinui-c64": {
    adapter: new ThinUiC64ThemeAdapter(),
    lowResourceSafe: true,
  },
  "thinui-nes-sonic": {
    adapter: new ThinUiNesSonicThemeAdapter(),
    lowResourceSafe: true,
  },
  "thinui-teletext": {
    adapter: new ThinUiTeletextThemeAdapter(),
    lowResourceSafe: true,
  },
  "minimal-safe": {
    adapter: minimalSafeAdapter,
    lowResourceSafe: true,
  },
};

// Workspace-06 phase C bridge: mirror the thinui-safe subset of uDOS-themes skin registry.
// This keeps ThinUI runtime authority local while accepting registry-aligned ids.
const themeAliases: Record<string, string> = {
  "thinui-minimal-safe": "minimal-safe",
};

const skinHints: Record<string, ThinUiSkinHint> = {
  "sonic-boot": {
    baseThemeId: "thinui-c64",
    loaderHint: "c64-boot",
  },
  "alpine-safe": {
    baseThemeId: "thinui-minimal-safe",
  },
};

function resolveThemeAlias(themeId: string): string {
  return themeAliases[themeId] ?? themeId;
}

function resolveSkinToTheme(themeId: string): string {
  const normalized = themeId.startsWith("skin:") ? themeId.slice("skin:".length) : themeId;
  const hint = skinHints[normalized];
  if (!hint) {
    return themeId;
  }
  return resolveThemeAlias(hint.baseThemeId);
}

export class DefaultThinUiThemeResolver implements ThinUiThemeResolver {
  resolveThinUiTheme(themeId: string, mode: ThinUiStatePacket["mode"]): ThinUiThemeAdapter {
    const effectiveThemeId = resolveSkinToTheme(resolveThemeAlias(themeId));
    const selected = adapters[effectiveThemeId] ?? adapters["minimal-safe"];

    if (mode === "recovery" && !selected.lowResourceSafe) {
      return minimalSafeAdapter;
    }

    return selected.adapter;
  }
}

export function createDefaultThinUiThemeResolver(): ThinUiThemeResolver {
  return new DefaultThinUiThemeResolver();
}
