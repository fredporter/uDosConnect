# uDOS-empire Architecture

uDOS-empire is the WordPress-centred CRM, contact, email, and admin operations
repo for the family.

The current refactor replaces the older "generic outbound operations
container" framing with a narrower role: Empire is a WordPress plugin intended
to run on the local `uDOS-host` host.

## Main Areas

- `src/` holds WordPress-oriented source and contract material for Empire-owned
  CRM, intake, and email workflows.
- `examples/` demonstrates inspectable contact, import, and workflow payloads.
- `docs/` explains repo boundaries, plugin architecture, and cross-repo
  ownership.
- `scripts/run-empire-checks.sh` is the activation validation entrypoint.

Key companion docs:

- `docs/wordpress-plugin-architecture.md`
- `docs/wordpress-plugin-data-model.md`
- `docs/contact-and-crm-model.md`
- `docs/publishing.md`

## Top Layers

### Plugin Layer

Defines Empire as a WordPress plugin that extends local host capabilities with:

- admin pages
- upload flows
- contact processing
- audience views
- campaign or send surfaces
- audit-friendly notes and logs

### CRM Layer

Defines contact records on top of WordPress users and metadata, including:

- contact identity fields
- consent metadata
- lifecycle and source fields
- binder or workspace links
- import provenance
- append-only activity notes

### Intake Layer

Defines bulk import and family-event intake flows such as:

- CSV, TSV, and JSON browser imports
- field mapping and dry-run preview
- deterministic matching or dedupe
- inbound family contact payload handling
- provenance capture and change logging

### Email Layer

Defines WordPress-centred outbound messaging with:

- audience selection from local CRM records
- binder or workspace-driven segmentation
- consent-aware send rules
- campaign and contact activity logging

### Host Integration Layer

Defines the host split with Ubuntu:

- Ubuntu owns WordPress hosting, local service lifecycle, repo storage,
  scheduling, Git or GitHub operations, and host security policy.
- Empire owns the plugin logic and local business data processing on top of
  that host.
- Wizard may assist or orchestrate but does not own the plugin or the host.

## Current Refactor Rule

Empire should now be read as a WordPress plugin repo first.

Older Google, HubSpot, webhook, and generic outbound-ops material is now
legacy unless it directly supports:

- WordPress-hosted CRM intake
- WordPress-centred messaging
- local plugin admin surfaces
- family contact-event intake into WordPress

## Operating Split

- `uDOS-core` owns family contracts and generic workflow semantics.
- `uDOS-host` owns the always-on runtime host, system services, Git or GitHub
  execution surfaces, and central local repo-store posture.
- `uDOS-empire` owns the WordPress plugin, CRM record handling, contact notes,
  binder or workspace tagging, and WordPress-centred email workflows.
- `uDOS-wizard` owns optional assist or orchestration on top of host-owned
  actions.
