import type { ThinUiView } from "./types";

export class ThinUiViewRegistry {
  private readonly views = new Map<string, ThinUiView>();

  register(view: ThinUiView): void {
    this.views.set(view.id, view);
  }

  get(viewId: string): ThinUiView | undefined {
    return this.views.get(viewId);
  }

  has(viewId: string): boolean {
    return this.views.has(viewId);
  }

  list(): string[] {
    return [...this.views.keys()];
  }
}
