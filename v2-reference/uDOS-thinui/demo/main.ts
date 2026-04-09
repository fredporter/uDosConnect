import type { ThinUiEvent } from "@thinui/contracts/event";
import type { ThinUiStatePacket } from "@thinui/contracts/state";
import { createThinUiRuntime } from "@thinui/runtime/bootstrap";
import { resolveBuiltinSurfaceProfile } from "@thinui/surface/surface-profile";
import type { ThinUiRenderFrame } from "@thinui/runtime/types";
import type { ThinUiRuntimeLoop } from "@thinui/runtime/runtime-loop";
import { buildTeletextNewsdeskHtml } from "./teletext-newsdesk-html";

function applyTokens(frame: ThinUiRenderFrame, el: HTMLElement): void {
  const t = frame.renderTokens;
  if (!t) {
    el.style.background = "#111118";
    el.style.color = "#e4e4ec";
    el.style.borderColor = "#2a2a38";
    return;
  }
  el.style.background = t.palette.background;
  el.style.color = t.palette.foreground;
  el.style.borderColor = t.palette.border;
}

function applyThemeCssVars(frame: ThinUiRenderFrame, stage: HTMLElement | null): void {
  if (!stage) {
    return;
  }
  const t = frame.renderTokens;
  if (!t) {
    stage.style.removeProperty("--thinui-bg");
    stage.style.removeProperty("--thinui-fg");
    stage.style.removeProperty("--thinui-accent");
    stage.style.removeProperty("--thinui-border");
    return;
  }
  stage.style.setProperty("--thinui-bg", t.palette.background);
  stage.style.setProperty("--thinui-fg", t.palette.foreground);
  stage.style.setProperty("--thinui-accent", t.palette.accent);
  stage.style.setProperty("--thinui-border", t.palette.border);
}

const SWATCH_KEYS = [
  ["bg", "background"],
  ["fg", "foreground"],
  ["accent", "accent"],
  ["border", "border"],
  ["warn", "warning"],
  ["danger", "danger"],
  ["ok", "success"],
] as const;

function renderThemeLoaded(frame: ThinUiRenderFrame, stateThemeId: string): void {
  const host = document.getElementById("theme-loaded");
  if (!host) {
    return;
  }
  const label = frame.themeLabel ?? stateThemeId;
  const t = frame.renderTokens;
  host.replaceChildren();

  const title = document.createElement("div");
  title.className = "theme-loaded__title";
  title.textContent = `Theme loaded: ${label}`;
  host.appendChild(title);

  const meta = document.createElement("div");
  meta.className = "theme-loaded__meta";
  const parts: string[] = [`id: ${stateThemeId}`];
  if (frame.fontFamily) {
    parts.push(`font: ${frame.fontFamily}`);
  }
  if (frame.loaderLabel) {
    parts.push(`loader: ${frame.loaderLabel}`);
  }
  meta.textContent = parts.join(" · ");
  host.appendChild(meta);

  if (!t) {
    const note = document.createElement("div");
    note.textContent = "No render tokens on this frame (fallback).";
    note.style.fontSize = "0.75rem";
    note.style.color = "#888";
    host.appendChild(note);
    return;
  }

  const row = document.createElement("div");
  row.className = "theme-loaded__swatches";
  const cap = document.createElement("span");
  cap.textContent = "Palette";
  row.appendChild(cap);
  for (const [abbr, key] of SWATCH_KEYS) {
    const chip = document.createElement("div");
    chip.className = "swatch";
    chip.title = `${abbr}: ${t.palette[key]}`;
    chip.style.background = t.palette[key];
    row.appendChild(chip);
  }
  host.appendChild(row);
}

function eventForAction(actionId: string): ThinUiEvent {
  if (actionId === "back") {
    return { type: "navigate", targetId: "back" };
  }
  if (actionId === "launch-browser-ui") {
    return { type: "launch-browser" };
  }
  return { type: "action", targetId: actionId };
}

function renderActions(
  runtime: ThinUiRuntimeLoop,
  state: ThinUiStatePacket,
  onAction: (ev: ThinUiEvent) => void,
): void {
  const host = document.getElementById("actions");
  if (!host) {
    return;
  }
  host.replaceChildren();
  for (const a of state.actions) {
    const btn = document.createElement("button");
    btn.type = "button";
    btn.textContent = a.label;
    btn.disabled = Boolean(a.disabled);
    btn.addEventListener("click", () => onAction(eventForAction(a.id)));
    host.appendChild(btn);
  }
}

