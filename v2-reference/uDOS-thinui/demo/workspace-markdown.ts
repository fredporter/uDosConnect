/** Tiny markdown subset for demo docs view (escape-first; no script injection). */
function escapeHtml(s: string): string {
  return s
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

function inlineBold(escapedLine: string): string {
  return escapedLine.replace(/\*\*(.+?)\*\*/g, "<strong>$1</strong>");
}

export function formatBinderMarkdown(md: string): string {
  const trimmed = md.trim();
  if (!trimmed) {
    return "<p class=\"ws-md-empty\">No content.</p>";
  }
  const blocks = trimmed.split(/\n\n+/);
  const parts: string[] = [];
  for (const b of blocks) {
    const lines = b.split("\n");
    const first = lines[0] ?? "";
    if (first.startsWith("# ")) {
      parts.push(`<h1>${inlineBold(escapeHtml(first.slice(2)))}</h1>`);
      continue;
    }
    if (first.startsWith("## ")) {
      parts.push(`<h2>${inlineBold(escapeHtml(first.slice(3)))}</h2>`);
      const rest = lines.slice(1).join("\n");
      if (rest.trim()) {
        parts.push(
          `<p>${inlineBold(escapeHtml(rest).replace(/\n/g, "<br/>"))}</p>`,
        );
      }
      continue;
    }
    if (first.startsWith("### ")) {
      parts.push(`<h3>${inlineBold(escapeHtml(first.slice(4)))}</h3>`);
      const rest = lines.slice(1).join("\n");
      if (rest.trim()) {
        parts.push(
          `<p>${inlineBold(escapeHtml(rest).replace(/\n/g, "<br/>"))}</p>`,
        );
      }
      continue;
    }
    parts.push(
      `<p>${inlineBold(escapeHtml(b).replace(/\n/g, "<br/>"))}</p>`,
    );
  }
  return parts.join("");
}
