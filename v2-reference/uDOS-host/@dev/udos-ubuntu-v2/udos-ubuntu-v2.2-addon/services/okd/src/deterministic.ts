import {
  defaultFrontmatter,
  mergeMarkdownDocs,
  normalizeMarkdown,
  renderCanonicalMarkdown,
  type SourceRef
} from "@udos/doc-format";
import type { OkJob } from "./types.js";

export async function tryDeterministic(job: OkJob): Promise<string | null> {
  if (job.requestClass === "transformation" || job.requestClass === "draft" || job.requestClass === "summarize") {
    const normalized = await normalizeMarkdown(job.input);
    return normalized;
  }

  return null;
}

export async function mergeThreeDocs(inputs: string[], title: string): Promise<string> {
  const docs = inputs.map((markdown, index) => ({
    markdown,
    source: { title: `input-${index + 1}` } as SourceRef
  }));
  const merged = mergeMarkdownDocs(docs, { targetTitle: title, sourceType: "markdown" });
  merged.frontmatter = {
    ...defaultFrontmatter(title, "markdown"),
    doc_type: "merged_report"
  };
  return renderCanonicalMarkdown(merged);
}
