# Family Learning Path

## Purpose

Describe the active v2 learning path for the uDOS and uHOME family.

This document promotes the strongest structure from the archived course ladder
and wiki pathway material without pulling the old monorepo wording forward
unchanged.

## Three Entry Paths

The family should be understandable through three clear entry paths:

- use
- learn
- build

Use them like this:

- `use` = run the current products and learn the practical operator path
- `learn` = follow the course ladder and architecture explanations
- `build` = work through examples, templates, binders, workflows, and repo-local implementation surfaces

## Learning Ladder

The family learning ladder remains:

1. Markdown Systems
2. Local-First Development
3. API and Automation Systems
4. Modular Architecture
5. Personal Infrastructure

The ladder matters because learners should be able to stop at any level and
still build something useful.

## Current Family Mapping

### Markdown Systems

Use:

- `uDOS-docs` for family explanations
- `uDOS-core` for canonical markdown-first contracts
- `uDOS-themes` for prose presets, theme adapters, and publishing style packs

### Local-First Development

Use:

- `uDOS-core`
- local runtime repos that keep state inspectable and file-backed

### API and Automation Systems

Use:

- `uDOS-wizard` for network and provider-facing API surfaces
- `uDOS-empire` for configurable webhooks, online sync, and API automation
- `uHOME-server` for local automation and household service lanes

### Modular Architecture

Use:

- sibling repo boundaries
- explicit ownership between Core, Wizard, Sonic, `uHOME-server`, and `uDOS-empire`

### Personal Infrastructure

Use:

- `sonic-screwdriver` for deployment and hardware bootstrap
- `uDOS-host` for the always-on command centre
- `uHOME-server` for local-network home infrastructure in the `uHOME` stream
- `uDOS-wizard` for networking-side adapters

## Family Education Rules

- the family should teach one shared architecture language
- pathway repos should feel specialized, not disconnected
- education should preserve Markdown-first and local-first ideas
- examples should stay small, inspectable, and owned by a current repo

## Current Repo Roles In The Learning Path

- `uDOS-docs` = family-level explanations, pathway framing, archive assessment, and onboarding language
- `uDOS-core` = canonical contracts and semantics
- `uDOS-wizard` = provider, networking, Beacon Activate, and API/control-plane concepts
- `uDOS-host` = always-on command-centre host
- `uDOS-themes` = theme packs, prose presets, gameplay skin adapters, and
  shared visual vocabulary
- `uHOME-server` = household service runtime and local-console/ThinUI surfaces
- `uDOS-empire` = webhook server patterns, online sync, HubSpot/Google integration, and CRM operations
- `sonic-screwdriver` = deployment and portable provisioning

## Promotion Rule

When archived course or wiki material is reused:

1. keep the educational structure if it is still strong
2. rewrite repo references to match current family ownership
3. prefer concise active docs over large copied lesson banks
4. leave the old archive in place as the design bank
