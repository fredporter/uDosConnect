# Unit 01: Workflow Basics

## Goal

Understand what `uDOS-workflow` owns in the family.

## What This Repo Is For

`uDOS-workflow` is the family repo for workflow-execution surfaces that need
their own boundary.

It may hold:

- workflow contracts
- execution adapters
- orchestration-facing runtime assets

It should not absorb Core semantics, browser rendering, or Ubuntu host
ownership.

## Quick Check

Read:

- `README.md`
- `docs/activation.md`

Then explain in one sentence:

- what belongs in `uDOS-workflow`
- what still belongs in `uDOS-core` or `uDOS-host`
