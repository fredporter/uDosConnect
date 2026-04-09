from __future__ import annotations

import json
import unittest
from pathlib import Path


class WorkflowAutomationContractTests(unittest.TestCase):
    def setUp(self) -> None:
        self.contracts_root = Path(__file__).resolve().parents[1] / "contracts"
        self.schemas_root = Path(__file__).resolve().parents[1] / "schemas"

    def test_contract_manifests_lock_expected_owners_and_versions(self) -> None:
        workflow_state = json.loads(
            (self.contracts_root / "workflow-state-contract.json").read_text(encoding="utf-8")
        )
        workflow_action = json.loads(
            (self.contracts_root / "workflow-action-contract.json").read_text(encoding="utf-8")
        )
        automation_job = json.loads(
            (self.contracts_root / "automation-job-contract.json").read_text(encoding="utf-8")
        )
        automation_result = json.loads(
            (self.contracts_root / "automation-result-contract.json").read_text(encoding="utf-8")
        )

        self.assertEqual(workflow_state["version"], "v2.0.4")
        self.assertEqual(workflow_action["version"], "v2.0.4")
        self.assertEqual(automation_job["version"], "v2.0.4")
        self.assertEqual(automation_result["version"], "v2.0.4")

        self.assertEqual(workflow_state["owners"]["policy"], "uDOS-wizard")
        self.assertEqual(automation_job["owners"]["fulfillment_owner"], "uHOME-server")
        self.assertEqual(automation_result["owners"]["workflow_consumer"], "uDOS-wizard")
        self.assertEqual(automation_job["owners"]["interpretation_consumer"], "uDOS-gameplay")

    def test_schemas_define_expected_titles_and_core_ownership(self) -> None:
        workflow_state_schema = json.loads(
            (self.schemas_root / "workflow-state-contract.schema.json").read_text(encoding="utf-8")
        )
        workflow_action_schema = json.loads(
            (self.schemas_root / "workflow-action-contract.schema.json").read_text(encoding="utf-8")
        )
        automation_job_schema = json.loads(
            (self.schemas_root / "automation-job-contract.schema.json").read_text(encoding="utf-8")
        )
        automation_result_schema = json.loads(
            (self.schemas_root / "automation-result-contract.schema.json").read_text(encoding="utf-8")
        )

        self.assertEqual(workflow_state_schema["title"], "uDOS Workflow State Contract")
        self.assertEqual(workflow_action_schema["title"], "uDOS Workflow Action Contract")
        self.assertEqual(automation_job_schema["title"], "uDOS Automation Job Contract")
        self.assertEqual(automation_result_schema["title"], "uDOS Automation Result Contract")

        self.assertEqual(workflow_state_schema["properties"]["owner"]["const"], "uDOS-core")
        self.assertEqual(workflow_action_schema["properties"]["owner"]["const"], "uDOS-core")
        self.assertEqual(automation_job_schema["properties"]["owner"]["const"], "uDOS-core")
        self.assertEqual(automation_result_schema["properties"]["owner"]["const"], "uDOS-core")


if __name__ == "__main__":
    unittest.main()
