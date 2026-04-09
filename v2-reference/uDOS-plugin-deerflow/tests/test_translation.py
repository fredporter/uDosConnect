import json
import sys
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src/python/udos_plugin_deerflow"))

from translator import translate_workflow  # noqa: E402
from executor import controlled_execute, dry_run_execute  # noqa: E402
from adapter import compile_manifest_to_workflow, run_adapter, upstream_pin_status, validate_workflow  # noqa: E402


class TranslationTests(unittest.TestCase):
    def test_translation_builds_nodes_and_edges(self):
        workflow = json.loads((ROOT / "examples/workflows/sample.workflow.json").read_text())
        graph = translate_workflow(workflow, upstream_pin="abc123")
        self.assertEqual(graph["workflowId"], "family-live-show-research")
        self.assertEqual(len(graph["nodes"]), 4)
        self.assertEqual(len(graph["edges"]), 3)
        self.assertEqual(graph["upstream"]["pin"], "abc123")

    def test_dry_run_execute_returns_normalized_node_statuses(self):
        workflow = json.loads((ROOT / "examples/workflows/sample.workflow.json").read_text())
        graph = translate_workflow(workflow, upstream_pin="abc123")
        result = dry_run_execute(graph)
        self.assertEqual(result["status"], "dry-run")
        self.assertEqual(result["summary"]["completed"], 4)
        self.assertEqual(result["nodes"][0]["status"], "dry-run")
        self.assertEqual(result["artifacts"], [])

    def test_run_adapter_returns_graph_and_result(self):
        workflow = json.loads((ROOT / "examples/workflows/sample.workflow.json").read_text())
        payload = run_adapter(workflow, upstream_pin="abc123", dry_run=True)
        self.assertIn("graph", payload)
        self.assertIn("result", payload)
        self.assertEqual(payload["graph"]["upstream"]["pin"], "abc123")
        self.assertEqual(payload["result"]["executionId"] != "", True)

    def test_validate_workflow_rejects_missing_steps(self):
        with self.assertRaisesRegex(ValueError, "workflow steps must contain at least one entry"):
            validate_workflow({"workflowId": "broken", "steps": []})

    def test_compile_manifest_to_workflow_builds_render_steps(self):
        workflow = compile_manifest_to_workflow(
            {
                "version": 1,
                "binder": {"id": "campaign-1", "type": "campaign", "title": "Campaign 1"},
                "compile": {
                    "id": "compile-1",
                    "target": "dashboard",
                    "provider": "wizard",
                    "status": "draft",
                    "template": "campaign-dashboard",
                },
                "views": [
                    {"id": "summary", "kind": "card-grid", "fields": ["title"]},
                    {"id": "map", "kind": "map", "fields": ["lat", "lng"]},
                ],
            }
        )
        self.assertEqual(workflow["workflowId"], "compile-campaign-1-compile-1")
        self.assertEqual(len(workflow["steps"]), 2)
        self.assertEqual(workflow["steps"][1]["dependsOn"], ["render-summary"])

    def test_upstream_pin_status_reports_valid_commitish(self):
        status = upstream_pin_status("v2.4-preview")
        self.assertTrue(status["pin_valid"])
        self.assertEqual(status["pin_type"], "commit-ish")

    def test_controlled_execute_returns_completed_artifacts(self):
        workflow = json.loads((ROOT / "examples/workflows/sample.workflow.json").read_text())
        graph = translate_workflow(workflow, upstream_pin="abc123")
        result = controlled_execute(graph)
        self.assertEqual(result["status"], "completed")
        self.assertEqual(result["summary"]["artifactsProduced"], 4)
        self.assertEqual(result["nodes"][0]["status"], "completed")
        self.assertEqual(result["artifacts"][0]["kind"], "rendered-view")


if __name__ == "__main__":
    unittest.main()
