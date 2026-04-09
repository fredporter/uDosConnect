import path from "node:path";
import { defineConfig } from "vite";

export default defineConfig({
  root: "demo",
  publicDir: "public",
  resolve: {
    alias: {
      "@thinui": path.resolve(__dirname, "src"),
    },
  },
  server: {
    port: 5179,
    open: true,
  },
  build: {
    rollupOptions: {
      input: {
        main: path.resolve(__dirname, "demo/index.html"),
        workspace: path.resolve(__dirname, "demo/workspace.html"),
      },
    },
  },
});
