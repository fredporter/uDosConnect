# Vault Survival Contract

**version**: v2.0.8  
**owner**: uDOS-core  
**status**: active

---

## Purpose

This document defines the canonical vault survival contract for uDOS. The vault
is the portable data layer that survives crashes, forced kills, snap-off events,
and host reinstalls. This contract defines what is crash-safe, what is
discardable, how to restore, and how to reconnect.

---

## 1. Vault State Boundary

### 1.1 Crash-Safe State (must survive)

The following must survive any kill signal or unclean shutdown:

| Surface | Format | Location |
| --- | --- | --- |
| Active binder state | JSONL checkpoint | `@dev/logs/checkpoints/*.state` |
| Scheduler audit trail | JSONL | `@dev/logs/workflow-scheduler-audit.jsonl` |
| Process registry | Plain text | `@dev/logs/process-registry.log` |
| Active work surfaces | Markdown or JSON | per-repo `@dev/` surfaces |
| `.compost` snapshot | Compressed JSON | `.compost/<vault-id>-<timestamp>.compost` |
| Progressive version deltas | JSONL | `.compost/deltas/<surface-slug>-<seq>.delta` |

All crash-safe state must be written atomically (write-then-rename) or to an
append-only JSONL file. No in-place overwrite of a crash-safe surface is
permitted without a prior backup artifact.

### 1.2 Discard-Safe State

The following may be discarded after a crash without data loss:

| Surface | Reason |
| --- | --- |
| Per-run log files (`v2-1-operations-checks-*.jsonl`) | Regenerable on next run |
| Per-run check output logs (`v2-1-check-*-*.log`) | Regenerable on next run |
| PID files (`@dev/logs/pids/*.pid`) | Process is dead; stale PID files are safe to remove |
| Temporary draft files (`*.draft` suffix) | Replaced on next advance step |

### 1.3 Recovery Priority Order

On restart after a crash:

1. Read the active `.compost` snapshot (most recent by timestamp in `.compost/`)
2. Apply progressive version deltas in sequence number order
3. Verify integrity checksum on restored state
4. Load checkpoint file for any in-progress binder round
5. Resume from the last `pass` checkpoint entry (skip completed stages)
6. Report any unresolvable conflict to the operator before proceeding

---

## 2. `.compost` Format

### 2.1 Purpose

A `.compost` file is a compact periodic snapshot that captures the complete
restorable vault state at a point in time. It is the primary restore artifact
after catastrophic failure.

### 2.2 File Naming

```
.compost/<vault-id>-<utc-timestamp-compact>.compost
```

Example: `.compost/vault-01-20260321T002640Z.compost`

### 2.3 Structure (JSON lines inside a `.compost` file)

```
Line 1  — header record
Line 2+ — state records (one per tracked surface)
Last    — footer record with integrity checksum
```

**Header record fields**:

| Field | Type | Description |
| --- | --- | --- |
| `record_type` | string | `"compost_header"` |
| `vault_id` | string | Stable vault identity token |
| `timestamp` | string | UTC ISO-8601 |
| `version_vector` | object | Map of `surface-slug → sequence-number` |
| `schema_version` | string | `"v2.0.8"` |

**State record fields**:

| Field | Type | Description |
| --- | --- | --- |
| `record_type` | string | `"state_surface"` |
| `slug` | string | Surface identifier (unique within compost) |
| `path` | string | Relative path from vault root |
| `content_hash` | string | SHA-256 hex of the content |
| `content` | string | Base64-encoded content (UTF-8) |
| `seq` | integer | Sequence number at snapshot time |

**Footer record fields**:

| Field | Type | Description |
| --- | --- | --- |
| `record_type` | string | `"compost_footer"` |
| `surface_count` | integer | Number of state records written |
| `checksum` | string | SHA-256 of all state record content hashes concatenated |

### 2.4 Rotation Policy

