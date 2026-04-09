import { resolveThinUiTheme } from "../utils/resolve-thinui-theme";

const resolved = resolveThinUiTheme("thinui-c64", "fullscreen");

console.log({
  theme: resolved.theme.id,
  font: resolved.font.family,
  loader: resolved.loader.frames.map((frame) => frame.text),
});
