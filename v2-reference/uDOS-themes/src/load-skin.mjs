import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = path.resolve(__dirname, "..");

/**
 * Resolve a skin from registry/skin-registry.json plus its base theme payload.
 * @param {string} skinId
 * @param {{ repoRoot?: string }} [opts]
 */
export function loadSkinBundle(skinId, opts = {}) {
  const root = opts.repoRoot ?? REPO_ROOT;
  const skinRegPath = path.join(root, "registry/skin-registry.json");
  const themeRegPath = path.join(root, "registry/theme-registry.json");
  const skinReg = JSON.parse(fs.readFileSync(skinRegPath, "utf8"));
  const themeReg = JSON.parse(fs.readFileSync(themeRegPath, "utf8"));

  const skinEntry = skinReg.skins?.find((s) => s.skin_id === skinId);
  if (!skinEntry) {
    throw new Error(`loadSkinBundle: unknown skin_id "${skinId}"`);
  }

  const skinPath = path.join(root, skinEntry.skin_ref);
  const skin = JSON.parse(fs.readFileSync(skinPath, "utf8"));

  const themeEntry = themeReg.themes?.find((t) => t.theme_id === skinEntry.base_theme);
  if (!themeEntry) {
    throw new Error(`loadSkinBundle: base_theme "${skinEntry.base_theme}" not in theme registry`);
  }

  const themePath = path.join(root, themeEntry.theme_ref);
  const baseTheme = JSON.parse(fs.readFileSync(themePath, "utf8"));

  return {
    skinId,
    skinEntry,
    skin,
    baseThemeId: skinEntry.base_theme,
    baseTheme,
  };
}