- Keep the 3 most recent `.compost` files per vault.
- Remove older files only after a newer `.compost` has been verified with a
  successful integrity check.
- Maximum restore depth: 3 snapshots back.

---

## 3. Progressive File Versioning Protocol

### 3.1 Purpose

Progressive deltas capture mutations to tracked surfaces between `.compost`
snapshots, allowing point-in-time restore without a full snapshot.

### 3.2 Delta File Format

```
.compost/deltas/<surface-slug>-<seq-padded>.delta
```

Example: `.compost/deltas/binder-state-000042.delta`

**Delta JSONL record fields**:

| Field | Type | Description |
| --- | --- | --- |
| `record_type` | string | `"delta"` |
| `slug` | string | Surface identifier |
| `seq` | integer | Monotonically increasing sequence number |
| `timestamp` | string | UTC ISO-8601 of the mutation |
| `op` | string | `"write"`, `"delete"`, or `"rename"` |
| `content_hash` | string | SHA-256 of new content (for `write` ops) |
| `content` | string | Base64-encoded new content (for `write` ops) |

### 3.3 Write Guard

Before any mutation to a tracked surface:

1. Increment the sequence counter for the surface slug.
2. Write the delta record to `.compost/deltas/<slug>-<seq>.delta`.
3. Confirm the delta file is fully written.
4. Then apply the mutation to the active file.

### 3.4 Retention Window

- Deltas are retained until superseded by a new `.compost` snapshot.
- After a successful snapshot, deltas with `seq ≤ snapshot version_vector[slug]`
  may be pruned.
- Retain a minimum of the last 10 deltas per surface regardless of snapshot state
  as a safety margin.

### 3.5 Restore from `.compost` + Deltas

1. Load the `.compost` snapshot into memory.
2. For each surface slug, apply delta records with `seq > version_vector[slug]`
   in ascending sequence order.
3. Verify the final content hash after applying all deltas.
4. If any delta is missing from the sequence, report the gap and pause before
   completing the restore.

---

## 4. Sandbox (Draft and Backup/Restore) Protocol

### 4.1 Draft-Before-Write Guard

Any operation that mutates a promotable surface must:

1. Write the new content to `<path>.draft` first.
2. Verify the draft file is complete and parseable (format check).
3. Only then rename `<path>.draft` → `<path>` (atomic move).

If the process is killed between steps 2 and 3, the active file is unchanged
and the `.draft` artifact is recoverable.

### 4.2 Backup-Before-Mutate Trigger

For high-stakes mutations (promotion operations, binder close, vault snapshot):

1. Before writing, copy the current active file to `<path>.bak-<timestamp>`.
2. Perform the mutation.
3. On success, remove the `.bak-<timestamp>` artifact.
4. On failure, restore from `.bak-<timestamp>` and report.

### 4.3 Restore-from-Backup Sequence

```
1. Locate the most recent .bak-<timestamp> artifact for the target path.
2. Verify it is newer than the current active file OR the active file is missing.
3. Copy .bak-<timestamp> → <path> (write-then-rename).
4. Log the restore event to the scheduler audit trail.
5. Remove the .bak-<timestamp> artifact after a confirmed successful restore.
```

### 4.4 Draft/Backup Cleanup Policy

- `.draft` files older than 24 hours with no corresponding active write in
  progress are safe to prune.
- `.bak-*` files are pruned after the operation that created them completes
  successfully. If the operation aborted, the `.bak-*` file is retained until
  the next scheduled vault checkpoint.

---

## 5. Snap-Off Protocol

### 5.1 What Is Portable (Vault Layer)

The vault layer is host-independent. It consists of:

- `.compost/` directory (snapshots and deltas)
- `@dev/logs/checkpoints/` directory
- `@dev/logs/workflow-scheduler-audit.jsonl`
- All `@dev/` binder surfaces (requests, submissions, notes, routes)
- Active repo work surfaces tracked by the operator

The vault layer can be archived to any block storage and restored on a new host.

