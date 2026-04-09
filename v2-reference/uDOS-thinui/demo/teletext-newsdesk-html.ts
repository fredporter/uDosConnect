/**
 * Browser-only Teletext “newsdesk” chrome (coloured spans). Core frame lines stay plain text.
 */

export function escapeHtml(s: string): string {
  return s
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

function splitTeletextFrame(lines: readonly string[]): {
  body: string[];
  cast: string;
  keys: string;
} {
  let cast = "";
  let keys = "";
  const body: string[] = [];
  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i]!;
    if (line.startsWith("CAST ")) {
      cast = line;
      const next = lines[i + 1];
      if (next?.startsWith("KEYS ")) {
        keys = next;
      }
      break;
    }
    body.push(line);
  }
  while (body.length > 0 && body[body.length - 1] === "") {
    body.pop();
  }
  if (!keys) {
    keys = "KEYS RED/GRN/YEL/BLU = actions";
  }
  return { body, cast: cast || "CAST —", keys };
}

export function buildTeletextNewsdeskHtml(lines: readonly string[]): string {
  const { body, cast, keys } = splitTeletextFrame(lines);
  const clock = new Date().toLocaleTimeString(undefined, {
    hour: "2-digit",
    minute: "2-digit",
  });
  const mainLines = body
    .map(
      (line) =>
        `<div class="tt-line tt-fg-white">${line ? escapeHtml(line) : "&nbsp;"}</div>`,
    )
    .join("");

  return `<div class="tt-newsdesk">
  <header class="tt-mast">
    <span class="tt-strap tt-bg-red tt-fg-yellow"> NEWSFLASH </span>
    <span class="tt-mast__title tt-fg-cyan">uDOS TELETEXT · NEWSDESK</span>
    <span class="tt-mast__time tt-fg-yellow">${escapeHtml(clock)}</span>
  </header>
  <div class="tt-mosaic" aria-hidden="true">
    <span class="tt-fg-white">▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜</span><br/>
    <span class="tt-fg-green">▌</span><span class="tt-fg-yellow"> P100 </span><span class="tt-fg-cyan">SERVICE</span><span class="tt-fg-green"> ▐</span><br/>
    <span class="tt-fg-white">▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟</span><br/>
    <span class="tt-fg-magenta"> ▄▀▀▄</span> <span class="tt-fg-red">▄▀▄</span> <span class="tt-fg-yellow">█▀▀</span> <span class="tt-fg-cyan">▀▄▀</span> <span class="tt-fg-green">███</span>
  </div>
  <div class="tt-columns">
    <aside class="tt-index" aria-label="Teletext index">
      <div class="tt-index__row"><span class="tt-fg-yellow">101</span> <span class="tt-fg-white">HEADLINE</span></div>
      <div class="tt-index__row"><span class="tt-fg-green">102</span> <span class="tt-fg-cyan">WEATHER</span></div>
      <div class="tt-index__row"><span class="tt-fg-red">103</span> <span class="tt-fg-yellow">SPORT</span></div>
      <div class="tt-index__row"><span class="tt-fg-magenta">104</span> <span class="tt-fg-white">TECH</span></div>
    </aside>
    <div class="tt-main" role="article">${mainLines}</div>
  </div>
  <footer class="tt-ticker tt-bg-blue">
    <span class="tt-fg-yellow">${escapeHtml(cast)}</span>
    <span class="tt-fg-white tt-ticker__sep"> · </span>
    <span class="tt-fg-green">${escapeHtml(keys)}</span>
  </footer>
</div>`;
}
