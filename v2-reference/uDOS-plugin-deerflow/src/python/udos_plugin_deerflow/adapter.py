from __future__ import annotations

import argparse
import json
from pathlib import Path
import re

from translator import translate_workflow
from executor import controlled_execute, dry_run_execute


def load_json(path: str):
    return json.loads(Path(path).read_text(encoding="utf-8"))


def validate_workflow(workflow: dict) -> None:
    if not isinstance(workflow, dict):
        raise ValueError("workflow must be an object")
    if not workflow.get("workflowId"):
        raise ValueError("workflowId is required")
    steps = workflow.get("steps")
    if not isinstance(steps, list) or len(steps) == 0:
        raise ValueError("workflow steps must contain at least one entry")
    for index, step in enumerate(steps):
        if not isinstance(step, dict) or not step.get("id"):
            raise ValueError(f"workflow step at index {index} is missing id")


def compile_manifest_to_workflow(manifest: dict) -> dict:
    if not isinstance(manifest, dict):
        raise ValueError("compile manifest must be an object")

    binder_data = manifest.get("binder")
    compile_data = manifest.get("compile")
    views = manifest.get("views")

    if not isinstance(binder_data, dict) or not binder_data.get("id"):
        raise ValueError("compile manifest binder.id is required")
    if not isinstance(compile_data, dict) or not compile_data.get("id"):
        raise ValueError("compile manifest compile.id is required")
    if not isinstance(views, list) or len(views) == 0:
        raise ValueError("compile manifest views must contain at least one entry")

    workflow_steps = []
    previous_step_id = None
    for view in views:
        if not isinstance(view, dict) or not view.get("id") or not view.get("kind"):
            raise ValueError("compile manifest views entries require id and kind")

        step_id = f"render-{view['id']}"
        step = {
            "id": step_id,
            "kind": "render-view",
            "label": f"Render {view['id']}",
            "dependsOn": [previous_step_id] if previous_step_id else [],
            "config": {
                "binderId": binder_data["id"],
                "binderType": binder_data.get("type", "binder"),
                "compileId": compile_data["id"],
                "target": compile_data.get("target", "workspace"),
                "template": compile_data.get("template", ""),
                "viewId": view["id"],
                "viewKind": view["kind"],
                "fields": view.get("fields", []),
            },
        }
        workflow_steps.append(step)
        previous_step_id = step_id

    return {
        "workflowId": f"compile-{binder_data['id']}-{compile_data['id']}",
        "origin": {
            "source": "uDOS-workspace",
            "binderId": binder_data["id"],
            "compileId": compile_data["id"],
        },
        "policy": {
            "trustClass": "local-wrapped",
            "networkProfile": "offline",
            "filesystemProfile": "staged-output-only",
        },
        "steps": workflow_steps,
    }


def upstream_pin_status(upstream_pin: str) -> dict:
    pinned = bool(re.fullmatch(r"[A-Za-z0-9._-]{4,}", upstream_pin))
    return {
        "pin": upstream_pin,
        "pin_valid": pinned,
        "pin_type": "commit-ish" if pinned else "unknown",
    }


def run_adapter(workflow: dict, upstream_pin: str = "TBD", dry_run: bool = True) -> dict:
    validate_workflow(workflow)
    graph = translate_workflow(workflow, upstream_pin=upstream_pin)
    pin_status = upstream_pin_status(upstream_pin)
    if dry_run:
        result = dry_run_execute(graph)
        result["pinStatus"] = pin_status
        return {"graph": graph, "result": result, "pin_status": pin_status}
    result = controlled_execute(graph)
    result["pinStatus"] = pin_status
    return {"graph": graph, "result": result, "pin_status": pin_status}


def main() -> int:
    parser = argparse.ArgumentParser(description="uDOS Deer Flow adapter scaffold")
    parser.add_argument("--workflow", help="Path to compiled uDOS workflow JSON")
    parser.add_argument("--validate", help="Validate and translate workflow JSON")
    parser.add_argument("--dry-run", action="store_true", help="Do not invoke upstream execution")
    args = parser.parse_args()

    target = args.validate or args.workflow
    if not target:
        parser.error("Provide --workflow or --validate")

    workflow = load_json(target)
    payload = run_adapter(workflow, dry_run=args.dry_run or bool(args.validate))

    if args.validate:
        print(json.dumps(payload["graph"], indent=2))
        return 0

    if args.dry_run:
        print(json.dumps(payload, indent=2))
        return 0

    print(json.dumps(payload, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
