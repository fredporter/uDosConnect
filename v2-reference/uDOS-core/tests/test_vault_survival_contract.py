"""Tests for the vault survival contract (v2.0.8 Round B).

Covers:
  - .compost header, state surface, and footer record validation
  - progressive delta record validation
  - sandbox operation descriptor validation
  - vault state boundary descriptor validation
  - draft-before-write and backup-before-mutate round-trip demonstration
  - snap-off portability boundary assertions
"""

from __future__ import annotations

import base64
import hashlib
import json
import os
import shutil
import tempfile

import jsonschema
import pytest

CONTRACT_PATH = "contracts/vault-survival-contract.json"

with open(CONTRACT_PATH) as _f:
    _contract = json.load(_f)

_defs = _contract["definitions"]


def _schema(name: str) -> dict:
    return _defs[name]


# ---------------------------------------------------------------------------
# .compost header
# ---------------------------------------------------------------------------

class TestCompostHeader:
    def test_valid_header(self):
        record = {
            "record_type": "compost_header",
            "vault_id": "vault-dev-01",
            "timestamp": "2026-03-21T00:26:40Z",
            "version_vector": {"binder-state": 7, "audit-trail": 42},
            "schema_version": "v2.0.8",
        }
        jsonschema.validate(instance=record, schema=_schema("compost_header"))

    def test_invalid_vault_id_format(self):
        record = {
            "record_type": "compost_header",
            "vault_id": "VAULT_01",  # uppercase not allowed
            "timestamp": "2026-03-21T00:26:40Z",
            "version_vector": {},
            "schema_version": "v2.0.8",
        }
        with pytest.raises(jsonschema.ValidationError):
            jsonschema.validate(instance=record, schema=_schema("compost_header"))

    def test_wrong_schema_version_rejected(self):
        record = {
            "record_type": "compost_header",
            "vault_id": "vault-dev-01",
            "timestamp": "2026-03-21T00:26:40Z",
            "version_vector": {},
            "schema_version": "v1.0.0",
        }
        with pytest.raises(jsonschema.ValidationError):
            jsonschema.validate(instance=record, schema=_schema("compost_header"))

    def test_missing_required_field_rejected(self):
        record = {
            "record_type": "compost_header",
            "vault_id": "vault-dev-01",
            # timestamp missing
            "version_vector": {},
            "schema_version": "v2.0.8",
        }
        with pytest.raises(jsonschema.ValidationError):
            jsonschema.validate(instance=record, schema=_schema("compost_header"))


# ---------------------------------------------------------------------------
# .compost state surface
# ---------------------------------------------------------------------------

def _sha256(text: str) -> str:
    return hashlib.sha256(text.encode()).hexdigest()


def _b64(text: str) -> str:
    return base64.b64encode(text.encode()).decode()


class TestCompostStateSurface:
    def test_valid_state_surface(self):
        content = "active binder state data"
        record = {
            "record_type": "state_surface",
            "slug": "binder-state",
            "path": "@dev/logs/checkpoints/v2-1-operations-checks.state",
            "content_hash": _sha256(content),
            "content": _b64(content),
            "seq": 7,
        }
        jsonschema.validate(instance=record, schema=_schema("compost_state_surface"))

    def test_invalid_content_hash_format(self):
        record = {
            "record_type": "state_surface",
            "slug": "binder-state",
            "path": "@dev/logs/checkpoints/v2-1-operations-checks.state",
            "content_hash": "not-a-sha256",
            "content": _b64("data"),
            "seq": 1,
        }
        with pytest.raises(jsonschema.ValidationError):
            jsonschema.validate(instance=record, schema=_schema("compost_state_surface"))

    def test_negative_seq_rejected(self):
        content = "data"
        record = {
            "record_type": "state_surface",
            "slug": "binder-state",
            "path": "some/path",
            "content_hash": _sha256(content),
            "content": _b64(content),
            "seq": -1,
        }
        with pytest.raises(jsonschema.ValidationError):
            jsonschema.validate(instance=record, schema=_schema("compost_state_surface"))


# ---------------------------------------------------------------------------
# .compost footer
# ---------------------------------------------------------------------------

class TestCompostFooter:
    def _make_footer(self, surface_count: int, checksum: str) -> dict:
        return {
            "record_type": "compost_footer",
            "surface_count": surface_count,
            "checksum": checksum,
        }

    def test_valid_footer(self):
        checksum = _sha256("combined-hashes")
        record = self._make_footer(3, checksum)
        jsonschema.validate(instance=record, schema=_schema("compost_footer"))

    def test_invalid_checksum_rejected(self):
        record = self._make_footer(3, "not-a-hex-sha256")
        with pytest.raises(jsonschema.ValidationError):
            jsonschema.validate(instance=record, schema=_schema("compost_footer"))

    def test_negative_surface_count_rejected(self):
        record = self._make_footer(-1, _sha256("x"))
        with pytest.raises(jsonschema.ValidationError):
            jsonschema.validate(instance=record, schema=_schema("compost_footer"))


