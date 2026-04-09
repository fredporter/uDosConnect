const browserThemeMap = {
  "browser-default": {
    skinId: "empire-editorial",
    cssVars: {
      "--udos-bg": "#f8f5ee",
      "--udos-fg": "#1d2728",
      "--udos-accent": "#1d5c63",
      "--udos-panel": "#fffcf7",
      "--udos-border": "#c8d3d1",
    },
    proseClasses: "prose prose-slate max-w-3xl",
  },
};

export function createBrowserThemeModel(themeId = "browser-default") {
  return browserThemeMap[themeId] ?? browserThemeMap["browser-default"];
}

export function renderBrowserScreen({
  themeId = "browser-default",
  title,
  intro = "",
  sections = [],
  actions = [],
  progress,
}) {
  const theme = createBrowserThemeModel(themeId);
  const progressMarkup = progress
    ? `<div class="udos-progress"><span>${progress.current}/${progress.total}</span><strong>${escapeHtml(progress.label ?? "")}</strong></div>`
    : "";
  const sectionMarkup = sections
    .map(
      (section) => `
        <section class="udos-panel">
          <h2>${escapeHtml(section.title)}</h2>
          <p>${escapeHtml(section.body ?? "")}</p>
        </section>`,
    )
    .join("");
  const actionMarkup = actions
    .map((action) => `<button class="udos-button">${escapeHtml(action.label)}</button>`)
    .join("");

  const style = Object.entries(theme.cssVars)
    .map(([key, value]) => `${key}:${value}`)
    .join(";");

  return {
    themeId,
    skinId: theme.skinId,
    proseClasses: theme.proseClasses,
    html: `
      <main class="udos-browser-screen ${theme.proseClasses}" style="${style}">
        <header class="udos-hero">
          <p class="udos-kicker">uDOS browser adapter</p>
          <h1>${escapeHtml(title)}</h1>
          <p>${escapeHtml(intro)}</p>
          ${progressMarkup}
        </header>
        <div class="udos-sections">${sectionMarkup}</div>
        <footer class="udos-actions">${actionMarkup}</footer>
      </main>`,
  };
}

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;");
}
