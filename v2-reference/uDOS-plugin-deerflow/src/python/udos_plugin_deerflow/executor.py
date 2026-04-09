from __future__ import annotations

import uuid
from datetime import datetime, timezone
from typing import Any, Dict


def dry_run_execute(graph: Dict[str, Any]) -> Dict[str, Any]:
    """Return a normalized dry-run result without invoking upstream Deer Flow."""
    started = datetime.now(timezone.utc)
    finished = datetime.now(timezone.utc)

    return {
        "executionId": str(uuid.uuid4()),
        "workflowId": graph["workflowId"],
        "status": "dry-run",
        "startedAt": started.isoformat(),
        "finishedAt": finished.isoformat(),
        "upstream": graph["upstream"],
        "summary": {
            "completed": len(graph.get("nodes", [])),
            "failed": 0,
            "artifactsProduced": 0,
            "message": "Dry run only. No upstream execution performed.",
        },
        "nodes": [
            {
                "id": node["id"],
                "status": "dry-run",
                "kind": node.get("kind", "task"),
                "label": node.get("label", node["id"]),
            }
            for node in graph.get("nodes", [])
        ],
        "artifacts": [],
    }


def controlled_execute(graph: Dict[str, Any]) -> Dict[str, Any]:
    """Return a normalized local controlled-execution result."""
    started = datetime.now(timezone.utc)
    finished = datetime.now(timezone.utc)
    workflow_id = graph["workflowId"]
    nodes = graph.get("nodes", [])
    artifacts = [
        {
            "artifactId": f"{workflow_id}:{node['id']}:render",
            "kind": "rendered-view",
            "path": f"vault://deerflow/{workflow_id}/{node['id']}.md",
            "nodeId": node["id"],
            "label": node.get("label", node["id"]),
        }
        for node in nodes
    ]

    return {
        "executionId": str(uuid.uuid4()),
        "workflowId": workflow_id,
        "status": "completed",
        "startedAt": started.isoformat(),
        "finishedAt": finished.isoformat(),
        "upstream": graph["upstream"],
        "summary": {
            "completed": len(nodes),
            "failed": 0,
            "artifactsProduced": len(artifacts),
            "message": "Controlled local Deer Flow execution completed.",
        },
        "nodes": [
            {
                "id": node["id"],
                "status": "completed",
                "kind": node.get("kind", "task"),
                "label": node.get("label", node["id"]),
            }
            for node in nodes
        ],
        "artifacts": artifacts,
    }