function renderMeta(frame: ThinUiRenderFrame, state: ThinUiStatePacket): void {
  const el = document.getElementById("meta");
  if (!el) {
    return;
  }
  const parts = [
    `view: ${state.view}`,
    `theme: ${state.themeId}${frame.themeLabel ? ` (${frame.themeLabel})` : ""}`,
    `mode: ${state.mode}`,
    `status: ${state.status ?? "—"}`,
  ];
  if (state.surface) {
    parts.push(
      `surface: ${state.surface.profileId} · ${state.surface.layout}/${state.surface.navigation} · density ${state.surface.density}`,
    );
  }
  el.textContent = parts.join(" · ");
}

let runtime: ThinUiRuntimeLoop;

/** One-shot bezel loader when entering C64 theme (not on every view repaint). */
const C64_LOADER_DURATION_MS = 2800;
let c64LoaderTimeoutId: number | null = null;
let paintPreviousThemeId: string | null = null;

function syncC64StripeLoader(themeId: string): void {
  const screen = document.querySelector<HTMLElement>(".thinui-demo-screen");
  if (!screen) {
    return;
  }

  if (themeId !== "thinui-c64") {
    if (c64LoaderTimeoutId !== null) {
      clearTimeout(c64LoaderTimeoutId);
      c64LoaderTimeoutId = null;
    }
    screen.removeAttribute("data-c64-loader");
    screen.removeAttribute("aria-busy");
    paintPreviousThemeId = themeId;
    return;
  }

  if (paintPreviousThemeId !== "thinui-c64") {
    if (c64LoaderTimeoutId !== null) {
      clearTimeout(c64LoaderTimeoutId);
      c64LoaderTimeoutId = null;
    }
    screen.dataset.c64Loader = "active";
    screen.setAttribute("aria-busy", "true");
    c64LoaderTimeoutId = window.setTimeout(() => {
      screen.dataset.c64Loader = "idle";
      screen.setAttribute("aria-busy", "false");
      c64LoaderTimeoutId = null;
    }, C64_LOADER_DURATION_MS);
  }

  paintPreviousThemeId = themeId;
}

function paint(frame: ThinUiRenderFrame): void {
  const frameEl = document.getElementById("frame");
  const stage = document.getElementById("stage");
  const themeId = runtime.getState().themeId;
  syncC64StripeLoader(themeId);
  document.body.dataset.thinuiTheme = themeId;
  if (stage) {
    stage.dataset.theme = themeId;
  }
  if (!frameEl) {
    return;
  }
  if (themeId === "thinui-teletext") {
    frameEl.innerHTML = buildTeletextNewsdeskHtml(frame.lines);
  } else {
    frameEl.textContent = frame.lines.join("\n");
  }
  applyTokens(frame, frameEl);
  if (frame.fontFamily) {
    frameEl.style.fontFamily = `${frame.fontFamily}, ui-monospace, monospace`;
  } else {
    frameEl.style.removeProperty("font-family");
  }
  applyThemeCssVars(frame, stage);
  renderThemeLoaded(frame, runtime.getState().themeId);
  renderMeta(frame, runtime.getState());
}

function wireThemeSelect(): void {
  const sel = document.getElementById("theme") as HTMLSelectElement | null;
  if (!sel) {
    return;
  }
  sel.addEventListener("change", () => {
    runtime.handleEvent({
      type: "select",
      targetId: "theme",
      value: sel.value,
      meta: { themeId: sel.value },
    });
  });
}

function main(): void {
  const params = new URLSearchParams(window.location.search);
  const themeFromUrl = params.get("theme");
  const profileParam = params.get("profile");
  const surfaceProfileId =
    profileParam === "ubuntu-gnome" || profileParam === "ubuntu_gnome"
      ? "ubuntu-gnome"
      : undefined;
  const profileThemeDefault = surfaceProfileId
    ? resolveBuiltinSurfaceProfile(surfaceProfileId)?.thinui.theme
    : undefined;
  const defaultThemeId =
    themeFromUrl ??
    (profileThemeDefault === "udos-default" ? "udos-default" : "thinui-c64");

  runtime = createThinUiRuntime({
    surfaceProfileId,
    seedState: {
      themeId: defaultThemeId,
    },
    renderFrame: (frame) => {
      paint(frame);
      renderActions(runtime, runtime.getState(), (ev) => {
        runtime.handleEvent(ev);
      });
    },
  });

  const sel = document.getElementById("theme") as HTMLSelectElement | null;
  if (sel) {
    if (themeFromUrl) {
      sel.value = themeFromUrl;
    } else if (surfaceProfileId) {
      sel.value = defaultThemeId;
    }
  }

  wireThemeSelect();
  runtime.start();
}

main();
