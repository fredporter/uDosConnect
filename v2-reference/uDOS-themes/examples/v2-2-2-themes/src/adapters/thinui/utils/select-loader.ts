import type { ThinUiLoaderDefinition } from "../contracts/types";
import { c64BootLoader } from "../loaders/c64-boot";
import { minimalSafeLoader } from "../loaders/minimal-safe";
import { nesPulseLoader } from "../loaders/nes-pulse";

const loaderRegistry: Record<string, ThinUiLoaderDefinition> = {
  [c64BootLoader.id]: c64BootLoader,
  [nesPulseLoader.id]: nesPulseLoader,
  [minimalSafeLoader.id]: minimalSafeLoader,
};

export function selectLoader(loaderId: string): ThinUiLoaderDefinition {
  return loaderRegistry[loaderId] ?? minimalSafeLoader;
}
