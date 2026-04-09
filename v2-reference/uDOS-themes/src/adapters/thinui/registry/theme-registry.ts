import type { ThinUiThemeDefinition } from "../contracts/types";
import { minimalSafeTheme } from "../adapters/minimal-safe";
import { thinUiC64Theme } from "../adapters/thinui-c64";
import { thinUiNesSonicTheme } from "../adapters/thinui-nes-sonic";
import { thinUiTeletextTheme } from "../adapters/thinui-teletext";

export const thinUiThemeRegistry: Record<string, ThinUiThemeDefinition> = {
  [thinUiC64Theme.id]: thinUiC64Theme,
  [thinUiNesSonicTheme.id]: thinUiNesSonicTheme,
  [thinUiTeletextTheme.id]: thinUiTeletextTheme,
  [minimalSafeTheme.id]: minimalSafeTheme,
};
