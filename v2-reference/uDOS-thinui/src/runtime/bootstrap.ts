import { MockThinUiCoreBridge } from "../bridge/mock-core";
import type { ThinUiStatePacket } from "../contracts/state";
import {
  resolveBuiltinSurfaceProfile,
  thinUiSeedFromSurfaceProfile,
  type SurfaceProfileThinUiV01,
} from "../surface/surface-profile";
import { createBinderSelectView } from "../views/binder-select";
import { createBootLoaderView } from "../views/boot-loader";
import { createHandoffToBrowserView } from "../views/handoff-to-browser";
import { createHomeLauncherView } from "../views/home-launcher";
import { createOperationProgressView } from "../views/operation-progress";
import { createRecoveryPanelView } from "../views/recovery-panel";
import { createSyncStatusView } from "../views/sync-status";
import { createTeletextDisplayView } from "../views/teletext-display";
import { createUtilityPanelView } from "../views/utility-panel";
import { ThinUiRuntimeLoop } from "./runtime-loop";
import type { ThinUiFrameRenderer } from "./runtime-loop";
import { ThinUiViewRegistry } from "./view-registry";
import type { ThinUiThemeResolver } from "./types";

export type CreateThinUiRuntimeOptions = {
  seedState?: Partial<ThinUiStatePacket>;
  renderFrame?: ThinUiFrameRenderer;
  themeResolver?: ThinUiThemeResolver;
  /** Built-in surface profile id (e.g. `ubuntu-gnome`); merged before `seedState`. */
  surfaceProfileId?: string;
  /**
   * Parsed surface profile JSON (e.g. from disk). Takes precedence over `surfaceProfileId`.
   */
  surfaceProfileData?: SurfaceProfileThinUiV01;
};

function mergeSeedWithSurfaceProfile(
  options: Pick<CreateThinUiRuntimeOptions, "surfaceProfileId" | "surfaceProfileData">,
  seedState?: Partial<ThinUiStatePacket>,
): Partial<ThinUiStatePacket> | undefined {
  const profile: SurfaceProfileThinUiV01 | undefined =
    options.surfaceProfileData ??
    (options.surfaceProfileId ? resolveBuiltinSurfaceProfile(options.surfaceProfileId) : undefined);
  if (!profile) {
    return seedState;
  }
  const { seed } = thinUiSeedFromSurfaceProfile(profile);
  return { ...seed, ...seedState };
}

export function createThinUiRuntime(options: CreateThinUiRuntimeOptions = {}) {
  const registry = new ThinUiViewRegistry();
  registry.register(createBootLoaderView());
  registry.register(createHomeLauncherView());
  registry.register(createBinderSelectView());
  registry.register(createOperationProgressView());
  registry.register(createSyncStatusView());
  registry.register(createRecoveryPanelView());
  registry.register(createHandoffToBrowserView());
  registry.register(createUtilityPanelView());
  registry.register(createTeletextDisplayView());

  const coreBridge = new MockThinUiCoreBridge(
    mergeSeedWithSurfaceProfile(options, options.seedState),
  );

  const frameRenderer: ThinUiFrameRenderer =
    options.renderFrame ??
    ((frame) => {
      // Default renderer is console-first so the scaffold can run without GUI dependencies.
      console.log(frame.lines.join("\n"));
    });

  const runtime = new ThinUiRuntimeLoop(
    coreBridge,
    registry,
    frameRenderer,
    options.themeResolver,
  );

  return runtime;
}
