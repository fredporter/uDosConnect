import type { CanonicalBlock, CanonicalDoc, MergeOptions, SourceRef } from "./types.js";
import { defaultFrontmatter } from "./frontmatter.js";
import { jaccardSimilarity, normalizeForSimilarity } from "./utils.js";

function blockify(markdown: string, source: SourceRef): CanonicalBlock[] {
  return markdown
    .split(/\n\n+/)
    .map((text) => text.trim())
    .filter(Boolean)
    .map((text) => ({
      kind: text.startsWith("#") ? "heading" : "paragraph",
      text,
      sourceRefs: [source],
      confidence: "exact" as const
    }));
}

export function mergeMarkdownDocs(
  inputs: Array<{ markdown: string; source: SourceRef }>,
  options: MergeOptions
): CanonicalDoc {
  const threshold = options.dedupeThreshold ?? 0.88;
  const merged: CanonicalBlock[] = [];

  for (const input of inputs) {
    const blocks = blockify(input.markdown, input.source);
    for (const block of blocks) {
      const existing = merged.find((candidate) => {
        const a = normalizeForSimilarity(candidate.text);
        const b = normalizeForSimilarity(block.text);
        if (a === b) return true;
        return jaccardSimilarity(candidate.text, block.text) >= threshold;
      });

      if (existing) {
        existing.sourceRefs.push(...block.sourceRefs);
        if (block.text.length > existing.text.length) {
          existing.text = block.text;
          existing.confidence = "merged";
        }
      } else {
        merged.push(block);
      }
    }
  }

  return {
    frontmatter: defaultFrontmatter(options.targetTitle, options.sourceType ?? "markdown"),
    blocks: merged,
    relatedLinks: []
  };
}
