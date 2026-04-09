#!/usr/bin/env node
/**
 * Print uDOS-themes skin bundle summary (sibling checkout or UDOS_THEMES_ROOT).
 * Usage: node scripts/print-themes-skin.mjs [skin_id]
 */
import fs from "fs";
import path from "path";
import { fileURLToPath, pathToFileURL } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const thinuiRoot = path.resolve(__dirname, "..");
const familyRoot = path.resolve(thinuiRoot, "..");
const themesRoot = process.env.UDOS_THEMES_ROOT || path.join(familyRoot, "uDOS-themes");
const skinId = process.argv[2] || "sonic-boot";

const loaderPath = path.join(themesRoot, "src/load-skin.mjs");
if (!fs.existsSync(loaderPath)) {
  console.error(`uDOS-themes not found at ${themesRoot}. Set UDOS_THEMES_ROOT or clone uDOS-themes next to uDOS-thinui.`);
  process.exit(1);
}

const mod = await import(pathToFileURL(loaderPath).href);
const bundle = mod.loadSkinBundle(skinId, { repoRoot: themesRoot });

console.log(
  JSON.stringify(
    {
      skinId: bundle.skinId,
      baseThemeId: bundle.baseThemeId,
      skin_overrides: bundle.skin.overrides ?? {},
      base_theme_keys: bundle.baseTheme && typeof bundle.baseTheme === "object" ? Object.keys(bundle.baseTheme) : [],
    },
    null,
    2,
  ),
);
