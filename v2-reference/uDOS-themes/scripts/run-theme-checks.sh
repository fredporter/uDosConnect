#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

require_file() {
  if [ ! -f "$1" ]; then
    echo "missing required file: $1" >&2
    exit 1
  fi
}

cd "$REPO_ROOT"

require_file "$REPO_ROOT/README.md"
require_file "$REPO_ROOT/docs/architecture.md"
require_file "$REPO_ROOT/docs/boundary.md"
require_file "$REPO_ROOT/docs/getting-started.md"
require_file "$REPO_ROOT/docs/examples.md"
require_file "$REPO_ROOT/docs/activation.md"
require_file "$REPO_ROOT/src/README.md"
require_file "$REPO_ROOT/src/theme-tokens.json"
require_file "$REPO_ROOT/src/tokens/README.md"
require_file "$REPO_ROOT/src/tokens/base-tokens.json"
require_file "$REPO_ROOT/src/components/README.md"
require_file "$REPO_ROOT/src/components/primitives.json"
require_file "$REPO_ROOT/src/adapters/README.md"
require_file "$REPO_ROOT/src/adapters/browser/README.md"
require_file "$REPO_ROOT/src/adapters/browser/adapter-contract.json"
require_file "$REPO_ROOT/src/adapters/browser/index.mjs"
require_file "$REPO_ROOT/src/adapters/tui/README.md"
require_file "$REPO_ROOT/src/adapters/tui/adapter-contract.json"
require_file "$REPO_ROOT/src/adapters/tui/index.mjs"
require_file "$REPO_ROOT/src/adapters/workflow/README.md"
require_file "$REPO_ROOT/src/adapters/workflow/adapter-contract.json"
require_file "$REPO_ROOT/src/adapters/workflow/index.mjs"
require_file "$REPO_ROOT/src/adapters/workflow/gtx-step-task-map.json"
require_file "$REPO_ROOT/src/adapters/publish/README.md"
require_file "$REPO_ROOT/src/adapters/publish/adapter-contract.json"
require_file "$REPO_ROOT/src/adapters/publish/index.mjs"
require_file "$REPO_ROOT/src/adapters/publish/tailwind-prose-preset.json"
require_file "$REPO_ROOT/src/adapters/forms/README.md"
require_file "$REPO_ROOT/src/adapters/forms/adapter-contract.json"
require_file "$REPO_ROOT/src/adapters/forms/index.mjs"
require_file "$REPO_ROOT/src/adapters/forms/gtx-form-prototype.mjs"
require_file "$REPO_ROOT/src/adapters/index.mjs"
require_file "$REPO_ROOT/src/shell-theme-map.json"
require_file "$REPO_ROOT/src/publishing-theme-map.json"
require_file "$REPO_ROOT/src/prose-preset-map.json"
require_file "$REPO_ROOT/src/gameplay-skin-map.json"
require_file "$REPO_ROOT/src/themes/README.md"
require_file "$REPO_ROOT/src/themes/browser-default.json"
require_file "$REPO_ROOT/src/themes/thinui-c64.json"
require_file "$REPO_ROOT/src/themes/thinui-nes-sonic.json"
require_file "$REPO_ROOT/src/themes/thinui-minimal-safe.json"
require_file "$REPO_ROOT/src/themes/workflow-default.json"
require_file "$REPO_ROOT/src/themes/publish-prose-default.json"
require_file "$REPO_ROOT/src/themes/gtx-form-default.json"
require_file "$REPO_ROOT/src/skins/README.md"
require_file "$REPO_ROOT/src/skins/sonic-boot.json"
require_file "$REPO_ROOT/src/skins/empire-editorial.json"
require_file "$REPO_ROOT/src/skins/alpine-safe.json"
require_file "$REPO_ROOT/src/skins/dev-lab.json"
require_file "$REPO_ROOT/registry/README.md"
require_file "$REPO_ROOT/registry/theme-registry.json"
require_file "$REPO_ROOT/registry/adapter-registry.json"
require_file "$REPO_ROOT/registry/skin-registry.json"
require_file "$REPO_ROOT/scripts/README.md"
require_file "$REPO_ROOT/scripts/sync-theme-tokens-to-workspace.sh"
require_file "$REPO_ROOT/scripts/sync-publish-prose-preset-to-workspace.sh"
require_file "$REPO_ROOT/scripts/sync-publish-prose-preset-to-package.sh"
require_file "$REPO_ROOT/scripts/sync-gtx-step-task-map-to-wizard.sh"
require_file "$REPO_ROOT/scripts/smoke-adapters.mjs"
require_file "$REPO_ROOT/scripts/demo-gtx-form-tui.mjs"
require_file "$REPO_ROOT/packages/tailwind-prose-preset/package.json"
require_file "$REPO_ROOT/packages/tailwind-prose-preset/README.md"
require_file "$REPO_ROOT/packages/tailwind-prose-preset/tailwind-prose-preset.json"
require_file "$REPO_ROOT/tests/README.md"
require_file "$REPO_ROOT/config/README.md"
require_file "$REPO_ROOT/examples/README.md"
require_file "$REPO_ROOT/examples/basic-theme.json"
require_file "$REPO_ROOT/examples/gtx-form-flow.json"
require_file "$REPO_ROOT/examples/cross-surface-rendering-matrix.json"
require_file "$REPO_ROOT/docs/v2.0.1-theme-foundation.md"
require_file "$REPO_ROOT/docs/v2.2.1-integrated-design-system.md"
require_file "$REPO_ROOT/docs/theme-upstream-index.md"
require_file "$REPO_ROOT/docs/theme-fork-rollout.md"
require_file "$REPO_ROOT/docs/workspace-06-next-round.md"
require_file "$REPO_ROOT/docs/display-modes.md"
require_file "$REPO_ROOT/docs/theme-token-standard.md"
require_file "$REPO_ROOT/docs/step-form-presentation-rules.md"
require_file "$REPO_ROOT/docs/adapter-skin-registry-plan.md"
require_file "$REPO_ROOT/docs/integration-thinui-workflow-prose-gtx.md"
require_file "$REPO_ROOT/src/load-skin.mjs"
require_file "$REPO_ROOT/wiki/credits-and-inspiration.md"
require_file "$REPO_ROOT/vendor/README.md"
require_file "$REPO_ROOT/vendor/forks/README.md"
require_file "$REPO_ROOT/vendor/fonts/README.md"
require_file "$REPO_ROOT/.gitmodules"

