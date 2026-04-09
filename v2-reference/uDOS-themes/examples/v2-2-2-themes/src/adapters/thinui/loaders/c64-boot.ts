import type { ThinUiLoaderDefinition } from "../contracts/types";

export const c64BootLoader: ThinUiLoaderDefinition = {
  id: "c64-boot-seq",
  label: "C64 Boot Sequence",
  loop: true,
  frames: [
    { text: "**** UDOS BASIC V2 ****", durationMs: 420 },
    { text: "64K RAM SYSTEM  38911 BASIC BYTES FREE", durationMs: 420 },
    { text: "READY.", durationMs: 300 },
    { text: "LOAD\"UDOS\",8,1", durationMs: 300 },
    { text: "SEARCHING FOR UDOS", durationMs: 320 },
    { text: "LOADING", durationMs: 320 },
    { text: "READY.", durationMs: 300 },
    { text: "RUN", durationMs: 260 },
  ],
};
