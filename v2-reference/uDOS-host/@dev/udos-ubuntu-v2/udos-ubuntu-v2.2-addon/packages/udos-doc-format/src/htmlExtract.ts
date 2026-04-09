import { JSDOM } from "jsdom";
import TurndownService from "turndown";
import { Readability } from "@mozilla/readability";

const STRIP_SELECTORS = [
  "nav",
  "header",
  "footer",
  "aside",
  "[role='navigation']",
  ".breadcrumbs",
  ".breadcrumb",
  ".cookie-banner",
  ".newsletter",
  ".related-posts",
  ".site-header",
  ".site-footer"
];

export interface ExtractedWebContent {
  title: string;
  markdown: string;
  byline?: string;
  excerpt?: string;
}

export function extractMainContentFromHtml(html: string, url = "https://local.invalid"): ExtractedWebContent {
  const dom = new JSDOM(html, { url });
  for (const selector of STRIP_SELECTORS) {
    dom.window.document.querySelectorAll(selector).forEach((el) => el.remove());
  }

  const article = new Readability(dom.window.document).parse();
  const turndown = new TurndownService({ headingStyle: "atx", codeBlockStyle: "fenced" });

  if (!article) {
    const fallbackBody = dom.window.document.body?.innerHTML ?? "";
    return {
      title: dom.window.document.title || "Untitled",
      markdown: turndown.turndown(fallbackBody)
    };
  }

  return {
    title: article.title || dom.window.document.title || "Untitled",
    markdown: turndown.turndown(article.content),
    byline: article.byline || undefined,
    excerpt: article.excerpt || undefined
  };
}
