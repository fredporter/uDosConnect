# uDOS-empire WordPress Plugin Data Model

This document defines the first-pass local data model for the Empire
WordPress-plugin refactor.

## Canonical Record Host

WordPress is the contact and consent-aware record host.

Each CRM contact should be represented as:

- a WordPress user
- plugin-owned user meta
- optional Empire-owned index tables only where high-volume lookup requires it

## Core Contact Fields

Identity and communication:

- `first_name`
- `last_name`
- `display_name`
- `user_email`
- `mobile_phone`
- `alternate_phone`

Business and profile:

- `company_name`
- `job_title`
- `social_urls`
- `address_*`

Lifecycle and provenance:

- `source_channel`
- `lifecycle_stage`
- `import_source`
- `import_batch_id`
- `external_reference_ids`
- `last_contacted_at`
- `last_activity_at`

Consent and policy:

- `consent_status`
- `consent_date`
- `subscription_state`

uDOS links:

- `binder_links`
- `workspace_links`
- `tags`

Notes:

- `empire_contact_notes`

## Notes Format

Notes should be append-only by default and use a readable log structure:

```text
[2026-03-30 14:20] [empire] Imported from batch crm-import-004.
[2026-03-30 14:25] [binder:#tour-launch] Added to binder.
[2026-03-30 14:30] [email] Sent campaign "Launch Reminder 01".
```

## Matching Rules

Primary matching should prefer:

1. explicit external reference IDs
2. email address
3. deterministic secondary rules configured by the import profile

## Storage Rule

Store binder or workspace references in structured metadata first.

Free-text notes may mention those links, but notes must not be the only
canonical storage surface for them.