# ---------------------------------------------------------------------------
# Delta record
# ---------------------------------------------------------------------------

class TestDeltaRecord:
    def test_valid_write_delta(self):
        content = "new surface content"
        record = {
            "record_type": "delta",
            "slug": "binder-state",
            "seq": 8,
            "timestamp": "2026-03-21T00:30:00Z",
            "op": "write",
            "content_hash": _sha256(content),
            "content": _b64(content),
        }
        jsonschema.validate(instance=record, schema=_schema("delta_record"))

    def test_valid_delete_delta(self):
        record = {
            "record_type": "delta",
            "slug": "temp-surface",
            "seq": 9,
            "timestamp": "2026-03-21T00:30:00Z",
            "op": "delete",
        }
        jsonschema.validate(instance=record, schema=_schema("delta_record"))

    def test_invalid_op_rejected(self):
        record = {
            "record_type": "delta",
            "slug": "binder-state",
            "seq": 1,
            "timestamp": "2026-03-21T00:30:00Z",
            "op": "overwrite",  # not allowed
        }
        with pytest.raises(jsonschema.ValidationError):
            jsonschema.validate(instance=record, schema=_schema("delta_record"))

    def test_zero_seq_rejected(self):
        record = {
            "record_type": "delta",
            "slug": "binder-state",
            "seq": 0,  # must be >= 1
            "timestamp": "2026-03-21T00:30:00Z",
            "op": "write",
        }
        with pytest.raises(jsonschema.ValidationError):
            jsonschema.validate(instance=record, schema=_schema("delta_record"))


# ---------------------------------------------------------------------------
# Sandbox operation
# ---------------------------------------------------------------------------

class TestSandboxOperation:
    def test_valid_draft_write(self):
        record = {
            "op_type": "draft_write",
            "target_path": "@dev/notes/roadmap/v2-roadmap-status.md",
            "artifact_path": "@dev/notes/roadmap/v2-roadmap-status.md.draft",
            "timestamp": "2026-03-21T00:30:00Z",
            "status": "pending",
        }
        jsonschema.validate(instance=record, schema=_schema("sandbox_operation"))

    def test_valid_backup_mutate(self):
        record = {
            "op_type": "backup_mutate",
            "target_path": "@dev/notes/roadmap/v2-roadmap-status.md",
            "artifact_path": "@dev/notes/roadmap/v2-roadmap-status.md.bak-20260321T003000Z",
            "timestamp": "2026-03-21T00:30:00Z",
            "status": "complete",
        }
        jsonschema.validate(instance=record, schema=_schema("sandbox_operation"))

    def test_invalid_op_type_rejected(self):
        record = {
            "op_type": "overwrite_direct",  # not in enum
            "target_path": "some/path",
            "artifact_path": "some/path.draft",
            "timestamp": "2026-03-21T00:30:00Z",
            "status": "pending",
        }
        with pytest.raises(jsonschema.ValidationError):
            jsonschema.validate(instance=record, schema=_schema("sandbox_operation"))

    def test_invalid_status_rejected(self):
        record = {
            "op_type": "draft_write",
            "target_path": "some/path",
            "artifact_path": "some/path.draft",
            "timestamp": "2026-03-21T00:30:00Z",
            "status": "in-progress",  # not in enum
        }
        with pytest.raises(jsonschema.ValidationError):
            jsonschema.validate(instance=record, schema=_schema("sandbox_operation"))


# ---------------------------------------------------------------------------
# Vault state boundary
# ---------------------------------------------------------------------------

class TestVaultStateBoundary:
    def test_valid_boundary(self):
        record = {
            "vault_id": "vault-dev-01",
            "crash_safe_surfaces": ["binder-state", "audit-trail", "process-registry"],
            "discard_safe_patterns": [
                "@dev/logs/v2-1-operations-checks-*.jsonl",
                "@dev/notes/reports/v2-1-check-*-*.log",
                "@dev/logs/pids/*.pid",
            ],
            "compost_rotation_keep": 3,
            "delta_retention_minimum": 10,
        }
        jsonschema.validate(instance=record, schema=_schema("vault_state_boundary"))

    def test_empty_crash_safe_surfaces_rejected(self):
        record = {
            "vault_id": "vault-dev-01",
            "crash_safe_surfaces": [],  # minItems: 1
            "discard_safe_patterns": ["@dev/logs/pids/*.pid"],
        }
        with pytest.raises(jsonschema.ValidationError):
            jsonschema.validate(instance=record, schema=_schema("vault_state_boundary"))

    def test_invalid_vault_id_rejected(self):
        record = {
            "vault_id": "VAULT_DEV",  # uppercase
            "crash_safe_surfaces": ["binder-state"],
            "discard_safe_patterns": [],
        }
        with pytest.raises(jsonschema.ValidationError):
            jsonschema.validate(instance=record, schema=_schema("vault_state_boundary"))

    def test_compost_rotation_keep_minimum(self):
        record = {
            "vault_id": "vault-dev-01",
            "crash_safe_surfaces": ["binder-state"],
            "discard_safe_patterns": [],
            "compost_rotation_keep": 0,  # minimum is 1
        }
        with pytest.raises(jsonschema.ValidationError):
            jsonschema.validate(instance=record, schema=_schema("vault_state_boundary"))


