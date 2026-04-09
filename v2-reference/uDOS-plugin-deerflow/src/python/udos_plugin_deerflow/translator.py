from __future__ import annotations

from datetime import datetime, timezone
from typing import Any, Dict, List


def translate_workflow(workflow: Dict[str, Any], upstream_pin: str = "TBD") -> Dict[str, Any]:
    """Translate a minimal uDOS workflow shape into a Deer Flow-oriented graph artifact.

    This is intentionally small and conservative for the scaffold stage.
    """
    nodes: List[Dict[str, Any]] = []
    edges: List[Dict[str, Any]] = []

    for step in workflow.get("steps", []):
        nodes.append(
            {
                "id": step["id"],
                "kind": step.get("kind", "task"),
                "label": step.get("label", step["id"]),
                "config": step.get("config", {}),
            }
        )
        for dep in step.get("dependsOn", []):
            edges.append({"from": dep, "to": step["id"]})

    return {
        "translationVersion": "0.1.0",
        "workflowId": workflow["workflowId"],
        "generatedAt": datetime.now(timezone.utc).isoformat(),
        "upstream": {
            "repo": "https://github.com/bytedance/deer-flow",
            "pinType": "commit",
            "pin": upstream_pin,
        },
        "nodes": nodes,
        "edges": edges,
        "policy": workflow.get(
            "policy",
            {
                "trustClass": "local-wrapped",
                "networkProfile": "offline",
                "filesystemProfile": "staged-output-only",
            },
        ),
    }
