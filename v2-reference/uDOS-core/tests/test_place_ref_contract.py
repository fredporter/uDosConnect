
import json
import jsonschema
import pytest

# Load the PlaceRef contract schema
with open('contracts/place_ref_contract.json') as f:
    schema = json.load(f)

def test_valid_place_ref():
    valid = {
        "place_ref": "EARTH:SUR:L300-AJ11-Z1",
        "anchor": "EARTH",
        "layer": "L300",
        "cell": "AJ11",
        "z": 1
    }
    jsonschema.validate(instance=valid, schema=schema)

def test_invalid_layer():
    invalid = {
        "place_ref": "EARTH:SUR:L300-AJ11-Z1",
        "anchor": "EARTH",
        "layer": "L3A0",
        "cell": "AJ11",
        "z": 1
    }
    with pytest.raises(jsonschema.ValidationError):
        jsonschema.validate(instance=invalid, schema=schema)

def test_missing_place_ref():
    invalid = {
        "anchor": "EARTH",
        "layer": "L300",
        "cell": "AJ11"
    }
    with pytest.raises(jsonschema.ValidationError):
        jsonschema.validate(instance=invalid, schema=schema)
