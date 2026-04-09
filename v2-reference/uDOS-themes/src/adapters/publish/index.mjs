import tailwindProsePreset from "./tailwind-prose-preset.json" with { type: "json" };

export const TAILWIND_PROSE_CLASSES = tailwindProsePreset.classes.article;

export function getTailwindProsePreset() {
  return tailwindProsePreset;
}

export function renderPublishPage({
  title,
  lede = "",
  sections = [],
  theme = "publish-prose-default",
}) {
  const sectionMarkup = sections
    .map(
      (section) => `
        <section>
          <h2>${escapeHtml(section.title)}</h2>
          <p>${escapeHtml(section.body ?? "")}</p>
        </section>`,
    )
    .join("");

  return `<!doctype html>
<html lang="en">
  <body class="${TAILWIND_PROSE_CLASSES}" style="--udos-accent:#1d5c63;background:#fffdf8;color:#233031;">
    <article data-theme="${escapeHtml(theme)}">
      <h1>${escapeHtml(title)}</h1>
      <p>${escapeHtml(lede)}</p>
      ${sectionMarkup}
    </article>
  </body>
</html>`;
}

export function renderEmailPage({ title, lede = "", sections = [] }) {
  const sectionMarkup = sections
    .map(
      (section) => `
        <tr>
          <td style="padding:0 0 16px 0;">
            <h2 style="margin:0 0 8px 0;color:#1d5c63;">${escapeHtml(section.title)}</h2>
            <p style="margin:0;color:#233031;">${escapeHtml(section.body ?? "")}</p>
          </td>
        </tr>`,
    )
    .join("");

  return `
    <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#fffdf8;color:#233031;">
      <tr>
        <td align="center">
          <table role="presentation" width="640" cellpadding="0" cellspacing="0" style="padding:24px;">
            <tr><td><h1 style="margin:0 0 12px 0;color:#1d5c63;">${escapeHtml(title)}</h1></td></tr>
            <tr><td><p style="margin:0 0 16px 0;">${escapeHtml(lede)}</p></td></tr>
            ${sectionMarkup}
          </table>
        </td>
      </tr>
    </table>`;
}

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;");
}
