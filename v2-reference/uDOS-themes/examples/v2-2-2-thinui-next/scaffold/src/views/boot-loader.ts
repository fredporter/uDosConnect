import type { ThinUiStatePacket } from "../contracts/thinui";

export function renderBootLoader(state: ThinUiStatePacket): string {
  const title = state.title ?? "uDOS thinui";
  const subtitle = state.subtitle ?? "Preparing local GUI runtime";

  return [
    "╔══════════════════════════════════════════════════════════════╗",
    `║ ${title.padEnd(60, " ")} ║`,
    "╠══════════════════════════════════════════════════════════════╣",
    `║ ${subtitle.padEnd(60, " ")} ║`,
    "║                                                              ║",
    "║ [■■■■□□□□□□] mount vault                                     ║",
    "║ [■■■■■■□□□□] load binder registry                            ║",
    "║ [■■■■■■■■□□] sync local state                               ║",
    "║ [■■■■■■■■■■] ready                                          ║",
    "╚══════════════════════════════════════════════════════════════╝"
  ].join("\n");
}
