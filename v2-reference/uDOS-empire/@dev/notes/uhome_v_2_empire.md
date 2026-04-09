# Superseded: Older Empire Operations-Container Framing

This note captured the earlier position where `uDOS-empire` was a broad
operations-container and outward workflow workbench.

That framing is now superseded by the March 2026 refactor.

## Current Direction

`uDOS-empire` is now being repurposed as a WordPress plugin that runs on the
local `uDOS-host` host.

Use these records instead:

- `../../docs/wordpress-plugin-architecture.md`
- `../../docs/wordpress-plugin-data-model.md`
- `../../../uDOS-dev/@dev/notes/2026-03-30-empire-ubuntu-restructure.md`

## Rule

Do not use this older note as the default public identity for Empire.

Only reuse material from it if a concept still supports the narrower
WordPress-centred CRM, contact, email, and admin-plugin role.

That way Empire still works as a real extension even when:
	•	Wizard is disabled
	•	offline mode is preferred
	•	AI budget is limited
	•	deterministic execution is required

⸻

Relationship to Binders

Empire is a strong home for binder-packaged operational workflows.

A binder in Empire could package:
	•	campaign brief
	•	audience segment definition
	•	contact mapping
	•	email templates
	•	page content
	•	assets
	•	send rules
	•	approval requirements
	•	analytics/report config

So a binder can become a portable operational unit.

Examples:
	•	show launch binder
	•	local event promo binder
	•	product launch binder
	•	weekly bulletin binder
	•	creator release binder
	•	fundraising binder
	•	subscriber reactivation binder

This is where Empire and the broader uDOS package model should connect cleanly.

⸻

Suggested Internal Architecture

Top layers

1. Domain layer

Defines the core concepts:
	•	contact
	•	audience
	•	campaign
	•	message
	•	publication
	•	asset
	•	channel
	•	workflow
	•	job
	•	report

2. Pack/container layer

Defines how reusable operational units are packaged:
	•	manifests
	•	templates
	•	transforms
	•	rules
	•	sample data
	•	tests

3. Adapter layer

Provider-specific connectors:
	•	Gmail
	•	HubSpot
	•	WordPress
	•	web publish targets
	•	form platforms
	•	file exports
	•	later: SMS/WhatsApp/provider adapters

4. Make/education layer

Guided creation surfaces:
	•	starter packs
	•	tutorials
	•	editable examples
	•	validation helpers
	•	safe test mode

5. Execution layer

Runs jobs with:
	•	dry-run
	•	preview
	•	approval gates
	•	logging
	•	rollback where possible
	•	reporting

⸻

Suggested Repo Spine

uDOS-empire/
├── README.md
├── docs/
│   ├── overview.md
│   ├── architecture.md
│   ├── make-pathway.md
│   ├── containers.md
│   ├── workflows.md
│   ├── providers.md
│   ├── contacts-and-audiences.md
│   ├── publishing.md
│   ├── messaging.md
│   └── roadmap.md
├── packs/
│   ├── campaign-starter/
│   ├── event-launch/
│   ├── edm-basic/
│   ├── landing-page-basic/
│   ├── contact-import-cleanup/
│   └── weekly-bulletin/
├── scripts/
│   ├── publish/
│   ├── messaging/
│   ├── contacts/
│   ├── reporting/
│   └── transforms/
├── templates/
│   ├── email/
│   ├── pages/
│   ├── forms/
│   ├── reports/
│   └── campaign/
├── adapters/
│   ├── gmail/
│   ├── hubspot/
│   ├── wordpress/
│   ├── static-web/
│   └── exports/
├── schemas/
│   ├── contact.schema.json
│   ├── audience.schema.json
│   ├── campaign.schema.json
│   ├── job.schema.json
│   └── pack-manifest.schema.json
├── examples/
│   ├── first-campaign/
│   ├── launch-sequence/
│   └── local-event-promo/
├── tests/
├── src/
└── CHANGELOG.md


⸻

Make Pathway Structure

The Make pathway should probably be explicit in docs and product language.

Suggested levels

Level 1 — Run

User picks a prebuilt pack:
	•	fill inputs
	•	preview
	•	dry-run
	•	approve
	•	execute

Level 2 — Modify

