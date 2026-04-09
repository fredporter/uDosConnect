/**
 * Validates bundled / example / public demo binder JSON files against
 * binder spine v1 (uDOS-core contract). Run from repo root:
 * `npx tsx scripts/validate-binder-spine-payload.ts`
 */
import { readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { parseBinderSpinePayloadV1 } from "../src/workspace/binder-spine-v1";

const here = dirname(fileURLToPath(import.meta.url));
const root = join(here, "..");
const files = [
  join(root, "src/workspace/demo-binder.json"),
  join(root, "demo/public/demo-binder.json"),
  join(root, "examples/demo-binder.json"),
];

for (const f of files) {
  const raw: unknown = JSON.parse(readFileSync(f, "utf8"));
  parseBinderSpinePayloadV1(raw);
}

console.log(`binder spine v1: ok (${files.length} files)`);
