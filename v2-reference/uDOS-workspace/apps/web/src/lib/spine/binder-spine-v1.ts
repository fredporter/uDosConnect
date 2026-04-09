/**
 * Structural validation for **binder spine payload v1** (uDOS-core contract).
 * Workspace does not own the schema; this mirrors Core/ThinUI checks for operator UX.
 */

export interface BinderSpineItemV1 {
  id: string;
  title: string;
  recordType: string;
  /** Optional fields allowed by Core v1 (forward-compatible). */
  status?: string;
  dueAt?: string;
  scheduledAt?: string;
  summary?: string;
  markdown?: string;
  owner?: string;
}

export interface BinderSpinePayloadV1 {
  schema_version: '1';
  id: string;
  title: string;
  items: BinderSpineItemV1[];
}

function isRecord(v: unknown): v is Record<string, unknown> {
  return typeof v === 'object' && v !== null && !Array.isArray(v);
}

export function validateBinderSpineV1Json(raw: unknown): asserts raw is BinderSpinePayloadV1 {
  if (!isRecord(raw)) {
    throw new Error('binder-spine-v1: root must be object');
  }
  if (raw.schema_version !== '1') {
    throw new Error('binder-spine-v1: schema_version must be "1"');
  }
  if (typeof raw.id !== 'string' || raw.id.length === 0) {
    throw new Error('binder-spine-v1: id must be non-empty string');
  }
  if (typeof raw.title !== 'string' || raw.title.length === 0) {
    throw new Error('binder-spine-v1: title must be non-empty string');
  }
  if (!Array.isArray(raw.items) || raw.items.length === 0) {
    throw new Error('binder-spine-v1: items must be non-empty array');
  }
  for (let i = 0; i < raw.items.length; i++) {
    const it = raw.items[i];
    if (!isRecord(it)) {
      throw new Error(`binder-spine-v1: items[${i}] must be object`);
    }
    if (typeof it.id !== 'string' || it.id.length === 0) {
      throw new Error(`binder-spine-v1: items[${i}].id must be non-empty string`);
    }
    if (typeof it.title !== 'string' || it.title.length === 0) {
      throw new Error(`binder-spine-v1: items[${i}].title must be non-empty string`);
    }
    if (typeof it.recordType !== 'string' || it.recordType.length === 0) {
      throw new Error(`binder-spine-v1: items[${i}].recordType must be non-empty string`);
    }
  }
}

export function recordTypeCounts(items: BinderSpineItemV1[]): Record<string, number> {
  const out: Record<string, number> = {};
  for (const it of items) {
    const k = it.recordType;
    out[k] = (out[k] ?? 0) + 1;
  }
  return out;
}