User edits:
	•	text
	•	fields
	•	audience rules
	•	asset references
	•	timing
	•	publish targets

Level 3 — Build

User creates:
	•	a new pack
	•	new template family
	•	new transform
	•	new script chain
	•	new provider mapping

Level 4 — Share / Deploy

User:
	•	packages pack/container
	•	saves to library
	•	shares to team/community
	•	promotes to stable workflow

This gives Empire a strong educational ladder.

⸻

UX Direction

Empire should feel like:
	•	a workshop
	•	a control room
	•	a publishing desk
	•	an operations studio

Not a bloated enterprise dashboard by default.

The UI should favour:
	•	modular cards/panels
	•	task flows
	•	visible structure
	•	previews
	•	templates
	•	editable manifests
	•	clear dry-run/approve/send states

It should help users understand:
	•	what is about to happen
	•	what inputs are needed
	•	what systems are touched
	•	what outputs will be created

⸻

Safety / Approval Model

Empire needs strong approval concepts.

Especially for:
	•	sending email
	•	publishing pages
	•	syncing/deleting contacts
	•	overwriting lists
	•	bulk actions
	•	live provider writes

Recommended support:
	•	dry-run first
	•	diff preview
	•	approval gates
	•	“test send” or “test publish”
	•	environment separation
	•	action logs
	•	rollback notes where possible

⸻

Data/CRM Direction

From our earlier direction, Empire should likely support at least:

contact fields
	•	name
	•	email
	•	phone
	•	address
	•	city
	•	postcode
	•	state
	•	country

company fields
	•	company name
	•	address
	•	city
	•	postcode
	•	state
	•	country
	•	phone
	•	linked contacts

matching logic
	•	email-address based identity matching for email flows
	•	phone-number based identity matching for text / WhatsApp later

This belongs inside Empire’s audience/contact operation layer.

⸻

Channel Strategy

Empire should be channel-aware, but not channel-fragmented.

Start with:
	•	email
	•	web publishing
	•	static campaign pages
	•	forms/subscription/account widgets
	•	exports/reports

Then expand toward:
	•	CRM sync
	•	SMS/WhatsApp adapters
	•	social publishing helpers
	•	event comms
	•	headless/content syndication

⸻

Educational Public Repo Positioning

If Empire is public-facing in any way, it should be educational, not just contributor-internal.

That means docs should explain:
	•	what a pack is
	•	what a workflow is
	•	how a template maps to data
	•	how to safely test
	•	how to make your own version
	•	how to contribute examples
	•	how to submit useful workflows

This matches your broader shift away from “wiki for contributors only” toward a broader learning/make framework.

⸻

Recommended Docs to Break Out

I’d split Empire docs into these first:

1. uDOS-empire-overview.md

Purpose, role, boundaries, relationship to core/wizard.

2. uDOS-empire-make-pathway.md

Education ladder, templates, remix/build/deploy flow.

3. uDOS-empire-containers.md

How script packs/binders/containers are structured.

4. uDOS-empire-contacts-campaigns.md

Audience, contact mapping, segmentation, messaging concepts.

5. uDOS-empire-publishing.md

Web, landing pages, forms, publishing adapters.

6. uDOS-empire-roadmap.md

Phased delivery plan.

⸻

Early Roadmap Suggestion

Phase 1 — Foundations
	•	repo spine
	•	domain models
	•	pack manifest
	•	dry-run execution model
	•	starter templates
	•	Gmail + static publish adapters
	•	first Make docs

Phase 2 — Campaign and audience layer
	•	contacts/company records
	•	audience segments
	•	campaign packs
	•	reporting outputs
	•	approval workflows

Phase 3 — Guided Make system
	•	pack builder
	•	editable manifests
	•	validation helpers
	•	educational walkthroughs
	•	sample projects

Phase 4 — Extended adapters
	•	HubSpot mapping
	•	WordPress/headless publishing
	•	richer export/report options
	•	shared library/community packs

⸻

Recommended One-Line Definition

uDOS-empire is the uDOS v2 extension for outbound operations, publishing, audience workflows, and educational make/deploy systems, packaged as reusable scriptable containers rather than a monolithic business app.

⸻

If you want, I can turn this straight into a proper repo brief markdown doc in the same house style as the other uDOS v2 docs.