python3 - <<'PY'
import json
from pathlib import Path

repo_root = Path(".").resolve()
source = json.loads((repo_root / "src" / "theme-tokens.json").read_text(encoding="utf-8"))
example = json.loads((repo_root / "examples" / "basic-theme.json").read_text(encoding="utf-8"))
shell_map = json.loads((repo_root / "src" / "shell-theme-map.json").read_text(encoding="utf-8"))
publishing_map = json.loads((repo_root / "src" / "publishing-theme-map.json").read_text(encoding="utf-8"))
base_tokens = json.loads((repo_root / "src" / "tokens" / "base-tokens.json").read_text(encoding="utf-8"))
primitives = json.loads((repo_root / "src" / "components" / "primitives.json").read_text(encoding="utf-8"))
theme_registry = json.loads((repo_root / "registry" / "theme-registry.json").read_text(encoding="utf-8"))
adapter_registry = json.loads((repo_root / "registry" / "adapter-registry.json").read_text(encoding="utf-8"))
skin_registry = json.loads((repo_root / "registry" / "skin-registry.json").read_text(encoding="utf-8"))
form_flow = json.loads((repo_root / "examples" / "gtx-form-flow.json").read_text(encoding="utf-8"))
render_matrix = json.loads((repo_root / "examples" / "cross-surface-rendering-matrix.json").read_text(encoding="utf-8"))
prose_preset = json.loads((repo_root / "src" / "adapters" / "publish" / "tailwind-prose-preset.json").read_text(encoding="utf-8"))
prose_preset_pkg = json.loads((repo_root / "packages" / "tailwind-prose-preset" / "tailwind-prose-preset.json").read_text(encoding="utf-8"))
workflow_gtx_map = json.loads((repo_root / "src" / "adapters" / "workflow" / "gtx-step-task-map.json").read_text(encoding="utf-8"))

