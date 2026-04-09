import type { ThinUiLoaderDefinition } from "../contracts/types";

export const minimalSafeLoader: ThinUiLoaderDefinition = {
  id: "minimal-safe",
  label: "Minimal Safe",
  loop: true,
  frames: [
    { text: "starting...", durationMs: 250 },
    { text: "starting.", durationMs: 250 },
    { text: "starting..", durationMs: 250 },
  ],
};
