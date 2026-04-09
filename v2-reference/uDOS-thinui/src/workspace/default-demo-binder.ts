import { parseBinderSpinePayloadV1 } from "./binder-spine-v1";
import raw from "./demo-binder.json";

/** Parsed demo binder shipped with ThinUI for the unified workspace demo (spine v1). */
export const defaultDemoBinder = parseBinderSpinePayloadV1(raw as unknown);
