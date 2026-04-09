import type { ThinUiLoaderDefinition } from "../contracts/types";

export const teletextCastLoader: ThinUiLoaderDefinition = {
  id: "teletext-cast",
  label: "Teletext Cast",
  loop: true,
  frames: [
    { text: "P100 loading", durationMs: 220 },
    { text: "P101 services ready", durationMs: 220 },
    { text: "P102 display online", durationMs: 220 },
  ],
};
