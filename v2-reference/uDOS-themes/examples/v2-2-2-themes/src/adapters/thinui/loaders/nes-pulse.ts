import type { ThinUiLoaderDefinition } from "../contracts/types";

export const nesPulseLoader: ThinUiLoaderDefinition = {
  id: "nes-pulse",
  label: "NES Pulse",
  loop: true,
  frames: [
    { text: "[■□□] booting thinui", durationMs: 180 },
    { text: "[■■□] booting thinui", durationMs: 180 },
    { text: "[■■■] booting thinui", durationMs: 180 },
  ],
};
