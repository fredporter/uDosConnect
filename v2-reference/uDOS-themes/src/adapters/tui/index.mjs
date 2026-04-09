export function renderTuiScreen({
  title,
  subtitle = "",
  steps = [],
  actions = [],
  progress,
  width = 64,
}) {
  const rule = "=".repeat(width);
  const lines = [rule, center(title, width)];
  if (subtitle) {
    lines.push(center(subtitle, width));
  }
  lines.push(rule);

  if (progress) {
    lines.push(renderProgress(progress, width));
    lines.push("-".repeat(width));
  }

  for (const [index, step] of steps.entries()) {
    lines.push(`${String(index + 1).padStart(2, " ")}. ${step.title}`);
    if (step.body) {
      lines.push(wrap(step.body, width - 4).map((line) => `    ${line}`).join("\n"));
    }
  }

  if (actions.length) {
    lines.push("-".repeat(width));
    lines.push(actions.map((action) => `[${action.label}]`).join(" "));
  }

  return {
    width,
    height: lines.length,
    lines: lines.flatMap((line) => String(line).split("\n")),
  };
}

function renderProgress(progress, width) {
  const total = Math.max(progress.total ?? 1, 1);
  const current = Math.min(progress.current ?? 0, total);
  const barWidth = Math.max(width - 20, 10);
  const filled = Math.round((current / total) * barWidth);
  return `${progress.label ?? "Progress"} ${"█".repeat(filled)}${"·".repeat(barWidth - filled)} ${current}/${total}`;
}

function wrap(text, width) {
  const words = String(text).split(/\s+/);
  const lines = [];
  let current = "";
  for (const word of words) {
    const candidate = current ? `${current} ${word}` : word;
    if (candidate.length > width && current) {
      lines.push(current);
      current = word;
    } else {
      current = candidate;
    }
  }
  if (current) {
    lines.push(current);
  }
  return lines;
}

function center(text, width) {
  const value = String(text);
  if (value.length >= width) {
    return value.slice(0, width);
  }
  const left = Math.floor((width - value.length) / 2);
  return `${" ".repeat(left)}${value}`;
}
