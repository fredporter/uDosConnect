from __future__ import annotations

import json
import unittest
from pathlib import Path


class SyncRecordContractTests(unittest.TestCase):
    def test_contract_manifest_lists_expected_record_types(self) -> None:
        contract_path = (
            Path(__file__).resolve().parents[1] / "contracts" / "sync-record-contract.json"
        )
        payload = json.loads(contract_path.read_text(encoding="utf-8"))

        self.assertEqual(payload["version"], "v2.0.4")
        self.assertEqual(payload["owner"], "uDOS-core")
        self.assertEqual(payload["schema"], "schemas/sync-record-contract.schema.json")

        record_types = {record["key"] for record in payload["record_types"]}
        self.assertEqual(
            record_types,
            {"canonical_contact", "activity", "binder_project", "sync_metadata"},
        )

    def test_schema_defines_expected_core_record_shapes(self) -> None:
        schema_path = (
            Path(__file__).resolve().parents[1]
            / "schemas"
            / "sync-record-contract.schema.json"
        )
        payload = json.loads(schema_path.read_text(encoding="utf-8"))

        self.assertEqual(payload["title"], "uDOS Sync Record Contract")
        self.assertEqual(payload["properties"]["contract_version"]["const"], "v2.0.4")
        defs = payload["$defs"]

        self.assertEqual(defs["canonical_contact"]["properties"]["entity_type"]["const"], "canonical_contact")
        self.assertEqual(defs["activity"]["properties"]["entity_type"]["const"], "activity")
        self.assertEqual(defs["binder_project"]["properties"]["entity_type"]["const"], "binder_project")
        self.assertEqual(defs["sync_metadata"]["properties"]["entity_type"]["const"], "sync_metadata")
        self.assertIn("projection_targets", defs["binder_project"]["properties"]["routing"]["required"])


if __name__ == "__main__":
    unittest.main()
