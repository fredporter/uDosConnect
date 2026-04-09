import themeTokens from './theme-tokens.json';

export type ThemeTokensFile = typeof themeTokens;

function hexToRgb(hex: string): { r: number; g: number; b: number } | null {
  const n = hex.trim().replace('#', '');
  if (n.length !== 6) return null;
  const r = Number.parseInt(n.slice(0, 2), 16);
  const g = Number.parseInt(n.slice(2, 4), 16);
  const b = Number.parseInt(n.slice(4, 6), 16);
  if ([r, g, b].some((v) => Number.isNaN(v))) return null;
  return { r, g, b };
}

function rgbToHex(r: number, g: number, b: number): string {
  return (
    '#' +
    [r, g, b]
      .map((x) => Math.max(0, Math.min(255, Math.round(x))).toString(16).padStart(2, '0'))
      .join('')
  );
}

/** Darken a #RRGGBB colour for gradient endpoints (not in token file). */
function darkenHex(hex: string, factor: number): string {
  const rgb = hexToRgb(hex);
  if (!rgb) return hex;
  return rgbToHex(rgb.r * (1 - factor), rgb.g * (1 - factor), rgb.b * (1 - factor));
}

function firstHexIn(cssValue: string): string | null {
  const m = cssValue.match(/#[0-9a-fA-F]{6}/);
  return m ? m[0].toLowerCase() : null;
}

function rgbaFromHex(hex: string, alpha: number): string {
  const rgb = hexToRgb(hex);
  if (!rgb) return `rgba(0,0,0,${alpha})`;
  return `rgba(${rgb.r},${rgb.g},${rgb.b},${alpha})`;
}

/** Blend error (or any) colour toward white for a subtle alert surface. */
function mixTowardWhite(hex: string, amount: number): string {
  const rgb = hexToRgb(hex);
  if (!rgb) return '#fdf2f2';
  const r = rgb.r * amount + 255 * (1 - amount);
  const g = rgb.g * amount + 255 * (1 - amount);
  const b = rgb.b * amount + 255 * (1 - amount);
  return rgbToHex(r, g, b);
}

export function buildWorkspaceShellCssVars(tokens: ThemeTokensFile = themeTokens): Record<string, string> {
  const t = tokens.tokens;
  const accent = t.color.accent;
  const panel = t.surface.panel;
  const overlay = t.surface.overlay;
  const borderDefault = firstHexIn(t.border.default) ?? '#c8d3d1';
  const borderStrong = firstHexIn(t.border.strong) ?? accent;

  return {
    '--ws-bg': t.color.background,
    '--ws-fg': t.color.foreground,
    '--ws-fg-muted': t.color.muted,
    '--ws-accent': accent,
    '--ws-accent-end': darkenHex(accent, 0.12),
    '--ws-panel': panel,
    '--ws-panel-deep': overlay,
    '--ws-card': t.input.background,
    '--ws-input-bg': t.input.background,
    '--ws-border': borderDefault,
    '--ws-border-strong': borderStrong,
    '--ws-error': t.state.error,
    '--ws-error-bg': mixTowardWhite(t.state.error, 0.06),
    '--ws-shadow': t.shadow.soft,
    '--ws-accent-soft': rgbaFromHex(accent, 0.12),
    '--ws-topbar-glass': rgbaFromHex(panel, 0.92),
    '--ws-sidebar-glass': rgbaFromHex(overlay, 0.96),
    '--ws-tray-glass': rgbaFromHex(panel, 0.94),
  };
}

export const workspaceShellCssVars = buildWorkspaceShellCssVars();

export function applyWorkspaceShellVars(target: HTMLElement): void {
  for (const [key, value] of Object.entries(workspaceShellCssVars)) {
    target.style.setProperty(key, value);
  }
}
