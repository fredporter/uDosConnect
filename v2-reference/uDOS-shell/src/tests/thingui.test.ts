import { test } from "node:test";
import assert from "node:assert/strict";
import { launchThinGui } from "../thingui/index.js";

test("builds a thin gui handoff url against wizard", () => {
  const url = launchThinGui("render-preview", {
    target: "web-prose",
    prosePreset: "prose-reference",
    themeAdapter: "public-sunset-prose",
    title: "Preview Deck",
  });

  assert.equal(
    url,
    "http://127.0.0.1:8787/thin?route=render-preview&target=web-prose&prosePreset=prose-reference&themeAdapter=public-sunset-prose&title=Preview+Deck",
  );
});

test("allows custom wizard base urls", () => {
  const url = launchThinGui("beacon-library", {
    baseUrl: "http://127.0.0.1:58008/",
    target: "beacon-library",
  });

  assert.equal(
    url,
    "http://127.0.0.1:58008/thin?route=beacon-library&target=beacon-library&prosePreset=prose-default",
  );
});