required = {"theme", "owner", "surface", "tokens"}
for name, payload in {"src/theme-tokens.json": source, "examples/basic-theme.json": example}.items():
    missing = sorted(required - payload.keys())
    if missing:
        raise SystemExit(f"{name} missing required fields: {missing}")
    if not isinstance(payload["tokens"], dict):
        raise SystemExit(f"{name} tokens must be an object")

for name, payload in {
    "src/shell-theme-map.json": shell_map,
    "src/publishing-theme-map.json": publishing_map,
}.items():
    if payload.get("version") != "v2.2.1":
        raise SystemExit(f"{name} version must be v2.2.1")
    if not isinstance(payload.get("themes"), list) or not payload["themes"]:
        raise SystemExit(f"{name} themes must be a non-empty array")
    for theme in payload["themes"]:
        if not {"theme", "adapter", "tokens"} <= theme.keys():
            raise SystemExit(f"{name} theme entry missing required fields: {theme}")
        if not isinstance(theme["tokens"], dict):
            raise SystemExit(f"{name} theme tokens must be an object")

required_categories = {
    "color",
    "typography",
    "spacing",
    "radius",
    "border",
    "shadow",
    "motion",
    "density",
    "surface",
    "state",
    "feedback",
    "focus",
    "input",
}
if set(base_tokens.get("token_categories", [])) != required_categories:
    raise SystemExit("src/tokens/base-tokens.json must define the required v2.2.1 token categories")

if source.get("version") != "v2.2.1":
    raise SystemExit("src/theme-tokens.json version must be v2.2.1")
if set(source["tokens"].keys()) != required_categories:
    raise SystemExit("src/theme-tokens.json tokens must include the full v2.2.1 token category set")

if primitives.get("version") != "v2.2.1":
    raise SystemExit("src/components/primitives.json version must be v2.2.1")
if "button" not in primitives.get("primitives", []):
    raise SystemExit("src/components/primitives.json must include button")
if "form-step" not in primitives.get("form_primitives", []):
    raise SystemExit("src/components/primitives.json must include form-step")

theme_ids = {item["theme_id"] for item in theme_registry.get("themes", [])}
adapter_ids = {item["adapter_id"] for item in adapter_registry.get("adapters", [])}
skin_ids = {item["skin_id"] for item in skin_registry.get("skins", [])}
required_theme_ids = {
    "browser-default",
    "thinui-c64",
    "thinui-nes-sonic",
    "thinui-minimal-safe",
    "workflow-default",
    "publish-prose-default",
    "gtx-form-default",
}
required_adapter_ids = {
    "browser-default",
    "thinui-default",
    "tui-default",
    "workflow-default",
    "publish-tailwind-prose",
    "forms-gtx-step",
}
required_skin_ids = {
    "sonic-boot",
    "empire-editorial",
    "alpine-safe",
    "dev-lab",
}
if not required_theme_ids <= theme_ids:
    raise SystemExit("registry/theme-registry.json missing required themes")
if not required_adapter_ids <= adapter_ids:
    raise SystemExit("registry/adapter-registry.json missing required adapters")
if not required_skin_ids <= skin_ids:
    raise SystemExit("registry/skin-registry.json missing required skins")

for item in theme_registry.get("themes", []):
    if not (repo_root / item["theme_ref"]).is_file():
        raise SystemExit(f"theme ref missing: {item['theme_ref']}")

for item in skin_registry.get("skins", []):
    if item["base_theme"] not in theme_ids:
        raise SystemExit(f"skin base_theme missing from theme registry: {item}")
    if not (repo_root / item["skin_ref"]).is_file():
        raise SystemExit(f"skin ref missing: {item['skin_ref']}")

for item in adapter_registry.get("adapters", []):
    contract_ref = repo_root / item["contract_ref"]
    if not contract_ref.exists():
        raise SystemExit(f"adapter contract missing: {item['contract_ref']}")

if not isinstance(form_flow.get("steps"), list) or len(form_flow["steps"]) < 3:
    raise SystemExit("examples/gtx-form-flow.json must define at least three form steps")
if set(render_matrix.get("surfaces", [])) != {"browser", "thinui", "tui", "workflow", "publish", "forms"}:
    raise SystemExit("examples/cross-surface-rendering-matrix.json must define the required surfaces")

if prose_preset != prose_preset_pkg:
    raise SystemExit("packages/tailwind-prose-preset/tailwind-prose-preset.json must match src/adapters/publish/tailwind-prose-preset.json")

