import type { ThinUiFontDefinition } from "../contracts/types";

export const systemMonoFont: ThinUiFontDefinition = {
  id: "system-mono",
  label: "System Monospace",
  family: "ui-monospace, SFMono-Regular, Menlo, Consolas, monospace",
  source: "system",
  fallbackFamily: "monospace",
  monospace: true,
};
