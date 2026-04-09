import { unified } from "unified";
import remarkParse from "remark-parse";
import remarkStringify from "remark-stringify";
import remarkGfm from "remark-gfm";
import { visit } from "unist-util-visit";

export async function normalizeMarkdown(input: string): Promise<string> {
  const file = await unified()
    .use(remarkParse)
    .use(remarkGfm)
    .use(() => (tree) => {
      visit(tree, "heading", (node: any) => {
        if (node.depth > 3) node.depth = 3;
      });
    })
    .use(remarkStringify, {
      listItemIndent: "one",
      fences: true,
      bullet: "-"
    })
    .process(input);

  return String(file).trim();
}
