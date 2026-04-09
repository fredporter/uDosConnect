import type { BinderSpinePayloadV1 } from '$lib/spine/binder-spine-v1';
import { recordTypeCounts } from '$lib/spine/binder-spine-v1';

/** Operator-facing snapshot: presentation only; Core remains canonical for persistence. */
export interface BinderOperatorSnapshot {
  schemaVersion: '1';
  binderId: string;
  title: string;
  itemCount: number;
  recordTypes: Record<string, number>;
  /** Fixed demo lane until fetch/API lands in a later round. */
  source: 'sample-spine-v1';
}

export function buildBinderOperatorSnapshot(spine: BinderSpinePayloadV1): BinderOperatorSnapshot {
  return {
    schemaVersion: '1',
    binderId: spine.id,
    title: spine.title,
    itemCount: spine.items.length,
    recordTypes: recordTypeCounts(spine.items),
    source: 'sample-spine-v1'
  };
}