### 5.2 What Is Host-Bound (Runtime Bindings)

The following are host-specific and are NOT part of the portable vault:

- `.venv/` directories (Python virtual environments)
- `node_modules/` directories
- PID files and process registry live state
- Build artifacts (`dist/`, `build/`, compiled binaries)
- OS-level service registrations

### 5.3 Clean Detach Sequence

```
1. Trigger kill-switch: bash scripts/run-dev-kill-switch.sh --all
2. Wait for all registered processes to exit (confirm via process-registry.log).
3. Flush open log handles (kill-switch confirms this on exit).
4. Write a final `.compost` snapshot of the current vault state.
5. Verify snapshot integrity checksum.
6. Archive the vault layer to the target transport (disk image, rsync, etc.).
7. Record detach event in scheduler audit trail with timestamp and vault-id.
```

---

## 6. Reconnect Handshake

### 6.1 Vault Identity Claim

On reconnect to a new or reinstalled host:

1. Read `vault-id` from the most recent `.compost` header.
2. Verify the `vault-id` matches the expected identity (operator confirms).
3. If `vault-id` is absent, generate a new one and record it in the first new
   `.compost` header; treat as a fresh vault.

### 6.2 Family Network Re-Registration

1. Restore all `@dev/` surfaces from the `.compost` snapshot.
2. Apply any pending deltas.
3. Verify all active binder state files are present and parseable.
4. Re-run `scripts/run-v2-1-operations-checks.sh` to confirm family readiness.

### 6.3 Active Binder State Resync

1. For each checkpoint file in `@dev/logs/checkpoints/`:
   - Load the checkpoint and identify the last completed stage.
   - If the binder round is still `in-progress` in the ledger, flag it for
     manual review before resuming.
2. Operator reviews flagged binders and either resumes (`--resume`) or closes
   the round manually.

### 6.4 Conflict Resolution on Diverged Surfaces

If a surface exists both in the restored vault and on the new host with
different content:

1. Both versions are preserved: active file and `.bak-<timestamp>` backup.
2. The operator resolves the divergence before any new advance step is allowed
   on that surface.
3. The resolution is recorded in the scheduler audit trail.

---

## 7. Mid-Round Crash Restore: Worked Example

**Scenario**: The `run-v2-1-operations-checks.sh` orchestrator is killed
mid-run after 5 of 9 checks have passed. The vault must be fully restorable to
the state just before the crash.

**Recovery steps**:

```
Step 1: Confirm crash
  - PID file for the run remains in @dev/logs/pids/
  - process-registry.log shows start but no stop entry for the run

Step 2: Clean up stale PID
  - bash scripts/run-dev-kill-switch.sh --all --dry-run
    (confirms process is no longer alive; PID file is stale)
  - bash scripts/run-dev-kill-switch.sh --all
    (removes stale PID file)

Step 3: Read checkpoint
  - @dev/logs/checkpoints/v2-1-operations-checks.state
    contains pass records for the 5 completed checks

Step 4: Resume from checkpoint
  - bash scripts/run-v2-1-operations-checks.sh --resume
    (skips the 5 passing stages, runs the remaining 4)

Step 5: Confirm full pass
  - scheduler audit trail records the resumed run with skip_count=5

Step 6: Optional: load from .compost if checkpoint is missing
  - Locate most recent .compost file
  - Restore @dev/logs/checkpoints/ from compost snapshot
  - Repeat Step 4
```

---

## 8. Boundary Check

- `uDOS-core` owns crash-safe state definitions, `.compost` format, delta
  versioning protocol, and sandbox guard semantics.
- `uDOS-grid` owns spatial datasets; no grid data is included in vault snapshots.
- `uDOS-dev` governs the binder lifecycle and `@dev/` surfaces that are included
  in the vault layer.
- Runtime bindings (`.venv`, build outputs) are host-owned; Core does not define
  their recovery.
