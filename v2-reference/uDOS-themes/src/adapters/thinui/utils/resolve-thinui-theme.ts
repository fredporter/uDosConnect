import type { ThinUiMode, ThinUiThemeAdapter } from "../contracts/types";
import { thinUiAdapterRegistry } from "../registry/adapter-registry";

export function resolveThinUiTheme(themeId: string, mode: ThinUiMode): ThinUiThemeAdapter {
  const fallback = thinUiAdapterRegistry["minimal-safe"];
  const selected = thinUiAdapterRegistry[themeId] ?? fallback;

  if (mode === "recovery" && !selected.lowResourceSafe) {
    return fallback.adapter;
  }

  return selected.adapter;
}
