# Round: Cursor Workspace 09 — Classic Modern MVP (post-08)

- Date opened: 2026-04-02
- Workspace file: `uDOS-dev/workspaces/cursor-09-classic-modern-mvp.code-workspace` (under `uDOS-family/`)

## Status

**CLOSED** **2026-04-02** — documentation promotion, consumer wiring, and workspace files versioned in `uDOS-dev/workspaces/`. **Prior:** `@dev/notes/rounds/cursor-08-family-convergence-2026-04-01.md` **CLOSED**. **Next:** optional post-08 rounds `@dev/notes/roadmap/post-08-optional-rounds.md` (O1–O4).

## Operator start

1. Open **`cursor-09-classic-modern-mvp.code-workspace`**.
2. Read **`docs/cursor-focused-workspaces.md`** (Workspace 09) and **`docs/cursor-execution.md`** (Step 9).
3. Treat **`uDOS-docs/docs/classic-modern-mvp-0.1/README.md`** as the canonical pack index; use **`uDOS-dev/@dev/inbox/classic-modern-mvp/`** for draft edits before promotion.

## Lane authority

- Objectives, repos in scope, exit pattern: `docs/cursor-focused-workspaces.md` § Workspace 09

## This slice (2026-04-02)

| Deliverable | Artifact | Status |
| --- | --- | --- |
| Promote inbox pack to canonical docs | `uDOS-docs/docs/classic-modern-mvp-0.1/` (synced from inbox + README + `rebrief-instructions.md`) | **Done** |
| Charter canonical / mirror wording | `uDOS-docs/.../sonic-tui-charter.md` + `sonic-screwdriver/docs/sonic-tui-charter.md` | **Done** |
| Roadmap: 09 before O1–O4 | `v2-roadmap-status.md`, `post-08-optional-rounds.md` | **Done** |
| Inbox typo fix | `uDOS-thinui` in `@dev/inbox/classic-modern-mvp/README.md` | **Done** |
| Surface + Shell + Ubuntu wiring (pushed) | `uDOS-shell` `internal/surface/`, `uDOS-host` ThinUI `/v1/status` surface block, env example | **Done** |
| **`--cm-*` consumer matrix** | Pack `README.md` + `classic-modern-tokens.md` + `themes/classic-modern.css` header + `uDOS-themes/docs/README.md` | **Done** |
| **`apply-classic-modern.sh` smoke** | Prints checklist, exits 0; points to host profile doc + optional `UDOS_SURFACE_*` / `curl` hint | **Done** |
| **Workspaces 01–08 + overview in git** | `uDOS-dev/workspaces/*.code-workspace` + `workspaces/README.md` index | **Done** |

## Exit gate (Workspace 09)

Defined per slice in this file (not the historical 01–08 train). Close this round when:

- [x] **Implementation pass (follow-on):** `--cm-*` tokens and **`udos-default`** / surface wiring referenced from pack index, `uDOS-themes` docs, ThinUI resolver, Shell docs + `internal/surface`, Ubuntu ThinUI status (see pack **Token and implementation wiring** table).
- [x] **Ubuntu host profile:** `ubuntu/apply-classic-modern.sh` smoke path documented (run script → exit 0; GNOME steps remain manual per `classic-modern-host-profile.md`).
- [x] **Canonical index for Classic Modern 0.1:** **`uDOS-docs/docs/classic-modern-mvp-0.1/README.md`** is the promoted pack index; **`uDOS-dev/@dev/inbox/classic-modern-mvp/`** is draft-only per that README; **`docs/cursor-focused-workspaces.md`** Workspace 09 points at both.

**Round closed:** documentation, consumer matrix, and control-plane workspace inventory are complete.

## Related

- `docs/cursor-focused-workspaces.md` § Workspace 09
- `docs/workspace-08-exit-evidence.md` § 3 (main post-08 backlog; optional O1–O4 after Workspace 09)
