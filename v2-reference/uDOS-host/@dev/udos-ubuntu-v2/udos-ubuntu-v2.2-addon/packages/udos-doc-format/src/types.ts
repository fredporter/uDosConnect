export type SourceType =
  | "web_page"
  | "markdown"
  | "plain_text"
  | "doc_docx"
  | "pdf"
  | "email"
  | "slides"
  | "spreadsheet_or_data"
  | "image_only"
  | "mixed_media_bundle";

export type ImageRole =
  | "informational_required"
  | "informational_convertible"
  | "contextual_optional"
  | "decorative_discard"
  | "prompt_reference"
  | "metadata_only";

export interface SourceRef {
  url?: string;
  filePath?: string;
  title?: string;
  fetchedAt?: string;
}

export interface Frontmatter {
  title: string;
  slug: string;
  doc_type: string;
  status: string;
  created: string;
  updated: string;
  source_type: SourceType;
  source_urls: string[];
  source_files: string[];
  tags: string[];
  topics: string[];
  related: string[];
  aliases: string[];
  split_parent?: string;
  split_part?: number;
  canonical: boolean;
  horizontal_view: boolean;
  marp: boolean;
  word_count: number;
  media_policy?: Record<string, unknown>;
  compost_refs?: string[];
}

export interface CanonicalBlock {
  kind:
    | "paragraph"
    | "heading"
    | "bullet_list"
    | "numbered_list"
    | "quote"
    | "code"
    | "table"
    | "callout"
    | "source_list"
    | "diagram"
    | "ascii_art"
    | "teletext"
    | "image_meta"
    | "prompt_ref"
    | "extract_note";
  headingPath?: string[];
  text: string;
  sourceRefs: SourceRef[];
  confidence: "exact" | "merged" | "inferred";
}

export interface CanonicalDoc {
  frontmatter: Frontmatter;
  blocks: CanonicalBlock[];
  relatedLinks: string[];
}

export interface FormatOptions {
  injectFrontmatter?: boolean;
  normalizeHeadings?: boolean;
  cleanLists?: boolean;
  horizontalView?: boolean;
  marp?: boolean;
}

export interface MergeOptions {
  targetTitle: string;
  dedupeThreshold?: number;
  sourceType?: SourceType;
}
