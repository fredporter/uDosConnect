import { loadSkinBundle } from "../src/load-skin.mjs";
import { renderBrowserScreen } from "../src/adapters/browser/index.mjs";
import { renderTuiScreen } from "../src/adapters/tui/index.mjs";
import { buildWorkflowBoard, renderWorkflowText } from "../src/adapters/workflow/index.mjs";
import { renderPublishPage, renderEmailPage } from "../src/adapters/publish/index.mjs";
import {
  createGtxFormPrototype,
  renderBrowserFormStep,
  renderThinUiFormStep,
  renderTuiFormStep,
  submitForm,
} from "../src/adapters/forms/index.mjs";

const browser = renderBrowserScreen({
  title: "uDOS Browser Story",
  intro: "First implementation pass for the browser adapter.",
  sections: [{ title: "Step 1", body: "Render a guided story surface." }],
  actions: [{ label: "Continue" }],
  progress: { current: 1, total: 3, label: "Setup" },
});
if (!browser.html.includes("uDOS Browser Story")) {
  throw new Error("browser adapter smoke failed");
}

const tui = renderTuiScreen({
  title: "uDOS TUI Story",
  subtitle: "guided full viewport",
  steps: [{ title: "Step 1", body: "Render the current action and next choice." }],
  actions: [{ label: "Continue" }],
  progress: { current: 1, total: 3, label: "Setup" },
});
if (!tui.lines.some((line) => line.includes("uDOS TUI Story"))) {
  throw new Error("tui adapter smoke failed");
}

const workflow = buildWorkflowBoard({
  title: "Cursor handover",
  lanes: [
    {
      id: "now",
      title: "Now",
      tasks: [{ id: "runtime", title: "Runtime spine", status: "active", summary: "Keep Ubuntu as the owner." }],
    },
  ],
});
if (!renderWorkflowText(workflow).some((line) => line.includes("Runtime spine"))) {
  throw new Error("workflow adapter smoke failed");
}

const publishHtml = renderPublishPage({
  title: "Publish Story",
  lede: "Tailwind Prose baseline",
  sections: [{ title: "Section", body: "HTML output works." }],
});
if (!publishHtml.includes("prose")) {
  throw new Error("publish adapter smoke failed");
}

const emailHtml = renderEmailPage({
  title: "Email Story",
  lede: "Fallback rendering",
  sections: [{ title: "Section", body: "Email-safe output works." }],
});
if (!emailHtml.includes("<table")) {
  throw new Error("email adapter smoke failed");
}

const form = createGtxFormPrototype();
if (!renderBrowserFormStep(form, 0).includes("Name this runtime")) {
  throw new Error("forms browser smoke failed");
}
if (!renderThinUiFormStep(form, 1).lines.some((line) => line.includes("local-first"))) {
  throw new Error("forms thinui smoke failed");
}
if (!renderTuiFormStep(form, 2).some((line) => line.includes("~/.udos/vault"))) {
  throw new Error("forms tui smoke failed");
}
const submitted = submitForm(form, {
  "runtime-name": "uDOS command centre",
  "network-mode": "local-first",
  "vault-root": "~/.udos/vault",
});
if (!submitted.completed) {
  throw new Error("forms submit smoke failed");
}

const sonicSkin = loadSkinBundle("sonic-boot");
if (sonicSkin.skin.overrides?.loader !== "c64-boot") {
  throw new Error("load-skin sonic-boot smoke failed");
}
const devSkin = loadSkinBundle("dev-lab");
if (devSkin.baseThemeId !== "workflow-default") {
  throw new Error("load-skin dev-lab base theme smoke failed");
}

console.log("uDOS-themes adapter smokes passed");
