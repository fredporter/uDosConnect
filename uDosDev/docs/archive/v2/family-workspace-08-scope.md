# Family Workspace 08 — convergence scope

**Gap matrix:** rows **4** (deferred features), **8** (`uDOS-docs` v1 posture), **D**
(cross-cutting themes). Complements **`docs/family-documentation-layout.md`**
(spec output 1, docs surfaces).

## Deferred features after `v2.5` (row 4)

The following are **not** local completion gates for Workspace 08 and were
**outside** the completed `v2.5` family plan. They stay **future plan material**
until product need and a gate such as **`docs/next-family-plan-gate.md`** justify
a named `v2.x` slice:

- **Remote Deer Flow clusters** — local controlled execution is in scope for
  `v2.5`; remote/distributed clusters are deferred.
- **Graph editing** — not a current family completion gate.
- **Memory sync import/export** — deferred; local memory/vault contracts remain
  authoritative per Core and Ubuntu docs.

**References:** `@dev/notes/roadmap/v2.5-rounds.md` Round D (“outside local family
scope”); `v2-roadmap-status.md` § Current Focus (Deferred); Workspace 08 round
note `@dev/notes/rounds/cursor-08-family-convergence-2026-04-01.md`.

## `v1` architecture under `uDOS-docs` (row 8)

Material under **`uDOS-docs`** that is labeled or reads as **v1** is **historical
/ archive context** unless explicitly marked as the current norm. **Current**
operator manuals and contracts live in **tier-1 repos** (`uDOS-core`,
`uDOS-host`, `uDOS-wizard`, etc.) and should be linked from the docs hub—not
re-authored in full under `uDOS-docs` when another repo already owns the topic.

**Hub rule:** `uDOS-docs` publishes cross-repo navigation, publishing metadata,
and learning paths; see **`uDOS-docs/docs/local-vs-github-docs-boundary.md`**.

## Cross-cutting themes (matrix section D)

Short family-facing statements so repos and docs do not contradict each other.

### Binder + DeerFlow

Preview versus **controlled** execution, artifact persistence, and where operators
read results should match across **Wizard**, **workspace**, and **docs**
(`uDOS-wizard`, `uDOS-workspace`, `uDOS-docs` publishing notes). Wizard owns the
optional Deer Flow adapter lane; results surface in workspace operator state per
`v2.5` completion.

### Binder + spool synchronicity

**Binder complete** should align with feed/spool semantics in **Core** and host
policy—no silent drift between “binder done” and “spool updated.” Stable ref:
**`uDOS-core/docs/feeds-and-spool.md`**; pathway candidate:
`@dev/pathways/logs-feeds-and-spool-candidate.md`.

### Clean as we go

Each lane ends with traceable **scripts**, **public `docs/`**, and **`@dev`**
notes; avoid orphan planning in public `docs/`.

### Compost heap

**`.compost`** and superseded material: **build, compact, rotate**; local organic
archive only—not runtime or vault source of truth. See Core vault survival docs.

### System vitals

Health and optimisation paths for **`~/.udos/`**, Ubuntu hosts, and family
check scripts should stay **documented, runnable, and linked** from onboarding
or activation docs (`uDOS-host`, `uDOS-dev`).

## Related

- `docs/deferred-product-rfc-stubs.md` — RFC stubs for § Deferred themes (OB-R6)
- `docs/archive/v2/workspace-08-exit-evidence.md` (exit gate — **closed** **2026-04-01**)
- `docs/next-family-plan-gate.md`
- `docs/family-documentation-layout.md`
- `@dev/notes/reports/family-duplication-and-pathway-candidates-2026-04-01.md`
- `docs/gui-system-family-contract.md`
- `docs/archive/v2/cursor-focused-workspaces.md` (cross-cutting table by workspace)
