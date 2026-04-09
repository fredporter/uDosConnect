from __future__ import annotations

import json
import unittest
from pathlib import Path


class RenderContractTests(unittest.TestCase):
    def test_render_contract_has_expected_targets_and_theme_owner(self) -> None:
        contract_path = (
            Path(__file__).resolve().parents[1] / "contracts" / "render-contract.json"
        )
        payload = json.loads(contract_path.read_text(encoding="utf-8"))

        self.assertEqual(payload["version"], "v2.0.3")
        self.assertEqual(payload["owner"], "uDOS-core")
        self.assertEqual(payload["theme_contract"]["theme_owner"], "uDOS-themes")

        target_ids = {target["id"] for target in payload["targets"]}
        self.assertEqual(
            target_ids,
            {"web-prose", "email-html", "gui-preview", "beacon-library"},
        )

    def test_render_schema_declares_core_owned_contract(self) -> None:
        schema_path = (
            Path(__file__).resolve().parents[1]
            / "schemas"
            / "render-contract.schema.json"
        )
        payload = json.loads(schema_path.read_text(encoding="utf-8"))

        self.assertEqual(payload["title"], "uDOS Render Contract")
        self.assertEqual(payload["properties"]["owner"]["const"], "uDOS-core")


if __name__ == "__main__":
    unittest.main()
