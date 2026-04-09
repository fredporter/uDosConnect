# Completion rounds and **v2.6** naming (family spine vs inbox product pack)

## Two different “v2.6” ideas

| Name | What it is | Authority |
| --- | --- | --- |
| **Family plan `v2.6` (completed)** | Coordinated **binder spine payload v1**, ThinUI bridge, workspace operator consumption, Ubuntu host parity, family release pass | `@dev/notes/roadmap/v2.6-rounds.md`, `scripts/run-v2-6-release-pass.sh` |
| **Inbox `udos-family-v2.6` Dev Pack** (local draft under `@dev/inbox/`) | **MDC Mac / MDC iOS** App Store–first product ladder (`docs/v2.6/ROADMAP.md` style: v2.6.0 contracts → v2.6.1–v2.6.4 betas/releases → v2.6.5 host bridge) | Not family contract until promoted out of inbox |

Do **not** merge the two roadmaps without an explicit decision: the inbox pack optimises for **Apple App Store** surfaces; the completed family **`v2.6`** optimises for **binder-native workspace** alignment across **Core, ThinUI, Workspace, Host**.

## Family `v2.6` spine repos (Round A–D summary)

| Family round | Primary repos | Canonical docs / checks |
| --- | --- | --- |
| A | `uDOS-core` | `uDOS-core/docs/binder-spine-payload.md`, `tests/test_binder_spine_contract.py` |
| B | `uDOS-thinui` | `docs/thinui-unified-workspace-entry.md`, `npm run validate:binder-spine` |
| C | `uDOS-workspace` | `docs/workspace-binder-spine.md`, `run-workspace-checks.sh` |
| D | `uDOS-host` | `docs/activation.md` § v2.6 spine parity, `run-ubuntu-checks.sh` |
| E | `uDOS-dev` | `scripts/run-v2-6-release-pass.sh`, reports under `@dev/notes/reports/v2-6-release-pass-*.md` |

## Completion workspace mapping (upgrade to “uDOS 2.6 format”)

Workspace JSON files are **archived** under **`uDOS-dev/workspaces/archive/v2/`**. **“v2.6 format”** here means: each round includes the **spine-aligned siblings** needed for PR review against **binder spine v1**, not only the thematic lane.

| Workspace | File | Role |
| --- | --- | --- |
| **0 (pre-round)** | `archive/v2/completion-round-00-v2-6-spine-parity.code-workspace` | **Spine parity maintenance** — Core, ThinUI, Workspace, Host, Wizard, Shell ref, dev, docs. Use when touching `schema_version`, binder JSON, or cross-repo spine behaviour. |
| **1** | `archive/v2/completion-round-01-install-distribution.code-workspace` | Sonic / Ventoy / Alpine + **Core** (contract anchor) + plugin-index, dev, docs |
| **2** | `archive/v2/completion-round-02-startup-networking-mcp.code-workspace` | Alpine, Core, gpthelper, host, wizard + **ThinUI + Workspace** (spine B/C) + shell, plugin-index, dev, docs |
| **3** | `archive/v2/completion-round-03-tui.code-workspace` | Core, grid, shell, workflow + **ThinUI + plugin-index** (spine validation + MCP) + host, dev, docs |
| **4** | `archive/v2/completion-round-04-gui.code-workspace` | Empire, host, surface, themes, thinui, workspace, wizard, core + **gpthelper** (export/helper lane) + dev, docs |

## Inbox `udos-family-v2.6` — how the “next four” product milestones relate

The inbox pack’s **recommended build order** (MDC Mac beta → Mac App Store → iOS beta → iOS App Store) is a **product** sequence. It does **not** replace family **`v2.6`** rounds A–E. If you promote that pack, treat it as a **separate** versioning line (e.g. MDC app semver) and link **into** the spine repos above for shared types and orchestration — see inbox `docs/v2.6/REPO_BOUNDARIES.md`.

## Verification

- Full family spine re-check: **`bash scripts/run-v2-6-release-pass.sh`** from **`uDOS-dev`** (sibling layout per script).
- GUI/TUI quick launchers: **`workspaces/completion-launchers/`** (host HTTP proof, shell TUI).

## Related

- `workspaces/archive/v2/completion-round-00-v2-6-spine-parity.md` — **prepare for Round 00** (checklist before opening the workspace)
- `workspaces/completion-rounds-and-local-stack.md`
- `workspaces/README.md` § Completion rounds
- `docs/next-family-plan-gate.md` — next numbered plan after completed family `v2.6`
