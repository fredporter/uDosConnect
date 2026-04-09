from __future__ import annotations

import json
import unittest
from pathlib import Path


class OKAgentContractTests(unittest.TestCase):
    def setUp(self) -> None:
        root = Path(__file__).resolve().parents[1]
        self.contracts_root = root / "contracts"
        self.schemas_root = root / "schemas"

    def test_contract_manifests_expose_core_owned_ok_surfaces(self) -> None:
        capability = json.loads(
            (self.contracts_root / "ok-agent-capability-contract.json").read_text(encoding="utf-8")
        )
        mcp_tool = json.loads(
            (self.contracts_root / "mcp-tool-contract.json").read_text(encoding="utf-8")
        )
        deferred_packet = json.loads(
            (self.contracts_root / "deferred-packet-contract.json").read_text(encoding="utf-8")
        )
        budget_policy = json.loads(
            (self.contracts_root / "budget-policy-contract.json").read_text(encoding="utf-8")
        )

        self.assertEqual(capability["version"], "v2.0.4")
        self.assertEqual(mcp_tool["version"], "v2.0.4")
        self.assertEqual(deferred_packet["version"], "v2.0.4")
        self.assertEqual(budget_policy["version"], "v2.0.4")

        self.assertEqual(capability["owners"]["managed_policy"], "uDOS-wizard")
        self.assertEqual(mcp_tool["owners"]["managed_mcp_owner"], "uDOS-wizard")
        self.assertEqual(deferred_packet["owners"]["queue_owner"], "uDOS-wizard")
        self.assertEqual(budget_policy["owners"]["live_budget_owner"], "uDOS-wizard")

        self.assertEqual(capability["owners"]["contributor_lane"], "uDOS-dev")
        self.assertEqual(mcp_tool["owners"]["fixture_validation_owner"], "uDOS-dev")
        self.assertEqual(deferred_packet["owners"]["promotion_lane"], "uDOS-dev")
        self.assertEqual(budget_policy["owners"]["simulation_owner"], "uDOS-dev")

    def test_schemas_define_expected_titles_and_core_owner_consts(self) -> None:
        capability_schema = json.loads(
            (self.schemas_root / "ok-agent-capability-contract.schema.json").read_text(encoding="utf-8")
        )
        mcp_tool_schema = json.loads(
            (self.schemas_root / "mcp-tool-contract.schema.json").read_text(encoding="utf-8")
        )
        deferred_packet_schema = json.loads(
            (self.schemas_root / "deferred-packet-contract.schema.json").read_text(encoding="utf-8")
        )
        budget_policy_schema = json.loads(
            (self.schemas_root / "budget-policy-contract.schema.json").read_text(encoding="utf-8")
        )

        self.assertEqual(capability_schema["title"], "uDOS OK Agent Capability Contract")
        self.assertEqual(mcp_tool_schema["title"], "uDOS MCP Tool Contract")
        self.assertEqual(deferred_packet_schema["title"], "uDOS Deferred Packet Contract")
        self.assertEqual(budget_policy_schema["title"], "uDOS Budget Policy Contract")

        self.assertEqual(capability_schema["properties"]["owner"]["const"], "uDOS-core")
        self.assertEqual(mcp_tool_schema["properties"]["owner"]["const"], "uDOS-core")
        self.assertEqual(deferred_packet_schema["properties"]["owner"]["const"], "uDOS-core")
        self.assertEqual(budget_policy_schema["properties"]["owner"]["const"], "uDOS-core")


if __name__ == "__main__":
    unittest.main()
