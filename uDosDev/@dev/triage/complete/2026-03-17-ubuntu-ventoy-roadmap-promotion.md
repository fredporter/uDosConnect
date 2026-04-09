# Triage: uDOS Ubuntu and uDOS Ventoy Family Activation

- title: uDOS-host and sonic-ventoy intake promotion
- date: 2026-03-17
- related binder: #binder/family-v2-0-6-ubuntu-ventoy-activation
- working tags:
  - @dev/ubuntu-base-image
  - @dev/ventoy-boot-platform
  - @dev/sonic-v2-orchestration
- related repos:
  - uDOS-dev
  - uDOS-host
  - sonic-ventoy
  - sonic-screwdriver
- status: triaged

## Summary

This intake package promotes two new inbox briefs into the live v2 roadmap and
opens the first v2.0.6 activation lane for base image and boot-platform work.
The promoted outcome creates canonical family repos for uDOS-host and
sonic-ventoy and maps them into binder-backed roadmap tracking.

## Brief Coverage

- uDOS-host-brief.md
  - promoted to a new public family repo scaffold: uDOS-host/
  - promoted to round tracking: @dev/notes/roadmap/v2.0.6-rounds.md
- uDOS-v2-sonic-upgrade.md
  - promoted to a new public family repo scaffold: sonic-ventoy/
  - promoted to round tracking: @dev/notes/roadmap/v2.0.6-rounds.md

## Findings

- uDOS-host should remain a reproducible base image definition lane and not
  absorb runtime ownership from uDOS-core.
- sonic-ventoy should remain the boot substrate layer while Sonic remains the
  deployment orchestrator.
- macOS should be treated as a maintenance lane for media updates while Linux
  remains the primary initial-stick creation lane.

## Promotion Actions

1. initialize uDOS-host and sonic-ventoy as public family repos
2. open v2.0.6 Round A binder request for activation and boundary lock
3. update family map, release surfaces, and automation repo lists
4. update roadmap status to mark v2.0.6 Round A active

## Next Actions

- advance v2.0.6 Round A integration work in sonic-screwdriver
- define ss init generation flow for ventoy.json, themes, and profile-aware
  menu metadata
- stage v2.0.6 Round B validation criteria once Sonic wiring work lands