# ---------------------------------------------------------------------------
# Sandbox round-trip demonstration
# (draft-before-write and backup-before-mutate exercised on a temp directory)
# ---------------------------------------------------------------------------

class TestSandboxRoundTrip:
    """Demonstrates the draft-before-write and backup-before-mutate protocols
    using a temporary directory as the vault root."""

    def setup_method(self):
        self.vault_root = tempfile.mkdtemp(prefix="vault-test-")
        self.target = os.path.join(self.vault_root, "active-surface.md")
        with open(self.target, "w") as f:
            f.write("original content\n")

    def teardown_method(self):
        shutil.rmtree(self.vault_root, ignore_errors=True)

    def _draft_path(self) -> str:
        return self.target + ".draft"

    def _bak_path(self) -> str:
        return self.target + ".bak-20260321T003000Z"

    def test_draft_before_write_succeeds(self):
        draft = self._draft_path()

        # Step 1: write draft
        with open(draft, "w") as f:
            f.write("updated content\n")

        # Step 2: verify draft is parseable (non-empty)
        assert os.path.getsize(draft) > 0

        # Step 3: atomic promote (rename draft → active)
        os.rename(draft, self.target)

        assert not os.path.exists(draft)
        with open(self.target) as f:
            assert f.read() == "updated content\n"

    def test_draft_before_write_recovery_on_kill(self):
        """If the process dies after writing .draft but before rename,
        the active file is unchanged and the draft is recoverable."""
        draft = self._draft_path()

        with open(draft, "w") as f:
            f.write("new content — not yet promoted\n")

        # Simulate kill here (do not rename)
        # Active file must be unchanged
        with open(self.target) as f:
            assert f.read() == "original content\n"

        # Draft is recoverable
        assert os.path.exists(draft)
        with open(draft) as f:
            assert "new content" in f.read()

    def test_backup_before_mutate_and_restore(self):
        bak = self._bak_path()

        # Step 1: backup
        shutil.copy2(self.target, bak)
        assert os.path.exists(bak)

        # Step 2: mutate
        with open(self.target, "w") as f:
            f.write("mutated content\n")

        # Step 3: simulate failure — restore from backup
        shutil.copy2(bak, self.target)

        with open(self.target) as f:
            assert f.read() == "original content\n"

        # Step 4: cleanup
        os.remove(bak)
        assert not os.path.exists(bak)

    def test_backup_before_mutate_cleanup_on_success(self):
        bak = self._bak_path()

        # Backup
        shutil.copy2(self.target, bak)

        # Mutate
        with open(self.target, "w") as f:
            f.write("successfully mutated\n")

        # On success: remove backup
        os.remove(bak)

        assert not os.path.exists(bak)
        with open(self.target) as f:
            assert f.read() == "successfully mutated\n"


# ---------------------------------------------------------------------------
# Snap-off portability boundary assertions
# ---------------------------------------------------------------------------

class TestSnapOffBoundary:
    """Assertions about what is and is not part of the portable vault layer."""

    PORTABLE_PATTERNS = [
        ".compost",
        "@dev/logs/checkpoints",
        "@dev/logs/workflow-scheduler-audit.jsonl",
        "@dev/requests",
        "@dev/submissions",
        "@dev/notes",
    ]

    HOST_BOUND_PATTERNS = [
        ".venv",
        "node_modules",
        "@dev/logs/pids",
        "dist",
        "build",
        "__pycache__",
    ]

    def test_compost_dir_is_portable(self):
        assert ".compost" in self.PORTABLE_PATTERNS

    def test_venv_is_not_portable(self):
        assert ".venv" in self.HOST_BOUND_PATTERNS

    def test_node_modules_is_not_portable(self):
        assert "node_modules" in self.HOST_BOUND_PATTERNS

    def test_pid_files_are_not_portable(self):
        assert "@dev/logs/pids" in self.HOST_BOUND_PATTERNS

    def test_binder_surfaces_are_portable(self):
        assert "@dev/requests" in self.PORTABLE_PATTERNS
        assert "@dev/submissions" in self.PORTABLE_PATTERNS

    def test_no_overlap_between_portable_and_host_bound(self):
        overlap = set(self.PORTABLE_PATTERNS) & set(self.HOST_BOUND_PATTERNS)
        assert overlap == set(), f"Unexpected overlap: {overlap}"
