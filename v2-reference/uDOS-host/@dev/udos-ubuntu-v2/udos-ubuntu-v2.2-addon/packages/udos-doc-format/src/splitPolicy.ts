export interface SplitDecision {
  shouldSplit: boolean;
  reason?: string;
}

export function evaluateSplitPolicy(markdown: string): SplitDecision {
  const words = markdown.split(/\s+/).filter(Boolean).length;
  const majorSections = (markdown.match(/^##\s+/gm) || []).length;
  if (words > 4000) return { shouldSplit: true, reason: "hard_threshold" };
  if (words > 2500 && majorSections > 3) return { shouldSplit: true, reason: "topic_threshold" };
  return { shouldSplit: false };
}
