import { parseDemoBinderJson } from "./parse-demo-binder";
import type { BinderWorkspaceModel } from "./types";

function isRecord(v: unknown): v is Record<string, unknown> {
  return typeof v === "object" && v !== null && !Array.isArray(v);
}

/** True when the JSON declares Core **binder spine payload v1** (`schema_version: "1"`). */
export function isBinderSpineV1Payload(raw: unknown): boolean {
  if (!isRecord(raw)) {
    return false;
  }
  return raw.schema_version === "1";
}

/**
 * Structural checks aligned with `uDOS-core` `schemas/binder-spine-payload.v1.schema.json`
 * (required root + item fields). Throws with a stable prefix for UI/error text.
 */
export function validateBinderSpineV1Json(raw: unknown): void {
  if (!isRecord(raw)) {
    throw new Error("binder-spine-v1: root must be object");
  }
  if (raw.schema_version !== "1") {
    throw new Error('binder-spine-v1: schema_version must be "1"');
  }
  if (typeof raw.id !== "string" || raw.id.length === 0) {
    throw new Error("binder-spine-v1: id must be non-empty string");
  }
  if (typeof raw.title !== "string" || raw.title.length === 0) {
    throw new Error("binder-spine-v1: title must be non-empty string");
  }
  if (!Array.isArray(raw.items) || raw.items.length === 0) {
    throw new Error("binder-spine-v1: items must be non-empty array");
  }
  for (let i = 0; i < raw.items.length; i++) {
    const it = raw.items[i];
    if (!isRecord(it)) {
      throw new Error(`binder-spine-v1: items[${i}] must be object`);
    }
    if (typeof it.id !== "string" || it.id.length === 0) {
      throw new Error(`binder-spine-v1: items[${i}].id must be non-empty string`);
    }
    if (typeof it.title !== "string" || it.title.length === 0) {
      throw new Error(`binder-spine-v1: items[${i}].title must be non-empty string`);
    }
    if (typeof it.recordType !== "string" || it.recordType.length === 0) {
      throw new Error(`binder-spine-v1: items[${i}].recordType must be non-empty string`);
    }
  }
}

/** Parse JSON that is already known to be spine v1 (after fetch or bundled). */
export function parseBinderSpinePayloadV1(raw: unknown): BinderWorkspaceModel {
  validateBinderSpineV1Json(raw);
  return parseDemoBinderJson(raw);
}
