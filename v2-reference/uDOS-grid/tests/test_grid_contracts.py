from __future__ import annotations

import json
import unittest
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
CONTRACTS = REPO_ROOT / "contracts"
EXAMPLES = REPO_ROOT / "examples"
SEED = REPO_ROOT / "seed"


def _load(path: Path) -> dict | list:
    return json.loads(path.read_text(encoding="utf-8"))


class PlaceRecordContractTests(unittest.TestCase):
    def setUp(self) -> None:
        self.contract = _load(CONTRACTS / "place-record.contract.json")

    def test_contract_has_required_meta_fields(self) -> None:
        for field in ("version", "owner", "required_fields", "optional_fields", "consumers"):
            self.assertIn(field, self.contract, f"place-record contract missing field: {field}")

    def test_contract_version_is_current(self) -> None:
        self.assertEqual(self.contract["version"], "v2.0.4")

    def test_contract_owner_is_grid(self) -> None:
        self.assertEqual(self.contract["owner"], "uDOS-grid")

    def test_required_fields_cover_spatial_identity(self) -> None:
        required = set(self.contract["required_fields"])
        for field in ("place_id", "name", "layer", "cell", "space", "anchor"):
            self.assertIn(field, required)

    def test_contract_declares_canonical_identity_formats(self) -> None:
        formats = self.contract.get("canonical_id_formats", {})
        self.assertEqual(formats.get("short"), "L{Layer}-{Cell}[-Z{z}]")
        self.assertEqual(formats.get("place_ref"), "ANCHOR:SPACE:LAYER-CELL[-Z]")

    def test_allowed_space_values_cover_runtime_spaces(self) -> None:
        spaces = set(self.contract.get("allowed_space_values", []))
        self.assertTrue({"SUR", "SUB", "UDN", "ORB", "COS"}.issubset(spaces))

    def test_seed_geometry_is_standard(self) -> None:
        geometry = self.contract.get("seed_geometry", {})
        self.assertEqual(geometry.get("cols"), 80)
        self.assertEqual(geometry.get("rows"), 30)
        self.assertIn("cell_format", geometry)

    def test_resolution_order_is_deterministic(self) -> None:
        self.assertEqual(
            self.contract.get("resolution_order"),
            ["anchor", "space", "layer", "cell", "z"],
        )

    def test_consumers_include_shell_and_wizard(self) -> None:
        consumers = set(self.contract["consumers"])
        self.assertIn("uDOS-shell", consumers)
        self.assertIn("uDOS-wizard", consumers)


class LayerRecordContractTests(unittest.TestCase):
    def setUp(self) -> None:
        self.contract = _load(CONTRACTS / "layer-record.contract.json")

    def test_contract_has_required_meta_fields(self) -> None:
        for field in ("version", "owner", "required_fields", "optional_fields", "consumers"):
            self.assertIn(field, self.contract, f"layer-record contract missing field: {field}")

    def test_contract_version_is_current(self) -> None:
        self.assertEqual(self.contract["version"], "v2.0.4")

    def test_contract_owner_is_grid(self) -> None:
        self.assertEqual(self.contract["owner"], "uDOS-grid")

    def test_required_fields_cover_layer_identity(self) -> None:
        required = set(self.contract["required_fields"])
        for field in ("layer_id", "anchor", "space", "domain", "cols", "rows", "seed"):
            self.assertIn(field, required)

    def test_allowed_domains_include_seed_families(self) -> None:
        domains = set(self.contract.get("allowed_domains", []))
        self.assertTrue(
            {
                "terrestrial",
                "terrestrial-subsurface",
                "virtual",
                "planetary",
                "orbital",
                "stellar",
            }.issubset(domains)
        )

    def test_allowed_space_values_cover_runtime_spaces(self) -> None:
        spaces = set(self.contract.get("allowed_space_values", []))
        self.assertTrue({"SUR", "SUB", "UDN", "ORB", "COS"}.issubset(spaces))

    def test_geometry_rule_is_standard(self) -> None:
        geometry = self.contract.get("geometry_rule", {})
        self.assertEqual(geometry.get("cols"), 80)
        self.assertEqual(geometry.get("rows"), 30)


