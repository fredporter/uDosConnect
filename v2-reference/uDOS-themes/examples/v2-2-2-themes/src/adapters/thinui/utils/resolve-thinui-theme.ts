import type { ThinUiMode, ThinUiResolvedTheme } from "../contracts/types";
import { thinUiThemeRegistry } from "../registry/theme-registry";
import { selectFont } from "./select-font";
import { selectLoader } from "./select-loader";

export function resolveThinUiTheme(themeId: string, mode: ThinUiMode): ThinUiResolvedTheme {
  const fallback = thinUiThemeRegistry["minimal-safe"];
  const theme = thinUiThemeRegistry[themeId] ?? fallback;

  const resolvedTheme =
    mode === "recovery" && fallback.capabilities.lowResourceSafe
      ? theme.capabilities.lowResourceSafe
        ? theme
        : fallback
      : theme;

  return {
    theme: resolvedTheme,
    font: selectFont(resolvedTheme.defaultFontId),
    loader: selectLoader(resolvedTheme.defaultLoaderId),
    mode,
  };
}
