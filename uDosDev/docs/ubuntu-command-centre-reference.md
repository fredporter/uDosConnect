# Ubuntu Command Centre Reference

## Purpose

This document is the compact family reference for the Ubuntu command-centre
runtime.

## Core Decision

`uDOS-host` is the always-on command-centre host for the family.

It owns:

- host runtime and uptime
- local and remote-aware networking
- vault, sync, scheduling, and background jobs
- runtime-edge budget and policy enforcement
- browser command-centre and TUI shell hosting

## Runtime Layers

### Host Bootstrap

- image and profile assembly
- package and service prerequisites
- startup wiring

### Core Runtime Services

- command router
- vault service
- sync worker
- scheduler
- network host
- budget gate

### Operator Surfaces

- browser command centre
- TUI shell
- ThinUI service views where needed

### Optional Adapter Layer

- Wizard publishing and provider bridges
- Empire external sync and operations lanes

## Filesystem Rule

Source tree:

- `~/Code/uDOS-family`

Runtime state:

- `~/.udos/`

Do not let logs, service state, queues, or vault data drift into repo trees.

## Process Rule

The minimum always-on service set should cover:

- host bootstrap
- command router
- vault
- sync
- scheduling
- networking
- budget
- web surface

## Split Rule

- Ubuntu owns the runtime host
- Wizard consumes or extends host services but does not replace them
- Empire remains a business-operations and remote-service extension layer

## Implementation Rule

Use the checked-in Ubuntu docs, contracts, config templates, and service stubs
as the implementation-facing source of truth. Keep future planning detail in
`uDOS-host` rather than re-expanding this family reference.
