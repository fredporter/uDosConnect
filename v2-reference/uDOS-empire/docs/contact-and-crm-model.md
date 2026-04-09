# uDOS-empire Contact And CRM Model

## Purpose

Define the current local-first contact and CRM vocabulary for the Empire
WordPress-plugin refactor.

## Ownership Split

### `uDOS-empire` owns

- WordPress-backed CRM record handling
- import, dedupe, matching, and enrichment rules
- binder and workspace links on contact records
- append-only contact activity notes
- WordPress-centred audience and email workflow metadata

### `uDOS-host` owns

- WordPress host runtime and service lifecycle
- host filesystem, scheduling, and runtime policy
- Git and GitHub execution surfaces

### `uDOS-core` owns

- canonical workflow and task semantics
- binder and vault truth rules
- any family-wide contact or record contracts promoted later

## Core Rule

The source of truth for operational CRM records is local, reviewable, and
WordPress-hosted.

Empire should not hide canonical contact state in remote CRM adapters.

## Normalized Contact Shape

Recommended normalized contact fields for the WordPress-plugin lane:

```yaml
wordpress_user_id: integer
user_email: string
display_name: string
first_name: string|null
last_name: string|null
mobile_phone: string|null
alternate_phone: string|null
company_name: string|null
job_title: string|null
address:
  street: string|null
  city: string|null
  state: string|null
  postcode: string|null
  country: string|null
consent_status: granted|revoked|unknown
subscription_state: subscribed|unsubscribed|suppressed
lifecycle_stage: string|null
source_channel: string|null
import_source: string|null
import_batch_id: string|null
binder_links: [string]
workspace_links: [string]
tags: [string]
external_reference_ids: [string]
empire_contact_notes: string
```

## Matching Rules

Use this precedence order unless a repo-specific import profile says otherwise:

1. explicit external reference IDs
2. email address
3. mobile phone
4. deterministic profile-specific secondary rules

## Allowed Empire Updates

- create or update WordPress user-backed CRM records
- append import provenance and activity notes
- attach binder and workspace links
- normalize names, phones, and addresses
- enrich company, lifecycle, and source metadata for review

## Disallowed Empire Behavior

- silently merge ambiguous contacts without review
- treat a remote CRM as canonical identity truth
- store binder or workspace linkage only in free-text notes
- move host-owned runtime or GitHub operations into the plugin

## Notes Rule

Contact history should remain readable and export-safe.

Default note mode:

- append-only
- timestamped
- source-labelled
- safe for export
- human-readable first, machine-parseable second

Example:

```text
[2026-03-30 14:20] [empire] Imported from batch brisbane-launch-leads-01.
[2026-03-30 14:21] [workspace:@workspace/marketing/brisbane-launch] Canonical workspace link added.
[2026-03-30 14:30] [email] Sent campaign "Launch Reminder 01".
```

## Binder Linkage

Contacts should remain binder-aware and workspace-aware.

At minimum, local CRM records should preserve:

- linked binder references
- linked workspace references
- import batch provenance
- last activity timestamp

## Review Model

Any merge or enrichment flow that changes identity-level fields should expose:

- source systems involved
- fields in conflict
- recommended resolution
- last sync status

This keeps local CRM processing useful without moving human contact judgment
into a hidden background process.
