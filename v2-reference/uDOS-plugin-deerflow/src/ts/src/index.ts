import { readFileSync } from "node:fs";
import { buildGraph } from "./buildGraph.js";

const inputPath = process.argv[2];
if (!inputPath) {
  console.error("Usage: node dist/index.js <workflow.json>");
  process.exit(1);
}

const workflow = JSON.parse(readFileSync(inputPath, "utf8"));
const graph = buildGraph(workflow);
console.log(JSON.stringify(graph, null, 2));
