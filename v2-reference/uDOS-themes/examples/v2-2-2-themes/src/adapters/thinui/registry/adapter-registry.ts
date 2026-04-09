export const thinUiAdapterRegistry = {
  thinui: {
    families: ["c64", "nes", "safe"],
    themes: ["thinui-c64", "thinui-nes-sonic", "minimal-safe"],
    defaults: {
      normal: "thinui-c64",
      utility: "thinui-nes-sonic",
      recovery: "minimal-safe",
    },
  },
} as const;
