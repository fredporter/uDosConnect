import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const repoRoot = path.resolve(__dirname, "..");
const sourcePath = path.join(repoRoot, "site", "data", "family-source.json");
const outputPath = path.join(repoRoot, "site", "data", "family.json");
const manifestOutputPath = path.join(repoRoot, "site", "data", "library-manifest.json");
const siteDir = path.join(repoRoot, "site");
const checkOnly = process.argv.includes("--check");

function githubTree(user, repo, branch, segment) {
  return `https://github.com/${user}/${repo}/tree/${branch}/${segment}`;
}

function githubIssues(user, repo) {
  return `https://github.com/${user}/${repo}/issues`;
}

function githubPulls(user, repo) {
  return `https://github.com/${user}/${repo}/pulls`;
}

function githubContributors(user, repo) {
  return `https://github.com/${user}/${repo}/graphs/contributors`;
}

function buildRepoLinks(user, repoDef) {
  const repo = repoDef.repo;
  const branch = repoDef.branch || "main";
  const docsSegment = repoDef.docs_segment || "docs";
  const links = [
    { label: "Repo", url: `https://github.com/${user}/${repo}` },
    { label: "Docs", url: githubTree(user, repo, branch, docsSegment) },
  ];

  if (!repoDef.omit_wiki) {
    links.push({ label: "Wiki", url: githubTree(user, repo, branch, "wiki") });
  }

  if (Array.isArray(repoDef.extra_links)) {
    links.push(...repoDef.extra_links);
  }

  links.push(
    { label: "Issues", url: githubIssues(user, repo) },
    { label: "Pull Requests", url: githubPulls(user, repo) },
    { label: "Contributors", url: githubContributors(user, repo) },
  );

  return links;
}

function buildData(source) {
  return {
    site_shell: source.site_shell,
    library_nav: buildLibraryNav(source),
    library_cards: source.library_cards,
    track_cards: source.track_cards,
    featured_references: source.featured_references,
    wiki_units: source.wiki_units,
    courses_and_resources: source.courses_and_resources,
    github_cards: source.github_cards,
    repo_groups: source.repo_groups.map((group) => ({
      title: group.title,
      description: group.description,
      repos: group.repos.map((repoDef) => ({
        name: repoDef.repo,
        role: repoDef.role,
        summary: repoDef.summary,
        keywords: repoDef.keywords || [],
        links: buildRepoLinks(source.github_user, repoDef),
      })),
    })),
  };
}

function buildManifest(source) {
  const repoGroups = source.repo_groups.map((group) => ({
    title: group.title,
    description: group.description,
    repos: group.repos.map((repoDef) => ({
      name: repoDef.repo,
      role: repoDef.role,
      summary: repoDef.summary,
      keywords: repoDef.keywords || [],
      links: buildRepoLinks(source.github_user, repoDef),
    })),
  }));

  return {
    title: source.site_shell.title,
    generated_from: "site/data/family-source.json",
    hubs: (source.library_pages || []).map((page) => ({
      slug: page.slug,
      title: page.title,
      eyebrow: page.eyebrow,
      url: `./${page.slug}.html`,
    })),
    tracks: (source.track_pages || []).map((page) => ({
      slug: page.slug,
      title: page.title,
      eyebrow: page.eyebrow,
      url: `./${page.slug}.html`,
    })),
    references: source.featured_references,
    wiki_units: source.wiki_units,
    courses_and_resources: source.courses_and_resources,
    github_cards: source.github_cards,
    repo_groups: repoGroups,
  };
}

function buildLibraryNav(source) {
  const items = [
    { label: "Library", url: "./index.html" },
    ...(source.library_pages || []).map((page) => ({
      label: page.eyebrow,
      url: `./${page.slug}.html`,
    })),
    { label: "Manifest", url: "./manifest.html" },
    ...(source.track_pages || []).map((page) => ({
      label: page.eyebrow,
      url: `./${page.slug}.html`,
    })),
  ];

  const seen = new Set();
  return items.filter((item) => {
    const key = `${item.label}|${item.url}`;
    if (seen.has(key)) {
      return false;
    }
    seen.add(key);
    return true;
  });
}

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;");
}

function renderAction(action) {
  const className = action.primary ? "button button--primary" : "button";
  return `          <a href="${escapeHtml(action.url)}" class="${className}">${escapeHtml(action.label)}</a>`;
}

function renderNavItem(item) {
  return `          <a href="${escapeHtml(item.url)}" class="library-nav__link">${escapeHtml(item.label)}</a>`;
}

function renderLibraryNav(items) {
  const links = items.map(renderNavItem).join("\n");
  return `    <nav class="library-nav" aria-label="Library navigation">
      <div class="library-nav__inner">
${links}
      </div>
    </nav>`;
}

function renderFooter(footer) {
  const links = (footer.links || [])
    .map((link) => `          <a href="${escapeHtml(link.url)}" class="library-footer__link">${escapeHtml(link.label)}</a>`)
    .join("\n");

  return `    <footer class="library-footer">
      <div class="library-footer__inner">
        <p class="library-footer__lede">${escapeHtml(footer.lede || "")}</p>
        <nav class="library-footer__links" aria-label="Library provenance">
${links}
        </nav>
      </div>
    </footer>`;
}

function renderLinkList(links) {
  const items = links
    .map((link) => `              <li><a href="${escapeHtml(link.url)}">${escapeHtml(link.label)}</a></li>`)
    .join("\n");
  return `            <ul class="link-list">\n${items}\n            </ul>`;
}

