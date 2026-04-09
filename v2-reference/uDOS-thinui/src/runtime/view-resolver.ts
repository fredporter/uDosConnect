import { ThinUiViewRegistry } from "./view-registry";
import type { ThinUiView } from "./types";

export function resolveThinUiView(
  viewId: string,
  views: ThinUiViewRegistry,
): ThinUiView | undefined {
  return views.get(viewId);
}
