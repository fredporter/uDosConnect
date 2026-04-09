import matter from "gray-matter";
import type { CanonicalDoc, Frontmatter, SourceType } from "./types.js";
import { slugify } from "./utils.js";

export function defaultFrontmatter(title: string, sourceType: SourceType): Frontmatter {
  const now = new Date().toISOString().slice(0, 10);
  return {
    title,
    slug: slugify(title),
    doc_type: "research_note",
    status: "active",
    created: now,
    updated: now,
    source_type: sourceType,
    source_urls: [],
    source_files: [],
    tags: [],
    topics: [],
    related: [],
    aliases: [],
    canonical: true,
    horizontal_view: true,
    marp: false,
    word_count: 0,
    media_policy: {},
    compost_refs: []
  };
}

export function renderCanonicalMarkdown(doc: CanonicalDoc): string {
  const data = matter.stringify(
    doc.blocks.map((b) => b.text).join("\n\n"),
    doc.frontmatter as unknown as Record<string, unknown>
  );
  return data;
}
