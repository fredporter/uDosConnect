import type { ThinUiFontDefinition } from "../contracts/types";
import { petmeFont } from "../fonts/petme";
import { systemMonoFont } from "../fonts/system-mono";

const fontRegistry: Record<string, ThinUiFontDefinition> = {
  [petmeFont.id]: petmeFont,
  [systemMonoFont.id]: systemMonoFont,
};

export function selectFont(fontId: string): ThinUiFontDefinition {
  return fontRegistry[fontId] ?? systemMonoFont;
}
