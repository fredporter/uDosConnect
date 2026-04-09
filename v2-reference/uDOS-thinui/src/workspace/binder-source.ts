import { defaultDemoBinder } from "./default-demo-binder";
import { isBinderSpineV1Payload, parseBinderSpinePayloadV1 } from "./binder-spine-v1";
import { parseDemoBinderJson } from "./parse-demo-binder";
import type { BinderWorkspaceModel } from "./types";

/** Pluggable binder snapshot for the unified workspace (Round 1 bridge tranche). */
export type BinderWorkspaceSource = {
  loadBinder(): Promise<BinderWorkspaceModel>;
};

export function createBundledDemoBinderSource(): BinderWorkspaceSource {
  return {
    async loadBinder(): Promise<BinderWorkspaceModel> {
      return defaultDemoBinder;
    },
  };
}

export type FetchBinderSourceOptions = {
  /**
   * When true, always use the legacy parser (no spine v1 validation), for JSON
   * without `schema_version` or for smoke tests.
   */
  legacy?: boolean;
};

/**
 * Load binder JSON from an absolute URL (same-origin or CORS-allowed).
 * If the payload has `schema_version: "1"`, it is validated and parsed as
 * **binder spine v1** (aligned with `uDOS-core`). Otherwise the legacy
 * `parseDemoBinderJson` path is used.
 */
export function createFetchBinderSource(
  url: string,
  options?: FetchBinderSourceOptions,
): BinderWorkspaceSource {
  const resolved = url.trim();
  if (!resolved) {
    throw new Error("binder-source: fetch URL is empty");
  }
  const legacy = options?.legacy === true;
  return {
    async loadBinder(): Promise<BinderWorkspaceModel> {
      const res = await fetch(resolved);
      if (!res.ok) {
        throw new Error(`binder-source: fetch ${resolved} → ${res.status}`);
      }
      const json: unknown = await res.json();
      if (legacy) {
        return parseDemoBinderJson(json);
      }
      if (isBinderSpineV1Payload(json)) {
        return parseBinderSpinePayloadV1(json);
      }
      return parseDemoBinderJson(json);
    },
  };
}

/**
 * Browser helper: `?binder=<url>` uses fetch; omit param for bundled demo.
 * Relative URLs resolve against the current document (e.g. `demo-binder.json` or `/demo-binder.json`).
 *
 * - **`binderLegacy=1`**: force legacy parse (skip spine v1 checks) for fetched JSON.
 * - Host-backed JSON: use a same-origin path or full URL (e.g. `/api/binder.json`) as `binder=`.
 */
export function createBinderSourceFromLocationSearch(search: string): BinderWorkspaceSource {
  const params = new URLSearchParams(search.startsWith("?") ? search.slice(1) : search);
  const raw = params.get("binder")?.trim();
  if (!raw) {
    return createBundledDemoBinderSource();
  }
  const legacy =
    params.get("binderLegacy") === "1" || params.get("binderLegacy")?.toLowerCase() === "true";
  const base =
    typeof globalThis.location !== "undefined" && globalThis.location?.href
      ? globalThis.location.href
      : "http://localhost/";
  const url = new URL(raw, base).toString();
  return createFetchBinderSource(url, { legacy });
}
