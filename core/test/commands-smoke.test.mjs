import { test } from "node:test";
import assert from "node:assert/strict";
import { spawnSync } from "node:child_process";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const repoRoot = path.resolve(__dirname, "..", "..");
const doBin = path.join(repoRoot, "core", "bin", "do.mjs");

function runDo(args) {
  const res = spawnSync(process.execPath, [doBin, ...args], {
    cwd: repoRoot,
    encoding: "utf8",
  });
  const out = `${res.stdout ?? ""}\n${res.stderr ?? ""}`;
  const noAnsi = out.replace(/\x1b\[[0-9;]*m/g, "");
  return { code: res.status ?? 0, output: noAnsi };
}

test("github and pr command groups are exposed", () => {
  const gh = runDo(["github", "--help"]);
  assert.equal(gh.code, 0);
  assert.match(gh.output, /do github/);

  const pr = runDo(["pr", "--help"]);
  assert.equal(pr.code, 0);
  assert.match(pr.output, /do pr/);
});

test("wp command emits A2 upgrade guidance", () => {
  const wp = runDo(["wp", "sync"]);
  assert.equal(wp.code, 0);
  assert.match(wp.output.toLowerCase(), /not implemented in udos a1 wireframe core/);
  assert.match(wp.output.toLowerCase(), /wordpress sync/);
  assert.match(wp.output.toLowerCase(), /udos universe/);
});

test("collab docs route uses wp stub path", () => {
  const submit = runDo(["submit", "docs/guide.md"]);
  assert.equal(submit.code, 0);
  assert.match(submit.output.toLowerCase(), /wordpress draft submission/);
});
