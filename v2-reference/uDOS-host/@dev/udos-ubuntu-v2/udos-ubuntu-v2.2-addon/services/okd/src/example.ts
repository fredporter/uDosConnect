import { OkRoutingEngine } from "./routingEngine.js";

const engine = new OkRoutingEngine();

const result = await engine.run({
  id: "job-001",
  requestClass: "transformation",
  input: "# Hello\n\nThis   is   a     messy   markdown doc.",
  allowRemote: true,
  budgetGroup: "tier0_free",
  target: { binder: "#demo", mode: "merge" }
});

console.log(result);