class ArtifactRecordContractTests(unittest.TestCase):
    def setUp(self) -> None:
        self.contract = _load(CONTRACTS / "artifact-record.contract.json")

    def test_contract_has_required_meta_fields(self) -> None:
        for field in ("version", "owner", "required_fields", "optional_fields", "consumers"):
            self.assertIn(field, self.contract, f"artifact-record contract missing field: {field}")

    def test_contract_version_is_current(self) -> None:
        self.assertEqual(self.contract["version"], "v2.0.4")

    def test_contract_owner_is_grid(self) -> None:
        self.assertEqual(self.contract["owner"], "uDOS-grid")

    def test_required_fields_cover_artifact_identity(self) -> None:
        required = set(self.contract["required_fields"])
        for field in ("artifact_id", "artifact_type", "places"):
            self.assertIn(field, required)

    def test_permission_classes_cover_security_model(self) -> None:
        classes = set(self.contract.get("permission_classes", []))
        self.assertTrue(
            {
                "public_read",
                "proximity_read",
                "handshake_unlock",
                "owner_mutation",
                "operator_override",
            }.issubset(classes)
        )

    def test_validation_pipeline_is_deterministic(self) -> None:
        self.assertEqual(
            self.contract.get("validation_pipeline"),
            [
                "resolve_place_ref",
                "verify_actor_role",
                "verify_proximity_and_handshake",
                "verify_artifact_gate_policy",
                "emit_decision_and_audit_payload",
            ],
        )

    def test_runtime_boundary_split_is_explicit(self) -> None:
        boundary = self.contract.get("runtime_boundary", {})
        for field in ("grid", "wizard", "gameplay"):
            self.assertIn(field, boundary)


class ExamplePlaceRecordTests(unittest.TestCase):
    def setUp(self) -> None:
        self.place = _load(EXAMPLES / "basic-place-record.json")
        self.contract = _load(CONTRACTS / "place-record.contract.json")

    def test_example_satisfies_required_fields(self) -> None:
        for field in self.contract["required_fields"]:
            self.assertIn(field, self.place, f"example place missing required field: {field}")

    def test_place_id_format_matches_anchor_space_layer_cell(self) -> None:
        place_id: str = self.place["place_id"]
        self.assertRegex(place_id, r"^[A-Z][A-Z0-9:]*:L\d+-[A-Z]{2}\d+(-Z-?\d+)?$")

    def test_example_is_seed(self) -> None:
        self.assertTrue(self.place.get("seed"), "example place should be marked as seed")


class ExampleArtifactRecordTests(unittest.TestCase):
    def setUp(self) -> None:
        self.artifact = _load(EXAMPLES / "basic-artifact-record.json")
        self.contract = _load(CONTRACTS / "artifact-record.contract.json")

    def test_example_satisfies_required_fields(self) -> None:
        for field in self.contract["required_fields"]:
            self.assertIn(field, self.artifact, f"example artifact missing required field: {field}")

    def test_places_is_non_empty_list(self) -> None:
        places = self.artifact["places"]
        self.assertIsInstance(places, list)
        self.assertGreater(len(places), 0)

    def test_each_place_ref_has_expected_format(self) -> None:
        for ref in self.artifact["places"]:
            self.assertRegex(ref, r"^[A-Z][A-Z0-9:]*:L\d+-[A-Z]{2}\d+(-Z-?\d+)?$")


class SeedLayerRegistryTests(unittest.TestCase):
    def setUp(self) -> None:
        self.layers = _load(SEED / "basic-layer-registry.json")
        self.contract = _load(CONTRACTS / "layer-record.contract.json")

    def test_registry_is_non_empty_list(self) -> None:
        self.assertIsInstance(self.layers, list)
        self.assertGreater(len(self.layers), 0)

    def test_all_items_have_required_fields(self) -> None:
        for item in self.layers:
            for field in self.contract["required_fields"]:
                self.assertIn(field, item, f"layer registry item missing field: {field}")

    def test_all_items_use_canonical_demo_scope(self) -> None:
        for item in self.layers:
            self.assertEqual(item.get("seed_scope"), "canonical-demo")

    def test_all_items_are_reviewed_for_current_version(self) -> None:
        for item in self.layers:
            self.assertEqual(item.get("review_status"), "reviewed-v2.0.3")

    def test_all_items_have_standard_grid_geometry(self) -> None:
        for item in self.layers:
            self.assertEqual(item["cols"], 80)
            self.assertEqual(item["rows"], 30)

    def test_registry_covers_all_domain_families(self) -> None:
        domains = {item["domain"] for item in self.layers}
        self.assertTrue(
            {
                "terrestrial",
                "virtual",
                "planetary",
                "orbital",
                "stellar",
            }.issubset(domains)
        )

    def test_registry_includes_orbital_and_stellar_anchors(self) -> None:
        anchors = {item["anchor"] for item in self.layers}
        self.assertIn("SKY", anchors)
        self.assertIn("GALAXY", anchors)


