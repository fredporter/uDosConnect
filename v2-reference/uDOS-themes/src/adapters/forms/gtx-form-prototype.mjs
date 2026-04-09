import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));

export function createGtxFormPrototype() {
  const flowPath = path.resolve(__dirname, "../../../examples/gtx-form-flow.json");
  const raw = JSON.parse(fs.readFileSync(flowPath, "utf8"));
  if (!raw.id || !Array.isArray(raw.steps) || raw.steps.length < 3) {
    throw new Error("createGtxFormPrototype: invalid examples/gtx-form-flow.json");
  }
  return {
    id: raw.id,
    title: raw.title ?? raw.id,
    adapter: raw.adapter ?? "forms-gtx-step",
    steps: raw.steps,
  };
}
