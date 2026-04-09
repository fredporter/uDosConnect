# Wizard / Surface vs host delegation (contract semantics)

**Updated:** 2026-04-01

## Promoted product decision

- **`uDOS-host`** owns the **canonical local host**: runtime layout under
  `~/.udos/`, command-centre surfaces, vault/sync policy materialisation, and
  the scripts that CI mirrors (`run-ubuntu-checks.sh`, …).
- **`uDOS-wizard`** (repo brand **uDOS Surface**) contains **Surface** (browser
  presentation) and **Wizard** (HTTP **delegation broker** — classify intent,
  resolve a target service, return a delegation envelope). See
  `uDOS-wizard/docs/wizard-broker.md` and `uDOS-wizard/docs/architecture.md`.

The compatibility process **`wizard.main:app`** hosts both the FastAPI broker
routes and the static/Svelte shells; that is a **delivery bundle**, not a claim
that Wizard owns the Ubuntu host.

## Why Core contracts still say `uDOS-wizard`

Several JSON contracts under `contracts/` name `uDOS-wizard`, `policy:
uDOS-wizard`, `managed_mcp_owner`, `story_rendering`, `workflow_consumer`, etc.

Those fields mean: the **Wizard/Surface codebase** is the **family-agreed
implementation actor** for that workflow lane (MCP tool registry, workflow UI,
render preview HTTP, feed/spool consumers, …). They do **not** redefine host
ownership: persistent host state, secrets, and always-on daemons remain
**Ubuntu-aligned** per `wizard-host-surface.v1.json` and ubuntu docs.

When a contract implies “authority,” interpret it as **application policy
routing** inside the Surface/Wizard service, bounded by Core semantics and
Ubuntu-hosted surfaces — not as “Wizard replaces the runtime host.”

## Related

- `uDOS-dev/docs/github-actions-family-contract.md`
- `uDOS-wizard/docs/wizard-broker.md`
- `uDOS-wizard/contracts/wizard-broker-contract.json`
