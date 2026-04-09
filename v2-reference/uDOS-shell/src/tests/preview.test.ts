import { test } from "node:test";
import assert from "node:assert/strict";
import { parseUcode } from "../ucode/parser.js";
import { renderCommandPreview } from "../ucode/preview.js";

test("routes wizard commands through the orchestration lane", () => {
  const parsed = parseUcode("#wizard assist draft-brief");
  const preview = renderCommandPreview(parsed);

  assert.equal(preview.owner, "uDOS-wizard");
  assert.equal(preview.lane, "orchestration");
  assert.equal(preview.adapter, "wizard-service");
  assert.equal(preview.runtimeService, "runtime.capability-registry");
  assert.equal(preview.foundationVersion, "v2.0.1");
  assert.ok(preview.runtimeServiceSource.endsWith("uDOS-core/contracts/runtime-services.json"));
  assert.equal(preview.runtimeServiceRoute, "local-kernel");
  assert.equal(preview.sourceVersion, "v2.0.2");
});

test("routes binder commands through the core runtime lane", () => {
  const parsed = parseUcode("#binder create foundation-spine");
  const preview = renderCommandPreview(parsed);

  assert.equal(preview.owner, "uDOS-core");
  assert.equal(preview.lane, "develop");
  assert.equal(preview.adapter, "core-runtime");
  assert.equal(preview.runtimeService, "runtime.command-registry");
  assert.ok(preview.runtimeServiceSource.endsWith("uDOS-core/contracts/runtime-services.json"));
  assert.equal(preview.runtimeServiceRoute, "local-kernel");
  assert.equal(preview.sourceVersion, "v2.0.2");
});