class SeedPlaceRegistryTests(unittest.TestCase):
    def setUp(self) -> None:
        self.places = _load(SEED / "basic-place-registry.json")
        self.contract = _load(CONTRACTS / "place-record.contract.json")

    def test_registry_is_non_empty_list(self) -> None:
        self.assertIsInstance(self.places, list)
        self.assertGreater(len(self.places), 0)

    def test_all_items_have_required_fields(self) -> None:
        for item in self.places:
            for field in self.contract["required_fields"]:
                self.assertIn(field, item, f"place registry item missing field: {field}")

    def test_all_items_use_canonical_demo_scope(self) -> None:
        for item in self.places:
            self.assertEqual(item.get("seed_scope"), "canonical-demo")

    def test_all_items_are_reviewed_for_current_version(self) -> None:
        for item in self.places:
            self.assertEqual(item.get("review_status"), "reviewed-v2.0.3")

    def test_place_ids_are_unique(self) -> None:
        ids = [item["place_id"] for item in self.places]
        self.assertEqual(len(ids), len(set(ids)), "duplicate place_id values found in registry")

    def test_all_items_declare_domain(self) -> None:
        for item in self.places:
            self.assertIn("domain", item, "place registry item missing field: domain")

    def test_registry_includes_planetary_orbital_and_stellar_examples(self) -> None:
        ids = {item["place_id"] for item in self.places}
        self.assertIn("BODY:MARS:SUR:L610-AB22", ids)
        self.assertIn("SKY:ORB:L700-AC20", ids)
        self.assertIn("GALAXY:COS:L800-AA01", ids)


class SeedArtifactRegistryTests(unittest.TestCase):
    def setUp(self) -> None:
        self.artifacts = _load(SEED / "basic-artifact-registry.json")
        self.contract = _load(CONTRACTS / "artifact-record.contract.json")

    def test_registry_is_non_empty_list(self) -> None:
        self.assertIsInstance(self.artifacts, list)
        self.assertGreater(len(self.artifacts), 0)

    def test_all_items_have_required_fields(self) -> None:
        for item in self.artifacts:
            for field in self.contract["required_fields"]:
                self.assertIn(field, item, f"artifact registry item missing field: {field}")

    def test_all_items_use_canonical_demo_scope(self) -> None:
        for item in self.artifacts:
            self.assertEqual(item.get("seed_scope"), "canonical-demo")

    def test_all_items_are_reviewed_for_current_version(self) -> None:
        for item in self.artifacts:
            self.assertEqual(item.get("review_status"), "reviewed-v2.0.3")

    def test_artifact_places_are_non_empty_lists(self) -> None:
        for item in self.artifacts:
            self.assertIsInstance(item["places"], list)
            self.assertGreater(len(item["places"]), 0)

    def test_artifact_ids_are_unique(self) -> None:
        ids = [item["artifact_id"] for item in self.artifacts]
        self.assertEqual(len(ids), len(set(ids)), "duplicate artifact_id values found in registry")


class CanonicalDemoIndexTests(unittest.TestCase):
    def setUp(self) -> None:
        self.index = _load(SEED / "canonical-demo-index.json")

    def test_index_has_required_fields(self) -> None:
        for field in ("version", "owner", "seed_scope", "review_status", "layers", "places", "artifacts"):
            self.assertIn(field, self.index, f"demo index missing field: {field}")

    def test_index_owner_is_grid(self) -> None:
        self.assertEqual(self.index["owner"], "uDOS-grid")

    def test_index_seed_scope_is_canonical_demo(self) -> None:
        self.assertEqual(self.index["seed_scope"], "canonical-demo")

    def test_index_review_status_is_current(self) -> None:
        self.assertEqual(self.index["review_status"], "reviewed-v2.0.3")

    def test_index_layers_are_non_empty(self) -> None:
        self.assertIsInstance(self.index["layers"], list)
        self.assertGreater(len(self.index["layers"]), 0)

    def test_index_places_are_non_empty(self) -> None:
        self.assertIsInstance(self.index["places"], list)
        self.assertGreater(len(self.index["places"]), 0)

    def test_index_places_align_with_registry(self) -> None:
        registry = _load(SEED / "basic-place-registry.json")
        registry_ids = {item["place_id"] for item in registry}
        for place_id in self.index["places"]:
            self.assertIn(place_id, registry_ids, f"index place {place_id!r} not found in registry")

    def test_index_artifacts_align_with_registry(self) -> None:
        registry = _load(SEED / "basic-artifact-registry.json")
        registry_ids = {item["artifact_id"] for item in registry}
        for artifact_id in self.index["artifacts"]:
            self.assertIn(artifact_id, registry_ids, f"index artifact {artifact_id!r} not found in registry")


if __name__ == "__main__":
    unittest.main()
