#!/usr/bin/env node
/**
 * Shell CLI demo: print TUI lines for a GTX form step using themes forms adapter.
 * Canonical JSON: examples/gtx-form-flow.json (override with --json).
 */
import fs from "fs";
import path from "path";
import { createGtxFormPrototype, renderTuiFormStep } from "../src/adapters/forms/index.mjs";

function usage() {
  process.stderr.write(`Usage: node scripts/demo-gtx-form-tui.mjs [--step N] [--step-id ID] [--json PATH] [--all]

  --step N      0-based step index (default: 0)
  --step-id ID  step id from JSON (e.g. runtime-name); overrides --step when set
  --json PATH   form definition JSON (default: examples/gtx-form-flow.json)
  --all         print every step, separated by --- markers
`);
}

function loadForm(jsonPath) {
  const raw = JSON.parse(fs.readFileSync(jsonPath, "utf8"));
  if (!raw.id || !Array.isArray(raw.steps) || raw.steps.length < 1) {
    throw new Error(`invalid form JSON: ${jsonPath}`);
  }
  return {
    id: raw.id,
    title: raw.title ?? raw.id,
    adapter: raw.adapter ?? "forms-gtx-step",
    steps: raw.steps,
  };
}

function parseArgs(argv) {
  let stepIndex = 0;
  let stepId = null;
  let jsonPath = null;
  let all = false;
  for (let i = 2; i < argv.length; i++) {
    const a = argv[i];
    if (a === "-h" || a === "--help") {
      usage();
      process.exit(0);
    }
    if (a === "--all") {
      all = true;
      continue;
    }
    if ((a === "--step" || a === "--step-id" || a === "--json") && argv[i + 1]) {
      const v = argv[++i];
      if (a === "--step") {
        stepIndex = Number(v, 10);
        if (!Number.isInteger(stepIndex) || stepIndex < 0) {
          throw new Error(`invalid --step: ${v}`);
        }
      } else if (a === "--step-id") {
        stepId = v;
      } else {
        jsonPath = v;
      }
      continue;
    }
    throw new Error(`unknown argument: ${a}`);
  }
  return { stepIndex, stepId, jsonPath, all };
}

const { stepIndex, stepId, jsonPath, all } = parseArgs(process.argv);
const resolvedJson = jsonPath ? path.resolve(process.cwd(), jsonPath) : null;
const form = resolvedJson ? loadForm(resolvedJson) : createGtxFormPrototype();

let index = stepIndex;
if (stepId) {
  const found = form.steps.findIndex((s) => s.id === stepId);
  if (found < 0) {
    process.stderr.write(`unknown step_id: ${stepId}\n`);
    process.exit(1);
  }
  index = found;
}

if (all) {
  for (let i = 0; i < form.steps.length; i++) {
    if (i > 0) console.log("\n---\n");
    for (const line of renderTuiFormStep(form, i)) {
      console.log(line);
    }
  }
} else {
  if (index >= form.steps.length) {
    process.stderr.write(`step index ${index} out of range (0..${form.steps.length - 1})\n`);
    process.exit(1);
  }
  for (const line of renderTuiFormStep(form, index)) {
    console.log(line);
  }
}