function renderCard(card) {
  const parts = ['          <article class="card">'];

  if (card.tag) {
    parts.push(`            <p class="card__tag">${escapeHtml(card.tag)}</p>`);
  }

  parts.push(`            <h3>${escapeHtml(card.title)}</h3>`);

  if (card.body) {
    parts.push(`            <p class="card__body">${escapeHtml(card.body)}</p>`);
  }

  if (Array.isArray(card.links) && card.links.length > 0) {
    parts.push(renderLinkList(card.links));
  } else if (card.url && card.link_label) {
    parts.push(`            <a class="card__link" href="${escapeHtml(card.url)}">${escapeHtml(card.link_label)}</a>`);
  }

  parts.push("          </article>");
  return parts.join("\n");
}

function renderSection(section) {
  const cards = section.cards.map(renderCard).join("\n");
  return `      <section class="section">
        <div class="section__header">
          <p class="eyebrow">${escapeHtml(section.eyebrow)}</p>
          <h2>${escapeHtml(section.title)}</h2>
        </div>
        <div class="grid ${escapeHtml(section.grid || "grid--three")}">
${cards}
        </div>
      </section>`;
}

function renderTrackPage(page) {
  const actions = page.actions.map(renderAction).join("\n");
  const sections = page.sections.map(renderSection).join("\n\n");
  const libraryNav = renderLibraryNav(page.library_nav || []);
  const footer = renderFooter(page.footer || {});
  return `<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>uDOS ${escapeHtml(page.eyebrow)}</title>
    <link rel="stylesheet" href="./styles.css">
  </head>
  <body>
${libraryNav}
    <header class="hero">
      <div class="hero__inner">
        <p class="eyebrow">${escapeHtml(page.eyebrow)}</p>
        <h1>${escapeHtml(page.title)}</h1>
        <p class="lede">
          ${escapeHtml(page.lede)}
        </p>
        <nav class="hero__actions">
${actions}
        </nav>
      </div>
    </header>

    <main class="page">
${sections}
    </main>
${footer}
  </body>
</html>
`;
}

function renderManifestPage(manifest) {
  const hubCards = manifest.hubs.map((hub) => ({
    tag: hub.eyebrow,
    title: hub.title,
    url: hub.url,
    link_label: "Open Hub",
  }));
  const trackCards = manifest.tracks.map((track) => ({
    tag: track.eyebrow,
    title: track.title,
    url: track.url,
    link_label: "Open Track",
  }));
  const repoCards = manifest.repo_groups.map((group) => ({
    title: group.title,
    body: group.description,
    links: group.repos.map((repo) => ({
      label: repo.name,
      url: repo.links[0].url,
    })),
  }));

  return renderTrackPage({
    eyebrow: "Library Manifest",
    title: "Human-readable map of the public uDOS library.",
    lede: "Use this page as a compact sitemap for hubs, tracks, wiki units, references, GitHub routes, and repo groups.",
    actions: [
      { label: "Back To Library", url: "./index.html", primary: true },
      { label: "Open JSON Manifest", url: "./data/library-manifest.json" },
    ],
    library_nav: manifest.library_nav,
    footer: manifest.footer,
    sections: [
      {
        eyebrow: "Hubs",
        title: "Learning and reference entry points",
        grid: "grid--two",
        cards: hubCards,
      },
      {
        eyebrow: "Tracks",
        title: "Role-based module paths",
        grid: "grid--three",
        cards: trackCards,
      },
      {
        eyebrow: "Learning",
        title: "Wiki units and public resources",
        grid: "grid--two",
        cards: [
          { title: "Wiki Units", links: manifest.wiki_units },
          { title: "Courses And Resources", links: manifest.courses_and_resources },
        ],
      },
      {
        eyebrow: "Reference",
        title: "Featured stable docs",
        grid: "grid--three",
        cards: manifest.references,
      },
      {
        eyebrow: "GitHub",
        title: "Repos, issues, pulls, and contributors",
        grid: "grid--three",
        cards: manifest.github_cards,
      },
      {
        eyebrow: "Repo Groups",
        title: "Component groupings",
        grid: "grid--two",
        cards: repoCards,
      },
    ],
  });
}

function buildOutputs(source) {
  const manifest = buildManifest(source);
  const libraryNav = buildLibraryNav(source);
  manifest.library_nav = libraryNav;
  manifest.footer = source.site_shell.footer;
  const outputs = [
    { filePath: outputPath, content: `${JSON.stringify(buildData(source), null, 2)}\n` },
    { filePath: manifestOutputPath, content: `${JSON.stringify(manifest, null, 2)}\n` },
    { filePath: path.join(siteDir, "manifest.html"), content: renderManifestPage(manifest) },
  ];

  for (const groupName of ["library_pages", "track_pages"]) {
    for (const page of source[groupName] || []) {
      outputs.push({
        filePath: path.join(siteDir, `${page.slug}.html`),
        content: renderTrackPage({ ...page, library_nav: libraryNav, footer: source.site_shell.footer }),
      });
    }
  }

  return outputs;
}

const source = JSON.parse(await fs.readFile(sourcePath, "utf8"));
const outputs = buildOutputs(source);

if (checkOnly) {
  for (const output of outputs) {
    const current = await fs.readFile(output.filePath, "utf8");
    if (current !== output.content) {
      console.error(`${path.relative(repoRoot, output.filePath)} is out of date. Run scripts/generate-site-data.mjs`);
      process.exit(1);
    }
  }
  console.log("generated site files are up to date");
  process.exit(0);
}

for (const output of outputs) {
  await fs.writeFile(output.filePath, output.content, "utf8");
  console.log(`Wrote ${path.relative(repoRoot, output.filePath)}`);
}