if prose_preset.get("preset_id") != "prose-tailwind-default":
    raise SystemExit("src/adapters/publish/tailwind-prose-preset.json preset_id must be prose-tailwind-default")
if prose_preset.get("owner") != "uDOS-themes":
    raise SystemExit("src/adapters/publish/tailwind-prose-preset.json owner must be uDOS-themes")
article_classes = prose_preset.get("classes", {}).get("article", "")
if not isinstance(article_classes, str) or "prose" not in article_classes.split():
    raise SystemExit("src/adapters/publish/tailwind-prose-preset.json classes.article must include prose")

if workflow_gtx_map.get("map_id") != "workflow-gtx-step-task-map":
    raise SystemExit("src/adapters/workflow/gtx-step-task-map.json map_id must be workflow-gtx-step-task-map")
if workflow_gtx_map.get("owner") != "uDOS-themes":
    raise SystemExit("src/adapters/workflow/gtx-step-task-map.json owner must be uDOS-themes")
gtx_steps = {step.get("id") for step in form_flow.get("steps", [])}
map_entries = workflow_gtx_map.get("mappings", [])
if not isinstance(map_entries, list) or not map_entries:
    raise SystemExit("src/adapters/workflow/gtx-step-task-map.json mappings must be a non-empty array")
mapped_steps = {entry.get("step_id") for entry in map_entries}
if gtx_steps != mapped_steps:
    raise SystemExit("src/adapters/workflow/gtx-step-task-map.json must cover all GTX step ids exactly")
for entry in map_entries:
    if not {"step_id", "task_id", "lane_id", "title"} <= set(entry.keys()):
        raise SystemExit("workflow GTX map entries must include step_id, task_id, lane_id, title")

required_primitives = render_matrix.get("required_primitives", [])
pmap = render_matrix.get("primitive_surface_map", {})
if set(pmap.keys()) != set(required_primitives):
    raise SystemExit("examples/cross-surface-rendering-matrix.json primitive_surface_map keys must match required_primitives")
surface_set = set(render_matrix["surfaces"])
for prim, row in pmap.items():
    if set(row.keys()) != surface_set:
        raise SystemExit(f"examples/cross-surface-rendering-matrix.json primitive_surface_map[{prim}] must list every surface")
    for _surf, adapter_id in row.items():
        if adapter_id not in adapter_ids:
            raise SystemExit(f"primitive_surface_map uses unknown adapter_id: {adapter_id}")
PY

if command -v rg >/dev/null 2>&1; then
  if rg -n '/Users/fredbook/Code|~/Users/fredbook/Code' \
    "$REPO_ROOT/README.md" \
    "$REPO_ROOT/docs" \
    "$REPO_ROOT/src" \
    "$REPO_ROOT/tests" \
    "$REPO_ROOT/examples" \
    "$REPO_ROOT/config"; then
    echo "private local-root reference found in uDOS-themes" >&2
    exit 1
  fi
else
  if grep -R -nE '/Users/fredbook/Code|~/Users/fredbook/Code' \
    "$REPO_ROOT/README.md" \
    "$REPO_ROOT/docs" \
    "$REPO_ROOT/src" \
    "$REPO_ROOT/tests" \
    "$REPO_ROOT/examples" \
    "$REPO_ROOT/config" >/dev/null 2>&1; then
    echo "private local-root reference found in uDOS-themes" >&2
    exit 1
  fi
fi

if command -v node >/dev/null 2>&1; then
  node "$REPO_ROOT/scripts/smoke-adapters.mjs" >/dev/null
  DEMO_OUT="$(node "$REPO_ROOT/scripts/demo-gtx-form-tui.mjs" --step 0)"
  if ! echo "$DEMO_OUT" | grep -q "Runtime Setup Story"; then
    echo "demo-gtx-form-tui.mjs --step 0 did not emit expected title" >&2
    exit 1
  fi
  DEMO_ALL="$(node "$REPO_ROOT/scripts/demo-gtx-form-tui.mjs" --all)"
  if ! echo "$DEMO_ALL" | grep -q "~/.udos/vault"; then
    echo "demo-gtx-form-tui.mjs --all did not emit vault placeholder" >&2
    exit 1
  fi
fi

echo "uDOS-themes checks passed"
