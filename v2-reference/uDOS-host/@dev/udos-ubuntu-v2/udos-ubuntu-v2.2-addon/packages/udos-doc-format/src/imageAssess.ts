import type { ImageRole } from "./types.js";

export interface ImageAssessmentInput {
  src?: string;
  alt?: string;
  nearbyText?: string;
}

export function assessImageRole(input: ImageAssessmentInput): ImageRole {
  const text = `${input.alt ?? ""} ${input.nearbyText ?? ""}`.toLowerCase();

  if (/diagram|flow|chart|graph|topology|map|wireframe|schema/.test(text)) {
    return "informational_convertible";
  }
  if (/logo|banner|hero|background|divider|icon/.test(text)) {
    return "decorative_discard";
  }
  if (/photo|portrait|scene|reference|style/.test(text)) {
    return "prompt_reference";
  }
  return "metadata_only";
}
