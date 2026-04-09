# Image Ingestion As Markdown Candidate

Status: **Post-08 O2 promoted** — **2026-04-02**; concrete lane: **`docs/image-ingestion-markdown-lane.md`**. Checklist: **`o2-image-ingestion-md-execution-checklist.md`**. Verify: `bash scripts/verify-o2-image-ingestion-lane.sh` (from `uDOS-docs` root).

**Active owner:** `uDOS-docs` (lane + hub); **`uDOS-core`** for markdown/MDC intake when implemented.

## Context

There is an **inbox of photos** (and similar assets) to process. This is a
separate lane from text-first docs and the General Knowledge Bank: treat it as
its own **ingestion round** when scheduled.

## Candidate Scope

- Ingest images into a **markdown-first** workflow (captions, sidecar `.md`,
  MDC-style blocks, or agreed family pattern — to be decided when roadmapped).
- Align with Core/docs contracts for document intake where relevant.
- Keep private or sensitive material out of public repos; scope per vault or
  instance policy.

## Rule

Planning and **execution checklists** stay under `@dev/pathways/`; the **public lane description** is `docs/image-ingestion-markdown-lane.md`. Open a numbered family plan only if scope crosses **`docs/next-family-plan-gate.md`** (`uDOS-dev`).

## Family index

Listed with other candidates in **`uDOS-dev`** `@dev/notes/reports/family-duplication-and-pathway-candidates-2026-04-01.md` (Workspace 08).
