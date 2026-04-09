import type { ThinUiThemeAdapter } from "../contracts/types";
import { minimalSafeAdapter } from "../adapters/minimal-safe";
import { thinUiC64Adapter } from "../adapters/thinui-c64";
import { thinUiNesSonicAdapter } from "../adapters/thinui-nes-sonic";
import { thinUiTeletextAdapter } from "../adapters/thinui-teletext";

type AdapterEntry = {
  adapter: ThinUiThemeAdapter;
  lowResourceSafe: boolean;
};

export const thinUiAdapterRegistry: Record<string, AdapterEntry> = {
  [thinUiC64Adapter.id]: {
    adapter: thinUiC64Adapter,
    lowResourceSafe: true,
  },
  [thinUiNesSonicAdapter.id]: {
    adapter: thinUiNesSonicAdapter,
    lowResourceSafe: true,
  },
  [thinUiTeletextAdapter.id]: {
    adapter: thinUiTeletextAdapter,
    lowResourceSafe: true,
  },
  [minimalSafeAdapter.id]: {
    adapter: minimalSafeAdapter,
    lowResourceSafe: true,
  },
};
