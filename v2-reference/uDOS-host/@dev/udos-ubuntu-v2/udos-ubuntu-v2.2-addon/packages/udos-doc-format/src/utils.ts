export function slugify(input: string): string {
  return input
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");
}

export function normalizeWhitespace(input: string): string {
  return input.replace(/\s+/g, " ").trim();
}

export function normalizeForSimilarity(input: string): string {
  return normalizeWhitespace(input)
    .toLowerCase()
    .replace(/[`*_>#\-]/g, "")
    .replace(/[.,;:!?()[\]{}"']/g, "");
}

export function jaccardSimilarity(a: string, b: string): number {
  const aSet = new Set(normalizeForSimilarity(a).split(" ").filter(Boolean));
  const bSet = new Set(normalizeForSimilarity(b).split(" ").filter(Boolean));
  const intersection = [...aSet].filter((x) => bSet.has(x)).length;
  const union = new Set([...aSet, ...bSet]).size || 1;
  return intersection / union;
}
