export type ThinGuiOptions = {
  baseUrl?: string;
  target?: "gui-preview" | "web-prose" | "email-html" | "beacon-library";
  prosePreset?: string;
  themeAdapter?: string;
  lensId?: string;
  title?: string;
};

export function launchThinGui(route: string, options: ThinGuiOptions = {}): string {
  const baseUrl = (options.baseUrl ?? "http://127.0.0.1:8787").replace(/\/$/, "");
  const params = new URLSearchParams();
  params.set("route", route);
  params.set("target", options.target ?? "gui-preview");
  params.set("prosePreset", options.prosePreset ?? "prose-default");
  if (options.themeAdapter) {
    params.set("themeAdapter", options.themeAdapter);
  }
  if (options.lensId) {
    params.set("lensId", options.lensId);
  }
  if (options.title) {
    params.set("title", options.title);
  }
  return `${baseUrl}/thin?${params.toString()}`;
}
