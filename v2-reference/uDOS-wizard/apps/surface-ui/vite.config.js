import { defineConfig } from "vite";
import { svelte } from "@sveltejs/vite-plugin-svelte";

/** Avoid same-origin module edge cases in strict browsers (Vite adds crossorigin by default). */
function stripHtmlCrossorigin() {
  return {
    name: "strip-html-crossorigin",
    transformIndexHtml(html) {
      return html.replace(/\s+crossorigin(?:="anonymous")?/g, "");
    },
  };
}

export default defineConfig(({ command }) => ({
  plugins: [svelte(), ...(command === "build" ? [stripHtmlCrossorigin()] : [])],
  // Production: FastAPI mounts `apps/surface-ui/dist` at `/app-assets` (wizard/main.py).
  // Dev: keep `/` so `npm run dev` stays at http://127.0.0.1:4173/
  base: command === "build" ? "/app-assets/" : "/",
  server: {
    host: "127.0.0.1",
    port: 4173,
  },
  appType: "spa",
  build: {
    outDir: "dist",
  },
}));
