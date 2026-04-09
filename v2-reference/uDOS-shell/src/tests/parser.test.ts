import { test } from "node:test";
import assert from "node:assert/strict";
import { parseUcode } from "../ucode/parser.js";

test("parses binder create", () => {
  const parsed = parseUcode("#binder create client-acme");
  assert.equal(parsed.namespace, "binder");
  assert.equal(parsed.action, "create");
  assert.equal(parsed.args.items, "client-acme");
});
