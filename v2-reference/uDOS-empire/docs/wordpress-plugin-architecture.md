# uDOS-empire WordPress Plugin Architecture

`uDOS-empire` runs as a WordPress plugin on the local `uDOS-host` host.

## Purpose

Empire becomes the local CRM enhancement and operations layer for:

- WordPress-backed contact records
- consent-aware contact intake
- import, merge, and enrichment workflows
- binder or workspace tagging
- WordPress-centred email sending
- auditable activity notes on contact records

## Runtime Position

- runtime host: `uDOS-host`
- application shell: WordPress
- primary storage surface: WordPress database
- primary admin surface: WordPress admin
- plugin role: extend WordPress rather than replace it

## Core Modules

### Contact Record Module

Represents each CRM contact as a WordPress user, usually with a subscriber-like
role, extended by plugin-owned metadata.

### Import Module

Provides browser upload flows for CSV, TSV, and JSON contact data with:

- field mapping
- duplicate strategy selection
- dry-run preview
- import provenance
- post-import reporting

### Enhancement Module

Normalizes and enriches contact records with:

- name and phone cleanup
- source and segment assignment
- binder or workspace links
- lifecycle updates
- change provenance

### Notes Module

Maintains append-only activity notes in a readable uDOS log format so contacts
carry an auditable local history.

### Email Module

Uses WordPress-centred permissions and local CRM segments for:

- audience selection
- binder or workspace-driven mailing groups
- contact send logging
- consent-aware delivery rules

## Family Boundary

- `uDOS-empire` owns plugin logic and WordPress-facing CRM workflows.
- `uDOS-host` owns host runtime, service lifecycle, Git or GitHub operations,
  central local repo storage, and policy or secrets.
- `uDOS-wizard` may assist with drafting, orchestration, or analysis without
  owning the plugin or the host.
- `uDOS-core` remains the canonical owner of generic workflow semantics.

## Adapter Rule

Treat older Google, HubSpot, webhook, and general outbound-ops materials as
adapter lanes only. They should be either:

- migrated into the WordPress plugin direction
- proven still necessary as adapters behind the new local-first model
- removed
